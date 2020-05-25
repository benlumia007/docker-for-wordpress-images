FROM ubuntu:18.04

## Here, we are going to set the frontend to no interactive.
ENV DEBIAN_FRONTEND=noninteractive

## Here we are going to run and update and upgrade packages.
RUN apt-get update && apt-get upgrade -y

# Here, we are going to add some basic requirements
RUN apt-get install --no-install-recommends build-essential curl dkms software-properties-common -y

# Here, we are going to add repository to support different versions of PHP.
# Please note that php7.3 will be installed by default and please avoid installing
# other versions since there will be different containers to support other php versions.
RUN add-apt-repository ppa:ondrej/php -y

# Here, we are going to install Web Server ( NGINX )
RUN apt-get install --no-install-recommends nginx -y

# Here, we are going to install basic php requirements
RUN apt-get install --no-install-recommends \
    php-imagick \
    php-memcache \
    php-memcached \
    php-pear \
    php-ssh2 \
    php-xdebug \
    -y

# Here, we will install all of the necessary components for php7.3.
RUN apt-get install --no-install-recommends \
    php7.3-bcmath \
    php7.3-cli \
    php7.3-common \
    php7.3-curl \
    php7.3-dev \
    php7.3-fpm \
    php7.3-gd \
    php7.3-imap \
    php7.3-json \
    php7.3-mbstring \
    php7.3-mysql \
    php7.3-soap \
    php7.3-sqlite3 \
    php7.3-xml \
    php7.3-zip \
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
} > /etc/php/7.3/mods-available/php7.3-custom.ini

# Here, we have php_error.logs own by www-data for write access.
RUN mkdir -p /var/log/php 
RUN touch /var/log/php/php_errors.log
RUN chown www-data /var/log/php/php_errors.log

COPY config/mailhog/mhsendmail /usr/local/bin/mhsendmail
RUN echo 'sendmail_path = /usr/local/bin/mhsendmail --smtp-addr mailhog:1025' > /etc/php/7.3/mods-available/mailhog.ini

# Here, we will be enable php-custom.ini using phpenmod
RUN phpenmod php7.3-custom

# Here, we enable mailhog for php.
RUN phpenmod mailhog

# Here, we are disabling xdebug by default
RUN phpdismod xdebug

RUN apt-get install php7.4-mysql -y
RUN phpenmod mysqli
RUN phpenmod mysqlnd 

RUN curl --silent -L -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x /usr/local/bin/wp

RUN usermod -u 1000 www-data

CMD service php7.3-fpm start && nginx -g "daemon off;"