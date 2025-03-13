#!/bin/bash
trap "exit" INT

printMessage() {
  echo
  echo "*** $1 ***"
  echo
}

printMessage "Qwiklabs enviroment setup script!"

PROJECT_ID=$(gcloud config get-value project)
PROJECT_NUMBER=$(gcloud projects describe "$PROJECT_ID" --format="value(projectNumber)")
export ZONE=$(gcloud compute instances list --filter "name="startup-vm"" --format "value(zone.basename())")
export REGION="${ZONE%-*}"
echo "Project ID=$PROJECT_ID, Project number=$PROJECT_NUMBER"

#### Management server deployment.
printMessage "Setting up management server..."
CONSUMER_ENDPOINT="https://backupdr.googleapis.com/v1/projects/$PROJECT_ID/locations/$REGION"
shopt -s expand_aliases
alias curl_prod='curl -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json" '

gcloud services enable servicenetworking.googleapis.com
gcloud services enable backupdr.googleapis.com
sudo apt-get install -y jq

# Give time for service activations to hit.
sleep 60

gcloud compute addresses create --global --prefix-length=20 --purpose=VPC_PEERING --network=default default-ip-range
gcloud beta services identity create --service=servicenetworking.googleapis.com

# Give time for address and service account to be created.
sleep 60

gcloud projects add-iam-policy-binding $PROJECT_ID --member="serviceAccount:service-$PROJECT_NUMBER@service-networking.iam.gserviceaccount.com" --role="roles/servicenetworking.serviceAgent" --condition=None
gcloud services vpc-peerings connect --service=servicenetworking.googleapis.com --ranges=default-ip-range --network=default

curl_prod -d "{\"name\": \"dummy\", \"type\": \"BACKUP_RESTORE\", \"networks\": [{\"network\": \"projects/$PROJECT_ID/global/networks/default\", \"peering_mode\": \"PRIVATE_SERVICE_ACCESS\"},]}" -X POST $CONSUMER_ENDPOINT/managementServers?management_server_id=qwiklabs-ms

START_TIME="$(date -u +%s)"
# Iterate for 30 minutes
TOTAL_TIME=$(( 30 * 60 ))
while [ true ]
do
  CURR_TIME="$(date -u +%s)"
  ELAPSED="$(($CURR_TIME-$START_TIME))"
  if (( ELAPSED > TOTAL_TIME )); then
    echo "TIMEOUT. Waited for 15 minutes and instance is still not ready."
    curl_prod $CONSUMER_ENDPOINT/managementServers
    exit 1
  fi
  STATE=$(curl_prod $CONSUMER_ENDPOINT/managementServers | jq -r .managementServers[].state?)
  if [[ $STATE == "READY" ]]; then
    echo "ManagementServer in instance state ready".
    curl_prod $CONSUMER_ENDPOINT/managementServers
    break
  fi
  echo "Waiting for instance to be ready. Waited $ELAPSED seconds..."
  sleep 5
done

#### Sky installer setup

printMessage "Writing sky installer workflow..."

