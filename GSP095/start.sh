#!/bin/bash

# Step 1
gcloud pubsub topics create myTopic

#Step 2
gcloud  pubsub subscriptions create --topic myTopic mySubscription
