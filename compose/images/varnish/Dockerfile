FROM ubuntu:16.04
RUN apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt install -y mc varnish curl
ADD bin/start.sh /start.sh
ENV CACHE_SIZE      64m
ENV VARNISH_PORT 80
EXPOSE 80
ENV VCL_CONFIG /data/varnish.vcl
ENV VARNISHD_PARAMS -p default_ttl=3600 -p default_grace=3600 -p feature=+esi_ignore_https -p feature=+esi_disable_xml_check -a 0.0.0.0:80

ADD etc/varnish.vcl /data/varnish.vcl
CMD /bin/bash /start.sh