cat << 'EOF' > installer.yaml
# This cloud workflow implements the Sky installation in GCP (go/backupdr-sky-installer-gcp). The
# workflow is launched from a Coliseum flow that the user triggers.
#
#workflow_is_active #workflow_executes_successfully - added for testing [DO NOT REMOVE]
# The workflow performs the following steps (each of which are API calls):
# 0. create an initial session with AGM to confirm connectivity,
# 1. create a service account for the Sky VM,
# 2. assign roles to the service account (see Permissions in go/backupdr-sky-installer-gcp),
# 3. create a keyring for the Sky VM,
# 4. assign roles to the sky service account on the keyring,
# 5. create the Sky VM from a custom image,
# 6. create an ingress firewall rule to allow traffic from AGM to the Sky VM, and
# 7. register the Sky VM with an existing AGM instance.
#
# The input for this workflow is a map called `input`. The values of the input parameters are
# access through through the dot-operator (eg. `input.skyName`).
#
# NOTE: Throughout the workflow, we execute a number of retries. A typical retry stanza is:
#
# ```
# predicate: ${retryWithLogging}
#   max_retries: 30
#   backoff:
#     initial_delay: 4
#     max_delay: 4
# ```
#
# This retry is useful in catching a specific type of GAIA token generation error that we are
# tracking in b/225938005. We have found that just waiting a bit (4s) is usually sufficient.
#
# @param input.skyName the name to be given to the Sky VM
# @param input.region the region to deploy Sky into
# @param input.zone the zone to deploy Sky into
# @param input.bootstrapSecret the secret used to initiate the trust between the AGM and Sky
# @param input.diskType the type of persistent disk to use for the primary and snapshot pools
# @param input.snapshotPoolSizeGb the size of the snapshot pool persistent disk (in GB)
# @param input.subnetName the name of the subnet the customer wants to deploy Sky into
# @param input.workflowSA the name of the workflow service account
# @param input.agmURL the public URL of the AGM the sky will be registered with
# @param input.oauthClientID the audience for which to generate the OIDC token
# @param input.vpcResourceName the path of the VPC: project/<proj_id>/global/networks/<vpc_name>
# @param input.consumerProject the project where the BackupDR API is activated
# @param input.msVpcResourceName the path of the MS VPC: project/<proj_id>/global/networks/<vpc_name>
# @param input.skyImagePath the path to the image used to boot the Sky VM
# @param input.machineType the machine type for the backup appliance
main:
  params: [input]
  steps:
  # Sleep for 60 seconds to allow IAM bindings to set.
  - slowStart:
      call: sys.sleep
      args:
        seconds: 60
  - initA:
      assign:
        # Retrieve the name of the project and store locally.
        - project: ${sys.get_env("GOOGLE_CLOUD_PROJECT_ID")}
        - skyName: ${input.skyName}
        - serviceAccountEmail: ${input.workflowSA}
        - region: ${input.region}
        - zone: ${input.zone}
        # Use the first 18 characters of the execution ID as a source of randomness.
        - randomValue: ${text.substring(sys.get_env("GOOGLE_CLOUD_WORKFLOW_EXECUTION_ID"), 0, 18)}
        - keyRingName: ${input.skyName + "-keyring-" + randomValue}
        - machineType: "e2-standard-16"
        - bootstrapSecret: ${input.bootstrapSecret}
        - allowSNApis: ${default(map.get(input, "allowSNPApis"), false)}

  # More inits needed because only 10 assigns are allowed per step.
  - initB:
      assign:
        - diskTypeUrl: ${"https://www.googleapis.com/compute/v1/projects/" + project
                               + "/zones/" + zone + "/diskTypes/" + input.diskType}
        - primaryPoolSizeGb: 200 # GB (fixed)
        - snapshotPoolSizeGb: ${input.snapshotPoolSizeGb}
        - primaryPoolDevice: "primary-pool"
        - snapshotPoolDevice: "snapshot-pool"
        - agmURL: ${input.agmURL}
        - oauthClientID: ${input.oauthClientID}
        - vpcResourceName: ${input.vpcResourceName}
        - firewallRuleName: ${skyName + "-firewall-rule"}
        - consumerProject: ${input.consumerProject}

  - decideOnIVP:
      call: text.match_regex
      args:
          source: ${input.agmURL}
          regexp: 'https:\/\/bmc'
      result: useIVP

  # Set the boot disk image path based on if skyImagePath is provided in the input or not.
  - setImagePath:
      switch:
        - condition: ${"skyImagePath" in input}
          assign:
            - bootDiskImage: ${input.skyImagePath}
        - condition: ${not("skyImagePath" in input)}
          assign:
            - bootDiskImage: "projects/backupdr-images/global/images/sky-11-0-10-425"

  # Override machine type if provided in input.
  - setMachineType:
      switch:
        - condition: ${"machineType" in input}
          assign:
            - machineType: ${input.machineType}

  # Determine if we should use secure boot or not.
  - splitPath:
      call: text.split
      args:
          source: ${bootDiskImage}
          separator: "/"
      result: pathSplitRes
  - splitImage:
      call: text.split
      args:
          source: ${pathSplitRes[len(pathSplitRes)-1]}
          separator: "-"
      result: imageSplitRes
  - defaultVarsFalse:
      assign:
        - secureBoot: False
        - removeComputeAdmin: False
  - decideOnSecureBoot:
      switch:
          - condition: ${(int(imageSplitRes[3]) == 1 AND int(imageSplitRes[4]) >= 8479) OR int(imageSplitRes[3]) > 1}
            assign:
              - secureBoot: True
  - decideOnComputeAdmin:
      switch:
          - condition: ${(int(imageSplitRes[3]) == 1 AND int(imageSplitRes[4]) >= 8588) OR int(imageSplitRes[3]) > 1}
            assign:
              - removeComputeAdmin: True

  - setBucketPrefix:
      # Generated bucket name would look like 'backup-server-123456-8cf6be'
      assign:
        - bucketRandomSuffix: ${text.substring(sys.get_env("GOOGLE_CLOUD_WORKFLOW_EXECUTION_ID"), 0, 6)}
        - bucketPrefix: ${text.substring(input.skyName, 0, 20) + "-" + bucketRandomSuffix}

  - addOnVaultRole:
      switch:
        - condition: ${int(imageSplitRes[3]) > 1}
          steps:
            - assignPrefix:
                assign:
                  - baseURL: ${"https://cloudresourcemanager.googleapis.com/v1/projects/" + project}
                  - role: "roles/backupdr.cloudStorageOperator"
                  - expression: ${"resource.name.startsWith(\"projects/_/buckets/" + bucketPrefix + "\")"}
                  - title: ${bucketPrefix + "-cloud-storage-metadata"}
                  - description: "Permissions for storing GCE VM instance backup metadata in bucket"
            - addRole:
                try:
                  call: addConditionalPolicyBindingProject
                  args:
                    baseURL: ${baseURL}
                    serviceAccountEmail: ${serviceAccountEmail}
                    role: ${role}
                    expression: ${expression}
                    title: ${title}
                    description: ${description}
                  result: roleBindings
                # Retry 30 times, with 4 seconds between each attempt.
                retry:
                  predicate: ${retryWithLogging}
                  max_retries: 30
                  backoff:
                    initial_delay: 4
                    max_delay: 4
                    multiplier: 1
                except:
                  as: e
                  steps:
                    - cleanUp20:
                        call: deleteServiceAccount
                        args:
                          project: ${project}
                          serviceAccountEmail: ${serviceAccountEmail}
                          e: ${e}
                          message: ${"Unable to add cloud storage conditional permissions."}

  # Set VPC project project and subnet path if it is specified.
  - setNetworkProject:
      steps:
        - split:
            call: text.split
            args:
              source: ${vpcResourceName}
              separator: "/"
            result: splitList
        - assignNetworkProject:
            assign:
              - vpcProject: ${splitList[1]}
              - vpcName: ${splitList[len(splitList)-1]}
              - subnetPath: ${"https://www.googleapis.com/compute/v1/projects/" + vpcProject + "/regions/" + region  + "/subnetworks/" + input.subnetName}

  # Wait until logging completes successfully, meaning the IAM permissions are in place.
  - initialLogging:
      try:
        call: sys.log
        args:
          text: ${"Starting backup/recovery appliance installation."}
          severity: "INFO"
      # Retry 30 times, with 4 seconds between each attempt.
      retry:
        predicate: ${retryWithLogging}
        max_retries: 30
        backoff:
          initial_delay: 4
          max_delay: 4
          multiplier: 1
      except:
        as: e
        steps:
          - cleanUp1:
              call: deleteServiceAccount
              args:
                project: ${project}
                serviceAccountEmail: ${serviceAccountEmail}
                e: ${e}
                message: ${"Unable to complete initial logging."}

  # Generate an OIDC token and create an AGM session to ensure the AGM is reachable.
  - initialAGMCommunication:
      switch:
        - condition: ${agmURL != ""}
          steps:
            - tokenAndSession:
                try:
                  steps:
                    - generateToken:
                        call: getToken
                        args:
                          serviceAccountEmail: ${serviceAccountEmail}
                          oauthClientID: ${oauthClientID}
                          useOAuth: ${useIVP}
                        result: token
                    - getSession:
                        call: getAGMSession
                        args:
                          token: ${token}
                          agmURL: ${agmURL}
                        result: session
                # Retry 60 times, with 60 seconds between each attempt. SSL certificate propagation.
                retry:
                  predicate: ${retryWithLogging}
                  max_retries: 60
                  backoff:
                    initial_delay: 60
                    max_delay: 60
                    multiplier: 1
                except:
                  as: e
                  steps:
                    - cleanUp2:
                        call: deleteServiceAccount
                        args:
                          project: ${project}
                          serviceAccountEmail: ${serviceAccountEmail}
                          e: ${e}
                          message: ${"Unable to establish AGM connection"}

  # Enable private google access for the subnet we are provided.
  - enablePrivateGoogleAccess:
      try:
        call: googleapis.compute.v1.subnetworks.setPrivateIpGoogleAccess
        args:
          project: ${vpcProject}
          region: ${region}
          subnetwork: ${input.subnetName}
          body:
            privateIpGoogleAccess: true
      # Retry 30 times, with 4 seconds between each attempt.
      retry:
        predicate: ${retryWithLogging}
        max_retries: 30
        backoff:
          initial_delay: 4
          max_delay: 4
          multiplier: 1
      except:
        as: e
        steps:
          - cleanUp3:
              call: deleteServiceAccount
              args:
                project: ${project}
                serviceAccountEmail: ${serviceAccountEmail}
                e: ${e}
                message: ${"Unable to enable Private Google Access for subnet=" + input.subnetName}

  # Fetch the subnet IP ranges for each subnet in the VPC.
  - getSubnetIPs:
      try:
        steps:
          - getNetwork:
              call: googleapis.compute.v1.networks.get
              args:
                project: ${vpcProject}
                network: ${vpcName}
              result: networkingListResult
          - assignEmptyList:
              assign:
                - ipRanges: []
      # Retry 30 times, with 4 seconds between each attempt.
      retry:
        predicate: ${retryWithLogging}
        max_retries: 30
        backoff:
          initial_delay: 4
          max_delay: 4
          multiplier: 1
      except:
        as: e
        steps:
          - cleanUp4:
              call: deleteServiceAccount
              args:
                project: ${project}
                serviceAccountEmail: ${serviceAccountEmail}
                e: ${e}
                message: ${"Unable to fetch VPC=" + vpcResourceName}

  # Parse the resource names for the regions and name.
  - getSubnetNamesRegions:
      for:
        value: subnet
        in: ${networkingListResult.subnetworks}
        steps:
          - parseSubnetName:
              call: text.split
              args:
                source: ${subnet}
                separator: "/"
              result: subnetPathSplit
          - assignSubnetDetails:
              assign:
                - subnetName: ${subnetPathSplit[len(subnetPathSplit)-1]}
                - subnetRegion: ${subnetPathSplit[len(subnetPathSplit)-3]}
          - getSubnet:
              try:
                steps:
                  - getSubnetDetails:
                      call: googleapis.compute.v1.subnetworks.get
                      args:
                        project: ${vpcProject}
                        region: ${subnetRegion}
                        subnetwork: ${subnetName}
                      result: subnetDetails
                  - appendCidrRange:
                      assign:
                        - ipRanges: ${list.concat(ipRanges, subnetDetails.ipCidrRange)}
              # Retry 30 times, with 4 seconds between each attempt.
              retry:
                predicate: ${retryNon404WithLogging}
                max_retries: 30
                backoff:
                  initial_delay: 4
                  max_delay: 4
                  multiplier: 1
              except:
                as: e
                steps:
                  # We ignore 404 errors because it means the subnet is hidden. See b/252807789.
                  - checkForNot404:
                      switch:
                      - condition: ${e.code != 404}
                        call: deleteServiceAccount
                        args:
                          project: ${project}
                          serviceAccountEmail: ${serviceAccountEmail}
                          e: ${e}
                          message: ${"Unable to get subnet=" + subnetName}

  # Fetch the IP range of the service networking peering to the consumer project, in vpcv-sc environment.
  - getServiceNetworkingIpRange_vpc_sc:
      switch:
        - condition: ${agmURL != "" AND allowSNApis == false}
          steps:
            - assignParameters:
                assign:
                  - getGlobalAddressPageToken: ""
            # Get the list of Global Addresss.
            - getGlobalAddresses:
                try:
                  call: googleapis.compute.v1.globalAddresses.list
                  args:
                    project: ${vpcProject}
                    pageToken: ${getGlobalAddressPageToken}
                    maxResults: 500
                  result: globalAddresses
                # Retry 3 times, with 4 seconds between each attempt.
                retry:
                  predicate: ${retryWithLogging}
                  max_retries: 3
                  backoff:
                    initial_delay: 4
                    max_delay: 4
                    multiplier: 1
                except:
                  as: e
                  steps:
                    - cleanUp_getServiceNetworkingIpRange_vpc_sc_1:
                        call: deleteServiceAccount
                        args:
                          project: ${project}
                          serviceAccountEmail: ${serviceAccountEmail}
                          e: ${e}
                          message: ${"Unable to fetch global address list for project=" + vpcProject}
            # Filter the Global Address based on network and purpose.
            - extractGlobalIPRanges:
                try:
                  for:
                    value: currAddress
                    in: ${globalAddresses.items}
                    steps:
                    # only fetch IP address from the management server host vpc networking
                        - matchNetwork:
                            try:
                                call: text.match_regex
                                args:
                                    source: ${currAddress.network}
                                    regexp: ${vpcResourceName}
                                result: bmcNetwork
                            except:
                                as: ignoredException
                        - contactRanges:
                            switch:
                                - condition: ${bmcNetwork == true AND "purpose" in currAddress AND currAddress.purpose == "VPC_PEERING"}
                                  assign:
                                    - currRange: ${currAddress.address + "/" +  string(currAddress.prefixLength)}
                                    - ipRanges: ${list.concat(ipRanges, currRange)}
                except:
                  as: e
                  steps:
                    - cleanUp_getServiceNetworkingIpRange_vpc_sc_2:
                        call: deleteServiceAccount
                        args:
                          project: ${project}
                          serviceAccountEmail: ${serviceAccountEmail}
                          e: ${e}
                          message: ${"Unable to parse global address allocated for VPC=" + vpcResourceName}
            - updateGetGlobalAddressesToken:
                switch:
                    - condition: ${"nextPageToken" in globalAddresses}
                      steps:
                        - assignNextPageToken:
                            assign:
                                - getGlobalAddressPageToken: ${globalAddresses.nextPageToken}
                      next: getGlobalAddresses

  # Fetch the IP range of the service networking peering to the consumer project.
  - getServiceNetworkingIpRange:
      switch:
        - condition: ${agmURL != "" AND allowSNApis == true}
          steps:
            # Get the list of service connections for servicenetworking.googleapis.com.
            - getServiceConnection:
                try:
                  call: http.get
                  args:
                    url: ${"https://servicenetworking.googleapis.com/v1/services/servicenetworking.googleapis.com/connections"}
                    auth:
                      type: OAuth2
                    query:
                      network: ${vpcResourceName}
                  result: serviceConnections
                # Retry 30 times, with 4 seconds between each attempt.
                retry:
                  predicate: ${retryWithLogging}
                  max_retries: 30
                  backoff:
                    initial_delay: 4
                    max_delay: 4
                    multiplier: 1
                except:
                  as: e
                  steps:
                    - cleanUp5:
                        call: deleteServiceAccount
                        args:
                          project: ${project}
                          serviceAccountEmail: ${serviceAccountEmail}
                          e: ${e}
                          message: ${"Unable to fetch service networking connections for VPC=" + vpcResourceName}
            # Fetch the additional IP ranges.
            - extractIpRanges:
                try:
                  for:
                    value: currConnection
                    in: ${serviceConnections.body.connections}
                    steps:
                      - assignPeeringRangeNames:
                          for:
                            value: currRangeName
                            in: ${currConnection.reservedPeeringRanges}
                            steps:
                              - getIpFromRangeName:
                                  call: googleapis.compute.v1.globalAddresses.get
                                  args:
                                    address: ${currRangeName}
                                    project: ${vpcProject}
                                  result: currAddress
                              - appendPeeringRange:
                                  assign:
                                  - currRange: ${currAddress.address + "/" +  string(currAddress.prefixLength)}
                                  - ipRanges: ${list.concat(ipRanges, currRange)}
                except:
                  as: e
                  steps:
                    - cleanUp6:
                        call: deleteServiceAccount
                        args:
                          project: ${project}
                          serviceAccountEmail: ${serviceAccountEmail}
                          e: ${e}
                          message: ${"Unable to parse service networking IP range for VPC=" + vpcResourceName}

  # Create firewall rule for the VPC that the customer provided.
  - createFirewallRule:
      try:
        call: http.post
        args:
          url: ${"https://compute.googleapis.com/compute/v1/projects/" + vpcProject + "/global/firewalls"}
          auth:
            type: OAuth2
          body:
            name: ${firewallRuleName}
            network: ${vpcResourceName}
            direction: "INGRESS"
            # Only applies to instances running with the Sky service account.
            targetServiceAccounts:
              - ${serviceAccountEmail}
            allowed:
              - IPProtocol: "tcp"
                ports: ["26", "443", "3260", "5107"]
            # All IPs, but only from within this network.
            sourceRanges: ${ipRanges}
        result: createFirewallResponse
      # Retry 30 times, with 4 seconds between each attempt.
      retry:
        predicate: ${retryWithLogging}
        max_retries: 30
        backoff:
          initial_delay: 4
          max_delay: 4
          multiplier: 1
      except:
        as: e
        steps:
          - cleanUp7:
              call: deleteServiceAccount
              args:
                project: ${project}
                serviceAccountEmail: ${serviceAccountEmail}
                e: ${e}
                message: "Unable to create firewall rules."

  # Assign polling variables. Total poll time = 15 * 20 = 300 s = 5 minutes.
  - prepareFirewallLRO:
      assign:
        - pollCount: 0
        - maxPollCount: 20
        - pollInterval: 15

  # Poll the LRO for firewall rule creation.
  - pollFirewallLRO:
      try:
        call: http.get
        args:
          url: ${"https://compute.googleapis.com/compute/v1/projects/" + vpcProject + "/global/operations/" + createFirewallResponse.body.name}
          auth:
            type: OAuth2
        result: opResultFirewall
      # Retry 30 times, with 4 seconds between each attempt.
      retry:
        predicate: ${retryWithLogging}
        max_retries: 30
        backoff:
          initial_delay: 4
          max_delay: 4
          multiplier: 1
      except:
        as: e
        steps:
          - cleanUp8:
              call: deleteFirewallRule
              args:
                project: ${project}
                vpcProject: ${vpcProject}
                serviceAccountEmail: ${serviceAccountEmail}
                firewallRule: ${firewallRuleName}
                e: ${e}
                message: ${"Unable to poll firewall rule long-running operation."}

  # Process the LRO operation.
  - pollFirewallLROUpdate:
      steps:
        - incrementPollCountFirewall:
            assign:
              - pollCount: ${pollCount + 1}
        - checkIfDoneFirewall:
            switch:
              - condition: ${pollCount >= maxPollCount}
                call: deleteFirewallRule
                args:
                  project: ${project}
                  vpcProject: ${vpcProject}
                  serviceAccountEmail: ${serviceAccountEmail}
                  firewallRule: ${firewallRuleName}
                  e: ${"LRO polling exceeded for firewall insertion. Operation=" + createFirewallResponse.body.name}
                  message: ${"LRO polling exceeded for firewall insertion. Operation=" + createFirewallResponse.body.name}
              - condition: ${opResultFirewall.body.status != "DONE"}
                call: sys.sleep
                args:
                  seconds: ${pollInterval}
                next: pollFirewallLRO
              - condition: ${"httpErrorStatusCode" in opResultFirewall.body}
                steps:
                  - jsonEncodeFirewallInsertError:
                      call: json.encode_to_string
                      args:
                        data: ${opResultFirewall.body.error}
                      result: stringException
                  - cleanupFirewallInsertError:
                      call: deleteFirewallRule
                      args:
                        project: ${project}
                        vpcProject: ${vpcProject}
                        serviceAccountEmail: ${serviceAccountEmail}
                        firewallRule: ${firewallRuleName}
                        e: ${stringException}
                        message: ${"Firewall insert failed with code=" + string(opResultFirewall.body.httpErrorStatusCode) + " error=" + stringException}

  # Create a cloud KMS keyring for the Sky VM to use.
  - createKeyRing:
      try:
        steps:
          - assignKmsURLs:
              assign:
                - kmsURL: ${"https://cloudkms.googleapis.com/v1/projects/" + project + "/locations/"
                            + region + "/keyRings"}
                - kmsURLWithKeyRing: ${kmsURL + "/" + keyRingName}
          - postCreateKeyRing:
              call: http.post
              args:
                url: ${kmsURL}
                auth:
                  type: OAuth2
                query:
                  keyRingId: ${keyRingName}
      # Retry 30 times, with 4 seconds between each attempt.
      retry:
        predicate: ${retryWithLogging}
        max_retries: 30
        backoff:
          initial_delay: 4
          max_delay: 4
          multiplier: 1
      except:
        as: e
        steps:
          - cleanUp9:
              call: deleteFirewallRule
              args:
                project: ${project}
                vpcProject: ${vpcProject}
                serviceAccountEmail: ${serviceAccountEmail}
                firewallRule: ${firewallRuleName}
                e: ${e}
                message: ${"Keyring error creation or IAM modification error."}

  # Add policy bindings to the IAM policy of the keyring.
  - modifyKeyringIAM:
      try:
        call: addPolicyBindingKeyRing
        args:
          baseURL: ${kmsURLWithKeyRing}
          serviceAccountEmail: ${serviceAccountEmail}
          roles: ["roles/cloudkms.cryptoKeyEncrypterDecrypter", "roles/cloudkms.admin"]
      # Retry 30 times, with 4 seconds between each attempt.
      retry:
        predicate: ${retryWithLogging}
        max_retries: 30
        backoff:
          initial_delay: 4
          max_delay: 4
          multiplier: 1
      except:
        as: e
        steps:
          - cleanUp10:
              call: deleteFirewallRule
              args:
                project: ${project}
                vpcProject: ${vpcProject}
                serviceAccountEmail: ${serviceAccountEmail}
                firewallRule: ${firewallRuleName}
                e: ${e}
                message: ${"Keyring error creation or IAM modification error."}

  - assignVMMetadata:
      assign:
        - vmMetadata:
            items:
              - key: "bootstrap_secret"
                value: ${bootstrapSecret}
              - key: "kms_keyringname"
                value: ${keyRingName}
              - key: "primary_pool_device"
                value: ${primaryPoolDevice}
              - key: "performance_pool_device"
                value: ${snapshotPoolDevice}
              - key: "machine_type"
                value: ${machineType}


  - addBucketPrefix:
      switch:
        - condition: ${int(imageSplitRes[3]) > 1}
          assign:
            - newItem:
              - key: "bucket_prefix"
                value: ${bucketPrefix}
            - vmMetadata.items: ${list.concat(vmMetadata.items, newItem)}

  # Create the Sky VM. In case of failure, delete the Sky service account.
  - createSkyVM:
      try:
        switch:
          - condition: ${secureBoot == true}
            call: http.post
            args:
              url: ${"https://compute.googleapis.com/compute/v1/projects/" + project + "/zones/" + zone + "/instances"}
              auth:
                type: OAuth2
              body:
                name: ${skyName}
                machineType: ${"zones/" + zone + "/machineTypes/" + machineType}
                deletionProtection: true
                serviceAccounts:
                  - email: ${serviceAccountEmail}
                    scopes: "https://www.googleapis.com/auth/cloud-platform"
                disks:
                  # Boot disk.
                  - initializeParams:
                      diskSizeGb: "200"
                      diskType: ${diskTypeUrl}
                      sourceImage: ${bootDiskImage}
                    boot: true
                    autoDelete: true
                    deviceName: ${skyName}
                  # Primary pool.
                  - initializeParams:
                      diskName: ${skyName + "-primary-pool"}
                      diskSizeGb: ${primaryPoolSizeGb}
                      diskType: ${diskTypeUrl}
                    autoDelete: true
                    boot: false
                    deviceName: ${primaryPoolDevice}
                  # Snapshot pool.
                  - initializeParams:
                      diskName: ${skyName + "-snapshot-pool"}
                      diskSizeGb: ${snapshotPoolSizeGb}
                      diskType: ${diskTypeUrl}
                    autoDelete: true
                    boot: false
                    deviceName: ${snapshotPoolDevice}
                networkInterfaces:
                  - network: ${vpcResourceName}
                    subnetwork: ${subnetPath}
                # Set metadata for VM to ingest during configuration step.
                metadata: ${vmMetadata}
                shieldedInstanceConfig:
                  enableSecureBoot: ${secureBoot}
            result: createInstanceResponse
          - condition: ${secureBoot == false}
            call: http.post
            args:
              url: ${"https://compute.googleapis.com/compute/v1/projects/" + project + "/zones/" + zone + "/instances"}
              auth:
                type: OAuth2
              body:
                name: ${skyName}
                machineType: ${"zones/" + zone + "/machineTypes/" + machineType}
                deletionProtection: true
                serviceAccounts:
                  - email: ${serviceAccountEmail}
                    scopes: "https://www.googleapis.com/auth/cloud-platform"
                disks:
                  # Boot disk.
                  - initializeParams:
                      diskSizeGb: "200"
                      diskType: ${diskTypeUrl}
                      sourceImage: ${bootDiskImage}
                    boot: true
                    autoDelete: true
                    deviceName: ${skyName}
                  # Primary pool.
                  - initializeParams:
                      diskName: ${skyName + "-primary-pool"}
                      diskSizeGb: ${primaryPoolSizeGb}
                      diskType: ${diskTypeUrl}
                    autoDelete: true
                    boot: false
                    deviceName: ${primaryPoolDevice}
                  # Snapshot pool.
                  - initializeParams:
                      diskName: ${skyName + "-snapshot-pool"}
                      diskSizeGb: ${snapshotPoolSizeGb}
                      diskType: ${diskTypeUrl}
                    autoDelete: true
                    boot: false
                    deviceName: ${snapshotPoolDevice}
                networkInterfaces:
                  - network: ${vpcResourceName}
                    subnetwork: ${subnetPath}
                # Set metadata for VM to ingest during configuration step.
                metadata: ${vmMetadata}
            result: createInstanceResponse
      # Retry 10 times, with 15 seconds between each attempt.
      retry:
        predicate: ${retryWithLogging}
        max_retries: 10
        backoff:
          initial_delay: 15
          max_delay: 15
          multiplier: 1
      except:
        as: e
        steps:
          # Note that key ring deletion is not supported.
          # See https://cloud.google.com/kms/docs/faq#cannot_delete for more details.
          - cleanUp11:
              call: deleteFirewallRule
              args:
                project: ${project}
                vpcProject: ${vpcProject}
                serviceAccountEmail: ${serviceAccountEmail}
                firewallRule: ${firewallRuleName}
                e: ${e}
                message: "Unable to create Backup and DR Appliance virtual machine."

  # Assign polling variables. Total poll time = 15 * 100 = 1500 seconds = 25 minutes.
  - prepareInstanceLRO:
      assign:
        - pollCount: 0
        - maxPollCount: 100
        - pollInterval: 15

  # Poll the LRO for instance creation.
  - pollInstanceLRO:
      try:
        call: http.get
        args:
          url: ${"https://compute.googleapis.com/compute/v1/projects/" + project + "/zones/" + zone + "/operations/" + createInstanceResponse.body.name}
          auth:
            type: OAuth2
        result: opResultInstance
      # Retry 30 times, with 4 seconds between each attempt.
      retry:
        predicate: ${retryWithLogging}
        max_retries: 30
        backoff:
          initial_delay: 4
          max_delay: 4
          multiplier: 1
      except:
        as: e
        steps:
          - cleanUp12:
              call: deleteVM
              args:
                project: ${project}
                vpcProject: ${vpcProject}
                serviceAccountEmail: ${serviceAccountEmail}
                firewallRule: ${firewallRuleName}
                zone: ${zone}
                name: ${skyName}
                e: ${e}
                message: ${"Unable to poll LRO for instance creation."}

  # Process the LRO operation.
  - pollInstanceLROUpdate:
      steps:
        - incrementPollCountInstance:
            assign:
              - pollCount: ${pollCount + 1}
        - checkIfDoneInstance:
            switch:
              - condition: ${pollCount >= maxPollCount}
                call: deleteVM
                args:
                  project: ${project}
                  vpcProject: ${vpcProject}
                  serviceAccountEmail: ${serviceAccountEmail}
                  firewallRule: ${firewallRuleName}
                  zone: ${zone}
                  name: ${skyName}
                  e: ${"LRO polling exceeded for instance insertion. Operation=" + createInstanceResponse.body.name}
                  message: ${"LRO polling exceeded for instance insertion. Operation=" + createInstanceResponse.body.name}
              - condition: ${opResultInstance.body.status != "DONE"}
                call: sys.sleep
                args:
                  seconds: ${pollInterval}
                next: pollInstanceLRO
              - condition: ${"httpErrorStatusCode" in opResultInstance.body}
                steps:
                  - jsonEncodeInstanceInsertError:
                      call: json.encode_to_string
                      args:
                        data: ${opResultInstance.body.error}
                      result: stringException
                  - cleanupInstanceInsertError:
                      call: deleteVM
                      args:
                        project: ${project}
                        vpcProject: ${vpcProject}
                        serviceAccountEmail: ${serviceAccountEmail}
                        firewallRule: ${firewallRuleName}
                        zone: ${zone}
                        name: ${skyName}
                        e: ${stringException}
                        message: ${"Compute instance insert failed with code=" + string(opResultInstance.body.httpErrorStatusCode) + " error=" + stringException}

  - prepareRegister:
      assign:
        - registrationStage: ""

  # Register the Sky with AGM, using the private IP address of the Sky.
  - registerSky:
      try:
        switch:
          - condition: ${agmURL != ""}
            steps:
              - setRegistrationStage1:
                  assign:
                    - registrationStage: "getToken"
              - getToken2:
                  call: getToken
                  args:
                    serviceAccountEmail: ${serviceAccountEmail}
                    oauthClientID: ${oauthClientID}
                    useOAuth: ${useIVP}
                  result: token
              - setRegistrationStage2:
                  assign:
                    - registrationStage: "getAGMSession"
              - createSession2:
                  call: getAGMSession
                  args:
                    token: ${token}
                    agmURL: ${agmURL}
                  result: session
              - setRegistrationStage3:
                  switch:
                    - condition: ${useIVP == false}
                      steps:
                        - assignPromoteUser:
                            assign:
                              - registrationStage: "promoteUser"
                        - promoteUser:
                            call: http.put
                            args:
                              headers:
                                Authorization: ${"Bearer " + token}
                                backupdr-management-session: ${"Actifio " + session}
                              url: ${agmURL + "/manageacl/promoteUser"}
              - setRegistrationStage4:
                  assign:
                    - registrationStage: "getSky"
              - getSky:
                  call: googleapis.compute.v1.instances.get
                  args:
                      instance: ${skyName}
                      project: ${project}
                      zone: ${zone}
                  result: skyInstance
              - setRegistrationStage5:
                  assign:
                    - registrationStage: "register"
              - register:
                  call: http.post
                  args:
                    headers:
                      Authorization: ${"Bearer " + token}
                      backupdr-management-session: ${"Actifio " + session}
                    url: ${agmURL + "/cluster/register"}
                    body:
                      shared_secret: ${bootstrapSecret}
                      ipaddress: ${skyInstance.networkInterfaces[0].networkIP}
      # Retry 40 times, with 60 seconds between each attempt.
      retry:
        predicate: ${retryWithLogging}
        max_retries: 40
        backoff:
          initial_delay: 60
          max_delay: 60
          multiplier: 1
      except:
        as: e
        steps:
          - cleanUp13:
              call: deleteVM
              args:
                project: ${project}
                vpcProject: ${vpcProject}
                serviceAccountEmail: ${serviceAccountEmail}
                firewallRule: ${firewallRuleName}
                zone: ${zone}
                name: ${skyName}
                e: ${e}
                message: ${"Unable to register backup/recovery appliance with the management console. Registration stage= " +  registrationStage}

  # Removes the roles in the consumer project from the service account.
  - removeRolesConsumer:
      try:
        call: removePolicyBindingProject
        args:
          baseURL: ${"https://cloudresourcemanager.googleapis.com/v1/projects/" + consumerProject}
          serviceAccountEmail: ${serviceAccountEmail}
          roles: ["roles/backupdr.admin"]
      # Retry 30 times, with 4 seconds between each attempt.
      retry:
        predicate: ${retryWithLogging}
        max_retries: 30
        backoff:
          initial_delay: 4
          max_delay: 4
          multiplier: 1
      except:
        as: e
        steps:
          - cleanUp14:
              call: deleteVM
              args:
                project: ${project}
                vpcProject: ${vpcProject}
                serviceAccountEmail: ${serviceAccountEmail}
                firewallRule: ${firewallRuleName}
                zone: ${zone}
                name: ${skyName}
                e: ${e}
                message: ${"Unable to remove consumer project roles from service account."}

  # Removes the compute.admin and compute.networkUser roles from the host project if it is not the
  # target project, if the host project is the target project, then just remove compute.networkUser.
  - removeRolesHost:
      switch:
        - condition: ${vpcProject != project}
          steps:
            - removeComputeRolesHost:
                try:
                  call: removePolicyBindingProject
                  args:
                    baseURL: ${"https://cloudresourcemanager.googleapis.com/v1/projects/" + vpcProject}
                    serviceAccountEmail: ${serviceAccountEmail}
                    roles: ["roles/compute.admin", "roles/compute.networkUser"]
                # Retry 30 times, with 4 seconds between each attempt.
                retry:
                  predicate: ${retryWithLogging}
                  max_retries: 30
                  backoff:
                    initial_delay: 4
                    max_delay: 4
                    multiplier: 1
                except:
                  as: e
                  steps:
                    - cleanUp15:
                        call: deleteVM
                        args:
                          project: ${project}
                          vpcProject: ${vpcProject}
                          serviceAccountEmail: ${serviceAccountEmail}
                          firewallRule: ${firewallRuleName}
                          zone: ${zone}
                          name: ${skyName}
                          e: ${e}
                          message: ${"Unable to remove host project roles from service account."}
        - condition: ${vpcProject == project}
          steps:
            - removeComputeNetworkUserHost:
                try:
                  call: removePolicyBindingProject
                  args:
                    baseURL: ${"https://cloudresourcemanager.googleapis.com/v1/projects/" + project}
                    serviceAccountEmail: ${serviceAccountEmail}
                    roles: ["roles/compute.networkUser"]
                # Retry 30 times, with 4 seconds between each attempt.
                retry:
                  predicate: ${retryWithLogging}
                  max_retries: 30
                  backoff:
                    initial_delay: 4
                    max_delay: 4
                    multiplier: 1
                except:
                  as: e
                  steps:
                    - cleanUp16:
                        call: deleteVM
                        args:
                          project: ${project}
                          vpcProject: ${vpcProject}
                          serviceAccountEmail: ${serviceAccountEmail}
                          firewallRule: ${firewallRuleName}
                          zone: ${zone}
                          name: ${skyName}
                          e: ${e}
                          message: ${"Unable to remove host project roles from service account."}

  # Removes the roles in the target project from the service account.
  - removeRolesTarget:
      try:
        call: removePolicyBindingProject
        args:
          baseURL: ${"https://cloudresourcemanager.googleapis.com/v1/projects/" + project}
          serviceAccountEmail: ${serviceAccountEmail}
          roles: ["roles/iam.serviceAccountAdmin", "roles/cloudkms.admin",
                  "roles/iam.serviceAccountTokenCreator"]
      # Retry 30 times, with 4 seconds between each attempt.
      retry:
        predicate: ${retryWithLogging}
        max_retries: 30
        backoff:
          initial_delay: 4
          max_delay: 4
          multiplier: 1
      except:
        as: e
        steps:
          - cleanUp17:
              call: deleteVM
              args:
                project: ${project}
                vpcProject: ${vpcProject}
                serviceAccountEmail: ${serviceAccountEmail}
                firewallRule: ${firewallRuleName}
                zone: ${zone}
                name: ${skyName}
                e: ${e}
                message: ${"Unable to remove target project roles from service account."}

  # Conditionally removes compute.admin from the target project.
  - conditionallyRemoveComputeAdminTarget:
      switch:
        - condition: ${removeComputeAdmin == true}
          steps:
            - removeComputeAdminTarget:
                try:
                  call: removePolicyBindingProject
                  args:
                    baseURL: ${"https://cloudresourcemanager.googleapis.com/v1/projects/" + project}
                    serviceAccountEmail: ${serviceAccountEmail}
                    roles: ["roles/compute.admin"]
                # Retry 30 times, with 4 seconds between each attempt.
                retry:
                  predicate: ${retryWithLogging}
                  max_retries: 30
                  backoff:
                    initial_delay: 4
                    max_delay: 4
                    multiplier: 1
                except:
                  as: e
                  steps:
                    - cleanUp18:
                        call: deleteVM
                        args:
                          project: ${project}
                          vpcProject: ${vpcProject}
                          serviceAccountEmail: ${serviceAccountEmail}
                          firewallRule: ${firewallRuleName}
                          zone: ${zone}
                          name: ${skyName}
                          e: ${e}
                          message: ${"Unable to remove target project roles from service account."}

  # Removes resourcemanager.projectIamAdmin role from the target, host, and consumer projects.
  - removeProjectIamAdmin:
      steps:
        - assignProjectList:
            assign:
              - projectList: [${project}, ${vpcProject}, ${consumerProject}]
              - doneProjectList: []
        - iterateProjectList:
            for:
              value: curProj
              in: ${projectList}
              steps:
                - assignProjectDone:
                    assign:
                      - projectDone: false
                - checkDoneProjects:
                    for:
                      value: iterProj
                      in: ${doneProjectList}
                      steps:
                        - isInDone:
                           switch:
                             - condition: ${iterProj == curProj}
                               assign:
                                 - projectDone: true
                - skipIterationIfProjectDone:
                    switch:
                      - condition: ${projectDone == true}
                        next: continue # go to next project.
                - removeIamAdmin:
                    try:
                      call: removePolicyBindingProject
                      args:
                        baseURL: ${"https://cloudresourcemanager.googleapis.com/v1/projects/" + curProj}
                        serviceAccountEmail: ${serviceAccountEmail}
                        roles: ["roles/resourcemanager.projectIamAdmin"]
                    # Retry 30 times, with 4 seconds between each attempt.
                    retry:
                      predicate: ${retryWithLogging}
                      max_retries: 30
                      backoff:
                        initial_delay: 4
                        max_delay: 4
                        multiplier: 1
                    except:
                      as: e
                      steps:
                        - cleanUp19:
                            call: deleteVM
                            args:
                              project: ${project}
                              vpcProject: ${vpcProject}
                              serviceAccountEmail: ${serviceAccountEmail}
                              firewallRule: ${firewallRuleName}
                              zone: ${zone}
                              name: ${skyName}
                              e: ${e}
                              message: ${"Unable to remove consumer project roles from service account."}
                - addToDoneProjects:
                    assign:
                      - doneProjectList: ${list.concat(doneProjectList, curProj)}

