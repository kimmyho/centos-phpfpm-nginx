FROM pongsak/centos-phpfpm:4.0
MAINTAINER "Pongsak Prabparn" <pongsak@rebatemango.com>


# Installing nginx
RUN yum -y install nginx

# Adding the configuration file of the nginx
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

COPY ./nginx/00-default /etc/nginx/conf.d/default.conf

COPY index.php /var/www/html/index.php

# start install supervisor
RUN curl "https://bootstrap.pypa.io/get-pip.py" -o "get-pip.py" && \
    python get-pip.py

RUN pip install supervisor && \
    supervisord --version

# Adding the configuration file of the Supervisor
COPY ./supervisord.conf /etc/supervisord.conf

# install Composer and plugins
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer
RUN chmod +x /usr/local/bin/composer

# Set the port to 80 
EXPOSE 80

RUN pip install supervisor && \
    supervisord --version

VOLUME ["/etc/nginx/conf.d", "/var/www/html" , "/var/log/php-fpm", "/var/log/nginx" ]


# Executing supervisord
CMD ["supervisord" , "-n"]

