FROM alpine:3.18.0

RUN apk add --no-cache nodejs npm

COPY ./tools /var/www/html/site

WORKDIR /var/www/html/site 

RUN npm init -y && npm install express -y

EXPOSE 3000

CMD ["node", "server.js"]