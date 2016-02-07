FROM gliderlabs/alpine:latest
MAINTAINER Frederic Guillot <fred@kanboard.net>

RUN apk-install nginx bash ca-certificates s6 \
    php-fpm php-json php-zlib php-xml php-dom php-ctype php-opcache php-zip \
    php-pdo php-pdo_mysql php-pdo_sqlite php-pdo_pgsql php-ldap \
    php-gd php-mcrypt php-openssl

RUN cd /var/www \
    && wget http://kanboard.net/kanboard-latest.zip \
    && unzip -qq kanboard-latest.zip \
    && rm -f *.zip \
    && chown -R nginx:nginx /var/www/kanboard \
    && chown -R nginx:nginx /var/lib/nginx

COPY files/services.d /etc/services.d
COPY files/php/conf.d/local.ini /etc/php/conf.d/
COPY files/php/php-fpm.conf /etc/php/
COPY files/nginx/nginx.conf /etc/nginx/
COPY files/kanboard/config.php /var/www/kanboard/
COPY files/kanboard/config.php /var/www/kanboard/
COPY files/crontab/kanboard /var/spool/cron/crontabs/nginx

EXPOSE 80

VOLUME /var/www/kanboard/data
VOLUME /var/www/kanboard/plugins

ENTRYPOINT ["/bin/s6-svscan", "/etc/services.d"]
CMD []
