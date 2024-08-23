# Script by Vish@l Bidwe (bidwe@google.com) for Qwiklabs Disaster Recovery and Backup service labs
PROJECT_ID=$(gcloud config get-value project)
export ZONE=$(gcloud compute instances list --filter "name="startup-vm"" --format "value(zone.basename())")
export REGION="${ZONE%-*}"
CONSUMER_ENDPOINT="https://backupdr.googleapis.com/v1/projects/$PROJECT_ID/locations/$REGION"
AGM_URL=$(curl -s -H "Authorization: Bearer $(gcloud auth print-access-token)" -H "Content-Type: application/json" $CONSUMER_ENDPOINT/managementServers | jq -r .managementServers[].managementUri.api?)
ID_TOKEN=$(gcloud auth application-default print-access-token)
SESSION_ID=$(curl -s -X POST -H "Authorization: Bearer $ID_TOKEN" -H "Content-Type: application/json; charset=utf-8" $AGM_URL/session | jq -r .session_id?)
TOKEN_URL=https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/workflow@$PROJECT_ID.iam.gserviceaccount.com:generateIdToken
PROMOTE_USER=$(curl -s -X PUT $AGM_URL/manageacl/promoteUser -H "Authorization: Bearer $ID_TOKEN" -H "backupdr-management-session: Actifio $SESSION_ID" -H "Content-Type: application/json; charset=utf-8")


#1. Add an OnVault pool
task_1(){

desired_onvault_pool="onvaultbackupbucket"
GET_RESOURCE_ID=$(curl -s -X GET ${AGM_URL}/diskpool -H "Authorization: Bearer ${ID_TOKEN}" -H "backupdr-management-session: Actifio ${SESSION_ID}" -H "Content-Type: application/json; charset=utf-8" | jq -r --arg queryname "$desired_onvault_pool" '.items[] | select(.name == $queryname).id')
if [[ $GET_RESOURCE_ID ]];
then
    POOL_RESULT=$(curl -s ${AGM_URL}/diskpool/$GET_RESOURCE_ID -H "Authorization: Bearer ${ID_TOKEN}" -H "backupdr-management-session: Actifio ${SESSION_ID}" -H "Content-Type: application/json; charset=utf-8" | grep onvaultbackupbucket)
    if [[ $POOL_RESULT =~ "onvaultbackupbucket" ]];
    then
        echo "Found:200"
    fi
else
    echo "Not Found:500"
fi
}

#2. Create a backup plan template
task_2(){

template="DB-Gold"
ID=$(curl -s ${AGM_URL}/slt -H "Authorization: Bearer ${ID_TOKEN}" -H "backupdr-management-session: Actifio ${SESSION_ID}" -H "Content-Type: application/json; charset=utf-8"|jq -r --arg queryname "$template" '.items[] | select(.name == $queryname).id')
BACKUP_TEMPLATE_RESULT=$(curl -s ${AGM_URL}/slt/${ID}/policy -H "Authorization: Bearer ${ID_TOKEN}" -H "backupdr-management-session: Actifio ${SESSION_ID}" -H "Content-Type: application/json; charset=utf-8"|jq -r '.items[] | select((.name == "Snap every 12 hours") and .retention == "2" and .iscontinuous == true and .rpo == "12" and .slt.name == "DB-Gold")')
if [[ $BACKUP_TEMPLATE_RESULT =~ "DB-Gold" ]];
then
    echo "Found:200"
else
    echo "Not Found:500"
fi

}

#3. Create a backup plan profile
task_3(){

profile="LocalandCloudStorage"
ID=$(curl -s ${AGM_URL}/slp -H "Authorization: Bearer ${ID_TOKEN}" -H "backupdr-management-session: Actifio ${SESSION_ID}" -H "Content-Type: application/json; charset=utf-8"|jq -r --arg queryname "$profile" '.items[] | select(.name == $queryname).id')
BACKUP_PROFILE_RESULT=$(curl -s ${AGM_URL}/slp/${ID} -H "Authorization: Bearer ${ID_TOKEN}" -H "backupdr-management-session: Actifio ${SESSION_ID}" -H "Content-Type: application/json; charset=utf-8"|jq -r ' select((.name == "LocalandCloudStorage") and .localnode == "qwiklabs-appliance")')
if [[ $BACKUP_PROFILE_RESULT =~ "onvaultbackupbucket" ]];
then
    echo "Found:200"
else
    echo "Not Found:500"
fi

}

#4. Backup plan applied for PostgreSQL database
task_4(){

JOB_INFO_POLICY1=$(curl -s ${AGM_URL}/jobstatus -H "Authorization: Bearer ${ID_TOKEN}" -H "backupdr-management-session: Actifio ${SESSION_ID}" -H "Content-Type: application/json; charset=utf-8"|jq -r '.items[] | select((.jobclass == "snapshot") and .status == "succeeded" and (.policyname == "Snap every 12 hours") and .hostname == "linuxhost")')
JOB_INFO_POLICY2=$(curl -s ${AGM_URL}/jobstatus -H "Authorization: Bearer ${ID_TOKEN}" -H "backupdr-management-session: Actifio ${SESSION_ID}" -H "Content-Type: application/json; charset=utf-8"|jq -r '.items[] | select((.jobclass == "OnVault") and .status == "succeeded" and (.policyname == "OnVault Every 12 hours") and .hostname == "linuxhost")')
if [[ $JOB_INFO_POLICY1 =~ "succeeded" ]] && [[ $JOB_INFO_POLICY2 =~ "succeeded" ]] ;
then
    echo "Found:200"
else
    echo "Not Found:500"
fi

}


#5. Restore PostgreSQL database
task_5(){

JOB_INFO=$(curl -s ${AGM_URL}/jobstatus -H "Authorization: Bearer ${ID_TOKEN}" -H "backupdr-management-session: Actifio ${SESSION_ID}" -H "Content-Type: application/json; charset=utf-8"|jq -r '.items[] | select((.jobclass == "restore") and .status == "succeeded" and (.policyname == "Snap every 12 hours") and .hostname == "linuxhost")')
if [[ $JOB_INFO =~ "succeeded" ]];
then
    echo "Found:200"
else
    echo "Not Found:500"
fi

}

#6. Mount PostgreSQL database
task_6(){

JOB_INFO=$(curl -s ${AGM_URL}/jobstatus -H "Authorization: Bearer ${ID_TOKEN}" -H "backupdr-management-session: Actifio ${SESSION_ID}" -H "Content-Type: application/json; charset=utf-8"|jq -r '.items[] | select((.jobclass == "mount") and .status == "succeeded" and (.policyname == "Snap every 12 hours") and .hostname == "linuxhost")')
if [[ $JOB_INFO =~ "succeeded" ]];
then
    echo "Found:200"
else
    echo "Not Found:500"
fi
}

# Script by Vish@l Bidwe (bidwe@google.com) for Qwiklabs Disaster Recovery and Backup service labs
opt=$1
case "$opt" in
   "1") task_1 ;;
   "2") task_2 ;;
   "3") task_3 ;;
   "4") task_4 ;;
   "5") task_5 ;;
   "6") task_6 ;;
   *) echo "Option not selected";;
esac
