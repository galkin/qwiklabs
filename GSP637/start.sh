#!/bin/bash

INSTANCE_NAME=instance-1

gcloud compute instances create $INSTANCE_NAME \
  --zone=us-central1-a --machine-type=n1-standard-1 \
  --metadata=startup-script='#! /bin/bash
  sudo apt install -y python3-pip
'

mkdir ~/.ssh
ssh-keygen -b 2048 -t rsa -f ~/.ssh/google_compute_engine -q -N ""

gcloud compute ssh --command="cat <<EOT >> model.py
import warnings
warnings.simplefilter(action='ignore', category=FutureWarning)
import tensorflow as tf
import numpy as np
from tensorflow import keras
from tensorflow.python.util import deprecation
deprecation._PRINT_DEPRECATION_WARNINGS = False
model = tf.keras.Sequential([keras.layers.Dense(units=1, input_shape=[1])])
model.compile(optimizer='sgd', loss='mean_squared_error')
xs = np.array([-1.0, 0.0, 1.0, 2.0, 3.0, 4.0], dtype=float)
ys = np.array([-2.0, 1.0, 4.0, 7.0, 10.0, 13.0], dtype=float)
model.fit(xs, ys, epochs=500)
print(model.predict([10.0]))
EOT" --zone=us-central1-a $INSTANCE_NAME
gcloud compute ssh --command="pip3 install --upgrade tensorflow" --zone=us-central1-a $INSTANCE_NAME
gcloud compute ssh --command="python3 model.py" --zone=us-central1-a $INSTANCE_NAME