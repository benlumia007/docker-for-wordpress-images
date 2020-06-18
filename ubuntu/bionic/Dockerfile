FROM ubuntu:18.04

## Here we are going to run and update and upgrade packages.
RUN apt-get update -y

# Here, we are going to add some basic requirements
RUN apt-get install --no-install-recommends \
    build-essential \
    curl \
    dkms \
    less \
    software-properties-common \
    sudo \
    unzip \
    wget \
    -y