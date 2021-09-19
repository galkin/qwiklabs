#!/bin/bash

REGISTRY_ID=my-registry
REGION=us-central1
TOPIC=cloud-builds
DEVICE_ID=my-device
PROJECT_ID=$(gcloud config get-value project)

gcloud pubsub topics create cloud-builds
gcloud pubsub subscriptions create projects/$PROJECT_ID/subscriptions/my-subscription --topic=projects/$PROJECT_ID/topics/$TOPIC
openssl req -x509 -newkey rsa:2048 -keyout rsa_private.pem -nodes -out rsa_cert.pem -subj "/CN=unused"

until $(gcloud iot registries create --region="$REGION" --state-pubsub-topic="$TOPIC" "$REGISTRY_ID")
do
  echo "Try again"
done

gcloud iot devices create "$DEVICE_ID" --region="$REGION" --registry="$REGISTRY_ID" --public-key "path=rsa_cert.pem,type=rs256"
