FROM nginx:1.13

RUN groupadd -g 1000 web \
 && useradd -g 1000 -u 1000 -d /var/www -s /bin/bash web
 
RUN touch /var/run/nginx.pid
RUN mkdir /sock

RUN apt-get update && apt-get install -y openssl mc
RUN mkdir /etc/nginx/certs 
COPY ./conf/server_crt.pem /etc/nginx/certs/
COPY ./conf/server_key.pem /etc/nginx/certs/
COPY ./conf/scandipwa-fullchain.pem /etc/nginx/certs/

RUN mkdir -p -- /var/www/.config /var/www/.selected_editor /var/www/.cache /var/www/.local \
&& chown -R web:web /var/www/.config /var/www/.selected_editor /var/www/.cache /var/www/.local /var/log/nginx
RUN chown -R web:web /etc/nginx/certs /sock /var/cache/nginx/ /var/run/nginx.pid /sock
COPY ./conf/nginx.conf /etc/nginx/
COPY ./conf/default.conf /etc/nginx/conf.d/
COPY ./conf/magento_es_auth.conf /etc/nginx/conf.d/

EXPOSE 8443

USER web:web

VOLUME /var/www

WORKDIR /var/www/html
