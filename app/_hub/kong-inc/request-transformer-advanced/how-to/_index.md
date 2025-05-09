---
nav_title: Examples of different transforms
title: Examples of different transforms
---

## Examples: Passing multiple headers in one request

### Pass each header separately

Add multiple headers by passing each header:value pair separately:

```bash
curl -X POST http://localhost:8001/services/httpbin/plugins \
  --data "name=request-transformer-advanced" \
  --data "config.add.headers[1]=h1:v1" \
  --data "config.add.headers[2]=h2:v1"
```

| Incoming Request Headers | Upstream Proxied Headers
| --------- | -----------
| h1: v1 | h1: v1, h2: v1

### Comma-separated `header:value` pairs

Add multiple headers by passing comma separated header:value pair:

```bash
curl -X POST http://localhost:8001/services/httpbin/plugins \
  --data "name=request-transformer-advanced" \
  --data "config.add.headers=h1:v1,h2:v2"
```

| Incoming Request Headers | Upstream Proxied Headers
| --------- | -----------
| h1: v1 | h1: v1, h2: v1

### Config as JSON body

Add multiple headers passing config as a JSON body:

```bash
curl -X POST http://localhost:8001/services/httpbin/plugins \
  --header 'content-type: application/json' \
  --data '{"name": "request-transformer-advanced", "config": {"add": {"headers": ["h1:v2", "h2:v1"]}}}'
```

| Incoming Request Headers | Upstream Proxied Headers
| --------- | -----------
| h1: v1 | h1: v1, h2: v1

### Multiple headers and query strings

Add multiple headers and query string parameters if not already set:

```bash
curl -X POST http://localhost:8001/services/httpbin/plugins \
  --data "name=request-transformer-advanced" \
  --data "config.add.headers=h1:v1,h2:v1" \
  --data "config.add.querystring=q1:v2,q2:v1" \
```

| Incoming Request Headers | Upstream Proxied Headers
| --------- | -----------
| h1: v1 | h1: v1, h2: v1
| h3: v1 |  h1: v1, h2: v1, h3: v1

| Incoming Request Query String | Upstream Proxied Query String
| --------- | -----------
| ?q1=v1 | ?q1=v1&q2=v1
|        | ?q1=v2&q2=v1


## Example: Adding a querystring and a header

```bash
curl -X POST http://localhost:8001/services/httpbin/plugins \
  --data "name=request-transformer-advanced" \
  --data "config.add.querystring=q1:v2,q2=v1" \
  --data "config.add.headers=h1:v1"

```

| Incoming Request Headers | Upstream Proxied Headers
| --------- | -----------
| h1: v1 | h1: v1, h2: v1
| h3: v1 | h1: v1, h2: v1, h3: v1

| Incoming Request Query String | Upstream Proxied Query String
| --------- | -----------
| ?q1=v1 | ?q1=v1&q2=v1
|        | ?q1=v2&q2=v1

## Example: Appending and removing in one request

Append multiple headers and remove a body parameter:

```bash
curl -X POST http://localhost:8001/services/httpbin/plugins \
  --data "name=request-transformer-advanced" \
  --data "config.append.headers=h1:v2,h2:v1" \
  --data "config.remove.body=p1" \
```

| Incoming Request Headers | Upstream Proxied Headers
| --------- | -----------
| h1: v1 | h1: v1, v2, h2: v1

| Incoming URL Encoded Body | Upstream Proxied URL Encoded Body
| --------- | -----------
| p1=v1&p2=v1 | p2=v1
| p2=v1 | p2=v1


## Example: Replace the relative URI 

Replace the upstream URI with a static path:

```bash
curl -X POST http://localhost:8001/services/httpbin/plugins \
 --data "name=request-transformer-advanced" \
 --data "config.replace.uri=/status/200"
```

| Service Path | Upstream Proxied URI
| --------- | -----------
| /anything | /status/200


## Example: Replace the relative URI using capturing groups

Assuming the gateway path definition of `~/(?<status>\d+)`,
replace the upstream URI based on the requested path:

```bash
curl -X POST http://localhost:8001/services/httpbin/plugins \
  --data "name=request-transformer-advanced" \
  --data "config.replace.uri=/status/\$(uri_captures['status'])"
```

| Gateway Path | Upstream Proxied URI
| --------- | -----------
| /200 | /status/200
| /301 | /status/301
