FROM alpine:3.19.0

RUN apk add --no-cache \
	mariadb \
	mariadb-client \
	mariadb-server-utils

COPY tools/config.sh /scripts/config.sh

RUN chmod -R 755 /scripts

EXPOSE 3306

ENTRYPOINT ["./scripts/config.sh"]