# Function to add a policy binding for a service account to a newly created KeyRing. This is much
# simpler than updating the policy of the entire project, because we are creating a new binding
# list. This process is broken down into 2 steps.
#
# 1. Create a new binding list based on the permissions to be granted for the service account.
# 2. Set the IAM policy of the KeyRing with the new binding list.
#
# @param baseURL the URL on which to call setIamPolicy.
# @param serviceAccountEmail the account to create a binding for
# @param roles a list of roles to assign to the service account
addPolicyBindingKeyRing:
  params: [baseURL, serviceAccountEmail, roles]
  steps:
    - createEmptyBindingList:
        assign:
          - bindingList: []
    # Add the bindings.
    - addNewBindings:
        for:
          value: role
          in: ${roles}
          steps:
            - createBinding:
                assign:
                  - newBinding:
                      members:
                        - ${"serviceAccount:" + serviceAccountEmail}
                      role: ${role}
                  - bindingList: ${list.concat(bindingList, newBinding)}
    # Set the new IAM policy for the keyring.
    - setIamPolicyKeyRing:
        call: setIamPolicyBindingList
        args:
          baseURL: ${baseURL}
          bindingList: ${bindingList}

# Function to set the IAM policy of a resource by overriding an existing binding list.
#
# @param baseURL the URL on which to call setIamPolicy
# @param bindingList the updated binding list for the policy
setIamPolicyBindingList:
    params: [baseURL, bindingList]
    steps:
      - setCall:
          call: http.post
          args:
            url: ${baseURL + ":setIamPolicy"}
            auth:
              type: OAuth2
            body:
              policy:
                bindings: ${bindingList}
              # Specify that we are only changing bindings.
              updateMask: "bindings"

