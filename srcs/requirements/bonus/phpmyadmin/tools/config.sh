#!/bin/sh

#install phpmyadmin
# wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.tar.gz -O /tmp/phpmyadmin.tar.gz
# mkdir -p /etc/phpmyadmin
# tar xzf /tmp/phpmyadmin.tar.gz --strip-components=1 -C /etc/phpmyadmin
# rm /tmp/phpmyadmin.tar.gz

#add www-data and edit www.conf file
adduser -S www-data -G www-data
sed -i "s|user = nobody|user = www-data|g" /etc/php81/php-fpm.d/www.conf
sed -i "s|group = nobody|group = www-data|g" /etc/php81/php-fpm.d/www.conf
sed -i "s|listen = 127.0.0.1:9000|listen = 8081|g" /etc/php81/php-fpm.d/www.conf
sed -i "s|;listen.owner = nobody|listen.owner = www-data|g" /etc/php81/php-fpm.d/www.conf
sed -i "s|;listen.group = www-data|listen.group = www-data|g" /etc/php81/php-fpm.d/www.conf

#edit phpmyadmin conf
# cp /etc/phpmyadmin/config.sample.inc.php /etc/phpmyadmin/config.inc.php
# mv /etc/phpmyadmin/config.sample.inc.php /etc/phpmyadmin/config.sample.inc.php.bak
# sed -i "s|$cfg['Servers'][$i]['host'] = 'localhost';|$cfg['Servers'][$i]['host'] = 'mariadb:3306';|g" /etc/phpmyadmin/config.inc.php
sed -i "s|\$cfg\['Servers'\]\[\$i\]\['host'\] = 'localhost';|\$cfg['Servers'][\$i]['host'] = 'mariadb:3306';|g" /etc/phpmyadmin/config.inc.php
#change ownerships and permissions for folder
chown -R www-data:www-data /etc/phpmyadmin
chmod 644 /etc/phpmyadmin/config.inc.php

#run fastcgi and nginx servers
# nginx -g "daemon off;" &
php-fpm81 -F

# NOTES:
# Tried to install manualy with wget, but this doesn't work bc of ownership isseus wtih config file
# We need to put the files in a volume, but if we do this, the permissions are set to 777 and can't be changed
# If we install as a package, the config file is set in a different location and therefore we don't have to copy it over to the volume
# Also we need the volume bc phpmyadmin contains non php files that have to be served over nginx
# tried to install nginx and fastcgi server on same container, but that doesn't seem to work well
# be careful of using sed with $, we have to \ out of it , otherwise it messes up the lines
# we can install adminer without a volume bc it is a single php file 

