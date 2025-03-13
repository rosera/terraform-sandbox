# Firebase Web

* console.cloud.google.com
* console.firebase.google.com


## Cloud Build

* Create a custom image for Firebase deploy
```
steps:
  # Copy across the remote files
  - id: copy_gcs
    name: 'gcr.io/google.com/cloudsdktool/cloud-sdk'
    env:
      'PROJECT_ID=$PROJECT_ID'
    script: |
      #!/bin/bash
      ## SCRIPT START
      # Web App
      gsutil -m cp -r gs://spls/arc-genai-chat/web /workspace
      # Cloud Function
      gsutil -m cp -r gs://spls/arc-genai-chat/functions /workspace
      # Firebase Configuration
      gsutil -m cp -r gs://$PROJECT_ID-fb-webapp/* /workspace
      ## SCRIPT END 
  # Firebase Hosting: Chat APP
  - id: firebase_hosting 
    # Custom community builder image 
    name: 'gcr.io/qwiklabs-resources/firebase'
    args: ['deploy', '--project=$PROJECT_ID', '--only=hosting']
  # Firebase Cloud Function: Cloud Storage Activity Tracking
  - id: firebase_functions
    # Custom community builder image 
    name: 'gcr.io/qwiklabs-resources/firebase'
    args: ['deploy', '--project=$PROJECT_ID', '--only=functions:createStorageFile']
timeout: 900s
options:
  substitution_option: 'ALLOW_LOOSE'
```


Copy the remote gcs bucket content

* functions
* nginx
* web


```
gsutil -m cp -r gs://spls/arc-genai-chat/* /workspace 
```

Copy the project specific Firebase configuration

* `.firebaserc`
* `firebase-config.json`
* `firebase.json`

```
gsutil -m cp -r gs://qwiklabs-gcp-00-c3695e9f8855-fb-webapp/* /workspace
```


Deploy the `web` folder (defined in the firebase.json) to Firebase Hosting
__NOTE:__ When deploying with CloudBuild, amend the distribution path to:
```
/workspace/web
```

```
firebase deploy --only hosting
```

The Firebase Hosting site is accessible at `[PROJECT_ID].web.app`

## Firebase Configurations

Terraform is used to generate Firebase JSON configuration files


## Configuration files

gs://spls/arc-genai-chat/
gs://spls/arc-genai-chat/Dockerfile
gs://spls/arc-genai-chat/functions/
gs://spls/arc-genai-chat/nginx/
gs://spls/arc-genai-chat/web/

1. Copy the files to be deployed
```bash
gsutil -m cp -r gs://spls/arc-genai-chat/functions .
```

__NOTE:__
If using CloudBuild replace `.` with `/workspace`


## Firebase Config 

Firebase configuration is normally performed by `firebase init`.
1. Init the folder
```bash
firebase init
```

Alternatively the configuration files can be generated manually as shown below.


The following files will be added:

.firebaserc
```json
{
  "projects": {
    "default": "qwiklabs-gcp-03-c8feb34301d0"
  }
}
```

firebase.json - Hosting + Cloud Functions

* Set the Hosting public folder to web
* Set the Cloud Function folder to functions 
* Set the Cloud Function runtime to nodejs18

```json
{
  "hosting": {
    "public": "web"
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
  },
  "functions": [
    {
      "source": "functions",
      "codebase": "default",
      "runtime": "nodejs18",
      "ignore": [
        "node_modules",
        ".git",
        "firebase-debug.log",
        "firebase-debug.*.log"
      ]
    }
  ]
}
```

## Firebase Hosting

1. Copy the files to be deployed
```bash
gsutil -m cp -r gs://spls/arc-genai-chat/web .
```

2. Deploy to Firebase hosting
```bash
firebase deploy --only hosting
```

Note: To deploy everything use
```
firebase deploy
```

3. The resulting site will be accessible using
```
[PROJECT_ID].web.app
```


## Firebase Cloud Functions 

* Firebase Cloud Functions deploy with Cloud Functions Gen2
* Cloud Function Service Account `service-[PROJECT_NUMBER]@gcf-admin-robot.iam.gserviceaccount.com`
* Ensure the Cloud Functions Service Account has been granted `roles/artifactregistry.reader`


1. Copy the files to be deployed
```bash
gsutil -m cp -r gs://spls/arc-genai-chat/functions .
```

The index.js will look similar to below:
```js
/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { Storage }   = require('@google-cloud/storage');
const { onRequest } = require("firebase-functions/v2/https");
const logger        = require("firebase-functions/logger");
const functions     = require('@google-cloud/functions-framework');

const projectId  = process.env.PROJECT_ID || 'Undefined'
const bucketName = process.env.BUCKETNAME || 'Undefined'
const fileName   = process.env.FILENAME   || 'Undefined'
const object     = process.env.CONTENT    || 'undefined'


async function googleStorageAPI() {
  // Creates a client
  const storage = new Storage({projectId});

  // writeStorage - writes a file to an existing bucket
  async function writeStorage() {

    try {
      // Create a new blob in the bucket.
      const blob = storage.bucket(bucketName).file(fileName);

      // Create a write stream for the blob.
      const writeStream = blob.createWriteStream();

      // Write the object to the stream.
      writeStream.write(object);

      // Close the stream.
      writeStream.end();

      // Write to logging
      console.log(`Storage file: ${fileName} written to ${bucketName}`);
    } catch (ex) {
      // Handle any exceptions
      console.log(`[writeStorage] ${ex}`)
    }
  }
  writeStorage();
}

// Entrypoint
exports.createStorageFile = onRequest((request, response) => {
  // Set the test data {"message": "Log Data"}
  let message = request.query.message || request.body.message || 'Welcome to Arcade!';

  // Set Access Control Allow Origin
  response.set('Access-Control-Allow-Origin', '*');

  // Validate access
  if (message === 'arcade'){
    // Show the storage for Cloud Functions
    googleStorageAPI();

    // Respond with success.
    response.status(200).send('Storage file created successfully.');
  }

  // Invalid query param
  response.status(400).send('Accessing storage function.');
})
```

The package.json will look similar to:
```json
{
  "name": "arcade-gcs",
  "version": "1.0.0",
  "description": "Create an empty file in Cloud Storage for activity tracking",
  "scripts": {
    "serve": "firebase emulators:start --only functions",
    "shell": "firebase functions:shell",
    "start": "npm run shell",
    "deploy": "firebase deploy --only functions",
    "logs": "firebase functions:log"
  },
  "engines": {
    "node": "18"
  },
  "keywords": [
    "GCS",
    "Arcade"
  ],
  "main": "index.js",
  "author": "Rich Rose",
  "license": "MIT",
  "dependencies": {
    "@google-cloud/functions-framework": "^3.3.0",
    "@google-cloud/storage": "^7.0.1",
    "firebase-admin": "^11.8.0",
    "firebase-functions": "^4.3.1"
  },
  "devDependencies": {
    "firebase-functions-test": "^3.1.0"
  },
  "private": true
}
```

2. Deploy to Firebase Cloud Functions 

The source code containers 
Ensure the entrypoint matches the required endpoint name

```bash
firebase deploy --only functions:createStorageFile
```

3. The Cloud Functions are deployed and accessible
```
TBC
``` 

Optional: Delete the Firebase Cloud Function
```
firebase functions:delete createStorageFile
```

Results in:

```
https://[REGION]-[PROJECT_ID].cloudfunctions.net/createStorageFile
```
