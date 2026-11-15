FROM php:8.3-apache

# PHP extension required to connect to MySQL (mysqli)
RUN docker-php-ext-install mysqli

# Apache serves files from this directory
WORKDIR /var/www/html

# Copy only the application source code
COPY src/ /var/www/html/

# Apache (user www-data) must be able to save uploaded images
RUN mkdir -p /var/www/html/uploads \
    && chown -R www-data:www-data /var/www/html/uploads

EXPOSE 80

# Mark the container healthy only when the app and database respond
HEALTHCHECK --interval=30s --timeout=5s --start-period=20s --retries=3 \
    CMD curl -fs http://localhost/health.php || exit 1

CMD ["apache2-foreground"]
