FROM  alpine:3.18.0

RUN apk add --no-cache \
	php \
	php-fpm \
	php-mysqli \
	php-json \
	php-session \
	php-mbstring \
	php-xml \
	php-gd \
	php-zip \ 
	phpmyadmin

RUN sed -i "s|$cfg['Servers'][$i]['host'] = 'localhost';|$cfg['Servers'][$i]['host'] = 'mariadb';|g" /etc/phpmyadmin/config.inc.php

RUN sed -i "s|listen = 127.0.0.1:9000|listen = 8081|g" /etc/php81/php-fpm.d/www.conf

ENV PMA_HOST=mariadb PMA_USER=hbui-vu PMA_PASSWORD=hbui-vu

EXPOSE 8081

CMD ["php-fpm81", "-F"]
# 	php7-common php7-iconv php7-json php7-gd php7-curl php7-xml \
# 	php7-mysqli php7-imap php7-cgi fcgi php7-pdo php7-pdo_mysql php7-soap php7-xmlrpc \
# 	php7-posix php7-mcrypt php7-gettext php7-ldap php7-ctype php7-dom php7 php7-fpm php7-opcache php7-session curl

#    php7-opcache php7-gd php7-zlib php7-curl php7-phar 


# RUN curl -O https://files.phpmyadmin.net/phpMyAdmin/5.1.3/phpMyAdmin-5.1.3-all-languages.tar.xz \
# && tar -xf phpMyAdmin-5.1.3-all-languages.tar.xz --directory=/
# RUN rm -rf phpMyAdmin-5.1.3-all-languages.tar.xz

# RUN mv phpMyAdmin-5.1.3-all-languages/* /


# COPY config.inc.php .
# CMD php -S 0.0.0.0:8081