FROM php:7.3-apache

RUN apt update && apt upgrade -y
RUN apt update && apt install nano -y

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' $APACHE_CONFDIR/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' $APACHE_CONFDIR/apache2.conf $APACHE_CONFDIR/conf-available/*.conf

# COPY docker-conf/000-default.conf $APACHE_CONFDIR/sites-available/000-default.conf
COPY docker-conf/php.ini $PHP_INI_DIR/php.ini
COPY docker-conf/apache2.conf $APACHE_CONFDIR/apache2.conf

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions && \
    install-php-extensions gd xdebug && \
    install-php-extensions intl mysqli mcrypt && \
    install-php-extensions bcmath bz2 zip