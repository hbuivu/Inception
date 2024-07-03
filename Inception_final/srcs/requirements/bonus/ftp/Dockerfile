FROM alpine:3.19.0

RUN apk add --no-cache \
	vsftpd \ 
	openrc \
	shadow
	
COPY tools/config.sh /scripts/config.sh

RUN chmod +x /scripts/config.sh

EXPOSE 20 21 40000-40100

ENTRYPOINT [ "./scripts/config.sh" ]