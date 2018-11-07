FROM jekyll/builder:3.1.0

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

COPY . /tmp/jekyll

RUN cd /tmp/jekyll \
  && npm install -g gulp \
  && npm install -f \
	&& bundle install \
	&& chmod -R 777 /usr/local/bundle/

CMD ["make", "run"]
