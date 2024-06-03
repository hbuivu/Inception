#!/bin/sh

if [ ! -d "/run/mysqld" ]; then
	echo "mysqld not found, creating...."
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ ! -d /var/lib/mysql/mysql ]; then
	echo "MySQL directory not found. Creating initial MySQL directory..."
	chown -R mysql:mysql /var/lib/mysql
	mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

	#SET THESE VARIABLES IN .ENV IN THE YAML FILE
	# if [ "$MYSQL_ROOT_PASSWORD" = "" ]; then
	# 	MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} #i think we set this in secrets?
	# fi

	# WP_DB_NAME=${WP_DB_NAME:-""}
	# MYSQL_USER=${MYSQL_USER:-""}
	# MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

	

	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
	    return 1
	fi


# ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PWD';
# GRANT ALL ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
# GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
# CREATE DATABASE $WP_DATABASE_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;
# CREATE USER '$WP_DATABASE_USR'@'%' IDENTIFIED by '$WP_DATABASE_PWD';
# GRANT ALL PRIVILEGES ON $WP_DATABASE_NAME.* TO '$WP_DATABASE_USR'@'%';
# ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PWD';
	cat << EOF > $tfile

USE mysql;
FLUSH PRIVILEGES ;
DELETE FROM	mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.db WHERE Db='test';
DROP DATABASE IF EXISTS test ;

SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MARIADB_ROOT_PWD}') ;

CREATE DATABASE $MARIADB_NAME CHARACTER SET $MARIADB_CHARSET COLLATE $MARIADB_COLLATION;
CREATE USER '$MARIADB_USER'@'%' IDENTIFIED by '$MARIADB_PWD';
GRANT ALL PRIVILEGES ON $MARIADB_NAME.* TO '$MARIADB_USER'@'%';

FLUSH PRIVILEGES ;

EOF

	#initialize the mariadb data directory from the tfile
	/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < $tfile
	rm -f $tfile
fi

sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf 	 	

#start mariadb server
exec /usr/bin/mysqld --user=mysql --console

	