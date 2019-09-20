# This should mirror the jekyll version in the Gemfile
FROM jekyll/jekyll:3.8.6

RUN apk add --update autoconf automake file build-base nasm musl libpng-dev zlib-dev

WORKDIR /srv/jekyll
COPY Makefile /srv/jekyll
RUN make install-prerequisites

RUN chmod -R 777 /usr/lib/node_modules \
  && usermod -a -G root jekyll

EXPOSE 3000 3001
