#!/bin/sh

#add www-data and edit www.conf file
adduser -S www-data -G www-data
sed -i "s|user = nobody|user = www-data|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|group = nobody|group = www-data|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|listen = 127.0.0.1:9000|listen = 8081|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|;listen.owner = nobody|listen.owner = www-data|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|;listen.group = www-data|listen.group = www-data|g" /etc/php82/php-fpm.d/www.conf

#edit phpmyadmin conf
sed -i "s|\$cfg\['Servers'\]\[\$i\]\['host'\] = 'localhost';|\$cfg['Servers'][\$i]['host'] = 'mariadb:3306';|g" /etc/phpmyadmin/config.inc.php
#change ownerships and permissions for folder
chown -R www-data:www-data /etc/phpmyadmin
chmod 644 /etc/phpmyadmin/config.inc.php

#run fastcgi and nginx servers
php-fpm82 -F


