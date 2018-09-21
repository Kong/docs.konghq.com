FROM jekyll/jekyll:3.1.0

WORKDIR /srv/jekyll

RUN apk update && apk upgrade && apk add \
  libstdc++ \
  libjpeg-turbo \
  libpng \
  build-base \
  libjpeg-turbo-dev \
  libpng-dev \
  libcurl \
  nasm \
  autoconf \
  libtool \
  pkgconfig \
  automake

RUN npm install -g gulp

ENTRYPOINT ["/bin/bash", "-c"]
CMD ["make run"]
