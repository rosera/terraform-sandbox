# Firebase Web

## Firebase Hosting

1. Copy the files to be deployed
```bash
gsutil -m cp -r gs://spls/arc-genai-chat/web .
```

2. Init the folder
```bash
firebase init
```

3. The following files will be added:

.firebaserc
```json
{
  "projects": {
    "default": "qwiklabs-gcp-03-c8feb34301d0"
  }
}
```

firebase.json - Hosting + Cloud Functions
```json
{
  "hosting": {
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "public": "web"
  },
  "functions": [
    {
      "source": "functions",
      "codebase": "default",
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

4. Deploy to Firebase hosting
```bash
firebase deploy
```

5. The resulting site will be accessible using
```
[PROJECT_ID].web.app
```
