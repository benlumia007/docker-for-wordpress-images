FROM ubuntu:18.04

## Here, we are going to set the frontend to no interactive.
ENV DEBIAN_FRONTEND=noninteractive

## Here we are going to run and update and upgrade packages.
RUN apt-get update -y

# Here, we are going to add some basic requirements
RUN apt-get install --no-install-recommends \
    build-essential \
    curl \
    dkms \
    less \
    python-pip \
    python-setuptools \
    python-wheel \
    software-properties-common \
    sudo \
    unzip \
    wget \
    -y

# Add a ppa repository  for git so that we can the latest version
RUN add-apt-repository ppa:git-core/ppa -y

# update and install git
RUN apt-get update && \
    apt-get install git \
    -y

# Here, we are going to add repository to support different versions of PHP.
# Please note that php7.4 will be installed by default and please avoid installing
# other versions since there will be different containers to support other php versions.
RUN add-apt-repository ppa:ondrej/php -y

# Here, we are going to install Web Server ( NGINX )
RUN apt-get install --no-install-recommends \
    mysql-client \
    nginx \
    -y

# Here, we are going to install basic php requirements
RUN apt-get install --no-install-recommends \
    php-imagick \
    php-memcache \
    php-memcached \
    php-pear \
    php-ssh2 \
    php-xdebug \
    php7.4-bcmath \
    php7.4-cli \
    php7.4-common \
    php7.4-curl \
    php7.4-dev \
    php7.4-fpm \
    php7.4-gd \
    php7.4-imap \
    php7.4-json \
    php7.4-mbstring \
    php7.4-mysql \
    php7.4-soap \
    php7.4-sqlite3 \
    php7.4-xml \
    php7.4-zip \
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
} > /etc/php/7.4/mods-available/php7.4-custom.ini

# Here, we are going to enable opcache
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
		echo 'opcache.fast_shutdown=1'; \
} > /etc/php/7.4/mods-available/php7.4-opcache.ini

COPY config/mailhog/mhsendmail /usr/local/bin/mhsendmail
RUN echo 'sendmail_path = /usr/local/bin/mhsendmail --smtp-addr mailhog:1025' > /etc/php/7.4/mods-available/mailhog.ini

# Here, we will be enable php-custom.ini using phpenmod
RUN phpenmod php7.4-custom && \
    phpenmod php7.4-opcache

# Here, we enable mailhog for php.
RUN phpenmod mailhog && \
    phpenmod mysqli && \
    phpenmod mysqlnd && \
    phpdismod xdebug

RUN pip install shyaml

# Here we are going to change user and group for php7.4-fpm to docker.
COPY config/php/www.conf /etc/php/7.4/fpm/pool.d/www.conf

# Here we are going to change the nginx.conf user to docker.
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf

# Let's create a user docker and create it's home directory and give docker full access with
# no passowrd and switch to docker as user.
RUN useradd docker --create-home && \
    echo 'docker ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/docker && \
    chmod 440 /etc/sudoers.d/docker

USER docker

# Here, we are going to install wp cli as docker user
RUN sudo  curl --silent -L -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    sudo chmod +x /usr/local/bin/wp && \
    sudo chown -R docker:docker /usr/local/bin/wp

WORKDIR /app

CMD sudo service mysql start && sudo service php7.4-fpm start && sudo nginx -g "daemon off;"