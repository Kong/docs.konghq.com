---
nav_title: Configure the plugin with Redis
title: Configure the plugin with Redis
---

## Configure the plugin with Redis

Here's a sample declarative configuration with `redis` as storage:

```yaml
_format_version: "3.0"
# this section is not necessary if there's already a route that matches
# /.well-known/acme-challenge path with http protocol
services:
  - name: acme-dummy
    url: http://127.0.0.1:65535
    routes:
      - name: acme-dummy
        protocols:
          - name: http
        paths:
          - /.well-known/acme-challenge
plugins:
  - name: acme
    config:
      account_email: example@myexample.com
      account_key:
        key_id: "1234"
        key_set: "example-key-set"
      domains:
        - "*.example.com"
        - "example.com"
      tos_accepted: true
      storage: redis
      storage_config:
        redis:
          host: redis.service
          port: 6379
```

{% if_plugin_version gte:3.3.x %}

Here is another example that uses a `key_id` and `key_set` to configure the `account_key`:

```yaml
_format_version: "3.0"
# this section is not necessary if there's already a route that matches
# /.well-known/acme-challenge path with http protocol
key_sets:
  name: example-key-set
keys:
  example-key:
    set: example-key-set
    pem:
      private_key: {vault://env/example-private-key}
services:
  - name: acme-dummy
    url: http://127.0.0.1:65535
    routes:
      - name: acme-dummy
        protocols:
          - name: http
        paths:
          - /.well-known/acme-challenge
plugins:
  - name: acme
    config:
      account_email: example@myexample.com
      account_key:
        key_id: example-key
        key_set: example-key-set
      domains:
        - "*.example.com"
        - "example.com"
      tos_accepted: true
      storage: redis
      storage_config:
        redis:
          host: redis.service
          port: 6379
```

{% endif_plugin_version %}
