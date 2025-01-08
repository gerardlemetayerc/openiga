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

# Install Symfony CLI
RUN curl -sS https://get.symfony.com/cli/installer | bash \
    && mv /root/.symfony*/bin/symfony /usr/local/bin/symfony

RUN mkdir /usr/lib/openiga/ 
# Clone the application repository
RUN git clone https://github.com/gerardlemetayerc/openiga.git/openiga /usr/lib/openiga

RUN chmod 777 /usr/lib/openiga/openiga
ln -s /usr/lib/openiga/openiga /var/www/html/openiga

# Set the working directory to the Symfony project
WORKDIR /var/www/html/openiga

# Install Composer
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

RUN symfony new --webapp . --no-interaction || true

# Install dependencies with Composer

RUN composer install

# Set permissions
RUN chown -R www-data:www-data /var/www/html