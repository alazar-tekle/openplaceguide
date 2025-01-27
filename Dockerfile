FROM composer:2.2.9 as composer

FROM php:8.1-apache-buster

RUN apt-get update && apt-get install -y zip
RUN curl https://robo.li/robo.phar -o /usr/bin/robo && chmod +x /usr/bin/robo

ENV LOG_CHANNEL=stderr
ENV APACHE_DOCUMENT_ROOT /var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

COPY . /var/www/html
RUN chown -R www-data:www-data /var/www/html/storage || true
RUN chown -R www-data:www-data /var/www/html/bootstrap/cache || true

COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN composer install --no-dev
