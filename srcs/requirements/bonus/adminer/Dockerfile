#Notes: 
	# - test with no volume
	# - test which php packages need to be there for it to work
	
FROM alpine:3.18.0

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
	php-session \
	curl
	
COPY tools/config.sh /scripts/config.sh

RUN chmod +x /scripts/config.sh

EXPOSE 8080

ENTRYPOINT ["./scripts/config.sh"]


# RUN apk add --no-cache \
# 	wget \
# 	php \
# 	php-cli \ 
# 	php-fpm \ 
# 	php-mysqli \ 
# 	php-pdo \ 
# 	php-pdo_mysql

# RUN adduser -S www-data -G www-data && \
# 	sed -i "s|user = nobody|user = www-data|g" /etc/php81/php-fpm.d/www.conf & \
# 	sed -i "s|group = nobody|group = www-data|g" /etc/php81/php-fpm.d/www.conf & \
# 	sed -i "s|listen = 127.0.0.1:8080|listen = 8080|g" /etc/php81/php-fpm.d/www.conf & \
# 	sed -i "s|;listen.owner = nobody|listen.owner = www-data|g" /etc/php81/php-fpm.d/www.conf & \
# 	sed -i "s|;listen.group = www-data|listen.group = www-data|g" /etc/php81/php-fpm.d/www.conf
