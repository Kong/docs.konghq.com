---
title: Use Plugins With Containers
content-type: reference
---

## Use external plugins in container and Kubernetes

To use plugins requiring external plugin servers, both the plugin servers and the plugins themselves need to be installed inside the {{ site.base_gateway }} container, copy or mount the plugin's source code into the {{ site.base_gateway }} container.

{:.note}
> **Note:** Official {{ site.base_gateway }} images are configured to run as the `nobody` user. When building a custom image, to copy files into
the {{ site.base_gateway }} image, you must temporarily set the user to `root`.

This is an example Dockerfile that explains how to mount your plugin in the {{ site.base_gateway }} image:

```dockerfile
FROM kong
USER root
# Example for GO:
COPY your-go-plugin /usr/local/bin/your-go-plugin
# Example for JavaScript:
RUN apk update && apk add nodejs npm && npm install -g kong-pdk
COPY you-js-plugin /path/to/your/js-plugins/you-js-plugin
# Example for Python
# PYTHONWARNINGS=ignore is needed to build gevent on Python 3.9
RUN apk update && \
    apk add python3 py3-pip python3-dev musl-dev libffi-dev gcc g++ file make && \
    PYTHONWARNINGS=ignore pip3 install kong-pdk
COPY you-py-plugin /path/to/your/py-plugins/you-py-plugin
# reset back the defaults
USER kong
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 8000 8443 8001 8444
STOPSIGNAL SIGQUIT
HEALTHCHECK --interval=10s --timeout=10s --retries=10 CMD kong health
CMD ["kong", "docker-start"]
```

## More information

* [Develop plugins with Python](/gateway/latest/plugin-development/other/python)
* [Develop plugins with Go](/gateway/latest/plugin-development/other/go)
* [Develop plugins with JavaScript](/gateway/latest/plugin-development/other/javascript)