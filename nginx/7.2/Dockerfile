FROM benlumia007/ubuntu:18.04

## Here, we are going to set the frontend to no interactive.
ENV DEBIAN_FRONTEND=noninteractive

# Add a ppa repository  for git so that we can the latest version
RUN add-apt-repository ppa:git-core/ppa -y

## Here we are going to run and update and upgrade packages.
RUN apt-get update -y

# Here, we are going to add some basic requirements
RUN apt-get install --no-install-recommends \
    git \
    python-pip \
    python-setuptools \
    python-wheel \
    -y

# Here, we are going to install Web Server ( NGINX )
RUN apt-get install --no-install-recommends \
    mysql-client \
    nginx \
    php-imagick \
    php-memcache \
    php-memcached \
    php-pear \
    php-ssh2 \
    php-xdebug \
    php7.2-bcmath \
    php7.2-cli \
    php7.2-common \
    php7.2-curl \
    php7.2-dev \
    php7.2-fpm \
    php7.2-gd \
    php7.2-imap \
    php7.2-json \
    php7.2-mbstring \
    php7.2-mysql \
    php7.2-soap \
    php7.2-sqlite3 \
    php7.2-xml \
    php7.2-zip \
    -y

# Install composer
RUN wget https://getcomposer.org/download/2.0.4/composer.phar
RUN chmod +x composer.phar
RUN mv composer.phar /usr/local/bin/composer

# Here, we are going to install shyaml
RUN pip install shyaml

# Here, we will be adding a custom file to enable features for php-custom.ini
RUN { \
    echo 'error_reporting=E_ALL'; \
    echo 'display_errors=On'; \
    echo 'display_startup_errors=On'; \
    echo 'error_log=/var/log/php/php_errors.log'; \
    echo 'log_errors=On'; \
    echo 'log_errors_max_len=0'; \
    echo 'max_execution_time=120'; \
    echo 'max_input_vars=3000'; \
    echo 'memory_limit=512M'; \
    echo 'post_max_size=100M'; \
    echo 'upload_max_filesize=100M'; \
} > /etc/php/7.2/mods-available/php-custom.ini


# Here, we are going to enable opcache
RUN { \
		echo 'opcache.memory_consumption=128'; \
		echo 'opcache.interned_strings_buffer=8'; \
		echo 'opcache.max_accelerated_files=4000'; \
		echo 'opcache.revalidate_freq=2'; \
		echo 'opcache.fast_shutdown=1'; \
} > /etc/php/7.2/mods-available/php-opcache.ini

COPY nginx/config/mailhog/mhsendmail /usr/local/bin/mhsendmail
RUN echo 'sendmail_path = /usr/local/bin/mhsendmail --smtp-addr mailhog:1025' > /etc/php/7.2/mods-available/mailhog.ini

# Here, we will be enable php-custom.ini using phpenmod
RUN phpenmod php-custom && \
    phpenmod php-opcache && \
    phpenmod mailhog && \
    phpenmod mysqli && \
    phpenmod mysqlnd && \
    phpdismod xdebug

# Here, we are going to install wp cli as docker user
RUN curl --silent -L -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x /usr/local/bin/wp

COPY nginx/7.2/app /app
WORKDIR /app

RUN usermod -u 1000 www-data
RUN chown -R www-data:www-data /var/www

CMD service php7.2-fpm start && nginx -g "daemon off;"