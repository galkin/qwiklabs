#!/bin/bash

gcloud config set compute/zone us-east1-b
gcloud compute instances create kraken-admin --network-interface="subnet=kraken-mgmt-subnet" --network-interface="subnet=kraken-prod-subnet"
