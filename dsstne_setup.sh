#!/bin/bash
# Just a script to install nvidia-docker and DSSTNE on an ubuntu 16 (xenial) installation.
#
# Note, this was tested under AWS EC2 infrastructure
#
# AMI: Deep Learning AMI (Ubuntu) Version 12.0 (ami-d1c9cdae)
# Instance type: p2.xlarge
#

# --------------------In the beginning, there's docker and nvidia's plugin-------------------------
# --Source--
# https://chunml.github.io/ChunML.github.io/project/Installing-NVIDIA-Docker-On-Ubuntu-16.04/

# Might be a good idea to run this script in (or somewhere close to) the user's home, stuff
# shouldn't break otherwise but it should make stuff more consistent

# First updating stuff up
sudo apt-get update

# Removing previous docker installs if any
sudo apt-get remove docker docker-engine docker.io

# Adding Docker's public key and repository
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Updating repositories and installing docker
sudo apt-get update && sudo apt-get install docker-ce -y

# Removing older versions of nvidia-docker if installed
sudo docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo apt-get purge -y nvidia-docker

# Installing nvidia's docker plugin repository
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -
curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu16.04/amd64/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

# Installing plugin
sudo apt-get update && sudo apt-get install -y nvidia-docker2
sudo pkill -SIGHUP dockerd

# Now download and run the latest CUDA image
sudo nvidia-docker run --rm nvidia/cuda nvidia-smi

# --------------------Now, setting up DSSTNE-------------------------------------------------------
# For these on, you could follow the project's readme:
# 	https://github.com/amzn/amazon-dsstne/blob/master/docs/getting_started/setup.md

# Cloning the repository
git clone https://github.com/amznlabs/amazon-dsstne.git
cd amazon-dsstne

# And building it, it's going to take a few (2~5) minutes
echo "--Alright, this is going to take a couple of minutes (around 2min)--"
sudo docker build -t amazon-dsstne .

