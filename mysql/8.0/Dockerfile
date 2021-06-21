FROM mysql:8.0

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

COPY mysql/8.0/scripts/.my.cnf /root/.my.cnf
RUN rm -rf /etc/mysql/mysql.cnf
COPY mysql/8.0/scripts/mysql.cnf /etc/mysql/mysql.cnf

RUN usermod -u 1000 mysql

# COPY mysql/8.0/scripts/app /app
WORKDIR /app