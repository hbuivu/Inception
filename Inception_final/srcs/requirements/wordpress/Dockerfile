FROM alpine:3.19.0

RUN apk add --no-cache \
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
	php-zip \ 
	php-tokenizer \
	curl

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN cp wp-cli.phar /usr/local/bin/wp
RUN adduser -S www-data -G www-data && \
    sed -i "s|user = nobody|user = www-data|g" /etc/php82/php-fpm.d/www.conf && \
    sed -i "s|group = nobody|group = www-data|g" /etc/php82/php-fpm.d/www.conf && \
    sed -i "s|listen = 127.0.0.1:9000|listen = 9000|g" /etc/php82/php-fpm.d/www.conf && \
    sed -i "s|;listen.owner = nobody|listen.owner = www-data|g" /etc/php82/php-fpm.d/www.conf && \
    sed -i "s|;listen.group = www-data|listen.group = www-data|g" /etc/php82/php-fpm.d/www.conf

EXPOSE 9000

WORKDIR /var/www/html/wordpress

COPY tools/config.sh scripts/config.sh

RUN chmod 755 scripts/config.sh

CMD ["sh", "scripts/config.sh"]