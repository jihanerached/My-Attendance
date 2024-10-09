# Use the official PHP image with Apache
FROM php:8.1-apache

# Install necessary PHP extensions
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install pdo pdo_mysql

# Enable Apache rewrite module
RUN a2enmod rewrite

# Set the working directory to /var/www
WORKDIR /var/www

# Install Composer globally
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create a new Laravel project (this will be run during build)
RUN composer create-project --prefer-dist laravel/laravel laravel-app

# Set permissions for the Laravel directory
RUN chown -R www-data:www-data /var/www/laravel-app/storage \
    && chown -R www-data:www-data /var/www/laravel-app/bootstrap/cache

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]
