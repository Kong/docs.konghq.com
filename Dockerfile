# This should mirror the jekyll version in the Gemfile
FROM jekyll/jekyll:3.8.5

RUN apk add --update autoconf automake file build-base nasm musl libpng-dev zlib-dev curl
RUN apk add --update-cache --upgrade curl

WORKDIR /srv/jekyll
COPY Makefile /srv/jekyll/Makefile

RUN make install-prerequisites

RUN chmod -R 777 /usr/lib/node_modules \
  && usermod -a -G root jekyll

EXPOSE 3000 3001

HEALTHCHECK CMD curl --fail http://localhost:5000/ || exit 1