# Function to delete a service account. This is invoked as part of the clean up process in the case
# of a failed installation to delete the service account we created for the Sky VM. This function
# is parameterized by the error which caused the workflow to fail. Once it deletes the service
# account it raises this error in order to inform the user what went wrong.
#
# @param project the consumer project ID where the Sky service account was created
# @param serviceAccountEmail the name of the service account to be deleted
# @param e the error to be raised once the service account is deleted
deleteServiceAccount:
    params: [project, serviceAccountEmail, e, message]
    steps:
      - jsonEncode:
          call: json.encode_to_string
          args:
            data: ${e}
          result: stringException
      - logGenError:
          try:
            call: logGeneralError
            args:
              toLog: ${stringException}
          # Continue on even if we can't log the error.
          except:
            as: ignoredException
            steps:
              - nextDeleteCall:
                  next: deleteCall
      - deleteCall:
          try:
            call: http.delete
            args:
              url: ${"https://iam.googleapis.com/v1/projects/" + project + "/serviceAccounts/"
                     + serviceAccountEmail}
              auth:
                type: OAuth2
          except:
            as: deleteException
            steps:
              - logDeleteServiceAccountFailure:
                  call: logDeleteError
                  args:
                    resource: "Backup/recovery appliance service account"
                    exception: ${deleteException}
      - checkForHttpError:
          # For HTTP errors, we can pretty print the message for the user.
          try:
            assign:
              - errMsg: ${"Error code=" + string(e.body.error.code) + ", Error Message=" + e.body.error.message}
          # Otherwise, we don't know the error structure, so just report the whole thing.
          except:
            as: ignoredException
            steps:
              - assignErrMsg:
                  assign:
                    - errMsg: ${stringException}
      - raiseError:
          raise: ${message + " " + errMsg}

