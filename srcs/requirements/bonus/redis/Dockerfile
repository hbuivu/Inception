#Redis cache is an in-memory data store that uses key-value structures
# It is used as a caching layer on top of your regular database and data is stored in the RAM
# This speeds up response time, as it stores frequently accessed data

FROM alpine:3.18.0

RUN apk --update && \
	apk add --no-cache redis 

RUN cp /etc/redis.conf /etc/redis.conf.bak

#s stands for substitute and g stands for global
#-i = inplace editing
#allow redis to bind to all available networks
#only allow redis to use up to 2mb of memory
#noeviction = redis returns error when max memory reached / allkeys-lru = redis evicting least recently used keys
RUN sed -i "s|bind 127.0.0.1|#bind 127.0.0.1|g" /etc/redis.conf \ 
	sed -i "s|# maxmemory <bytes>|maxmemory 5mb|g" /etc/redis.conf \
	sed -i "s|# maxmemory-policy noeviction|maxmemory-policy allkeys-lru|g" /etc/redis.conf 

EXPOSE 6379

ENTRYPOINT ["redis-server", "--protected-mode", "no"]

#note: might have to adjust the wordpress config file too for redis