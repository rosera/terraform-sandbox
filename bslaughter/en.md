# Instructions for Terraform to prep lab |  Firestore and Cloud Functions setup

<h2 style="margin-top: 20px;">Table of Contents</h2>

<ol style="padding-left: 20px;">
  <li>Lab: Configuring webhooks for use in a Dialogflow CX virtual agent.</li>
</ol>
<br></br>

## Resources

The following are some resources for the lab:
* Virtual agent which will need to be imported for testing
  * [virtual agent](https://storage.googleapis.com/cloud-training/T-CECCAI-I/lab-solns/Cloudio-df-webhooks.blob)
* Code for cloud functions  
  * [account update index.js](https://storage.googleapis.com/cloud-training/T-CECCAI-I/T-CCAISWDCX-I/lab-solns/lab-cx-accountupdate-index.js)
  * [most played index.js](https://storage.googleapis.com/cloud-training/T-CECCAI-I/T-CCAISWDCX-I/lab-solns/lab-cx-mostplayed-index.js)
  * [package.json](https://storage.googleapis.com/cloud-training/T-CECCAI-I/T-CCAISWDCX-I/lab-solns/lab-cx-package.json) 
* Firestore data:

### `most_played` collection
|Document|Field|Value|
|-----|-----|-----|
|pop|title|`See You Soon`|
|-|composer|`Wiz Khalifa`|
|rock|title|`Stairway to Heaven`|
|-|composer|`Led Zeppelin`|
|classical|title|`Serenade No 13 for strings in G major`|
|-|composer|`Wolfgang Mozart`|
| | | |

### `accounts` collection
|Phone(Document ID)|Parameter(Field name)|Value(Field value)|
|--------|-------|------|
|4155551212|first_name|`Nozomi`|
|-|last_name|`Hernandez`|
|-|pin|`1111`|
|-|tier|`platinum`|
|9255551212|first_name|`Mohammed`|
|-|last_name|`Devi`|
|-|pin|`2222`|
|-|tier|`gold`|
|6505551212|first_name|`Chitra`|
|-|last_name|`Wang`|
|-|pin|`3333`|
|-|tier|`silver`|
| | | |

<br></br>


## ---- START OF VM SETUP ----

## Task 1:  Setting up Firestore

In this lab, you'll use Firestore as your datastore. Two collections have been created in your Firestore to match the data already defined for your virtual agent. The data can be used to mimic scenarios you'll likely have where your business can read and write from a database of customer data as it interacts with the user through the virtual agent. 

1. In the Google Cloud Console, click on the navigation menu.

1. Select __Firestore__.

   *Tip: You may wish to bookmark Firestore for easy access later if you navigate away from it.*


1. In the __Select a Cloud Firestore mode__ page, choose __Select Native Mode__.

1. For location, select __nam5 (United States)__.

1. Click __CREATE DATABASE__.

This may take a minute. When your datastore is ready, the __Data__ dialog opens. Next, you'll add a collection to hold the `most played` songs.
<br></br>

## Task 2:  Adding a collection for 'most_played' song in each musical genre

Now you'll use a collection called `most_played` which contains three documents (pop, rock, and classical), each having two fields (title and composer). You'll access this data to answer customer questions about what is the most played title in a particular genre (list-most-played intent). It looks like this:

![most-played-collection.png](img/most-played-collection.png)


1. Click __+ START COLLECTION__ to kick off the process of creating your data in Firestore.

1. In the __Start a collection__ screen, click in the *Collection ID* box (look closely because your cursor may default to the Document ID box.)

1. In the *Collection ID* box, enter `'most_played'`.

1. In the *Document ID* box, enter `'pop'`.

1. In the *Field name* box, enter `'title'`.

1. In the *Field value* box, enter `'See You Soon'`, or any other song title you'd like.

1. Leave the field type as `string`. Field data retrieved from Dialogflow is provided in JSON syntax so string is the best choice for this lab.

1. Click +__ADD FIELD__.

1. Enter `'composer'` for the field name.

1. Enter `'Wiz Khalifa'` (or another artist if you'd like) for the value.

1. Click __SAVE & ADD ANOTHER__.  

   *Tip: Using the SAVE & ADD ANOTHER button (rather than the SAVE button) can save time when creating multiple documents.*

1. In the same way you added the Document called `'pop'` to the *most_played* Collection, create two more Documents for the collection:  one for rock and one for classical. 

|Document|Field|Value|
|-----|-----|-----|
|rock|title|`Stairway to Heaven`|
|-|composer|`Led Zeppelin`|
|classical|title|`Serenade No 13 for strings in G major`|
|-|composer|`Wolfgang Mozart`|
<br></br>


## Task 3:  Adding an 'accounts' customer data collection in Firestore

Your goal in this task is to use customer mobile phone numbers to uniquely identify each of their accounts for your Cloud Audio business. You'll create an 'accounts' collection for this purpose. The instructions in this section are intentionally less verbose to test your knowledge.

1. Add a collection in Firestore called `accounts` to represent customer data.

1. Add documents for three customers. The documents should have the following information.

    |Phone(Document ID)|Parameter(Field name)|Value(Field value)|
    |--------|-------|------|
    |4155551212|first_name|`Nozomi`|
    |-|last_name|`Hernandez`|
    |-|pin|`1111`|
    |-|tier|`platinum`|
    |9255551212|first_name|`Mohammed`|
    |-|last_name|`Devi`|
    |-|pin|`2222`|
    |-|tier|`gold`|
    |6505551212|first_name|`Chitra`|
    |-|last_name|`Wang`|
    |-|pin|`3333`|
    |-|tier|`silver`|
    | | | |

Now we have data for finding out the most played song as well as for storing customer data such as tier.

<br></br>


## Task 4:  Adding a cloud function to read most played songs by genre.

1. Go to __Navigation menu__ > __Cloud Functions__ in the main Google Cloud Platform menu.

1. Click __CREATE FUNCTION__.

1. Enter `cloudioMostPlayed` for the name of your cloud function.

1. Leave the defaults for region (us-central1) and trigger type (HTTP).

1. Under the __Authentication__ section, select `Allow unauthenticated invocations`. 

<ql-infobox><strong>Note</strong>: While this is fine for the lab, you will want to set permissions for this function in production.
</ql-infobox>

1. Click __SAVE__ to save the configuration you've set up so far.

1. Click __NEXT__ to move to the next stage of the cloud function configuration.

1. For _Runtime_, select `Node.js 10` from the dropdown.

1. For _Entry point_, enter `mostPlayed`.  This will match the function name in your cloud function code. 

1. Notice the default Javascript and JSON code templates for __index.js__ and __package.json__ under the __Source code__ section. There is some sample code to help you get started. You're going to replace that code with your own.

1. Click on the __index.js__ if not already enabled.

  * Use the [most played index.js](https://storage.googleapis.com/cloud-training/T-CECCAI-I/T-CCAISWDCX-I/lab-solns/lab-cx-mostplayed-index.js) for the __index.js__ which is needed for the `mostPlayed` function (also inserted below).

*Don't forget to update the project id field!*

```bash 
const Firestore = require('@google-cloud/firestore');
const PROJECTID = '<YOUR PROJECT ID>';
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
  ```

Next, you'll update the package parameters.

1. Click on the __package.json__.

1. Replace the code there with the following.

```bash
{
  "name": "dialogflowFirebaseFulfillment",
  "description": "This is the default fulfillment for a Dialogflow agents using Cloud Functions for Firebase",
  "version": "0.0.1",
  "private": true,
  "license": "Apache Version 2.0",
  "author": "Google Inc.",
  "engines": {
    "node": "10"
  },
  "scripts": {
    "start": "firebase serve --only functions:dialogflowFirebaseFulfillment",
    "deploy": "firebase deploy --only functions:dialogflowFirebaseFulfillment"
  },
  "dependencies": {
    "actions-on-google": "^2.5.0",
    "firebase-admin": "^8.2.0",
    "firebase-functions": "^2.0.2",
    "dialogflow": "^0.6.0",
    "dialogflow-fulfillment": "^0.6.1"
  }
}
```

1. Click __DEPLOY__.

It may take a few minutes for the new cloud function to fully deploy.

<br></br>


## Task 5:  Adding a cloud function to read and write customer data 

1. If you're not already there, go to __Navigation menu__ > __Cloud Functions__.

1. Click __+ CREATE FUNCTION__.

1. Add and deploy a function called `cloudioAccountUpdate`. 

  * Under the __Authentication__ section, select `Allow unauthenticated invocations`. 

  * For _Runtime_, select `Node.js 10`.
  
  * For _Entry point_, enter `accountUpdate`.  This will match the function name in your cloud function code. 

  * Use the [account update index.js](https://storage.googleapis.com/cloud-training/T-CECCAI-I/T-CCAISWDCX-I/lab-solns/lab-cx-accountupdate-index.js) for the __index.js__ which is needed for the `accountUpdate` function (also inserted below).

*Don't forget to update the project id field!*

```bash
const Firestore = require('@google-cloud/firestore');
const PROJECTID = '<YOUR PROJECT ID>';
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

```

  * As you did for the other cloud function, use the code below for the __package.json__.

```bash
{
  "name": "dialogflowFirebaseFulfillment",
  "description": "This is the default fulfillment for a Dialogflow agents using Cloud Functions for Firebase",
  "version": "0.0.1",
  "private": true,
  "license": "Apache Version 2.0",
  "author": "Google Inc.",
  "engines": {
    "node": "10"
  },
  "scripts": {
    "start": "firebase serve --only functions:dialogflowFirebaseFulfillment",
    "deploy": "firebase deploy --only functions:dialogflowFirebaseFulfillment"
  },
  "dependencies": {
    "actions-on-google": "^2.5.0",
    "firebase-admin": "^8.2.0",
    "firebase-functions": "^2.0.2",
    "dialogflow": "^0.6.0",
    "dialogflow-fulfillment": "^0.6.1"
  }
}
```

1. Click __DEPLOY__.

It will take a few minutes for the Google Cloud Platform to create the new cloud function.  





<br></br>
<br></br>
## ---- END OF VM SETUP ---- 
### THE REMAINING INSTRUCTIONS ARE FOR TESTING AFTER IT'S CREATED.
To test that the vm has been created correctly, we need to run through the steps below.
These instructions will become the new Webhooks lab.<br></br>
<br></br>
<br></br>










## ---- START OF LAB ----

## Configuring webhooks for a Dialogflow CX virtual agent.

In this lab, cloud functions have already been deployed, and a Firebase has been preloaded with data, which your virtual agent can use. 

## Task 1:  Getting familiar with the cloud functions and Firestore data

1. Go to __Navigation menu__ > __Cloud Functions__ in the main Google Cloud Platform menu.

There are two cloud functions that have been preloaded for you.
* cloudioGetMostPlayed
* cloudioAccountUpdate

1. Click into each cloud function's page and take a look at the trigger URL under the __TRIGGER__ tab.

1. Copy the trigger URL for each function and paste it into a table for your notes. You'll need this when you configure the Webhooks. In a nutshell, you'll have two Cloud Functions,

|Cloud Function Name|Entry Point|URL|
|---|---|---|
|cloudioGetMostPlayed|mostPlayed|https://<`project location and ID`>.cloudfunctions.net/cloudioGetMostPlayed|
|cloudioAccountUpdate|accountUpdate|https://<`project location and ID`>.cloudfunctions.net/cloudioAccountUpdate|
| | | |

where <`project location and ID`> is set when the cloud function is created.

1. In the Google Cloud Console, click on the navigation menu.

1. Go to __Navigation menu__ > __Firestore__.

There are two collections that have been preloaded for you.
* most_played
* accounts

1. Review the data including the most played songs by genre and the three customer accounts uniquely identifed by their phone numbers.



## Task 2:  Importing the Dialogflow agent

In this lab, you'll use a virtual agent which has already been created so that you can focus on just the configuration of webhooks.

1. Download the virtual agent to your hard drive.
  * [virtual agent solution](https://storage.googleapis.com/cloud-training/T-CECCAI-I/lab-solns/Cloudio-df-webhooks.blob)

1. Open the [Dialogflow CX console](https://dialogflow.cloud.google.com/cx/projects). 

1. Choose your project in the format `<qwiklabs-gcp-xx-xxxxxxx>`.

1. Click to enable the Dialogflow APIs if prompted.

1. Import your virtual agent according to the [Dialogflow CX "restore"](https://cloud.google.com/dialogflow/cx/docs/concept/agent#export) instructions.

Note:  You may need to first select your project from the dropdown menu under _GOOGLE PROJECT_. It should have the format `<qwiklabs-gcp-xx-xxxxxxx>`.

Once the virtual agent has been imported into your new agent project, you may proceed to the next task.

`Note: because this virtual agent is intended for learning purposes and for use in this lab only, the full compliment of error-checking and user-proofing is left out for simplicity.`
<br></br>


### Task 3:  Preparing to configure the webhooks inside of the virtual agent. 

You will create two webhooks 
* cloudioGetMostPlayed
* cloudioMakeAccountUpdate

and instruct the virtual agent to use them in different places during the flow. Webhooks are, simply put, a URL to call external code outside of the virtual agent. In our use case, we use cloud functions to execute some read and write activity on a Firestore, so the URLs will be to cloud functions. 

What information needs to be gathered before creating the webhook?
* The virtual agent will need to know which webhook to trigger within the flow at what time. So, you'll gather the trigger URL from the cloud functions (these functions already created for you).
* Google Cloud will need to know which function within the cloud function code to fire. So, you'll need the cloud function software developer to provide the tags that reference each piece of code relevant to the functionality. If the software developer doesn't provide the information, you can look through the cloud function code for tags. As an example, the following cloud function code snippet is checking to see if the webhook passed along 'most_played' for the tag:

```bash
if (tag === 'most_played') {
  ...
}  
```

How does the webhook know what tag to pass along to the cloud function? You will configure that a little later in this lab. 

One webhook may be used in multiple flows, but the tag will differ depending on the need within each page. The only important thing is that each tag you define in a page should match precisely (spelling and case matter) what is defined in the cloud function. 

The following represents all the configuration details you need to gather before you can begin configuring the virtual agent for this lab:

|Flow|Page|Webhook|Tag|
|---|---|---|---|
|ListMostPlayed|Get Most Played|cloudioGetMostPlayed|most_played|
|ChangeTier|Get Tier|cloudioMakeAccountUpdate|change_tier|
|ChangePin|Get Pin|cloudioMakeAccountUpdate|change_pin|
|ChangeLastName|Get Last Name|cloudioMakeAccountUpdate|change_last_name|
|ChangeFirstName|Get First Name|cloudioMakeAccountUpdate|change_first_name|
|Subscribe|Get Subscription Details|cloudioMakeAccountUpdate|subscribe|
| | | | |

## Task 4: Configuring a cloudioGetMostPlayed webhook for your virtual agent project.

1. Click on _Webhooks_ under the __Manage__ tab in Dialogflow CX console.

1. Click __Create new__ (click on `+Create`).

1. Give your webhook a name such as `cloudioGetMostPlayed`.

1. Set the Webhook timeout to 15 seconds. We give it a little longer for our lab since the first cloud function executions sometimes timeout. You may want this to be shorter in production.

   Now you need to copy the URL of your "cloudioMostPlayed" cloud function. You should have this info saved as notes to yourself already, but if not, recall that you get this information as follows:

  * Click on your `cloudioMostPlayed` cloud function in the Google Cloud Platform console.

  * Click on the __TRIGGER__ tab.

  * Copy the Trigger URL. 

  * Return to the Dialogflow CX console.

1. Paste the tigger URL of your function into the __Webhook URL__ section.

1. Click __Save__.

Now the webhook is configured for use, but you haven't specified where to use it yet. You'll do that next.

<br></br>

## Task 5: Adding the cloudioGetMostPlayed webhook to the ListMostPlayed flow.

In this task you tell the virtual agent when to invoke the webhook by configuring it within the flow. The following are some details you'll need.

|Flow|Page|Webhook|Tag|
|---|---|---|---|
|ListMostPlayed|Get Most Played|cloudioGetMostPlayed|most_played|
|||||

<br></br>
1. Navigate to __Build__ > __Default Start Flow__ > __ListMostPlayed__ flow in Dialogflow CX console.

1. Select the __Get Most Played__.

1. Click on the Route (i.e., `$page.params.status=FINAL`), to open the configuration pane.

1. Scroll down past _Parameter presets_ until you see slider to enable the webhook.

1. Click `Enable webhook`.

1. Choose `cloudioGetMostPlayed` from the Webhook dropdown.

1. Enter `most_played` for the Tag. 

   The tag will be used inside the function to specify the Collection name you defined in Firestore, so spelling and case are important.

1. Click __Save__.

<br></br>


### Task 6:  Testing the cloudioGetMostPlayed webhook. 

In this task, you test the `cloudioGetMostPlayed` webhook created for the `ListMostPlayed` flow. 

1. Open the _Simulator_ pane by clicking on __Test Agent__ on the top right of the page.

2. Enter a user utterance such as `What's the most played song in classical?` in _Talk to agent_ field to test if your webhook was successful.

   Did you see a response similar to the following?

   ```
   The most played for classical is "Serenade No 13 for strings in G major" by "Wolfgang Mozart".

   Anything else?
   ```

   The first line is the response provided by the cloud function. The second line is a static response to let the user know the virtual agent is ready for another request.

3. Try other phrases and genres to make sure everything is working.

|Who|Utterance|
|-|-|
|User|What's the most played song in pop?|
|Agent|The most played for pop is "See You Again" by "Whiz Khalifa". Anything else?|
|User|What's the most played song in rock?|
|Agent|The most played for rock is "Stairway to Heaven" by "Led Zeppelin". Anything else?|

<br></br>

## Task 7: Configuring a cloudioMakeAccountUpdate webhook for your virtual agent project.

1. Add a webhook called `cloudioMakeAccountUpdate` (under the __Manage__ section in Dialogflow CX console) to your virtual agent project, similar to how you did this for the _cloudioGetMostPlayed_ webhook. Don't forget to copy the URL from the cloud function you deployed.

<br></br>

## Task 8: Adding the cloudioMakeAccountUpdate webhook to the flows that need to use it.

Now that you've created the webhook, along with its trigger URL, you need to tell the virtual agent when to invoke it. In this task, you add your webhook to each of the appropriate sections of each flow. Let's start with one of them to give you the idea.

1. Add the `cloudioMakeAccountUpdate` webhook to your Route (i.e., `$page.params.status=FINAL`) in the `Get Tier` page of your `ChangeTier` flow. 

    Remember to enable the webhook with the slider. Review the instructions above for the other webhook if you need more help in how to get to the right spot within the Get Tier page.

    Note that you may need to close the simulator window to see the route configuration pane.

1. Specify the tag (i.e., `change_tier`).

1. Click __Save__.

1. Repeat the above steps for the remaining flows (you can skip the first one in the table below since you just did it).

|Flow|Page|Webhook|Tag|
|---|---|---|---|
|ChangeTier|Get Tier|cloudioMakeAccountUpdate|change_tier|
|ChangePin|Get Pin|cloudioMakeAccountUpdate|change_pin|
|ChangeLastName|Get Last Name|cloudioMakeAccountUpdate|change_last_name|
|ChangeFirstName|Get First Name|cloudioMakeAccountUpdate|change_first_name|
|Subscribe|Get Subscription Details|cloudioMakeAccountUpdate|subscribe|
| | | | |

<br></br>

## Task 9: Testing the cloudioMakeAccountUpdate webhook in each flow. 

As you've probably gathered by now, based on the configuration you've done, this webhook is utilized in quite a few places. 

* ChangeTier
* ChangeFirstName
* ChangeLastName
* ChangePin
* Subscribe

Your test plan includes testing each of the scenarios to ensure there are no typing mistakes anywhere that could cause the webhook to fail.

`Important:  In between testing with different customer accounts, be sure to reset the simulator using the __Reset__ button in the upper right of the simulator. Otherwise, the simulator will maintain in memory some values previously set and the virtual agent will not prompt you for new values.`

1. Open the _Simulator_ pane by clicking on __Test Agent__ on the top right of the page.

  Next, enter a user utterance to test if your webhook was successful.

1. Enter `I want to change my service to gold` in the _Talk to agent_ section of the simulator.

  The virtual agent will ask you for the phone number of your account.

1. Enter `4155551212` as the phone number.


   Did you see a response similar to the following?

   ```
    Your plan has been changed to the gold service.
    
    Anything else?
   ```

   The first line is the response provided by the cloud function. The second line is a static response to let the user know the virtual agent is ready for another request.

1. View the document in Firestore to confirm that the account tier has been updated from silver to gold.

    `Hint:  Google Cloud Console, click on the navigation menu, select Firestore, then select the account for 4155551212.`

1. Try a couple other requests for different customers (phone numbers) to make sure everything is working.

1. Next, try creating a new customer account using the information below. 

  `Remember to reset the simulator or it will use data from your previous test scenario and not prompt you for new data.`

Note: Because we have not enabled extended libraries for first and last names, some names you might try will not be recognized by Dialogflow. If this happens, simply try one of the ones suggested below. 

|Who|Utterance|
|---|---|
|User|I want to subscribe|
|Agent|What is the phone number that should be associated to your account?|
|User|7075551212|
|Agent|What is the last name that should be associated to your account?|
|User|Jones|
|Agent|What tier would you like? We have silver, gold, and platinum.|
|User|silver|
|Agent|What pin would you like associated to your account?|
|User|5555|
|Agent|What's your first name?|
|User|George|
|Agent|Anything else?|
|User|No|
<br></br>

1. View the documents in Firestore to be certain the data was written.

<br></br>


Congratulations! You now know how to set up webhooks for use in Dialogflox CX virtual agents.

If you'd like to compare your work to the sample solution, feel free to download the [virtual agent sample](https://storage.googleapis.com/cloud-training/T-CECCAI-I/lab-solns/Cloudio-df-webhooks-soln.blob).


