FROM alpine:3.16
LABEL maintainer="jeff@moresbymedia.com"

RUN set -x \
	&& adduser -u 82 -D -S -G www-data www-data

RUN apk --update add apache2 php8  php8-apache2 php8-ctype php8-openssl \
        php8-curl php8-pecl-apcu php8-opcache php8-bcmath php8-simplexml php8-xml \
        php8-intl php8-iconv php8-mbstring php8-session php8-common \
        bash

ENV HTTPD_PREFIX /var/src/html
RUN mkdir -p "$HTTPD_PREFIX" \
	&& chown www-data:www-data "$HTTPD_PREFIX"

COPY conf/php.ini /etc/php8/php.ini
COPY conf/httpd.conf /etc/apache2/httpd.conf
COPY index.php /var/src/html
ADD run-http.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run-http.sh

EXPOSE 80
CMD ["run-http.sh"]
