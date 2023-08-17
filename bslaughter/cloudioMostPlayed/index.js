const Firestore = require('@google-cloud/firestore');
const PROJECTID = process.env.PROJECT_ID || '<YOUR PROJECT ID>';

const firestore = new Firestore({
  projectId: PROJECTID,
  timestampsInSnapshots: true,
});

exports.mostPlayed = (req, res) => {
  
  function replaceAll(string, search, replace) {
  	return string.split(search).join(replace);
  }
 
  console.log('Dialogflow Request body: ' + JSON.stringify(req.body));
  let tag = req.body.fulfillmentInfo.tag;
  console.log('Tag: ' + tag);
  console.log('Session Info Parameters: ' + JSON.stringify(req.body.sessionInfo.parameters));

  // This tag is passed by the calling webhook, so it should match what you've
  // configured (along with the webhook URL) in your route within the DF UI.
  if (tag === 'most_played') {

    // The COLLECTION_NAME is what you named the collection in Firestore.
    const COLLECTION_NAME = 'most_played';

    // Set genre to the genre param value collected from the user.
    let genre = replaceAll(JSON.stringify(req.body.sessionInfo.parameters['genre']), '"', '');
    console.log('Genre: ' + genre);

    // Check if required params have been populated
    if (!(req.body.sessionInfo && req.body.sessionInfo.parameters)) {
      return res.status(404).send({ error: 'Not enough information.' });
    }

    // Document id is the genre obtained from the user.
    const id = genre;
    console.log('Id: ' + id);

    // If id is null or empty
    if (!(id && id.length)) {
      return res.status(404).send({ error: 'Empty genre' });
    }
    return firestore.collection(COLLECTION_NAME)
    .doc(id)
    .get()
    .then(doc => {
      if (!(doc && doc.exists)) {
        res.status(200).send({
            sessionInfo: {
              parameters: {
                most_played: 'None'
              }
            }
          });
      }
      const data = doc.data();
      console.log(JSON.stringify(data));
      const title = JSON.stringify(doc.data().title);
      const composer = JSON.stringify(doc.data().composer);
      var answer = 'The most played for ' + genre + ' is ' + title + ' by ' + composer + '.';

      console.log(answer);
      res.status(200).send({
            sessionInfo: {
              parameters: {
                most_played: title,
              }
            },
            fulfillmentResponse: {
              messages: [{
                text: {
                  text: [answer]
                }
              }]
            }
          });
    }).catch(err => {
      console.error(err);
      return res.status(404).send({ error: 'Unable to retrieve the document' });
    });
  } else {
    res.status(200).send({});
  }
};
