FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpq-dev \
    libonig-dev \
    libzip-dev \
    curl \
    && docker-php-ext-install pdo pdo_pgsql mbstring zip

RUN apt-get update && \
    apt-get install -y curl && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Clone the application repository
RUN git clone https://github.com/gerardlemetayerc/openiga.git /var/www/html

# Set the working directory to the Symfony project
WORKDIR /var/www/html/openiga

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Install dependencies with Composer
RUN composer install

# Set permissions
RUN chown -R www-data:www-data /var/www/html