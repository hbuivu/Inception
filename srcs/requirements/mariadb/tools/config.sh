#!/bin/sh

# initiate mysqld daemon
if [ ! -d "/run/mysqld" ]; then
	echo "mysqld not found, creating...."
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

# check if mysql directory exists
if [ ! -d /var/lib/mysql/mysql ]; then
	echo "MySQL directory not found. Creating initial MySQL directory..."
	chown -R mysql:mysql /var/lib/mysql
	mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql > /dev/null

	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
	    return 1
	fi

	cat << EOF > $tfile

USE mysql;
FLUSH PRIVILEGES ;
DELETE FROM	mysql.user WHERE User='';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.db WHERE Db='test';
DROP DATABASE IF EXISTS test ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${DB_ROOT_PWD}') ;
CREATE DATABASE $DB_NAME CHARACTER SET $DB_CHARSET COLLATE $DB_COLLATION;
CREATE USER '$WP_ADMIN_USER'@'%' IDENTIFIED by '$WP_ADMIN_PWD';
GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$WP_ADMIN_USER'@'%';
FLUSH PRIVILEGES ;
EOF

	/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < $tfile
	rm -f $tfile
fi

sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf 	 	

exec /usr/bin/mysqld --user=mysql --console