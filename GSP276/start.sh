#!/bin/bash

CLUSTER_NAME=my-cluster

# Creating the firewall
gcloud compute firewall-rules create game-server-firewall \
  --allow udp:7000-8000 \
  --target-tags game-server \
  --description "Firewall to allow game server udp traffic"

# Creating the cluster
gcloud container clusters create $CLUSTER_NAME \
  --no-enable-legacy-authorization \
  --tags=game-server \
  --scopes=gke-default \
  --num-nodes=3 \
  --machine-type=n1-standard-2 \
  --region=us-central1-a

# Enabling creation of RBAC resources
gcloud config set container/cluster $CLUSTER_NAME
gcloud container clusters get-credentials --region=us-central1-a $CLUSTER_NAME
kubectl create clusterrolebinding cluster-admin-binding  --clusterrole cluster-admin --user $(gcloud config get-value account)

# Installing Agones with YAML
kubectl create namespace agones-system
kubectl apply -f https://raw.githubusercontent.com/GoogleCloudPlatform/agones/release-1.6.0/install/yaml/install.yaml

# Create a GameServer
kubectl create -f https://raw.githubusercontent.com/googleforgames/agones/release-1.6.0/examples/simple-udp/gameserver.yaml

# Connect to the GameServer
gcloud compute instances create --zone=us-central1-a --machine-type=n1-standard-1 --image-project=debian-cloud --image-family=debian-9 agones-test-vm
mkdir ~/.ssh
ssh-keygen -b 2048 -t rsa -f ~/.ssh/google_compute_engine -q -N ""
gcloud compute ssh --command="sudo apt install -y netcat" --zone=us-central1-a agones-test-vm
PORT=$(kubectl get gs -o=jsonpath='{$..port}')
HOST=$(kubectl get gs -o=jsonpath='{$..address}')
gcloud compute ssh --command="echo EXIT | nc -u $HOST $PORT" --zone=us-central1-a agones-test-vm