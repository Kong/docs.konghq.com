FROM jekyll/jekyll:3.1.0

WORKDIR /srv/jekyll

RUN apk add --update autoconf automake file build-base nasm musl libpng-dev zlib-dev

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
