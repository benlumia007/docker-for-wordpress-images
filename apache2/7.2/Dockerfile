FROM ubuntu:18.04
LABEL maintainer="Benjamin Lu ( ben@getbenonit.com )"

# The main objective of this project is to create a working environment for WordPress development that
# does not use root as default and create a non user to do all it's job when the container is running.
# But first, we will need to install the basic requirements when usng root.+

# Let's set an environment variable for DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Here, we will then do an apt-get update and upgrade some packages before we start the process of 
# insalling actuall packages. This will help to install software that we need.
RUN apt-get update && apt-get upgrade -y

# Here, we are going to add some basic requirements that allows us to run. We will need to install sudo
# and less because we want to make sure not user can the one that gets used as the main user instead of
# the root. 
RUN apt-get install --no-install-recommends build-essential curl dkms software-properties-common sudo less -y

# Here, we are going to install the Apache2 Web Server because it seems to be a logic server to use from
# my own experience and it is a lot easier to configured. We will need to set the apache user and group
# to another user due to permissions issue.
RUN apt-get install --no-install-recommends apache2 -y

RUN apt-get install --no-install-recommends mysql-client -y

# Here, we are going to install basic php requirements
RUN apt-get install --no-install-recommends \
    php-imagick \
    php-memcache \
    php-memcached \
    php-pear \
    php-ssh2 \
    php-xdebug \
    -y

# Here, we will install all of the necessary components for php7.2.
RUN apt-get install --no-install-recommends \
    php7.2-bcmath \
    php7.2-cli \
    php7.2-common \
    php7.2-curl \
    php7.2-dev \
    php7.2-gd \
    php7.2-imap \
    php7.2-json \
    php7.2-mbstring \
    php7.2-mysql \
    php7.2-soap \
    php7.2-xml \
    php7.2-zip \
    libapache2-mod-php7.2 \
    -y

# Here, we will be adding a custom file to enable features for php-custom.ini
RUN { \
    echo 'error_reporting=E_ALL'; \
    echo 'display_errors=On'; \
    echo 'display_startup_errors=On'; \
    echo 'log_errors=On'; \
    echo 'error_log=/var/log/php/php_errors.log'; \
    echo 'log_errors_max_len=0'; \
    echo 'memory_limit=256M'; \
    echo 'post_max_size=100M'; \
    echo 'upload_max_filesize=100M'; \
} > /etc/php/7.2/mods-available/php7.2-custom.ini

COPY config/mailhog/mhsendmail /usr/local/bin/mhsendmail
RUN echo 'sendmail_path = /usr/local/bin/mhsendmail --smtp-addr mailhog:1025' > /etc/php/7.2/mods-available/mailhog.ini
RUN chmod +x /usr/local/bin/mhsendmail

COPY config/apache2/envvars /etc/apache2/envvars

RUN phpenmod php7.2-custom
RUN phpenmod mailhog

# Let's enable some modules for PHP
RUN a2enmod ssl rewrite

# Let's create a user docker and create it's home directory and give docker full access with
# no passowrd and switch to docker as user.
RUN useradd docker --create-home
RUN echo 'docker ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/docker
RUN chmod 440 /etc/sudoers.d/docker
USER docker

# Here, we are going to install wp cli as docker user
RUN sudo  curl --silent -L -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN sudo chmod +x /usr/local/bin/wp
RUN sudo chown -R docker:docker /usr/local/bin/wp

# Our working directory
WORKDIR /home/docker

# Here, we are going to start apache at forground.
CMD sudo apachectl -D FOREGROUND