#!/bin/bash

INSTANCE_NAME=my-vm-1
# Create a virtual machine using the Google Cloud Console
gcloud compute instances create   $INSTANCE_NAME \
  --zone=us-central1-a --machine-type=n1-standard-2 \
  --image-project=ubuntu-os-cloud --image-family=ubuntu-1804-lts --tags=http-server,https-server \
  --metadata=startup-script='#! /bin/bash
wget https://github.com/EOSIO/eos/releases/download/v2.0.9/eosio_2.0.9-1-ubuntu-18.04_amd64.deb
sudo apt install ./eosio_2.0.9-1-ubuntu-18.04_amd64.deb
wget https://github.com/eosio/eosio.cdt/releases/download/v1.7.0/eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb
sudo apt install ./eosio.cdt_1.7.0-1-ubuntu-18.04_amd64.deb'

mkdir ~/.ssh
ssh-keygen -b 2048 -t rsa -f ~/.ssh/google_compute_engine -q -N ""
gcloud compute ssh --command="nodeos -e -p eosio --plugin eosio::chain_api_plugin --plugin eosio::history_api_plugin --contracts-console >> nodeos.log 2>&1 &" --zone=us-central1-a $INSTANCE_NAME
gcloud compute ssh --command="cleos wallet create --name my_wallet --file my_wallet_password &&
cleos wallet open --name my_wallet &&
cleos wallet unlock --name my_wallet --password $(cat my_wallet_password) &&
cleos wallet import --name my_wallet --private-key 5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3 &&
cleos create key --file my_keypair1 &&
cleos create account eosio bob EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV
" --zone=us-central1-a $INSTANCE_NAME
