# HERO TEMPLATE - Sept 2025
#!/bin/bash
export PROJECT_ID="$1"

# Set the Platform Project
gcloud config set project "$1"

# Create CloudBuild script
cat << 'EOF' > cloudbuild.yaml
steps:
- id: bucket_copy 
  name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
  env:
  - 'PROJECT_ID=${_PROJECT_ID}'
  - 'APP_NAME=${_APP_NAME}'
  script: |
    #!/bin/bash
    ## SCRIPT START
    # Copy across remote assets 
    gsutil -m cp -R gs://spls/arc-hero/Dockerfile /workspace 
    gsutil -m cp -R gs://spls/arc-hero/nginx/default.conf /workspace 
    gsutil -m cp -R gs://spls/arc-hero/web /workspace 

    # Add generated tasks.json file to the application 
    gsutil cp gs://${PROJECT_ID}-app/tasks.json /workspace/web/assets/config/tasks.json
    ## SCRIPT END

- id: image_build 
  name: 'gcr.io/cloud-builders/docker'
  # Artifact Registry
  args: ['build', 
    '-t', '${_REGION}-docker.pkg.dev/$PROJECT_ID/${_REPO_NAME}/${_IMAGE_NAME}:${_IMAGE_VERSION}',
    '-t', '${_REGION}-docker.pkg.dev/$PROJECT_ID/${_REPO_NAME}/${_IMAGE_NAME}:${_IMAGE_REVISION}',
    '.']

- id: image_push
  name: 'gcr.io/cloud-builders/docker'
  env:
  - 'PROJECT_ID=${_PROJECT_ID}'
  - 'REGION=${_REGION}'
  - 'REPO_NAME=${_REPO_NAME}'
  - 'IMAGE_NAME=${_IMAGE_NAME}'
  - 'IMAGE_VERSION=${_IMAGE_VERSION}'
  - 'IMAGE_REVISION=${_IMAGE_REVISION}'
  script: |
    echo "IMAGE: ${REGION}-docker.pkg.dev/$PROJECT_ID/${REPO_NAME}/${IMAGE_NAME}:${IMAGE_VERSION}"
    docker push ${REGION}-docker.pkg.dev/$PROJECT_ID/${REPO_NAME}/${IMAGE_NAME}:${IMAGE_VERSION}
    docker push ${REGION}-docker.pkg.dev/$PROJECT_ID/${REPO_NAME}/${IMAGE_NAME}:${IMAGE_REVISION}

- id: image_deploy
  name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
  env:
  - 'PROJECT_ID=${_PROJECT_ID}'
  - 'REGION=${_REGION}'
  - 'REPO_NAME=${_REPO_NAME}'
  - 'IMAGE_NAME=${_IMAGE_NAME}'
  - 'IMAGE_VERSION=${_IMAGE_VERSION}'
  - 'IMAGE_REVISION=${_IMAGE_REVISION}'
  - 'SERVICE_NAME=${_SERVICE_NAME}'
  script: |
    echo "IMAGE: ${REGION}-docker.pkg.dev/$PROJECT_ID/${REPO_NAME}/${IMAGE_NAME}:${IMAGE_REVISION}"
    gcloud run deploy ${SERVICE_NAME} --image ${REGION}-docker.pkg.dev/$PROJECT_ID/${REPO_NAME}/${IMAGE_NAME}:${IMAGE_REVISION} --region ${REGION} --platform managed --allow-unauthenticated

options:
  substitution_option: 'ALLOW_LOOSE'

# SET TIMEOUT TO SCRIPT DURATION 
timeout: 1500s

substitutions:

  _PROJECT_ID: project_id
  _BUCKET_NAME: spls/arc-hero
  _IMAGE_VERSION: latest
  _IMAGE_REVISION: 0.0.2
  _APP_NAME: arc-hero
  _SERVICE_NAME: genai_hero          # PASS AS SUBSTITUTION VAR $4 to OVERRIDE
  _IMAGE_NAME: arcade-hero           # PASS AS SUBSTITUTION VAR $4 to OVERRIDE
  _REVISION_NAME: latest
  _TAG_NAME: arcade
  _REPO_NAME: arcade
  ## Artifact Registry format is based on Region
  # _REPO_NAME: gcr.io # Container Registry Setting
EOF

#Initiate CloudBuild Trigger
# gcloud builds submit --config=cloudbuild.yaml --project="$1" --substitutions=_PROJECT_ID="$1"
#Initiate CloudBuild Trigger
gcloud builds submit --config=cloudbuild.yaml --project="$1" --substitutions=_PROJECT_ID="$1",_REGION="$2",_ZONE="$3",_IMAGE_NAME="$4",_SERVICE_NAME="$5"

