FROM alpine:3.19
LABEL maintainer="jeff@moresbymedia.com"

RUN set -x \
	&& adduser -u 82 -D -S -G www-data www-data

RUN apk --update add apache2 php83  php83-apache2 php83-ctype php83-openssl \
        php83-curl php83-pecl-apcu php83-opcache php83-bcmath php83-simplexml php83-xml \
        php83-intl php83-iconv php83-mbstring php83-session php83-common \
        bash util-linux-misc && \
        ln -s /usr/bin/php83 /usr/bin/php

ENV HTTPD_PREFIX /var/src/html
RUN mkdir -p "$HTTPD_PREFIX" \
	&& chown www-data:www-data "$HTTPD_PREFIX"

COPY conf/php.ini /etc/php83/php.ini
COPY conf/httpd.conf /etc/apache2/httpd.conf
COPY index.php /var/src/html
ADD run-http.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run-http.sh

EXPOSE 80
CMD ["run-http.sh"]
