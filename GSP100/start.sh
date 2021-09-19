#!/bin/bash

CLUSTER_NAME=my-cluster

# Step 1
gcloud config set compute/zone us-central1-a

# Step 2
gcloud container clusters create $CLUSTER_NAME --machine-type=e2-micro

#Step 3
gcloud container clusters get-credentials $CLUSTER_NAME

#Step 4
kubectl create deployment hello-server --image=gcr.io/google-samples/hello-app:1.0
kubectl expose deployment hello-server --type=LoadBalancer --port 8080

#Step 5
gcloud container clusters delete --quiet $CLUSTER_NAME
