FROM alpine:3.18.0
#run apk update to ensure that package index is up to date.
#however this will increase the size of your docker image bc it adds metadata and indexes to the image layers
#to avoid issues with caching, run apk update and apk add in one RUN command
#no-cache ensures package index is not cached locally
RUN apk update &&\
	apk add --no-cache mariadb mariadb-client


RUN mkdir -p /var/mysqld

#the init.sql file initializes a database
COPY init.sql /docker-entrypoint-initdb.d/
# COPY ./tools/mariadb.sh /usr/local/bin/
# COPY ./conf/wordpress.sql /usr/local/bin/

ENV MARIADB_ROOT_PASSWORD pass123
ENV MARIADB_DATABASE testDB
ENV MARIADB_USER usr
ENV MARIADB_PASSWORD pass1234

#default mariadb port
EXPOSE 3306

#see https://mariadb.com/kb/en/creating-a-custom-container-image/
HEALTHCHECK --start-period=5m \
  CMD mariadb -e 'SELECT @@datadir;' || exit 1

CMD ["mysqld", "--user=mysql", "--console"]