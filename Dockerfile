FROM docker.io/library/php:8.3-fpm

ARG GLPI_VERSION=11.0.7

RUN apt-get update && apt-get install -y --no-install-recommends libpng-dev libjpeg-dev libfreetype6-dev libicu-dev libzip-dev libldap2-dev libbz2-dev ca-certificates curl && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-configure gd --with-jpeg --with-freetype && docker-php-ext-configure ldap --with-libdir=lib/$(dpkg-architecture -q DEB_BUILD_MULTIARCH) && docker-php-ext-install -j"$(nproc)" mysqli gd intl zip ldap bz2 exif opcache bcmath

COPY php-glpi.ini /usr/local/etc/php/conf.d/zz-glpi.ini

RUN curl -fsSL -o /tmp/glpi.tgz https://github.com/glpi-project/glpi/releases/download/${GLPI_VERSION}/glpi-${GLPI_VERSION}.tgz && tar -xzf /tmp/glpi.tgz -C /var/www && rm /tmp/glpi.tgz && mkdir -p /var/www/glpi/config /var/www/glpi/files /var/www/glpi/marketplace && chown -R www-data:www-data /var/www/glpi

WORKDIR /var/www/glpi
EXPOSE 9000
