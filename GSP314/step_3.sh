#!/bin/bash

gcloud config set compute/zone us-east1-b
gcloud container clusters get-credentials spinnaker-tutorial
while ! DECK_POD=$(kubectl get pods --namespace default \
-l "cluster=spin-deck" -o jsonpath="{.items[0].metadata.name}");
do
  echo waiting;
  sleep 1;
done;
echo Ready!;

kubectl port-forward --namespace default $DECK_POD 8080:9000 >> /dev/null &

cd ~
while ! gcloud source repos clone sample-app;
do
  echo waiting;
  sleep 1;
done;
echo Ready!;

cd sample-app
touch a
git add .
git config --global user.email "$(gcloud config get-value account)"
git config --global user.name "Student"
git commit -am "change"
git tag v1.0.1
git push --tags
