# Apache 2.4 basé sur Alpine
FROM httpd:2.4.57-alpine3.17

LABEL authors="Charles GERARD-LE METAYER <contact@glm-system.fr>"

# Modifier la configuration Apache
RUN sed -i \
    -e 's/Listen 80/Listen 8000/' \
    -e 's/^#ServerName.*/ServerName localhost:8000/' \
    /usr/local/apache2/conf/httpd.conf

# Activer les modules nécessaires pour PHP-FPM et proxy
RUN sed -i \
    -e 's/^#\(LoadModule proxy_module modules\/mod_proxy.so\)/\1/' \
    -e 's/^#\(LoadModule proxy_fcgi_module modules\/mod_proxy_fcgi.so\)/\1/' \
    /usr/local/apache2/conf/httpd.conf

# Ajouter la configuration du VirtualHost pour Symfony
COPY conf/httpd-vhosts.conf /usr/local/apache2/conf/extra/httpd-vhosts.conf

# Activer la configuration des VirtualHosts
RUN sed -i \
    -e 's/#Include\ conf\/extra\/httpd-vhosts.conf/Include\ conf\/extra\/httpd-vhosts.conf/' \
    /usr/local/apache2/conf/httpd.conf

# Créer le répertoire des logs
RUN mkdir -p /usr/local/apache2/logs \
    && chmod -R 755 /usr/local/apache2/logs

# Définir le répertoire de travail
WORKDIR /usr/local/apache2/htdocs

# Exposer le port
EXPOSE 8000

# Lancer Apache
CMD ["httpd-foreground"]
