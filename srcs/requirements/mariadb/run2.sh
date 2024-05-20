#!/bin/sh

if [ -d "/run/mysqld" ]; then
	echo "[i] mysqld already present, skipping creation"
	chown -R mysql:mysql /run/mysqld
else
	echo "[i] mysqld not found, creating...."
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ -d /var/lib/mysql/mysql ]; then
	echo "MySQL directory already created"
	chown -R mysql:mysql /var/lib/mysql
else
	echo "Creating initial MySQL directory"
	chown -R mysql:mysql /var/lib/mysql
	mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

	if [ "$MYSQL_ROOT_PASSWORD" = "" ]; then
		MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} #i think we set this in secrets?
		echo "[i] MySQL root Password: $MYSQL_ROOT_PASSWORD"
	fi

	MYSQL_DATABASE=${MYSQL_DATABASE:-""}
	MYSQL_USER=${MYSQL_USER:-""}
	MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
	    return 1
	fi

	cat << EOF > $tfile

USE mysql;
FLUSH PRIVILEGES ;
GRANT ALL ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;
EOF

#check if MYSQL_DATABASE is empty, if not then create the database
#
	if [ "$MYSQL_DATABASE" != "" ]; then
	    echo "[i] Creating database: $MYSQL_DATABASE"
		if [ "$MYSQL_CHARSET" != "" ] && [ "$MYSQL_COLLATION" != "" ]; then
			echo "[i] with character set [$MYSQL_CHARSET] and collation [$MYSQL_COLLATION]"
			echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET $MYSQL_CHARSET COLLATE $MYSQL_COLLATION;" >> $tfile
		else
			echo "[i] with character set: 'utf8' and collation: 'utf8_general_ci'"
			echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile
		fi

		if [ "$MYSQL_USER" != "" ]; then
			echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD"
			echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile
		fi
	fi
fi