FROM php:7.1-fpm
RUN apt-get update && apt-get install -y \
  cron \
  git \
  gzip \
  libfreetype6-dev \
  libicu-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libpng-dev \
  libxslt1-dev \
  lsof \
  mariadb-client \
  vim \
  zip \
  mc

RUN docker-php-ext-configure \
  gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/

RUN docker-php-ext-install \
  bcmath \
  gd \
  intl \
  mbstring \
  opcache \
  pdo_mysql \
  soap \
  xsl \
  zip \
  mcrypt


RUN pecl channel-update pecl.php.net \
  && pecl install xdebug \
  && docker-php-ext-enable xdebug
#  && sed -i -e 's/^zend_extension/\;zend_extension/g' /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

RUN apt-get install -y libssh2-1-dev \
  && pecl install ssh2-1.1.2 \
  && docker-php-ext-enable ssh2

RUN pecl install -o -f redis \
&&  rm -rf /tmp/pear \
&&  docker-php-ext-enable redis

RUN curl -sS https://getcomposer.org/installer | \
  php -- --install-dir=/usr/local/bin --filename=composer

RUN groupadd -g 1000 web \
 && useradd -g 1000 -u 1000 -d /var/www -s /bin/bash web

RUN apt-get install -y gnupg \
#  && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
#  && apt-get install -y nodejs \
  && mkdir /var/www/.config /var/www/.npm /var/www/.cache /var/www/.local /var/www/.composer /var/www/vendor /var/www/.selected_editor /var/www/logs /var/www/logs/php \
  && chown web:web /var/www/ /var/www/.config /var/www/.npm /var/www/.cache /var/www/.local /var/www/.composer /var/www/.selected_editor /var/www/vendor /var/www/logs /var/www/logs/php \
  && ln -s /var/www/html/node_modules/grunt/bin/grunt /usr/bin/grunt
COPY conf/www.conf /usr/local/etc/php-fpm.d/
COPY conf/php.ini /usr/local/etc/php/
COPY conf/php-fpm.conf /usr/local/etc/

ADD bin/magento-installer.sh /var/www/magento-installer.sh
ADD bin/magento-installer_no_composer_stage.sh /var/www/magento-installer_no_composer_stage.sh
ADD bin/magento-command.sh /var/www/magento-command.sh
ADD bin/fake-sendmail.sh /usr/bin/fake-sendmail.sh

RUN ["chmod", "+x", "/var/www/magento-installer.sh"]
RUN ["chmod", "+x", "/var/www/magento-installer_no_composer_stage.sh"]
RUN ["chmod", "+x", "/var/www/magento-command.sh"]
RUN ["chmod", "+x", "/usr/bin/fake-sendmail.sh"]
ADD bin/n98-magerun2.phar /usr/bin/n98-magerun2.phar
RUN ["chmod", "+x", "/usr/bin/n98-magerun2.phar"]
ADD bin/n98-magerun.phar /usr/bin/n98-magerun.phar
RUN ["chmod", "+x", "/usr/bin/n98-magerun.phar"]
ADD bin/dump-db.sh /usr/bin/dump-db.sh
RUN ["chmod", "+x", "/usr/bin/dump-db.sh"]
ADD bin/strip-db.sh /usr/bin/strip-db.sh
RUN ["chmod", "+x", "/usr/bin/strip-db.sh"]
ADD bin/phpcs.sh /usr/bin/phpcs.sh
RUN ["chmod", "+x", "/usr/bin/phpcs.sh"]



RUN mkdir /sock
RUN chown -R web:web /usr/local/etc/php/conf.d /sock /var/www/magento-command.sh /var/www/magento-installer.sh /var/www/magento-installer_no_composer_stage.sh /usr/bin/fake-sendmail.sh


USER web:web

VOLUME /var/www

WORKDIR /var/www/html

EXPOSE 9986

