const functions = require('@google-cloud/functions-framework');
const { Storage } = require('@google-cloud/storage');

const projectId  = process.env.PROJECT_ID || 'Undefined'
const bucketName = process.env.BUCKETNAME || 'Undefined'
const fileName   = process.env.FILENAME   || 'Undefined'
const object     = process.env.CONTENT    || 'undefined'

async function googleStorageAPI() {
//  const projectId = 'qwiklabs-gcp-01-137bb1ce582a'
//  const bucketName= 'qwiklabs-gcp-01-137bb1ce582a-bucket2'
//  const fileName  = 'test.txt'
//  const object    = 'Welcome to Arcade!'

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
exports.createStorageFile=(req, res)=>{
  // Set the test data {"message": "Log Data"}
  let message = req.query.message || req.body.message || 'Arcade API!';

  // Validate access
  if (message === 'arcade'){
    // Show the storage for Cloud Functions
    googleStorageAPI();

    // Respond with success.
    res.status(200).send('Storage file created successfully.');
  } else {
    // Invalid query param
    res.status(400).send('Accessing storage function.');
  }
}
