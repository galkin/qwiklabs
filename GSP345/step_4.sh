#!/bin/bash

export TF_VAR_project_id=$GOOGLE_CLOUD_PROJECT

cp ./step_4.tf ~/main.tf
cd ~/
terraform init
terraform apply -auto-approve
