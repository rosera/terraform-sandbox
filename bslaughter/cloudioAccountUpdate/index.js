const Firestore = require('@google-cloud/firestore');
const PROJECTID = process.env.PROJECT_ID || '<YOUR PROJECT ID>';
const firestore = new Firestore({
  projectId: PROJECTID,
  timestampsInSnapshots: true,
});

exports.accountUpdate = (req, res) => {

  function replaceAll(string, search, replace) {
  	return string.split(search).join(replace);
  }

  console.log('Dialogflow Request body: ' + JSON.stringify(req.body));
  let tag = req.body.fulfillmentInfo.tag;
  console.log('Tag: ' + tag);
  console.log('Session Info Parameters: ' + JSON.stringify(req.body.sessionInfo.parameters));

  // Subscribe
  if (tag === 'subscribe') {
    const COLLECTION_NAME = 'accounts';
    let phone_number = replaceAll(JSON.stringify(req.body.sessionInfo.parameters['phone-number']), '"', '');
    let first_name = replaceAll(JSON.stringify(req.body.sessionInfo.parameters['first-name']), '"', '');
    let last_name = replaceAll(JSON.stringify(req.body.sessionInfo.parameters['last-name']), '"', '');
    let pin = replaceAll(JSON.stringify(req.body.sessionInfo.parameters['pin']), '"', '');
    let tier = replaceAll(JSON.stringify(req.body.sessionInfo.parameters['tier']), '"', '');
    console.log('Phone number: ' + phone_number);
    console.log('First name: ' + first_name);
    console.log('Last name: ' + last_name);
    console.log('Pin: ' + pin);
    console.log('Tier: ' + tier);

    const data = {
      first_name: first_name,
      last_name: last_name,
      pin: pin,
      tier: tier
    };

    console.log(JSON.stringify(data));
    var answer = 'Welcome to the Cloud Audio family, '+ first_name +'! Enjoy our services.';
    return firestore.collection(COLLECTION_NAME)
      .doc(phone_number)
      .set(data)
      .then(doc => {
        return res.status(200).send({
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
        return res.status(404).send({ error: 'unable to store', err });
      });

  // Change Tier    
  } else if (tag === 'change_tier') {
      const COLLECTION_NAME = 'accounts';
      let phone_number = replaceAll(JSON.stringify(req.body.sessionInfo.parameters['phone-number']), '"', '');
      let tier = replaceAll(JSON.stringify(req.body.sessionInfo.parameters['tier']), '"', '');
      console.log('Phone number: ' + phone_number);
      console.log('Tier: ' + tier);

      const data = {
      tier: tier
    };
    console.log(JSON.stringify(data));
    var answer = 'Your plan has been changed to the '+ tier + ' service.';
    return firestore.collection(COLLECTION_NAME)
      .doc(phone_number)
      .update(data)
      .then(doc => {
        return res.status(200).send({
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
        return res.status(404).send({ error: 'unable to update field', err });
      });
  
  // Change first name
  } else if (tag === 'change_first_name') {
      const COLLECTION_NAME = 'accounts';
      let phone_number = replaceAll(JSON.stringify(req.body.sessionInfo.parameters['phone-number']), '"', '');
      let first_name = replaceAll(JSON.stringify(req.body.sessionInfo.parameters['first-name']), '"', '');
      console.log('Phone number: ' + phone_number);
      console.log('First name: ' + first_name);

      const data = {
        first_name: first_name
      };
      console.log(JSON.stringify(data));
      var answer = 'Okay, '+ first_name +', your name has been changed in our system. Anything else I can help you with today?';
      return firestore.collection(COLLECTION_NAME)
      .doc(phone_number)
      .update(data)
      .then(doc => {
        return res.status(200).send({
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
        return res.status(404).send({ error: 'unable to update field', err });
      });

  // Change last name
  } else if (tag === 'change_last_name') {
      const COLLECTION_NAME = 'accounts';
      let phone_number = replaceAll(JSON.stringify(req.body.sessionInfo.parameters['phone-number']), '"', '');
      let last_name = replaceAll(JSON.stringify(req.body.sessionInfo.parameters['last-name']), '"', '');
      console.log('Phone number: ' + phone_number);
      console.log('Last name: ' + last_name);

      const data = {
        last_name: last_name
      };
      console.log(JSON.stringify(data));
      var answer = 'The last name on the acount has changed to '+ last_name;
      return firestore.collection(COLLECTION_NAME)
      .doc(phone_number)
      .update(data)
      .then(doc => {
        return res.status(200).send({
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
        return res.status(404).send({ error: 'unable to update field', err });
      });

    // Change pin
  } else if (tag === 'change_pin') {
      const COLLECTION_NAME = 'accounts';
      let phone_number = replaceAll(JSON.stringify(req.body.sessionInfo.parameters['phone-number']), '"', '');
      let pin = replaceAll(JSON.stringify(req.body.sessionInfo.parameters['pin']), '"', '');
      console.log('Phone number: ' + phone_number);
      console.log('Pin: ' + pin);

      const data = {
        pin: pin
      };
      console.log(JSON.stringify(data));
      var answer = 'Your pin has been updated.';
      return firestore.collection(COLLECTION_NAME)
      .doc(phone_number)
      .update(data)
      .then(doc => {
        return res.status(200).send({
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
        return res.status(404).send({ error: 'unable to update field', err });
      });
  } else {
    res.status(200).send({});
  }
};
