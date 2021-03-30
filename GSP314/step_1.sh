#!/bin/bash

gcloud config set compute/zone us-east1-b
gcloud deployment-manager deployments create testing --config=prod-network.yaml

gcloud container clusters create kraken-prod \
  --num-nodes 2 \
  --network kraken-prod-vpc \
  --subnetwork kraken-prod-subnet

gcloud container clusters get-credentials kraken-prod
for F in $(ls k8s/*.yaml); do kubectl create -f $F; done
