FROM ubuntu:latest

RUN groupadd -g 1000 web \
 && useradd -g 1000 -u 1000 -d /var/www -s /bin/bash web
 
RUN touch /var/run/nginx.pid
RUN mkdir /sock
RUN mkdir /home/build
RUN apt-get update && apt-get install -y openssl mc build-essential zlib1g-dev libpcre3 libpcre3-dev unzip uuid-dev wget
COPY ./bin/install.sh /home/build/install.sh

RUN chmod +x /home/build/install.sh \
&& /home/build/install.sh
RUN mkdir /etc/nginx/certs \
  && echo -e "\n\n\n\n\n\n\n" | openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/certs/nginx.key -out /etc/nginx/certs/nginx.crt
RUN mkdir -p -- /var/www/.config /var/www/.selected_editor /var/www/.cache /var/www/.local /var/lib/nginx/body /var/lib/nginx/proxy /var/lib/nginx/fastcgi /var/lib/nginx/uwsgi /var/lib/nginx/scgi /var/cache/pagespeed \
&& chown -R web:web /var/www/.config /var/www/.selected_editor /var/www/.cache /var/www/.local /var/log/nginx
RUN chown -R web:web /etc/nginx/certs /var/run/nginx.pid /sock /var/lib/nginx/body /var/lib/nginx/proxy /var/lib/nginx/fastcgi /var/lib/nginx/uwsgi /var/lib/nginx/scgi /var/cache/pagespeed


COPY ./conf/nginx.conf /etc/nginx/
COPY ./conf/default.magento1.conf /etc/nginx/conf.d/default.conf

EXPOSE 8443

USER web:web

VOLUME /var/www
USER web:web

VOLUME /var/www
CMD ["/usr/sbin/nginx", "-g", "daemon off;"]
WORKDIR /var/www/html
