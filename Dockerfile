FROM php:7.1-fpm

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y libpng12-dev libjpeg-dev git curl wget libmagickwand-dev libmagickcore-dev \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd pdo_mysql zip opcache \
    
    && curl -sS https://getcomposer.org/installer | php -d detect_unicode=Off \
    && chmod a+x composer.phar && mv composer.phar /usr/local/bin/composer \
    && composer self-update \

    && curl -L https://pecl.php.net/get/redis-3.1.4.tgz >> /tmp/redis.tgz \
    && mkdir -p /usr/src/php/ext/ && tar -xf /tmp/redis.tgz -C /usr/src/php/ext/ \
    && rm /tmp/redis.tgz \
    && docker-php-ext-install redis-3.1.4

ENV LANG C.UTF-8

RUN DEBIAN_FRONTEND=noninteractive echo "Install imagick:" \
    && pecl install imagick && docker-php-ext-enable imagick 

RUN DEBIAN_FRONTEND=noninteractive echo "Install ffmpeg:" \
    && sh -c 'echo "deb http://ftp.uk.debian.org/debian jessie-backports main" >> /etc/apt/sources.list' \
    && apt-get update \
    && apt-get install -y ffmpeg

RUN echo " Clean up:"  && \
    apt-get clean  && \
    rm -rf /var/lib/apt/lists/*