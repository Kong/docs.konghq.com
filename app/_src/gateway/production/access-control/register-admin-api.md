---
title: Admins Examples
badge: enterprise
---

Invite and register an admin using the Admin API. Can be used for automation.

## Prerequisites

Set up the following environment variables:

```bash
export USERNAME=<username>
export EMAIL=<email>
export WORKSPACE=<workspace>
export HOST=<admin_api_host>
export TOKEN=Kong-Admin-Token:<super_admin_token>
```

For example:
```bash
export USERNAME=drogon
export EMAIL=test@test.com
export WORKSPACE=default
export HOST=127.0.0.1:8001
export ADMIN_TOKEN=Kong-Admin-Token:hunter2
```

You may benefit from HTTPie and jq.

## Invite an admin

Extract and store the token from the registration URL, either by manually creating an environment variable or by echoing and piping with `jq`:

{% navtabs %}
{% navtab Manual method example %}

1. Send a request to the registration URL

```bash
curl -i http://localhost:8001/$WORKSPACE/admins/$USERNAME?generate_register_url=true \
  -H Kong-Admin-Token:$TOKEN
```

2. Copy the response and export as an environment variable, for example:
```bash
export REGISTER_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NDUwNjc0NjUsImlkIjoiM2IyNzY3MzEtNjIxZC00ZjA3LTk3YTQtZjU1NTg0NmJkZjJjIn0.gujRDi2pX_E7u2zuhYBWD4MoPFKe3axMAq-AUcORg2g
```
{% endnavtab %}
{% navtab Programmatic method (requires jq) %}

```bash
REGISTER_TOKEN=$(curl -i -X http://localhost:8001/$WORKSPACE/admins/$USERNAME?generate_register_url=true -H Kong-Admin-Token:$TOKEN | jq .token -r)
```

{% endnavtab %}
{% endnavtabs %}

## Register the admin

```bash
curl -i -X http://localhost:8001/$WORKSPACE/admins/register \
  --data token=$REGISTER_TOKEN \
  --data username=$USERNAME \
  --data email=$EMAIL \
  --data password="<new_password>"
```
