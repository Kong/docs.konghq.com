---
nav_title: Overview
---

The ACME plugin allows {{site.base_gateway}} to apply certificates from Let's Encrypt 
or any other ACMEv2 service and serve them dynamically.
Renewal is handled with a configurable threshold time.

{:.note}
> **Notes**: 
> * The plugin only supports the http-01 challenge, meaning a user needs a public
IP and a resolvable DNS. Kong also needs to accept proxy traffic from port `80`.
> * A wildcard or star (`*`) certificate is not supported. Each domain must have its
own certificate.

## Supported storage types

You can set the backend storage for the plugin using the [`config.storage`](/hub/kong-inc/acme/configuration/#config-storage) parameter.
The backend storage available depends on the [topology](/gateway/latest/production/deployment-topologies/) of your {{site.base_gateway}} environment: 

Storage type | Description   | Traditional mode | Hybrid mode | DB-less | {{site.konnect_short_name}}
-------------|---------------|------------------|-------------|---------|----------------------------
`shm` | Lua shared dict storage. <br> This storage is volatile between Nginx restarts (not reloads). | ✅ | ❌ | ✅ | ❌
`kong`| Kong database storage. | ✅ | ✅ <sup>1</sup> | ❌ | ❌
`redis` | [Redis-based](https://redis.io/docs/latest/) storage.    | ✅ | ✅ | ✅ | ✅
`consul` | [HashiCorp Consul](https://www.consul.io/) storage.    | ✅ | ✅ | ✅ | ✅
`vault` | [HashiCorp Vault](https://www.vaultproject.io/) storage. <br> Only the [KV V2](https://www.vaultproject.io/api/secret/kv/kv-v2.html) backend is supported. | ✅ | ✅ | ✅ | ✅

{:.note .no-icon}
> **\[1\]**: Due to current the limitations of hybrid mode, `kong` storage only supports certificate generation from
the Admin API but not the proxy side, as the data planes don't have access to the Kong database. 
See the [hybrid mode workflow](#hybrid-mode-workflow) for details. 

To configure a storage type other than `kong`, see [lua-resty-acme](https://github.com/fffonion/lua-resty-acme#storage-adapters) for example configurations.

## Running with or without a database

In a database-backed deployment, the plugin creates an SNI and certificate entity in Kong to
serve the certificate. If the SNI or certificate for the current request is already set
in the database, it will be overwritten.

In DB-less mode, the plugin takes over certificate handling. If the SNI or
certificate entity is already defined in Kong, it will be overridden by the
response.

## Workflow

An `http-01` challenge workflow between the {{site.base_gateway}} and the ACME server is described below:

1. The client sends a proxy or Admin API request that triggers certificate generation for `mydomain.com`.
2. The {{site.base_gateway}} sends a request to the ACME server to start the validation process.
3. The ACME server returns a challenge response detail to the {{site.base_gateway}}.
4. `mydomain.com` is publicly resolvable to the {{site.base_gateway}} that serves the challenge response.
5. The ACME server checks if the previous challenge has a response at `mydomain.com`.
6. The {{site.base_gateway}} checks the challenge status and if passed, downloads the certificate from the ACME server.
7. The {{site.base_gateway}} uses the new certificate to serve TLS requests.

### Hybrid mode workflow

`kong` storage in hybrid mode works in following flow:

1. The client sends an Admin API request that triggers certificate generation for `mydomain.com`.
2. The Kong control plane requests the ACME server to start the validation process.
3. The ACME server returns a challenge response detail to the Kong control plane.
4. The Kong control plane propagates the challenge response detail to the Kong data plane.
5. `mydomain.com` is publicly resolvable to the Kong data plane that serves the challenge response.
6. The ACME server checks if the previous challenge has a response at `mydomain.com`.
7. The Kong control plane checks the challenge status and if passed, downloads the certificate from the ACME server.
8. The Kong control plane propagates the new certificates to the Kong data plane.
9. The Kong data plane uses the new certificate to serve TLS requests.

All external storage types work as usual in hybrid mode. Both the control plane and data planes
need to connect to the same external storage cluster. It's also a good idea to set up replicas to avoid
connecting to same node directly for external storage.

External storage in hybrid mode (`redis`, `consul`, or `vault`) works in the following way:

1. The client send a proxy or Admin API request that triggers certificate generation for `mydomain.com`.
2. The Kong control plane or data plane requests the ACME server to start the validation process.
3. The ACME server returns a challenge response detail to the {{site.base_gateway}}.
4. The Kong control plane or data plane stores the challenge response detail in external storage.
5. `mydomain.com` is publicly resolvable to the Kong data plane that reads and serves the challenge response from external storage.
6. The ACME server checks if the previous challenge has a response at `mydomain.com`.
7. The Kong control plane or data plane checks the challenge status and if passed, downloads the certificate from the ACME server.
8. The Kong control plane or data plane stores the new certificates in external storage.
9. The Kong data plane reads from external storage and uses the new certificate to serve TLS requests.


## EAB support

External account binding (EAB) is supported as long as the `eab_kid` and `eab_hmac_key` values are provided.

The following CA provider's external account can be registered automatically, without specifying
the `eab_kid` or `eab_hmac_key`:

- [ZeroSSL](https://zerossl.com/)

## Storage configuration considerations {#storage-config}

`config.storage_config` is a table for all possible storage types. By default, it is:

```json
    "storage_config": {
      "kong": {},
      "shm": {
        "shm_name": "kong"
      },
      "redis": {
        "auth": null,
        "port": 6379,
        "database": 0,
        "host": "127.0.0.1",
        "ssl": false,
        "ssl_verify": false,
        "ssl_server_name": null,
        "namespace": ""
      },
       "consul": {
          "host": "127.0.0.1",
          "port": 8500,
          "token": null,
          "kv_path": "acme",
          "timeout": 2000,
          "https": false
      },
      "vault": {
          "host": "127.0.0.1",
          "port": 8200,
          "token": null,
          "kv_path": "acme",
          "timeout": 2000,
          "https": false,
          "tls_verify": true,
          "tls_server_name": null,
          "auth_method": "token",
          "auth_path": null,
          "auth_role": null,
          "jwt_path": null,
      },
    }
```


## Get started with the ACME plugin

* [Configuration reference](/hub/kong-inc/acme/configuration/)
* [Basic configuration example](/hub/kong-inc/acme/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/acme/how-to/)
* [Configure the ACME plugin with Redis](/hub/kong-inc/acme/how-to/redis/)
* [Local testing and development](/hub/kong-inc/acme/how-to/local-testing-development/)
* [ACME plugin API reference](/hub/kong-inc/acme/api/)
