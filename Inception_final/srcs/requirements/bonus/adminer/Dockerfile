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
	php-session \
	curl
	
COPY tools/config.sh /scripts/config.sh

RUN chmod +x /scripts/config.sh

EXPOSE 8080

ENTRYPOINT ["./scripts/config.sh"]
