FROM ubuntu:18.04

## Here, we are going to set the frontend to no interactive.
ENV DEBIAN_FRONTEND=noninteractive

## Here we are going to run and update to grab any packages that are available to us.
RUN apt-get update -y

# Here, we are going to add some basic requirements
RUN apt-get install --no-install-recommends \
    build-essential \
    curl \
    dkms \
    software-properties-common \
    sudo \
    unzip \
    wget \
    -y

# Let's create a user docker and create it's home directory and give docker full access with
# no passowrd and switch to docker as user.
RUN useradd docker --create-home && \
    echo 'docker ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/docker && \
    chmod 440 /etc/sudoers.d/docker

WORKDIR /home/docker

USER docker