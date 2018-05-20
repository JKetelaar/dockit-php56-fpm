FROM phpdockerio/php56-fpm:latest

MAINTAINER Jeroen Ketelaar version: 0.1

WORKDIR "/application"

ARG DEBIAN_FRONTEND=noninteractive

ENV LOCALE en_US.UTF-8

ENV TZ=Europe/Amsterdam

RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8

RUN \
    sed -i -e "s/# $LOCALE/$LOCALE/" /etc/locale.gen \
    && echo "LANG=$LOCALE">/etc/default/locale \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=$LOCALE

RUN \
    apt-get -yqq install \
    apt-utils \
    build-essential \
    debconf-utils \
    debconf \
    mysql-client \
    curl \
    software-properties-common \
    python-software-properties

RUN \
    apt-get update

RUN \
    apt-get -yqq install \
    php5 \
    php5-curl \
    php5-dev \
    php5-gd \
    php5-imap \
    php5-imagick \
    php5-intl \
    php5-json \
    php5-ldap \
    php5-mcrypt \
    php5-mysql \
    php5-oauth \
    php5-odbc \
    php5-ssh2 \
    php5-solr \
    php5-apcu \
    php5-memcache \
    php5-memcached \
    php5-redis \
    php5-xdebug

RUN \
    echo $TZ | tee /etc/timezone && \
    dpkg-reconfigure --frontend noninteractive tzdata && \
    echo "date.timezone = \"$TZ\";" > /etc/php5/fpm/conf.d/timezone.ini && \
    echo "date.timezone = \"$TZ\";" > /etc/php5/cli/conf.d/timezone.ini

RUN apt-get clean; rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/share/doc/*

RUN \
    curl -Lsf 'https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz' | tar -C '/usr/local' -xvzf -

ENV PATH /usr/local/go/bin:$PATH

RUN \
    go get github.com/mailhog/mhsendmail

RUN \
    cp /root/go/bin/mhsendmail /usr/bin/mhsendmail
