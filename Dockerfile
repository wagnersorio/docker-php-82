FROM php:8.2.3-fpm

LABEL maintainer="Wagner Sorio"

# Set working directory
WORKDIR /var/www

# Arguments
ARG NODE_VERSION=18

ENV TZ=America/Sao_Paulo

ENV ORACLE_HOME=/opt/oracle/instantclient_19_14
ENV PATH=/opt/oracle/instantclient_19_14:$PATH
ENV LD_LIBRARY_PATH=/opt/oracle/instantclient_19_14:$LD_LIBRARY_PATH

RUN ln -snf /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

# Install system dependencies
RUN apt-get update \
  && apt-get install -y libpng-dev \
  && apt-get install -y libcap2-bin \
  && apt-get install -y libldb-dev \
  && apt-get install -y libldap2-dev \
  && apt-get install -y libonig-dev \
  && apt-get install -y libxml2-dev \
  && apt-get install -y libzip-dev \
  && apt-get install -y libpq-dev \ 
  && apt-get install -y libaio1 \
  && apt-get install -y iputils-ping \
  && apt-get install -y git \
  && apt-get install -y curl \
  &&  apt-get install -y zip \
  && apt-get install -y unzip \
  && apt-get install -y wget \
  && apt-get install -y nano \
  && php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer \
  && curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - \
  && apt-get install -y nodejs \
  && npm install -g npm \
  && npm install -g npm@8.5.4 \
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
  && apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y yarn

# Install Oracle Instant Client 
RUN mkdir /opt/oracle/ \
  && cd /opt/oracle/ \
  && wget https://download.oracle.com/otn_software/linux/instantclient/1914000/instantclient-basic-linux.x64-19.14.0.0.0dbru.zip \
  && unzip instantclient-basic-linux.x64-19.14.0.0.0dbru.zip -d /opt/oracle \
  && sh -c "echo /opt/oracle/instantclient_19_14 > /etc/ld.so.conf.d/oracle-instantclient.conf" \
  && ldconfig \
  && wget https://download.oracle.com/otn_software/linux/instantclient/1914000/instantclient-sdk-linux.x64-19.14.0.0.0dbru.zip \
  && unzip instantclient-sdk-linux.x64-19.14.0.0.0dbru.zip -d /opt/oracle \
  && wget https://download.oracle.com/otn_software/linux/instantclient/1914000/instantclient-sqlplus-linux.x64-19.14.0.0.0dbru.zip  \
  && unzip instantclient-sqlplus-linux.x64-19.14.0.0.0dbru.zip -d /opt/oracle \
  && ldconfig \
  && export PATH=/opt/oracle/instantclient_19_14:$PATH \
  && export LD_LIBRARY_PATH=/opt/oracle/instantclient_19_14:$LD_LIBRARY_PATH \
  && rm instantclient-basic-linux.x64-19.14.0.0.0dbru.zip \
  && rm instantclient-sdk-linux.x64-19.14.0.0.0dbru.zip \
  && rm instantclient-sqlplus-linux.x64-19.14.0.0.0dbru.zip \
  && cd /var/www


# Install PHP extensions
RUN docker-php-ext-install exif  \
  && docker-php-ext-install pcntl  \
  && docker-php-ext-install bcmath  \
  && docker-php-ext-install gd  \
  && docker-php-ext-install sockets \
  && docker-php-ext-install xml \
  && docker-php-ext-install zip \
  && docker-php-ext-install bcmath \
  && docker-php-ext-install soap \
  && docker-php-ext-install intl \
  && docker-php-ext-install ldap \
  && docker-php-ext-install opcache \
  && pecl install -o -f xdebug\
  && rm -rf /tmp/pear \
  && docker-php-ext-enable xdebug\
  && docker-php-ext-install pdo_mysql\
  && docker-php-ext-install pdo pdo_pgsql\
  && pecl install -o -f redis \
  && rm -rf /tmp/pear \
  && docker-php-ext-enable redis \
  && echo 'instantclient,/opt/oracle/instantclient_19_14' | pecl install oci8\
  && rm -rf /tmp/pear \
  && docker-php-ext-enable oci8

  
COPY php/docker-php.ini /usr/local/etc/php/conf.d/docker-php.ini

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
