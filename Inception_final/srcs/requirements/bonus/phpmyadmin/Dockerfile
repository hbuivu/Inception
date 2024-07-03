FROM  alpine:3.19.0

RUN apk add --no-cache \
	php-fpm \ 
	php-session \
	php-mysqli \
	php-iconv \
	phpmyadmin

COPY tools/config.sh /scripts/config.sh

RUN chmod +x /scripts/config.sh

ENV PMA_HOST=mariadb PMA_USER=hbui-vu PMA_PASSWORD=hbui-vu

EXPOSE 8081

ENTRYPOINT ["./scripts/config.sh"]
