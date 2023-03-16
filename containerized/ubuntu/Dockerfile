FROM ubuntu:20.04 AS base_image
LABEL maintainer="Le Thanh An <anlt@palvietnam.vn>"

#### PHP-FPM + NGINX
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN yes | apt-get install nginx
RUN yes | apt-get install software-properties-common && add-apt-repository ppa:ondrej/php
RUN apt-get update
RUN apt-get install -y \
    php7.4-fpm \
    php7.4-cli \
    php7.4-curl \
    php7.4-mysql \
    php7.4-mbstring \
    php7.4-xml \
    php7.4-dev \
    php7.4-redis 
RUN php -r "readfile('http://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer && mkdir /run/php 
RUN echo "clear_env = no">>/etc/php/7.4/fpm/pool.d/www.conf
RUN echo "catch_workers_output = yes">>/etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i 's/\/var\/log\/php7.4-fpm.log/\/proc\/self\/fd\/2/g' /etc/php/7.4/fpm/php-fpm.conf

RUN apt-get install -y \
    supervisor \
    zip \
    curl \
    sudo \
    unzip \
    libicu-dev \
    libbz2-dev \
    libpng-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libreadline-dev \
    libfreetype6-dev \
    g++

#### REDIS
# RUN yes | apt install redis-server

#### Clear apt-get
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

#### config
#WORKDIR /var/www/
#COPY ./app .
COPY ./containerized/ubuntu/nginx/app.conf  /etc/nginx/sites-enabled/default


#### RUNING
EXPOSE 80
EXPOSE 6379
COPY ./containerized/ubuntu/supervisord/supervisord.conf  /etc/supervisor/conf.d/supervisord.conf
COPY ./containerized/ubuntu/initial /usr/local/bin/
RUN chmod +x /usr/local/bin/initial

RUN mkdir -p /var/log/initial
RUN touch /var/log/initial/log
RUN chmod -R 775 /var/log/initial/log
CMD [ "/usr/local/bin/initial"]

