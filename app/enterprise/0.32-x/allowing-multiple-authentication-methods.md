---
title: Allowing multiple authentication methods
---
# Introduction

The default behavior for Kong authentication plugins is to require credentials for all requests without regard for whether a request has been authenticated via some other plugin. Configuring an anonymous consumer on your authentication plugins allows you to offer clients multiple options for authentication.

To begin, [create an API](/latest/getting-started/adding-your-api/) and then create three consumers:

```bash
$ curl -sX POST kong-admin:8001/consumers \
    -H "Content-Type: application/json" \
    --data '{"username": "anonymous"}'

{"created_at":1517528237000,"username":"anonymous","id":"d955c0cb-1a6e-4152-9440-414ebb8fee8a"}

$ curl -sX POST kong-admin:8001/consumers \
    -H "Content-Type: application/json" \
    --data '{"username": "medvezhonok"}'

{"created_at":1517528259000,"username":"medvezhonok","id":"b3c95318-a932-4bb2-9d74-1298a3ffc87c"}

$ curl -sX POST kong-admin:8001/consumers \
    -H "Content-Type: application/json" \
    --data '{"username": "ezhik"}'

{"created_at":1517528266000,"username":"ezhik","id":"47e74a17-dc08-4786-a8cf-d8e4f38a5459"}
```

The `anonymous` consumer does not correspond to any real user, and will only serve as a fallback.

Next, we add both Key Auth and Basic Auth plugins to our consumer, and set the anonymous fallback to the consumer we created earlier.

```bash
$ curl -sX POST kong-admin:8001/apis/example-api/plugins/ \
    -H "Content-Type: application/json" \
    --data '{"name": "key-auth", "config": { "hide_credentials": true, "anonymous": "d955c0cb-1a6e-4152-9440-414ebb8fee8a"} }'

{"created_at":1517528304000,"config":{"key_in_body":false,"hide_credentials":true,"anonymous":"d955c0cb-1a6e-4152-9440-414ebb8fee8a","run_on_preflight":true,"key_names":["apikey"]},"id":"bb884f7b-4e48-4166-8c80-c858b5a4c357","name":"key-auth","api_id":"a2a168a8-4491-4fe1-9426-cde3b5fcd45b","enabled":true}

$ curl -sX POST kong-admin:8001/apis/example-api/plugins/ \
    -H "Content-Type: application/json" \
    --data '{"name": "basic-auth", "config": { "hide_credentials": true, "anonymous": "d955c0cb-1a6e-4152-9440-414ebb8fee8a"} }' 

{"created_at":1517528499000,"config":{"hide_credentials":true,"anonymous":"d955c0cb-1a6e-4152-9440-414ebb8fee8a"},"id":"e5a40543-debe-4225-a879-a54901368e6d","name":"basic-auth","api_id":"a2a168a8-4491-4fe1-9426-cde3b5fcd45b","enabled":true}
```

If using [OpenID Connect](/enterprise/latest/plugins/openid-connect), you must also set `config.consumer_claim` along with `anonymous`, as setting `anonymous` alone will not map that consumer.

At this point unauthenticated requests and requests with invalid credentials are still allowed. The anonymous consumer is allowed, and will be applied to any request that does not pass a set of credentials associated with some other consumer.

```bash
$ curl -s example.com:8000/user-agent

{"user-agent": "curl/7.58.0"}

$ curl -s example.com:8000/user-agent?apikey=nonsense

{"user-agent": "curl/7.58.0"}
```

We'll now add a Key Auth credential for one consumer, and a Basic Auth credential for another.

```bash
$ curl -sX POST kong-admin:8001/consumers/medvezhonok/basic-auth \
    -H "Content-Type: application/json" \
    --data '{"username": "medvezhonok", "password": "hunter2"}'

{"created_at":1517528647000,"id":"bb350b87-f0d2-4605-b997-e28a116d8b6d","username":"medvezhonok","password":"f239a0404351d7170201e7f92fa9b3159e47bb01","consumer_id":"b3c95318-a932-4bb2-9d74-1298a3ffc87c"}

$ curl -sX POST kong-admin:8001/consumers/ezhik/key-auth \
    -H "Content-Type: application/json" \
    --data '{"key": "hunter3"}'

{"id":"06412d6e-8d41-47f7-a911-3c821ec98f1b","created_at":1517528730000,"key":"hunter3","consumer_id":"47e74a17-dc08-4786-a8cf-d8e4f38a5459"}

```

Lastly, we add a Request Terminator to the anonymous consumer.

```bash
$ curl -sX POST kong-admin:8001/consumers/d955c0cb-1a6e-4152-9440-414ebb8fee8a/plugins/ \
    -H "Content-Type: application/json" \
    --data '{"name": "request-termination", "config": { "status_code": 401, "content_type": "application/json; charset=utf-8", "body": "{\"error\": \"Authentication required\"}"} }'

{"created_at":1517528791000,"config":{"status_code":401,"content_type":"application\/json; charset=utf-8","body":"{\"error\": \"Authentication required\"}"},"id":"21fc5f6f-363f-4d79-b533-ce26d4478879","name":"request-termination","enabled":true,"consumer_id":"d955c0cb-1a6e-4152-9440-414ebb8fee8a"}
```

Requests with missing or invalid credentials are now rejected, whereas authorized requests using either authentication method are allowed.

```bash
$ curl -s example.com:8000/user-agent?apikey=nonsense

{"error": "Authentication required"}

$ curl -s example.com:8000/user-agent

{"error": "Authentication required"}

$ curl -s example.com:8000/user-agent?apikey=hunter3

{"user-agent": "curl/7.58.0"}

$ curl -s example.com:8000/user-agent -u medvezhonok:hunter2

{"user-agent": "curl/7.58.0"}
```
