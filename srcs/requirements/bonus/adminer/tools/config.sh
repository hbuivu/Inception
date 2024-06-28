#!/bin/sh

# install adminer
mkdir -p /var/www/html/wordpress
wget https://www.adminer.org/latest.php -O /var/www/html/wordpress/adminer.php

#add same user as in wordpress (www-data)
adduser -D -S www-data -G www-data
sed -i "s|user = nobody|user = www-data|g" /etc/php81/php-fpm.d/www.conf
sed -i "s|group = nobody|group = www-data|g" /etc/php81/php-fpm.d/www.conf
sed -i "s|listen = 127.0.0.1:9000|listen = 8080|g" /etc/php81/php-fpm.d/www.conf
sed -i "s|;listen.owner = nobody|listen.owner = www-data|g" /etc/php81/php-fpm.d/www.conf
sed -i "s|;listen.group = www-data|listen.group = www-data|g" /etc/php81/php-fpm.d/www.conf

chown www-data:www-data /var/www/html/wordpress/adminer.php
chmod -R 755 /var/www/html/wordpress

php-fpm81 -F


