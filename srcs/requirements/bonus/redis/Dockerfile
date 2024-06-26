FROM alpine:3.18.0

RUN apk add --no-cache redis

#create backup config
RUN cp /etc/redis.conf /etc/redis.conf.bak

RUN sed -i "s|bind 127.0.0.1|#bind 127.0.0.1|g" /etc/redis.conf &&\ 
	sed -i "s|# maxmemory <bytes>|maxmemory 5mb|g" /etc/redis.conf &&\
	sed -i "s|# maxmemory-policy noeviction|maxmemory-policy allkeys-lru|g" /etc/redis.conf 

EXPOSE 6379

ENTRYPOINT ["redis-server", "--protected-mode", "no"]
