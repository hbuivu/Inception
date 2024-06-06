FROM alpine:3.18.0
RUN apk update && apk add --no-cache nginx openssl

WORKDIR /etc/nginx

RUN mkdir -p ssl/private ssl/certs
RUN openssl req -x509 -sha256 -nodes \
	-newkey rsa:2048 \
	-days 365 \
	-subj "/C=AE/ST=AbuDhabi/L=AbuDhabi/O=42AbuDhabi/OU=Inception/CN=hbui-vu" \
	-keyout /etc/nginx/ssl/private/nginx.key \
	-out /etc/nginx/ssl/certs/nginx.pem

COPY ./nginx.conf nginx.conf
COPY ./index.php /var/www/html/index.php
COPY ./hello.php /var/www/html/hello.php

EXPOSE 80 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]