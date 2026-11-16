# ---------- Stage 1: build the PHP extension ----------
FROM php:8.3-apache AS builder

# Compile the mysqli extension (needs the PHP build tools)
RUN docker-php-ext-install mysqli

# ---------- Stage 2: runtime image ----------
FROM php:8.3-apache

# Copy only the compiled extension and its config from the builder stage
COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/etc/php/conf.d/docker-php-ext-mysqli.ini /usr/local/etc/php/conf.d/

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
