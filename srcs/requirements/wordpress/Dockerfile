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
RUN cp wp-cli.phar /usr/local/bin/wp
RUN adduser -S www-data -G www-data && \
    sed -i "s|user = nobody|user = www-data|g" /etc/php81/php-fpm.d/www.conf && \
    sed -i "s|group = nobody|group = www-data|g" /etc/php81/php-fpm.d/www.conf && \
    sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" /etc/php81/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner = www-data|g" /etc/php81/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = www-data|listen.group = www-data|g" /etc/php81/php-fpm.d/www.conf

#workdir will make the folder if one does not exist
WORKDIR /var/www/wordpress

COPY ./script.sh script.sh

RUN chmod +x script.sh

ENTRYPOINT ["./script.sh"]
# CMD ./scripts/script.sh
# RUN chmod +x ./script.sh
# COPY ./wp-config.php /
# RUN ls -l /scripts > ./hi.txit t
# ENTRYPOINT ["./script.sh"]

#no need to install mysql bc we've got mariadb already