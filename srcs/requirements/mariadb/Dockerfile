FROM alpine:3.18.0
#run apk update to ensure that package index is up to date.
#however this will increase the size of your docker image bc it adds metadata and indexes to the image layers
#to avoid issues with caching, run apk update and apk add in one RUN command
#no-cache ensures package index is not cached locally
RUN apk update &&\
	apk add --no-cache mariadb mariadb-client mariadb-server-utils &&\
	rm -f /var/cache/apk/*

COPY run.sh /scripts/run.sh

RUN mkdir /docker-entrypoint-initdb.d \
	chmod -R 755 /scripts 
# default permissions by docker is usually set to 755 for directories so we might not need this?

#default mariadb port
EXPOSE 3306

#run the script upon startup
ENTRYPOINT ["/scripts/runs.sh"]

#see https://mariadb.com/kb/en/creating-a-custom-container-image/
HEALTHCHECK --start-period=5m \
  CMD mariadb -e 'SELECT @@datadir;' || exit 1

# CMD ["mysqld", "--user=mysql", "--console"]

#the init.sql file initializes a database
# COPY init.sql /docker-entrypoint-initdb.d/
# COPY ./tools/mariadb.sh /usr/local/bin/
# COPY ./conf/wordpress.sql /usr/local/bin/

# ENV MARIADB_ROOT_PASSWORD pass123
# ENV MARIADB_DATABASE testDB
# ENV MARIADB_USER usr
# ENV MARIADB_PASSWORD pass1234

#creates a mount point with specified path
#var/lib/mysql is commonly used to store mysql database files
# VOLUME ["/var/lib/mysql"] -> we don't need this though because we have it in dockercompose