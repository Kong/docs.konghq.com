FROM jekyll/jekyll:3.1.0

WORKDIR /srv/jekyll

RUN apk add --update autoconf automake file build-base nasm musl libpng-dev zlib-dev

COPY entrypoint.sh /entrypoint.sh

RUN npm install -g yarn && npm install -g gulp

RUN chmod -R 777 /usr/lib/node_modules \
  && chmod 777 /entrypoint.sh \
  && usermod -a -G root jekyll

ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 3000 3001
