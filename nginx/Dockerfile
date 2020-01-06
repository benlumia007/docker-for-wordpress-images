FROM nginx:latest
LABEL maintainer="Benjamin Lu ( ben@getbenonit.com )"

# Install wget and install/updates certificates
RUN apt-get update \
 && apt-get install -y -q --no-install-recommends \
    ca-certificates \
    python-pip \
    python-setuptools \
    python-wheel \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

RUN pip install shyaml