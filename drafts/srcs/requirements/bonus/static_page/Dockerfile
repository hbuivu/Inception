FROM alpine:3.18.0

RUN apk update && \
	apk add --no-cache nodejs npm

ADD ./conf /

ENTRYPOINT ["node", "run.js"]