#!/bin/bash

export TF_VAR_project_id=$GOOGLE_CLOUD_PROJECT

cp ./step_2.tf ~/main.tf
cd ~/
terraform apply -auto-approve
