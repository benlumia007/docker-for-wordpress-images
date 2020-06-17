FROM mysql:5.7

## Here, we are going to set the frontend to no interactive.
ENV DEBIAN_FRONTEND=noninteractive

## Here we are going to run and update and upgrade packages.
RUN apt-get update -y && \
    apt-get install --no-install-recommends \
        build-essential \
        python-pip \
        python-setuptools \
        python-wheel \
        unzip \
        wget \
        -y

RUN pip install shyaml

COPY mysql/5.7/scripts/.my.cnf /root/.my.cnf