FROM alpine:3.18.0

RUN apk add --no-cache \
	nginx \
	openssl

# WORKDIR /etc/nginx

RUN mkdir -p /etc/nginx/ssl/private /etc/nginx/ssl/certs
# RUN mkdir -p ssl/private ssl/certs
RUN openssl req -x509 -sha256 -nodes \
	-newkey rsa:2048 \
	-days 365 \
	-subj "/C=AE/ST=AbuDhabi/L=AbuDhabi/O=42AbuDhabi/OU=Inception/CN=hbui-vu.42.fr" \
	-keyout /etc/nginx/ssl/private/nginx.key \
	-out /etc/nginx/ssl/certs/nginx.crt

# COPY tools/default.conf http.d/default.conf
COPY tools/default.conf /etc/nginx/http.d/default.conf

EXPOSE 80 443
# EXPOSE 443

ENTRYPOINT ["nginx", "-g", "daemon off;"]