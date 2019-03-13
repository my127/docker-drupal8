FROM my127/php:7.2-fpm-alpine-console

RUN apk --update add \
  # package dependencies \
    redis \
    libmemcached \
  # package dependencies only needed for the duration of the build \
    libmemcached-dev \
  # php extensions \
    && printf "\n" | pecl install memcached && docker-php-ext-enable memcached \
  # clean \
    && apk del \
    autoconf g++ make freetype-dev libjpeg-turbo-dev libpng-dev openssl-dev libxml2-dev libmcrypt-dev libxslt-dev icu-dev libmemcached-dev \
    && rm -rf /var/cache/apk/*