# Function to delete a firewall rule. This is invoked as part of the clean up process in the case
# of a failed installation to delete the firewall we created for the Sky VM. This function
# is parameterized by the error which caused the workflow to fail, and it calls deleteServiceAccount
# to continue the rollback process.
#
# @param project the consumer project ID where the Sky service account was created
# @param vpcProject the project ID where the VPC lives
# @param serviceAccountEmail the name of the service account to be deleted
# @param firewallRule the name of the firewall rule to be deleted
# @param e the error to be raised once the service account is deleted
# @param message the message to attach to the exception that is raised
deleteFirewallRule:
    params: [project, vpcProject, serviceAccountEmail, firewallRule, e, message]
    steps:
      - deleteFirewallCall:
          try:
            call: googleapis.compute.v1.firewalls.delete
            args:
              firewall: ${firewallRule}
              project: ${vpcProject}
          except:
            as: deleteException
            steps:
              - logDeleteFirewallFailure:
                  call: logDeleteError
                  args:
                    resource: "Firewall rule"
                    exception: ${deleteException}
      - callDeleteServiceAccount:
          call: deleteServiceAccount
          args:
            project: ${project}
            serviceAccountEmail: ${serviceAccountEmail}
            e: ${e}
            message: ${message}

# Function to delete a VM. This function is invoked in case of a failed installation after the VM
# was already created. It is parameterized by the error, and it calls deleteFirewallRule to
# continue the rollback process.
#
# @param project the project where the disk will be created
# @param vpcProject the project ID where the VPC lives
# @param serviceAccountEmail the Sky service account
# @param firewallRule the name of the firewall rule to be deleted
# @param zone the zone where the VM is
# @param name the name of the VM
# @param e the error to be passed into deleteServiceAccount
deleteVM:
  params: [project, vpcProject, serviceAccountEmail, firewallRule, zone, name, e, message]
  steps:
    - disableDeletionProtection:
        try:
          call: googleapis.compute.v1.instances.setDeletionProtection
          args:
            project: ${project}
            resource: ${name}
            zone: ${zone}
            deletionProtection: false
        except:
          as: deleteException
          steps:
            - logDeletionProtectionError:
                call: logDeleteError
                args:
                  resource: "Backup/recovery appliance: deletion protection"
                  exception: ${deleteException}
    - deleteVMCall:
        try:
          call: googleapis.compute.v1.instances.delete
          args:
            instance: ${name}
            project: ${project}
            zone: ${zone}
        except:
          as: deleteException
          steps:
            - logDeleteVMFailure:
                call: logDeleteError
                args:
                  resource: "Backup/recovery appliance"
                  exception: ${deleteException}
    - callDeleteFirewallRule:
        call: deleteFirewallRule
        args:
          project: ${project}
          vpcProject: ${vpcProject}
          serviceAccountEmail: ${serviceAccountEmail}
          firewallRule: ${firewallRule}
          e: ${e}
          message: ${message}

