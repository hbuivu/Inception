#!bin/bash

# rc-service lighttpd start 
# rc-update add lighttpd default

#install wordpress
#check for config file - if its there it's already installed
#download core wp files
#generate config file
#install core files
#create user


if [ ! -f /var/www/wordpress/wp-config.php ]; then 
	echo "Wordpress not found. Installing..."
	
	wp core download --allow-root
	wp config create --dbname=$MARIADB_NAME --dbuser=$MARIADB_USER \
        --dbpass=$MARIADB_PWD --dbhost=$MARIADB_HOST --allow-root  --skip-check
    wp core install --url=$WP_DOMAIN_NAME --title=$WP_TITLE --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PWD --admin_email=$WP_ADMIN_EMAIL \
        --allow-root
	wp user create $WP_USER $WP_USER_EMAIL --role=author --user_pass=$WP_USER_PWD --allow-root
	wp theme install neve --activate --allow-root

	#stream editor
	wp config set DB_USER $MARIADB_USER --allow-root
	wp config set DB_PASSWORD $MARIADB_PWD --allow-root
	wp config set DB_NAME $MARIADB_NAME --allow-root
	wp config set DB_HOST $MARIADB_HOST --allow-root
	
	wp config set FORCE_SSL_ADMIN 'false' --allow-root
    wp config set WP_REDIS_HOST $REDIS_HOST --allow-root
    wp config set WP_REDIS_PASSWORD $REDIS_PWD --allow-root
    wp config set WP_CACHE 'true' --allow-root


	wp plugin install redis-cache --allow-root
    wp plugin activate redis-cache --allow-root
    wp redis enable --allow-root
	

	cp wp-config-sample.php wp-config.php
fi

exec "$@"

# sed -i "s/username_here/$MYSQL_USER/g" wp-config-sample.php
# sed -i "s/password_here/$MYSQL_PASSWORD/g" wp-config-sample.php
# sed -i "s/localhost/$MYSQL_HOSTNAME/g" wp-config-sample.php
# sed -i "s/database_name_here/$MYSQL_DATABASE/g" wp-config-sample.php