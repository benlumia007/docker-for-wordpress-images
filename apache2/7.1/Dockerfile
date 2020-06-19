FROM benlumia007/ubuntu:18.04
LABEL maintainer="Benjamin Lu ( ben@getbenonit.com )"

# The main objective of this project is to create a working environment for WordPress development that
# uses root as default and allow the www-data to do all it's job when the container is running as much
# as possible. But first, we will need to install the basic requirements when usng root.

# Let's set an environment variable for DEBIAN_FRONTEND=noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Add a ppa repository  for git so that we can the latest version and let's grab the php versions as well
RUN add-apt-repository ppa:git-core/ppa && \
    add-apt-repository ppa:ondrej/php && \
    -y

# Here, we will then do an apt-get update and upgrade some packages before we start the process of 
# insalling actuall packages. This will help to install software that we need.
RUN apt-get update -y

# Here, we are going to add some basic requirements that allows us to run. We will need to install
# some of the python packages that we can install shyaml which allow us to read yaml files when running
# our main automation scripts.
RUN apt-get install --no-install-recommends \
    git \
    python-pip \
    python-setuptools \
    python-wheel \
    -y

# Here, we are going to install the Apache2 Web Server because it seems to be a logic server to use from
# my own experience and it is a lot easier to configured. We will need to set the apache user and group
# to another user due to permissions issue.
# Here, we are going to install Web Server ( NGINX )
RUN apt-get install --no-install-recommends \
    apache2 \
    libapache2-mod-php7.1 \
    mysql-client \
    php-imagick \
    php-memcache \
    php-memcached \
    php-pear \
    php-ssh2 \
    php-xdebug \
    php7.1-bcmath \
    php7.1-cli \
    php7.1-common \
    php7.1-curl \
    php7.1-dev \
    php7.1-gd \
    php7.1-imap \
    php7.1-json \
    php7.1-mbstring \
    php7.1-mysql \
    php7.1-soap \
    php7.1-xml \
    php7.1-zip \
    -y

# Here, we are going to install shyaml
RUN pip install shyaml

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
} > /etc/php/7.1/mods-available/php-custom.ini

# Here, we are going to enable opcache
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
		echo 'opcache.fast_shutdown=1'; \
} > /etc/php/7.1/mods-available/php-opcache.ini

COPY apache2/config/mailhog/mhsendmail /usr/local/bin/mhsendmail
RUN echo 'sendmail_path = /usr/local/bin/mhsendmail --smtp-addr mailhog:1025' > /etc/php/7.1/mods-available/mailhog.ini

# Here, we will be enable php-custom.ini using phpenmod
RUN phpenmod php-custom && \
    phpenmod php-opcache && \
    phpenmod mailhog && \
    phpenmod mysqli && \
    phpenmod mysqlnd && \
    phpdismod xdebug

# Let's enable some modules for PHP
RUN a2enmod ssl rewrite

# Here, we are going to install wp cli as docker user
RUN curl --silent -L -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

COPY apache2/app /app
WORKDIR /app

RUN usermod -u 1000 www-data
RUN chown -R www-data:www-data /var/www

# Here, we are going to start apache at forground.
CMD apachectl -D FOREGROUND