# Function to log deletion errors at the alert level.
#
# @param resource the resource that was not able to be deleted
# @param exception the exception raised during the deletion failure
logDeleteError:
  params: [resource, exception]
  steps:
    - jsonEncode:
        call: json.encode_to_string
        args:
          data: ${exception}
        result: stringException
    - logError:
        call: sys.log
        args:
          text: ${"Deletion Error. " + resource + " deletion failed with exception=" + stringException}
          severity: "ALERT"

# Function to log errors at the alert level.
#
# @param exception the exception raised during the deletion failure
logGeneralError:
  params: [toLog]
  steps:
    - logError:
        call: sys.log
        args:
          text: ${"Backup/recovery appliance installation failed with exception=" + toLog}
          severity: "ALERT"

# Function to generate a token (OIDC or OAuth) for workflow sevice account.
#
# @param useOAuth bool indicating if we should get an OAuth token, if false get OIDC
# @param serviceAccountEmail the email address of the workflow service account
# @param oauthClientID the audience to generate the OIDC token for (not needed for OAuth)
#
# @returns the token
getToken:
  params: [useOAuth, serviceAccountEmail, oauthClientID]
  steps:
    - decideTokenType:
        switch:
          - condition: ${useOAuth == true}
            call: getOAuthToken
            args:
              serviceAccountEmail: ${serviceAccountEmail}
            result: token
          - condition: ${useOAuth == false}
            call: getOIDCToken
            args:
              serviceAccountEmail: ${serviceAccountEmail}
              oauthClientID: ${oauthClientID}
            result: token
    - return:
        return: ${token}

