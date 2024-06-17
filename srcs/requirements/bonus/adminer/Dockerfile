#ADminer is a free and open-source tool for managing the contents of databases
#comes as a single, lightweight PHP file
#offers a simple, web-based interface

FROM alpine:3.18.0

RUN apk update && \
	apk add --no-cache adminer
	# apk add --no-cache wget apache2 php7 php7-apache2 php7-mysqli

EXPOSE 8080

RUN chown -R www-data:www-data /var/www/html/adminer.php &&\
	chmod 755 /var/www/html/adminer.php

WORKDIR /var/www/html

ENTRYPOINT ["php", "-S", "0.0.0.0:80"]

# RUN mkdir -p /var/www/html

# RUN wget "https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php" -O /var/www/html/adminer.php &&\ 
# 	chown -R www-data:www-data /var/www/html/adminer.php &&\ 
# 	chmod 755 /var/www/html/adminer.php

# EXPOSE 3306

# ENTRYPOINT ["php", "-S", "0.0.0.0:80"]





