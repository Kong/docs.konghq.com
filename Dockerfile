FROM jekyll/jekyll:3.1.0

WORKDIR /srv/jekyll

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
