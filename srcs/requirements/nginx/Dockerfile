# FROM nginx:alpine-3.19.0
# FROM nginx:latest
FROM alpine:3.18.0
RUN apk update && apk add --no-cache nginx openssl

#nginx SSL
#openssl req - use req command to create and process certificate commands
#x509 - output a self signed certificate instead of CSR (certificate signing request which contains info to be used to generate an SSL/TLS certificate by certificate authority (CA))
#sha256 - secure hash algorithm - commonly used to create and verify digital certificates (standard)
#nodes - don't encrypt private keys, don't have manually enter password each time key is accessed, easier testing, faster
#newkey rsa:2048 - create new rsa private key; 4096 more secure, but older systems may have some performance issues and takes longer to generate
#days 365 - certificate valid for 365 days
#subj - subject information for certificate
#keyout - output file for private key - key is used to decrypt data, server will use the key during ssl/tls handshake to decrypt pre-master secret sent by client. 
	#secret is used to generate session keys to encrypt actual data transmission
	#also used to create digital signature on certificate to prove server is owner of certificate
#out - specify output file for self signed certificate - public document that contains info about server's identity (domain name, etc)
	#.crt, .cert, and .pem (catchall that can contain key, certificate, etc)
	#contains public key that clients will use to encrypt data being sent to server
	#During the SSL/TLS handshake, the server sends the certificate to the client. The client uses the public key in the certificate to encrypt the pre-master secret and to verify the server's identity.
	#Encryption/Decryption: The public key in the certificate is used by clients to encrypt data, which only the corresponding private key can decrypt. This ensures that only the intended server can read the encrypted data.
	#Authentication: The server uses the private key to sign data, and the client uses the public key in the certificate to verify the signature. This helps confirm the server's identity.
RUN mkdir -p /etc/nginx/ssl/private /etc/nginx/ssl/certs
RUN openssl req -x509 -sha256 -nodes \
	-newkey rsa:2048 \
	-days 365 \
	-subj "/C=AE/ST=AbuDhabi/L=AbuDhabi/O=42AbuDhabi/OU=Inception/CN=hbui-vu" \
	-keyout /etc/nginx/ssl/private/nginx.key \
	-out /etc/nginx/ssl/certs/nginx.cert

#copy over configure file
COPY default.conf /etc/nginx/http.d/default.conf
# COPY . /usr/share/nginx

#this is the port that the app will be listening on
#exposed port are exposed to other containers, and indicates which ports are intended to be used by the application inside the container. They are not accessible outside Docker host by default
#published ports (mapped ports) make the container's port accessible outside of docker. Docker creates mapping bewteen a port on the docker host and and a port ont h container. PUblished ports override any expose instructions in Dockerfile
EXPOSE 443

#this will run nginx -g daemon off in command line
#-g passes config directive (daemon off) to nginx. 
ENTRYPOINT ["nginx", "-g", "daemon off;"]

