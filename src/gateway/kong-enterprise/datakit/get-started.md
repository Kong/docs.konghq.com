---
title: Get started with Datakit
badge: enterprise
alpha: true
---

## Enable the WASM engine

In `kong.conf`, set:

```
wasm = on
```

Or export the setting via an environment variable:

```sh
KONG_WASM=on
```

Reload or start {{site.base_gateway}} to apply the configuration.

## Create a service and a route

{% navtabs %}
{% navtab decK (YAML) %}

Add the following configuration to a `kong.yaml` file:

```yaml
_format_version: "3.0"
services:
- url: http://httpbin.org
  name: my-service
  routes:
  - name: my-route
    paths:
    - /
    strip_path: true
```
{% endnavtab %}
{% navtab Admin API %}

1. Create a service:
  ```bash
  curl -i -X POST http://localhost:8001/services \
    --data "name=my-service" \
    --data "url=http://httpbin.org"
  ```
  
1. Create a route:
  ```bash
  curl -i -X POST http://localhost:8001/services/my-service/routes \
    --data "name=my-route" \
    --data "paths[]=/" \
    --data "strip_path=true"
  ```

{% endnavtab %}
{% endnavtabs %}

## Enable Datakit

Let's test out Datakit by combining responses from two third party API calls, then returning directly to the client.

{% navtabs %}
{% navtab decK (YAML) %}
```yaml
plugins:
- name: datakit
  service: my-service
  config:
    debug: true
    nodes:
    - name: CAT_FACT
      type: call
      url: https://catfact.ninja/fact
    - name: DOG_FACT
      type: call
      url: https://dogapi.dog/api/v1/facts
    - name: JOIN
      type: jq
      inputs:
      - cat: CAT_FACT.body
      - dog: DOG_FACT.body
      jq: |
        {
          "cat_fact": $cat.fact,
          "dog_fact": $dog.facts[0]
        }
    - name: EXIT
      type: exit
      inputs:
      - body: JOIN
      status: 200
```

{% endnavtab %}
{% navtab Admin API %}

```sh
curl -X POST http://localhost:8001/services/my-service/plugins \
   --header "accept: application/json" \
   --header "Content-Type: application/json" \
   --data '
   {
 "name": "datakit",
 "config": {
   "debug": true,
   "nodes": [
     {
       "name": "CAT_FACT",
       "type": "call",
       "url": "https://catfact.ninja/fact"
     },
     {
       "name": "DOG_FACT",
       "type": "call",
       "url": "https://dogapi.dog/api/v1/facts"
     },
     {
       "name": "JOIN",
       "type": "jq",
       "inputs": [
         {
           "cat": "CAT_FACT.body"
         },
         {
           "dog": "DOG_FACT.body"
         }
       ],
       "jq": "{\n  \"cat_fact\": $cat.fact,\n  \"dog_fact\": $dog.facts[0]\n}\n"
     },
     {
       "name": "EXIT",
       "type": "exit",
       "inputs": [
         {
           "body": "JOIN"
         }
       ],
       "status": 200
     }
   ]
 }
}
   '
```
{% endnavtab %}
{% endnavtabs %}

## Validate

Access the service via the route `my-route` to test Datakit:

```sh
curl -i http://localhost:8000/my-route
```

You should get a `200` response with a random fact from each fact generator called in the config:

```json
HTTP/1.1 200 OK
Connection: keep-alive
Content-Length: 432
Content-Type: application/json
Date: Fri, 06 Dec 2024 18:26:48 GMT
Server: kong/3.9.0.0-enterprise-edition
Via: 1.1 kong/3.9.0.0-enterprise-edition
X-Kong-Proxy-Latency: 744
X-Kong-Request-Id: 878618103ee7137b7c2f914e107cb454
X-Kong-Upstream-Latency: 742

{
    "cat_fact": "The longest living cat on record according to the Guinness Book belongs to the late Creme Puff of Austin, Texas who lived to the ripe old age of 38 years and 3 days!",
    "dog_fact": "Greyhounds can reach a speed of up to 45 miles per hour."
}

```