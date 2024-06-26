#!/bin/sh

# install adminer
mkdir -p /var/www/html/adminer
wget https://www.adminer.org/latest.php -O /var/www/html/adminer/index.php

#add same user as in wordpress (www-data)
adduser -S www-data -G www-data
sed -i "s|user = nobody|user = www-data|g" /etc/php81/php-fpm.d/www.conf
sed -i "s|group = nobody|group = www-data|g" /etc/php81/php-fpm.d/www.conf
sed -i "s|listen = 127.0.0.1:9000|listen = 8080|g" /etc/php81/php-fpm.d/www.conf
sed -i "s|;listen.owner = nobody|listen.owner = www-data|g" /etc/php81/php-fpm.d/www.conf
sed -i "s|;listen.group = www-data|listen.group = www-data|g" /etc/php81/php-fpm.d/www.conf

chown www-data:www-data /var/www/html/adminer/index.php
chmod -R 755 /var/www/html/adminer


php-fpm81 -F
# -R
# adduser --uid 100 --gid 82 -S www-data -G www-data
# php -S 0.0.0.0:80

# ENTRYPOINT ["php", "-S", "0.0.0.0:9000"]

# chmod +x /var/www/html/adminer/index.php