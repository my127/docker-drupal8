FROM redis:5.0 AS redis
FROM my127/php:7.2-fpm-stretch-console

RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && apt-get update -qq \
 # Install base packages \
 && DEBIAN_FRONTEND=noninteractive apt-get -qq -y --no-install-recommends install \
    libmemcached11 \
    libmemcachedutil2 \
  # package dependencies only needed for the duration of the build \
    autoconf \
    g++ \
    make \
    libmemcached-dev \
    zlib1g-dev \
  # php extensions \
    && printf "\n" | pecl install memcached && docker-php-ext-enable memcached \
 # Clean the image \
 && DEBIAN_FRONTEND=noninteractive apt-get -y --purge remove \
    autoconf \
    g++ \
    make \
    libmemcached-dev \
    zlib1g-dev \
 && apt-get auto-remove -qq -y \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# tool: redis-cli
# ---------------
# we copy instead of using redis-cli or redis-tools due to inconsistent versions
COPY --from=redis /usr/local/bin/redis-cli /usr/local/bin/redis-cli
