#!/bin/sh

if [ ! -f /var/www/html/wordpress/wp-config.php ]; then 
	echo "Wordpress not found. Installing..."
	wp core download --allow-root
	wp config create --dbname=$DB_NAME --dbuser=$WP_ADMIN_USER \
        --dbpass=$WP_ADMIN_PWD --dbhost=$DB_HOST --dbcharset=$DB_CHARSET \
		--dbcollate=$DB_COLLATION --allow-root --skip-check
	cat wp-config.php
    wp core install --url=$WP_DOMAIN_NAME --title=$WP_TITLE --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PWD --admin_email=$WP_ADMIN_EMAIL \
        --allow-root
	wp user create $WP_USER $WP_USER_EMAIL --role=subscriber --user_pass=$WP_USER_PWD --allow-root
	wp theme install neve --activate --allow-root

	#Redis
	wp config set WP_CACHE 'true' --allow-root
	wp config set WP_REDIS_PORT $REDIS_PORT --allow-root
	wp config set WP_REDIS_HOST $REDIS_HOST --allow-root
	wp plugin install redis-cache --allow-root
	wp plugin activate redis-cache --allow-root

	#ftp
	wp config set FTP_HOST $FTP_HOST --allow-root
	wp config set FTP_USER $WP_ADMIN --allow-root
	wp config set FTP_PASS $WP_ADMIN_PWD --allow-root
	wp config set FTP_BASE /var/www/html/wordpress --allow-root
fi

chown -R www-data:www-data /var/www/html/wordpress
chmod -R 755 /var/www/html/wordpress

wp redis enable --allow-root

php-fpm81 -F -R