# Function to generate an OAuth token for workflow sevice account.
#
# @param serviceAccountEmail the email address of the workflow service account
# @param oauthClientID the audience to generate the token for
#
# @returns the OIDC token
getOAuthToken:
  params: [serviceAccountEmail]
  steps:
    - generate:
        call: http.post
        args:
          url: ${"https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/" + serviceAccountEmail + ":generateAccessToken"}
          auth:
            type: OAuth2
          body:
            scope:
            - "https://www.googleapis.com/auth/cloud-platform"
        result: oauthResp
    - return:
        return: ${oauthResp.body.accessToken}

# Function to generate an OIDC token for workflow sevice account and the oauth audience.
#
# @param serviceAccountEmail the email address of the workflow service account
# @param oauthClientID the audience to generate the token for
#
# @returns the OIDC token
getOIDCToken:
  params: [serviceAccountEmail, oauthClientID]
  steps:
    - generate:
        call: http.post
        args:
          url: ${"https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/" + serviceAccountEmail + ":generateIdToken"}
          auth:
            type: OAuth2
          body:
            audience: ${oauthClientID}
            includeEmail: true
        result: oidcResp
    - return:
        return: ${oidcResp.body.token}

# Function to create an AGM session using the OIDC token.
#
# @param token the token generated for the service account
# @param agmURL the API URL of the AGM.
#
# @returns the session ID
getAGMSession:
  params: [token, agmURL]
  steps:
    - session:
        call: http.post
        args:
          headers:
            Authorization: ${"Bearer " + token}
          url: ${agmURL + "/session"}
        result: session
    - return:
        return: ${session.body.session_id}

# Function to retry errors while logging the exception that was thrown.
#
# @param the error gererated
#
# @returns bool this is always true.
retryWithLogging:
  params: [e]
  steps:
    # We try to log, but if it fails, we still retry the error.
    - tryToLog:
        try:
          steps:
            - jsonEncode:
                call: json.encode_to_string
                args:
                  data: ${e}
                result: stringException
            - logURLNotReachable:
                call: sys.log
                args:
                  text: ${"Retrying = " + stringException}
                  severity: "WARNING"
        except:
          as: e
          steps:
            - retTrueLogFailed:
                return: True
    - retTrue:
        return: True

# Function to retry non-404 errors while logging the exception that was thrown.
#
# @param the error gererated
#
# @returns bool this is always true.
retryNon404WithLogging:
  params: [e]
  steps:
    # We try to log, but if it fails, we still retry the error.
    - tryToLog:
        try:
          steps:
            - check404:
                switch:
                # Don't retry if 404.
                - condition: ${e.code == 404}
                  return: False
            - jsonEncode:
                call: json.encode_to_string
                args:
                  data: ${e}
                result: stringException
            - logURLNotReachable:
                call: sys.log
                args:
                  text: ${"Retrying = " + stringException}
                  severity: "WARNING"
        except:
          as: e
          steps:
            - retTrueLogFailed:
                return: True
    - retTrue:
        return: True

# Function to remove a policy binding for a service account to a project. This is a 3 step process.
# 1. Get the IAM policy of the project.
# 2. Modify the policy to exclude a binding for the service account and the role.
# 3. Set the IAM policy of the project.
#
# @param baseURL the URL on which to call (get||set)IamPolicy.
# @param serviceAccountEmail the account to remove the binding for
# @param roles the list of roles to remove from the service account
removePolicyBindingProject:
  params: [baseURL, serviceAccountEmail, roles]
  steps:
  # Get the current IAM policy for the project.
  - getIamPolicy:
      call: http.post
      args:
        url: ${baseURL + ":getIamPolicy"}
        auth:
          type: OAuth2
      result: projectIamPolicy
  - assignBindingsList:
      assign:
        - bindingList: ${projectIamPolicy.body.bindings}
  # Remove the bindings.
  - removeBindings:
      for:
        value: role
        in: ${roles}
        steps:
          - removeBinding:
              call: removeSingleRole
              args:
                bindings: ${bindingList}
                serviceAccountEmail: ${serviceAccountEmail}
                role: ${role}
              result: bindingList
  # Set the new IAM policy for the project.
  - setIamPolicyProject:
      call: setIamPolicyBindingList
      args:
        baseURL: ${baseURL}
        bindingList: ${bindingList}

