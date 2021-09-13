FROM alpine:3.14

RUN echo "UTC" > /etc/timezone

# Install PHP NGINX and other goodies
RUN apk update --no-cache && apk upgrade --no-cache \
    && apk add --no-cache zip unzip curl nginx supervisor \
        php8 \
        php8-common \
        php8-fpm \
        php8-pdo \
        php8-opcache \
        php8-zip \
        php8-phar \
        php8-iconv \
        php8-cli \
        php8-curl \
        php8-openssl \
        php8-mbstring \
        php8-tokenizer \
        php8-fileinfo \
        php8-json \
        php8-xml \
        php8-xmlwriter \
        php8-simplexml \
        php8-dom \
        php8-pdo_mysql \
        php8-tokenizer \
        php8-pecl-redis \
    && ln -s /usr/bin/php8 /usr/bin/php

# Install composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php \
    && php composer-setup.php --install-dir=/usr/local/bin --filename=composer \
    && rm -rf composer-setup.php

# Configure supervisor
RUN mkdir -p /etc/supervisor.d/
COPY ./docker/supervisor/supervisord.conf /etc/supervisor/supervisord.conf

# Configure php/php-fpm
COPY ./docker/php/www.conf /etc/php8/php-fpm.d/www.conf
COPY ./docker/php/php.ini /etc/php8/conf.d/custom.ini

# Configure nginx
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
COPY ./docker/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./docker/nginx/user.mobilefuse.com /etc/nginx/conf.d/default.conf

RUN mkdir -p /run/nginx/
RUN touch /run/nginx/nginx.pid

# send logs out of the container
RUN ln -sf /dev/stdout /var/log/nginx/access.log
RUN ln -sf /dev/stderr /var/log/nginx/error.log

# Default user we'll be using need to own the files
RUN chown -R nobody:nobody /run && \
    chown -R nobody:nobody /var/lib/nginx && \
    chown -R nobody:nobody /var/log/nginx

# Switch to use default non-root user
USER nobody

# Run app via supervisor
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]