FROM alpine:3.19.0

RUN apk add --no-cache \
	nginx \
	openssl

RUN mkdir -p /etc/nginx/ssl/private /etc/nginx/ssl/certs

RUN openssl req -x509 -sha256 -nodes \
	-newkey rsa:2048 \
	-days 365 \
	-subj "/C=AE/ST=AbuDhabi/L=AbuDhabi/O=42AbuDhabi/OU=Inception/CN=hbui-vu.42.fr" \
	-keyout /etc/nginx/ssl/private/nginx.key \
	-out /etc/nginx/ssl/certs/nginx.crt

COPY tools/default.conf /etc/nginx/http.d/default.conf

EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]