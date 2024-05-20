#hash-band or shebang -> tells os which interpreter to use to execute script (sh, or zsh, etc)
#!/bin/sh

#CREATING DAEMON
if [ -d "/run/mysqld" ]; then
	echo "[i] mysqld already present, skipping creation"
	chown -R mysql:mysql /run/mysqld
else
	echo "[i] mysqld not found, creating...."
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

#-R recursive - changes ownership in all files and directories within that directory too
#mysql:mysql - owner:group
#mysql database server by default runs as mysql user, so this will give mysql server process permission to read and write databases
#-d used if directory exists
# we use this with '[]' which is equivalent to test
	#so test -d /var/lib.... or [ -d /var/lib ]. make sure there are spaces between the brackets and args
if [ -d /var/lib/mysql/mysql ]; then
	echo "MySQL directory already created"
	chown -R mysql:mysql /var/lib/mysql
else
	echo "Creating initial MySQL directory"
	#change ownership first to ensure that files and directories created by command mysql_install_db are owned by mysql user
	chown -R mysql:mysql /var/lib/mysql
	#initialize MySQL data directory; specify user running command is mysql; define location of MySQL data direcotryt; redirect standard output to /dev/null so the info will be hidden 
	mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

	#checks if password exists, if not generate a random one;
	#we might have delete this, and set the root password in secrets
	if [ "$MYSQL_ROOT_PASSWORD" = "" ]; then
		MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD} #i think we set this in secrets?
		echo "[i] MySQL root Password: $MYSQL_ROOT_PASSWORD"
	fi

	#defining environment variables
	#:-"" means that it will chekc for the value is already set and if not, then it is set to empty string
	#set these env variables as a fallback in case it's not defined elsewhere
	#KEY config environmental var: 
	#ROOT_PASSWORD - pswd for root user; crucial for admin access to server 
	#DATABASE - name of specific db to connect to; required if you want to work with a particular db
	#USER - define username of a madiadb user account with specific permissions; use this to grant access to a db but without full root privileges
	#PASSWORD - pswd for user
	#sometimes HOST and PORT ; HOST defines hostname or IP adddress of mariadb server if you're connecting remotely
	#port specifies port number used by mdb server; default is 3306
	#use MARIADB _* over MYSQL_* for better compatability
	MYSQL_DATABASE=${MYSQL_DATABASE:-""}
	MYSQL_USER=${MYSQL_USER:-""}
	MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

#create a temporary file and check if it exists
#Use here-doc (EOF) to store SQL commands temporarily
#set up a MariaDB server and use EOF to end heredoc
	#switch to mysql Database
	#reload privilege tables in mysql database, ensuring any changes made to user privileges take effect immediately
	#grant all privileges to root from nay host - WITH GRANT OPTION means root user can grant privileges to other users
	#grant all privileges to root from localhost
	#set password for root user
	#remove test database if it exists; test database is created by default and can be security risk if accessible
	#flush privileges again to apply all privileges immediately

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