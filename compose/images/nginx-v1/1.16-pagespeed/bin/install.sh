#!/usr/bin/env bash
PS_NGX_EXTRA_FLAGS="--user=web --group=web--prefix=/usr/share/nginx --sbin-path=/usr/sbin/nginx \
--modules-path=/usr/lib/nginx/modules --conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --pid-path=/var/run/nginx.pid \
--lock-path=/var/lock/nginx.lock \
--http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
--http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi \
--http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-openssl=../openssl-1.1.1c --with-openssl-opt=enable-ec_nistp_64_gcc_128 \
--with-openssl-opt=no-nextprotoneg --with-openssl-opt=no-weak-ssl-ciphers --with-openssl-opt=no-ssl3 \
--with-pcre=../pcre-8.43 --with-pcre-jit --with-zlib=../zlib-1.2.11 --with-compat --with-file-aio --with-threads \
--with-http_addition_module --with-http_auth_request_module --with-http_dav_module --with-http_flv_module \
--with-http_gunzip_module --with-http_gzip_static_module --with-http_mp4_module --with-http_random_index_module \
--with-http_realip_module --with-http_slice_module --with-http_ssl_module --with-http_sub_module \
--with-http_stub_status_module --with-http_v2_module --with-http_secure_link_module --with-mail --with-mail_ssl_module \
--with-stream --with-stream_realip_module --with-stream_ssl_module --with-stream_ssl_preread_module --with-debug"
#mkdir /home/build
cd /home/build/
# PCRE version 4.4 - 8.40
wget https://ftp.pcre.org/pub/pcre/pcre-8.43.tar.gz && tar xzvf pcre-8.43.tar.gz
# zlib version 1.1.3 - 1.2.11
wget http://www.zlib.net/zlib-1.2.11.tar.gz && tar xzvf zlib-1.2.11.tar.gz
# OpenSSL version 1.0.2 - 1.1.0
wget https://www.openssl.org/source/openssl-1.1.1c.tar.gz && tar xzvf openssl-1.1.1c.tar.gz
#[check the release notes for the latest version]
NPS_VERSION=1.13.35.2-stable
wget https://github.com/apache/incubator-pagespeed-ngx/archive/v${NPS_VERSION}.zip
unzip v${NPS_VERSION}.zip
nps_dir=$(find . -name "*pagespeed-ngx-${NPS_VERSION}" -type d)
cd "$nps_dir"
NPS_RELEASE_NUMBER=${NPS_VERSION/beta/}
NPS_RELEASE_NUMBER=${NPS_VERSION/stable/}
psol_url=https://dl.google.com/dl/page-speed/psol/${NPS_RELEASE_NUMBER}.tar.gz
[ -e scripts/format_binary_url.sh ]
psol_url=$(scripts/format_binary_url.sh PSOL_BINARY_URL)
wget ${psol_url}
tar -xzvf $(basename ${psol_url})  # extracts to psol/
NGINX_VERSION=1.16.0
cd /home/build/
wget http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
tar -xvzf nginx-${NGINX_VERSION}.tar.gz
cd nginx-${NGINX_VERSION}/
bash configure --add-dynamic-module=/home/build/$nps_dir ${PS_NGX_EXTRA_FLAGS}
make
make install
#cp /usr/local/nginx/modules/ngx_pagespeed.so /usr/lib/nginx/modules/