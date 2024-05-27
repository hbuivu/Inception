FROM alpine:3.18.0
#no need to install mysql bc we've got mariadb already
RUN apk update && \
	apk add --no-cache lighttpd php82 fcgi php82-cgi && \ 
	apk add curl && \
	rm -f /var/cache/apk/*

RUN mkdir -p /scripts

COPY ./script.sh ./scripts/script.sh
# COPY ./wp-config.php /

RUN chmod +x /scripts/script.sh

ENTRYPOINT ["./scripts/script.sh"]