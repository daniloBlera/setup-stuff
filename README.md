# Install notes...
This is just a simple script to install `nvidia-docker` and Amazon's DSSTNE on an ubuntu 16 (xenial) installation.

The commands below were tested under the AWS EC2 infrastructure

*   AMI: Deep Learning AMI (Ubuntu) Version 12.0 (ami-d1c9cdae)
*   Instance type: p2.xlarge

The instructions below were taken from here: https://chunml.github.io/ChunML.github.io/project/Installing-NVIDIA-Docker-On-Ubuntu-16.04/

obs.: It might be a good idea to run this script in (or somewhere close to) the user's home, stuff shouldn't break otherwise but it should make stuff more consistent.

... Anyway, back into installing stuff.

# Install stuff pls
Running the `dsstne_setup.sh` script will do the steps below...


# In the beginning, there's docker and nvidia's plugin
First updating stuff up

```bash
sudo apt-get update
```
Now removing previous docker installs if any

```bash
sudo apt-get remove docker docker-engine docker.io
```

Adding the required stuff (although they should be installed already)

```bash
sudo apt-get install apt-transport-https ca-certificates curl software-properties-common
```

Adding Docker's public key and repository then installing it.

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

sudo apt-get update && sudo apt-get install docker-ce -y
```

Removing older versions of nvidia-docker if installed

```bash
sudo docker volume ls -q -f driver=nvidia-docker | xargs -r -I{} -n1 docker ps -q -a -f volume={} | xargs -r docker rm -f
sudo apt-get purge -y nvidia-docker
```

Getting nvidia's docker repository and installing the plugin

```bash
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey | sudo apt-key add -

curl -s -L https://nvidia.github.io/nvidia-docker/ubuntu16.04/amd64/nvidia-docker.list | sudo tee /etc/apt/sources.list.d/nvidia-docker.list

sudo apt-get update && sudo apt-get install -y nvidia-docker2

sudo pkill -SIGHUP dockerd
```

Now, to download and run the latest CUDA image

```bash
sudo nvidia-docker run --rm nvidia/cuda nvidia-smi
```

## Now, onto setting up DSSTNE
obs.: For these on, you could follow the project's readme:

https://github.com/amzn/amazon-dsstne/blob/master/docs/getting_started/setup.md

Cloning the repository and building it. Just hang on because it should take a few (2~5) minutes.

```bash
git clone https://github.com/amznlabs/amazon-dsstne.git
cd amazon-dsstne
sudo docker build -t amazon-dsstne .
```