# Function to remove a role + service account binding from the binding list.
#
# @param bindings the current binding list
# @param serviceAccountEmail the account to remove the binding for
# @param role the role to remove from the service account
removeSingleRole:
  params: [bindings, serviceAccountEmail, role]
  steps:
  # Assign variables needed for iteration.
  - assignBindingsList:
      assign:
        - roleBindings: ${bindings}
        - bindingIndex: 0
        - foundBinding: false
        - serviceAccountWithPrefix: ${"serviceAccount:" + serviceAccountEmail}
        - newAccountList: []
  # Iterate the list of bindings to find the index of the correct role.
  - iterateBindings:
      for:
          value: currentRole
          in: ${roleBindings}
          steps:
              - checkRole:
                  switch:
                    # If we find the role in the current binding list, break out of loop.
                    - condition: ${currentRole.role == role}
                      assign:
                        - foundBinding: ${true}
                      next: break
              # Else increment to keep looking.
              - increment:
                  assign:
                    - bindingIndex: ${bindingIndex+1}
  - returnIfNotFound:
      switch:
        - condition: ${foundBinding == false}
          next: returnBindings
  # Iterate the list of accounts to construct the new members list.
  - iterateAccounts:
      for:
          value: currentAccount
          in: ${roleBindings[bindingIndex].members}
          steps:
              - checkAccount:
                  switch:
                    # If the account doesn't match, add it to the new list.
                    - condition: ${currentAccount != serviceAccountWithPrefix}
                      assign:
                        - newAccountList: ${list.concat(newAccountList, currentAccount)}
  - assignNewList:
      assign:
        - roleBindings[bindingIndex].members: ${newAccountList}
  - returnBindings:
      return: ${roleBindings}

# Function to add a conditional policy binding for a service account to a project. This is a 3 step process.
# 1. Get the IAM policy of the project.
# 2. Modify the policy to add a binding for the service account and the role.
# 3. Set the IAM policy of the project.
#
# @param baseURL the URL on which to call (get||set)IamPolicy.
# @param serviceAccountEmail the account to add the binding for
# @param role the role which needs to be added
# @param expression the conditional iam expression
# @param title the title of conditional iam to be shown in pantheon
# @param title the description of the condition
addConditionalPolicyBindingProject:
  params: [baseURL, serviceAccountEmail, role, expression, title, description]
  steps:
  - getBindings:
      call: getIamBindingsV3
      args:
        baseURL: ${baseURL}
      result: roleBindings
  - createRoleEntry:
      assign:
        - newBinding:
            members:
              - ${"serviceAccount:" + serviceAccountEmail}
            role: ${role}
            condition:
              expression: ${expression}
              title: ${title}
              description: ${description}
        - roleBindings: ${list.concat(roleBindings, newBinding)}
  - setIamPolicyBindingList:
      call: setIamPolicyBindingListV3
      args:
        baseURL: ${baseURL}
        bindingList: ${roleBindings}
  - returnBindings:
      return: ${roleBindings}

# Function to get the IAM policy of a resource
#
# @param baseURL the URL on which to call getIamPolicy
getIamBindingsV3:
  params: [baseURL]
  steps:
  # Get the current IAM policy for the project.
  - getIamPolicy:
      call: http.post
      args:
        url: ${baseURL + ":getIamPolicy"}
        auth:
          type: OAuth2
        body:
          options:
            requestedPolicyVersion: 3
      result: projectIamPolicy
  - returnBindings:
      return: ${projectIamPolicy.body.bindings}

# Function to set the IAM policy of a resource by overriding an existing binding list.
#
# @param baseURL the URL on which to call setIamPolicy
# @param bindingList the updated binding list for the policy (bindingList should be fetched with version 3)
setIamPolicyBindingListV3:
    params: [baseURL, bindingList]
    steps:
      - setCall:
          call: http.post
          args:
            url: ${baseURL + ":setIamPolicy"}
            auth:
              type: OAuth2
            body:
              policy:
                bindings: ${bindingList}
                version: 3
EOF

SKY_NAME="qwiklabs-appliance"
ZONE=$(gcloud compute instances list --filter "name="startup-vm"" --format "value(zone.basename())")
REGION="${ZONE%-*}"
NETWORK="default"
SUBNET="default"
AGM_URL=$(curl_prod $CONSUMER_ENDPOINT/managementServers | jq -r .managementServers[].managementUri.api?)
OAUTH_CLIENT_ID=$(curl_prod $CONSUMER_ENDPOINT/managementServers | jq -r .managementServers[].oauth2ClientId?)
NET_PATH="projects/$PROJECT_ID/global/networks/default"
SRC_PATH="installer.yaml"
WORKFLOW_SERVICE_ACCOUNT_NAME="workflow"
WORKFLOW_SERVICE_ACCOUNT_EMAIL="$WORKFLOW_SERVICE_ACCOUNT_NAME@$PROJECT_ID.iam.gserviceaccount.com"
WORKFLOW_NAME="sky-installer"

curdate=$(date "+%s")
# secret valid for 24 hrs
curdate=$((curdate+86400))
BOOTSTRAP_SECRET="$(head -c 40 /dev/urandom | base64 | tr -d '/+' | head -c 40 | tr '[:upper:]' '[:lower:]')00000000$(printf "%x" $curdate)"

# The bootstrapSecret is valid until November 1st 2023
WORKFLOW_PARAMS=$(cat <<EOM
{
  "agmURL": "$AGM_URL",
  "bootstrapSecret": "$BOOTSTRAP_SECRET",
  "consumerProject": "$PROJECT_ID",
  "diskType": "pd-ssd",
  "hostProject": "$PROJECT_ID",
  "oauthClientID": "$OAUTH_CLIENT_ID",
  "region": "$REGION",
  "skyName": "$SKY_NAME",
  "snapshotPoolSizeGb": "200",
  "subnetName": "$SUBNET",
  "vpcName": "$NETWORK",
  "msVpcResourceName": "$NET_PATH",
  "vpcResourceName": "$NET_PATH",
  "workflowSA": "$WORKFLOW_SERVICE_ACCOUNT_EMAIL",
  "zone": "$ZONE"
}
EOM
)

printMessage "Launching sky installer..."

# Enable APIS
gcloud services enable compute.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable workflows.googleapis.com
gcloud services enable workflowexecutions.googleapis.com
gcloud services enable cloudkms.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com

# Create service account for the cloud workflow.
gcloud iam service-accounts create "$WORKFLOW_SERVICE_ACCOUNT_NAME" \
--display-name="Test Sky install cloud workflow service account."

# Function to add policy bindings for the workflow service account.
addPolicyBinding() {
gcloud projects add-iam-policy-binding "$PROJECT_ID" \
--member="serviceAccount:$WORKFLOW_SERVICE_ACCOUNT_EMAIL" --role="roles/$1" \
--condition=None >/dev/null 2>&1
}

addPolicyBinding "backupdr.computeEngineOperator"
addPolicyBinding "backupdr.admin"
addPolicyBinding "cloudkms.admin"
addPolicyBinding "compute.admin"
addPolicyBinding "compute.networkUser"
addPolicyBinding "iam.serviceAccountAdmin"
addPolicyBinding "iam.serviceAccountTokenCreator"
addPolicyBinding "iam.serviceAccountUser"
addPolicyBinding "logging.logWriter"
addPolicyBinding "resourcemanager.projectIamAdmin"


# Sleep to allow IAM bindings to set.
sleep 30

# Deploy the cloud workflow
gcloud workflows deploy "$WORKFLOW_NAME" \
--source="installer.yaml" \
--service-account="$WORKFLOW_SERVICE_ACCOUNT_EMAIL" --location="$REGION"

# Function to create an execution of the cloud workflow.
runCloudWorkflow() {
gcloud workflows run "$WORKFLOW_NAME" --data="$WORKFLOW_PARAMS" \
--location="$REGION"
}

printMessage "Executing cloud workflow..."

runCloudWorkflow
echo
printMessage "Execution above should be SUCCEEDED."

printMessage "Done!"

curl_prod $CONSUMER_ENDPOINT/managementServers
