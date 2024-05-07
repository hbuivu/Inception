# FROM nginx:alpine-3.19.0
# FROM nginx:latest
FROM alpine:3.18.0
RUN apk update &&\
	apk add nginx

#copy all files from nginx folder into docker. we will need the conf and index.html
COPY default.conf /etc/nginx/http.d
COPY . /usr/share/nginx

#this is the port that the app will be listening on
#exposed port are exposed to other containers, and indicates which ports are intended to be used by the application inside the container. They are not accessible outside Docker host by default
#published ports (mapped ports) make the container's port accessible outside of docker. Docker creates mapping bewteen a port on the docker host and and a port ont h container. PUblished ports override any expose instructions in Dockerfile
EXPOSE 8080

#this will run nginx -g daemon off in command line
#-g passes config directive (daemon off) to nginx. 
CMD ["nginx", "-g", "daemon off;"]

