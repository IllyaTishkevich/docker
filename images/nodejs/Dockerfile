FROM node:13

RUN apt-get update && apt-get install -y \
  apt-utils \
  cron \
  python \
  git \
  gzip \
  libfreetype6-dev \
  libicu-dev \
  libjpeg62-turbo-dev \
  libmcrypt-dev \
  libpng-dev \
  libxslt1-dev \
  lsof \
  gcc \
  g++ \
  vim \
  nmap \
  zip \
  screen \
  mc

WORKDIR /home/node/pwa

RUN apt-get install -y gnupg \
  && mkdir /home/node/pwa/deity /home/node/pwa/pwa-studio /home/node/.config /home/node/.npm /home/node/.cache /home/node/.local /home/node/.composer /home/node/.selected_editor /home/node/falcon-data \
  && chown node:node /home/node/ /home/node/pwa /home/node/pwa/pwa-studio /home/node/pwa/deity /home/node/.config /home/node/.npm /home/node/.cache /home/node/.local /home/node/.composer /home/node/.selected_editor /home/node/falcon-data

COPY bin/.screenrc /home/node/.screenrc

# copy deity falcon files
COPY bin/falcon-pwa-installer.sh /home/node/falcon-pwa-installer.sh
COPY bin/falcon-server-config.json /home/node/falcon-data/server-config.json
COPY bin/falcon-client-config.json /home/node/falcon-data/client-config.json

# copy PWA Studio files
COPY bin/studio-build.sh /home/node/studio-build.sh
COPY bin/studio-run-all.sh /home/node/studio-run-all.sh
COPY bin/studio-run-venia.sh /home/node/studio-run-venia.sh
COPY bin/studio-install.sh /home/node/studio-install.sh

# copy ScandiPWA files
COPY bin/scandipwa-theme-installer.sh /home/node/scandipwa-theme-installer.sh
COPY bin/start.sh /home/node/start.sh
COPY bin/start-core.sh /home/node/start-core.sh

RUN ["chmod", "+x", "/home/node/start.sh"]
RUN ["chmod", "+x", "/home/node/start-core.sh"]
RUN ["chmod", "+x", "/home/node/scandipwa-theme-installer.sh"]
RUN ["chmod", "+x", "/home/node/falcon-pwa-installer.sh"]
RUN ["chmod", "+x", "/home/node/studio-install.sh"]
RUN ["chmod", "+x", "/home/node/studio-build.sh"]
RUN ["chmod", "+x", "/home/node/studio-run-all.sh"]
RUN ["chmod", "+x", "/home/node/studio-run-venia.sh"]

RUN mkdir /sock
RUN chown -R node:node /sock /home/node

USER node:node

VOLUME /var/www

EXPOSE 35725 3000 4000 3001 3003


