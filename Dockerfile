FROM centos-phpfpm:1.0
MAINTAINER "Pongsk Prabparn" <pongsak@rebatemango.com>

# update package

RUN yum -y update

# Installing nginx
FROM nginx:1.14.0

# Installing supervisor
RUN yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm && \
    yum -y install yum-utils && \
    yum-config-manager --enable remi-php72 && \
    yum -y update && \
    yum clean all


# Adding the configuration file of the nginx
ADD ./nginx/nginx.conf /etc/nginx/nginx.conf

ADD ./nginx/00-default /etc/nginx/conf.d/default.conf

ADD index.php /var/www/html/index.php

# Adding the configuration file of the Supervisor
COPY ./supervisord.conf /etc/supervisord.conf

# Set the port to 80 
EXPOSE 80

RUN pip install supervisor && \
    supervisord --version

VOLUME ["/etc/nginx/conf.d", "/var/www/html" , "/var/log/php-fpm", "/var/log/nginx" ]


# Executing supervisord
CMD ["supervisord" , "-n"]

