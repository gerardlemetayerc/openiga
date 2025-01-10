# PHP 8.2 basé sur Alpine
FROM php:8.2-fpm-alpine3.17

LABEL authors="Charles GERARD-LE METAYER <contact@glm-system.fr>"

# Configurer le fuseau horaire
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Installer les outils nécessaires
RUN apk add --no-cache \
    git \
    openssh \
    postgresql-dev \
    zip \
    unzip \
    curl \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    oniguruma-dev \
    bash \
    icu-dev \
    g++ \
    make

# Installer les extensions PHP nécessaires pour Symfony et PostgreSQL
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
    gd \
    pdo_pgsql \
    pdo_mysql \
    intl \
    opcache \
    zip

# Installer Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Créer l'utilisateur et le groupe avant d'exécuter d'autres commandes
RUN addgroup -g 1000 app \
    && adduser -D -H -h /var/www/openiga -s /sbin/nologin -G app -u 1000 app

# Cloner le repository Symfony dans /opt/openiga
RUN mkdir -p /opt/openiga \
    && git clone https://github.com/gerardlemetayerc/openiga.git /opt/openiga \
    && chown -R app:app /opt/openiga
RUN git config --global --add safe.directory /opt/openiga


# Créer un lien symbolique dans /var/www vers /opt/openiga/openiga/public
RUN mkdir -p /var/www \
    && ln -s /opt/openiga/openiga/public /var/www/openiga \
    && chown -h app:app /var/www/openiga

# Installer les dépendances Symfony
WORKDIR /opt/openiga/openiga
RUN composer install --no-dev --optimize-autoloader \
    && php bin/console cache:clear --env=prod \
    && chown -R app:app /opt/openiga

# Supprimer les outils inutiles pour réduire la taille de l'image (facultatif)
RUN apk del git openssh g++ make

# Définir l'utilisateur par défaut
USER app:app

# Définir le répertoire de travail
WORKDIR /var/www/openiga

# Exposer le port
EXPOSE 9000