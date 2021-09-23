#!/bin/bash

INSTANCE_NAME=lamp-1-vm
# Create a Compute Engine instance
gcloud compute firewall-rules create default-allow-http \
--direction=INGRESS --priority=1000 --network=default --action=ALLOW \
--rules=tcp:80 --source-ranges=0.0.0.0/0 --target-tags=http-server

gcloud compute instances create   $INSTANCE_NAME \
  --zone=us-central1-a --machine-type=n1-standard-2 \
  --image-project=debian-cloud --image-family=debian-9 --tags=http-server,https-server \
  --metadata=startup-script='#! /bin/bash
  sudo apt install -y apache2 php7.0
  curl -sSO https://dl.google.com/cloudagents/add-monitoring-agent-repo.sh
  sudo bash add-monitoring-agent-repo.sh
  sudo apt-get install stackdriver-agent
  curl -sSO https://dl.google.com/cloudagents/add-logging-agent-repo.sh
  sudo bash add-logging-agent-repo.sh
  sudo apt-get update
  sudo apt-get install google-fluentd
  '

# Alerts
gcloud beta monitoring channels create \
  --display-name="Foo Team Lead (Primary)" \
  --description="Primary contact method for the Foo team lead" \
  --type=email --user-labels=team=foo,role=lead,ord=1 \
  --channel-labels=email_address=user@somedomain.tld