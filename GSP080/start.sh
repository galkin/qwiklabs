#!/bin/bash

# Step 1
mkdir gcf_hello_world
cd gcf_hello_world
cat <<EOT >> index.js
/**
* Background Cloud Function to be triggered by Pub/Sub.
* This function is exported by index.js, and executed when
* the trigger topic receives a message.
*
* @param {object} data The event payload.
* @param {object} context The event metadata.
*/
exports.helloWorld = (data, context) => {
const pubSubMessage = data;
const name = pubSubMessage.data
    ? Buffer.from(pubSubMessage.data, 'base64').toString() : "Hello World";
console.log('My Cloud Function: '+name);
};
EOT

# Step 2
PROJECT_ID=$(gcloud config get-value project)
BUCKET_NAME=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 32 | head -n 1)
gsutil mb -p $PROJECT_ID gs://$BUCKET_NAME

# Step 3
gcloud functions deploy helloWorld \
  --stage-bucket $BUCKET_NAME \
  --trigger-topic hello_world \
  --runtime nodejs8