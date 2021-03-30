#!/bin/bash

# Step 1
gcloud container clusters create onlineboutique-cluster \
  --zone us-central1-a \
  --node-locations us-central1-a,us-central1-b \
  --machine-type n1-standard-2 \
  --num-nodes 1

gcloud config set compute/zone us-central1-a
gcloud container clusters get-credentials onlineboutique-cluster
kubectl create namespace prod
kubectl create namespace dev

git clone https://github.com/GoogleCloudPlatform/microservices-demo.git
cd microservices-demo
kubectl apply -f ./release/kubernetes-manifests.yaml --namespace dev

while ! kubectl get service frontend-external -o='jsonpath={.status...ip}' --namespace=dev;
do
  echo waiting;
  sleep 1;
done;
curl $(kubectl get service frontend-external -o='jsonpath={.status...ip}' --namespace=dev)
echo "Ready!";

# Step 2
gcloud container node-pools create optimized-pool \
  --cluster=onlineboutique-cluster \
  --machine-type=custom-2-3584 \
  --num-nodes=2

for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do
  kubectl cordon "$node";
done

for node in $(kubectl get nodes -l cloud.google.com/gke-nodepool=default-pool -o=name); do
  kubectl drain --force --ignore-daemonsets --delete-local-data --grace-period=10 "$node";
done

kubectl get pods -o=wide --namespace=dev

gcloud container node-pools delete default-pool \
  --cluster=onlineboutique-cluster \
  --quiet

# Step 3
kubectl create poddisruptionbudget onlineboutique-frontend-pdb --selector app=frontend --min-available 1 --namespace dev
kubectl patch deployment frontend --namespace=dev --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/image", "value":"gcr.io/qwiklabs-resources/onlineboutique-frontend:v2.1"}]'
kubectl patch deployment frontend --namespace=dev --type='json' -p='[{"op": "replace", "path": "/spec/template/spec/containers/0/imagePullPolicy", "Always"}]'

# Step 4
gcloud beta container clusters update onlineboutique-cluster --enable-autoscaling --min-nodes 1 --max-nodes 6