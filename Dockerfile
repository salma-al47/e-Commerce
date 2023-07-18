FROM php:7.4-apache
RUN apt-get update && apt-get install -y \
git \
unzip \
libzip-dev \
libonig-dev
RUN docker-php-ext-install pdo_mysql zip mbstring
COPY laravel.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
WORKDIR /var/www/html
COPY . /var/www/html
RUN composer install --optimize-autoloader --no-dev
RUN chown -R www-data:www-data storage bootstrap/cache
EXPOSE 80
CMD ["apache2-foreground"]