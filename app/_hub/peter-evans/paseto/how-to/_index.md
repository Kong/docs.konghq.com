## Installation

### Sodium Crypto Library

This plugin uses the [PASETO for Lua](https://github.com/peter-evans/paseto-lua){:target="_blank"}{:rel="noopener noreferrer"} library, which in turn depends on the [Sodium crypto library (libsodium)](https://github.com/jedisct1/libsodium){:target="_blank"}{:rel="noopener noreferrer"}.
The following is a convenient way to install libsodium via LuaRocks.
Alternatively, see [libsodium's documentation](https://download.libsodium.org/doc/installation/){:target="_blank"}{:rel="noopener noreferrer"} for full installation instructions.

```
luarocks install libsodium
```

Note: The Sodium Crypto Library must be installed on each node in your Kong cluster.

### PASETO Kong Plugin
Install the plugin on each node in your Kong cluster via luarocks:

```
luarocks install kong-plugin-paseto
```

Add to the custom_plugins list in your Kong configuration (on each Kong node):

```
custom_plugins = paseto
```

## Usage

In order to use the plugin, you first need to create a Consumer and associate one or more PASETO credentials (holding the public key used to verify the token) to it. The Consumer represents a developer using the final service.

### Create a Consumer

You need to associate a credential to an existing Consumer object. To create a Consumer, you can execute the following request:

```bash
$ curl -X POST http://kong:8001/consumers \
    --data "username=<USERNAME>" \
    --data "custom_id=<CUSTOM_ID>"
HTTP/1.1 201 Created
```

Parameter | Default | Description
---: | :--- | :---
`username` | semi-optional | The username for this Consumer. Either this field or `custom_id` must be specified.
`custom_id` | semi-optional | A custom identifier used to map the Consumer to an external database. Either this field or `username` must be specified.

A Consumer can have many PASETO credentials.

### Create a PASETO credential

You can provision a new PASETO credential by issuing the following HTTP request:

```bash
$ curl -X POST http://kong:8001/consumers/{consumer}/paseto -H "Content-Type: application/x-www-form-urlencoded"
HTTP/1.1 201 Created

{
   "consumer_id": "94c058d0-f5f1-4afc-ab18-eab487492a03",
   "created_at": 1530751342000,
   "id": "f99c0041-6271-43d3-bebd-32479c2746b6",
   "kid": "ikypl5x7QEKShEoEzFxfz5axONlgjdza",
   "public_key": "8SQDqtA5yx4atQEg0uH3Rit3nLq+EAQF4A1Zkvwh5TU=",
   "secret_key": "hbJbxFK3xFL1YlrcqodKqt0FvVyZjmPXQqOIexzxsVbxJAOq0DnLHhq1ASDS4fdGK3ecur4QBAXgDVmS/CHlNQ=="
}
```

- `consumer`: The `id` or `username` property of the Consumer entity to associate the credentials to.

Parameter |  Default | Description
---: | :--- | :---
`kid` | optional | A unique string identifying the credential. If left out, it will be auto-generated.
`secret_key` | optional |  The 64 byte secret key base64 encoded.
`public_key` | optional |  The 32 byte public key base64 encoded. If left out and a `secret_key` is supplied, the `public_key` is assumed to be the last 32 bytes of the `secret_key`.

If neither `secret_key` or `public_key` are supplied the plugin will generate a new key pair.

### Delete a PASETO credential

You can remove a Consumer's PASETO credential by issuing the following HTTP
request:

```bash
$ curl -X DELETE http://kong:8001/consumers/{consumer}/paseto/{id}
HTTP/1.1 204 No Content
```

- `consumer`: The `id` or `username` property of the Consumer entity to associate the credentials to.
- `id`: The `id` of the PASETO credential.

### List PASETO credentials

You can list a Consumer's PASETO credentials by issuing the following HTTP
request:

```bash
$ curl -X GET http://kong:8001/consumers/{consumer}/paseto
HTTP/1.1 200 OK
```

- `consumer`: The `id` or `username` property of the Consumer entity to list credentials for.

```json
{
    "data": [
        {
           "consumer_id": "94c058d0-f5f1-4afc-ab18-eab487492a03",
           "created_at": 1530751342000,
           "id": "f99c0041-6271-43d3-bebd-32479c2746b6",
           "kid": "ikypl5x7QEKShEoEzFxfz5axONlgjdza",
           "public_key": "8SQDqtA5yx4atQEg0uH3Rit3nLq+EAQF4A1Zkvwh5TU=",
           "secret_key": "hbJbxFK3xFL1YlrcqodKqt0FvVyZjmPXQqOIexzxsVbxJAOq0DnLHhq1ASDS4fdGK3ecur4QBAXgDVmS/CHlNQ=="
        }
    ],
    "total": 1
}
```

### Send a request with a PASETO

PASETOs can now be included in a request to Kong by adding it to the `Authorization` header:

```bash
$ curl http://kong:8000/{route path} \
    -H 'Authorization: Bearer v2.public.eyJuYmYiOiIyMDE4LTAxLTAxVDAwOjAwOjAwKzAwOjAwIiwiaWF0IjoiMjAxOC0wMS0wMVQwMDowMDowMCswMDowMCIsImlzcyI6InBhcmFnb25pZS5jb20iLCJhdWQiOiJzb21lLWF1ZGllbmNlLmNvbSIsImRhdGEiOiJ0aGlzIGlzIGEgc2lnbmVkIG1lc3NhZ2UiLCJleHAiOiIyMDk5LTAxLTAxVDAwOjAwOjAwKzAwOjAwIiwianRpIjoiODdJRlNHRmdQTnRRTk51dzBBdHVMdHRQIiwic3ViIjoidGVzdCIsIm15Y2xhaW0iOiJyZXF1aXJlZCB2YWx1ZSJ9-8bFBx9Z5665JK3Rfwl3v2rx-etZ0H-EAkmbOdt1VI4h3gDzMsqUR2pRRdBvzPiv5cPDQqmaJ1gcqnXR3P0BDQ.eyJraWQiOiJzaWduYXR1cmVfdmVyaWZpY2F0aW9uX3N1Y2Nlc3MifQ'
```

as a querystring parameter, if configured in `config.uri_param_names` (which contains `paseto` by default):

```bash
$ curl http://kong:8000/{route path}?paseto=v2.public.eyJuYmYiOiIyMDE4LTAxLTAxVDAwOjAwOjAwKzAwOjAwIiwiaWF0IjoiMjAxOC0wMS0wMVQwMDowMDowMCswMDowMCIsImlzcyI6InBhcmFnb25pZS5jb20iLCJhdWQiOiJzb21lLWF1ZGllbmNlLmNvbSIsImRhdGEiOiJ0aGlzIGlzIGEgc2lnbmVkIG1lc3NhZ2UiLCJleHAiOiIyMDk5LTAxLTAxVDAwOjAwOjAwKzAwOjAwIiwianRpIjoiODdJRlNHRmdQTnRRTk51dzBBdHVMdHRQIiwic3ViIjoidGVzdCIsIm15Y2xhaW0iOiJyZXF1aXJlZCB2YWx1ZSJ9-8bFBx9Z5665JK3Rfwl3v2rx-etZ0H-EAkmbOdt1VI4h3gDzMsqUR2pRRdBvzPiv5cPDQqmaJ1gcqnXR3P0BDQ.eyJraWQiOiJzaWduYXR1cmVfdmVyaWZpY2F0aW9uX3N1Y2Nlc3MifQ
```

or as cookie, if the name is configured in `config.cookie_names` (which is not enabled by default):

```bash
curl --cookie paseto=v2.public.eyJuYmYiOiIyMDE4LTAxLTAxVDAwOjAwOjAwKzAwOjAwIiwiaWF0IjoiMjAxOC0wMS0wMVQwMDowMDowMCswMDowMCIsImlzcyI6InBhcmFnb25pZS5jb20iLCJhdWQiOiJzb21lLWF1ZGllbmNlLmNvbSIsImRhdGEiOiJ0aGlzIGlzIGEgc2lnbmVkIG1lc3NhZ2UiLCJleHAiOiIyMDk5LTAxLTAxVDAwOjAwOjAwKzAwOjAwIiwianRpIjoiODdJRlNHRmdQTnRRTk51dzBBdHVMdHRQIiwic3ViIjoidGVzdCIsIm15Y2xhaW0iOiJyZXF1aXJlZCB2YWx1ZSJ9-8bFBx9Z5665JK3Rfwl3v2rx-etZ0H-EAkmbOdt1VI4h3gDzMsqUR2pRRdBvzPiv5cPDQqmaJ1gcqnXR3P0BDQ.eyJraWQiOiJzaWduYXR1cmVfdmVyaWZpY2F0aW9uX3N1Y2Nlc3MifQ http://kong:8000/{route path}
```

Note: When the PASETO is valid and proxied to the upstream service, Kong makes no modification to the request other than adding headers identifying the Consumer. The PASETO will be forwarded to your upstream service, which can assume its validity. It is now the role of your service to base64 decode the PASETO claims and make use of them.
