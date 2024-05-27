FROM alpine:3.18.0

RUN apk update && \
	apk add --no-cache \
	wget \
	php \
	php-fpm \
	php-phar \
	php-mysqli \
	php-curl \
	php-dom \
	php-exif \
	php-gd \
	php-iconv \
	php-json \
	php-fileinfo \
	php-mbstring \
	php-openssl \
	php-xml \
	php-zip && \ 
	apk add curl && \
	rm -f /var/cache/apk/*

#install wordpress
#must install wp-cli.phar the command line interface for managing wp installations
#manages wp installations, plugin and themes, database operations, user management, site config, and content management
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN cp wp-cli.phar /usr/bin/wp

#workdir will make the folder if one does not exist
WORKDIR /var/www/html/wordpress

COPY ./script.sh /scripts/script

RUN chmod +x /scripts/script.sh

# ENTRYPOINT [".scripts/script.sh"]
CMD ./scripts/script.sh
# RUN chmod +x ./script.sh
# COPY ./wp-config.php /
# RUN ls -l /scripts > ./hi.txit t
# ENTRYPOINT ["./script.sh"]

#no need to install mysql bc we've got mariadb already