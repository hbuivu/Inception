# The cadvisor binary you're downloading from GitHub is probably built against glibc, the GNU C Library, which is the standard C library used by Debian-based systems. Alpine Linux, however, uses musl, a different C library that is not binary-compatible with glibc.
# FROM alpine:3.18.0

# RUN apk add --no-cache \
# 	lm-sensors \
# 	python3 \
# 	python3-dev \
# 	linux-headers \
# 	libc-dev \
# 	gcc \
# 	git \
# 	curl \
# 	go

# # RUN mkdir /opt/cadvisor

# WORKDIR /usr/local/bin

# RUN wget https://github.com/google/cadvisor/releases/download/v0.39.0/cadvisor && \
# 	chmod +x cadvisor

# # RUN cd cadvisor && \
# # 	go build .

# EXPOSE 8000

# # ENTRYPOINT ["./usr/bin/cadvisor"]	
# CMD ["cadvisor"]

# # Base image
# FROM 		debian:bullseye

# # Update and upgrade system & install wget
# RUN 		apt -y update && apt -y upgrade
# RUN 		apt -y install wget 

# # Change working directory
# WORKDIR		/usr/local/bin

# # Download and install cAdvisor
# RUN 		wget https://github.com/google/cadvisor/releases/download/v0.39.0/cadvisor
# RUN 		chmod +x cadvisor

# # Execute cAdvisor
# # ENTRYPOINT	[ "cadvisor" ]
# CMD ["cadvisor"]

# Stage 1: Build cadvisor in a Debian-based image
FROM debian:bullseye AS builder
RUN apt -y update && apt -y upgrade
RUN apt -y install wget
WORKDIR /usr/local/bin
RUN wget https://github.com/google/cadvisor/releases/download/v0.39.0/cadvisor
RUN chmod +x cadvisor

# Stage 2: Copy cadvisor binary to Alpine image
FROM alpine:3.18.0
RUN apk add --no-cache lm-sensors python3 python3-dev linux-headers libc-dev gcc git curl go
COPY --from=builder /usr/local/bin/cadvisor /usr/local/bin/cadvisor
EXPOSE 8000
CMD ["cadvisor"]