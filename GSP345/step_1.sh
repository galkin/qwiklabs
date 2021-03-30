#!/bin/bash

export TF_VAR_project_id=$GOOGLE_CLOUD_PROJECT

cp ./step_1.tf ~/main.tf
cd ~/
terraform init
terraform import google_compute_instance.first tf-instance-1
terraform import google_compute_instance.second tf-instance-2
terraform apply -auto-approve