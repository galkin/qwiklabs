#!/bin/bash

# Step 1
BUCKET_NAME=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 32 | head -n 1)
gsutil mb gs://$BUCKET_NAME

#Step 2
IMAGE_SOURCE=https://cdn.qwiklabs.com/3hpf8ZMmvpav2QvPqQCY1Zl1O%2B%2F8rrass6yjAPki3Dc%3D
IMAGE=gs://$BUCKET_NAME/demo-image.jpg
curl -L $IMAGE_SOURCE | gsutil cp - $IMAGE
#Step 3
gsutil acl ch -u AllUsers:R $IMAGE
