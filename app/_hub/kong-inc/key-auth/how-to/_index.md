---
nav_title: 
title: How to configure realms

minimum_version: 3.8.x
---


With `pool_id` you can configure the key-auth plugin to validate API keys against the Identity Service.

### Configuring Multiple Pools

In the key-auth plugin configuration, add the `pools` option as shown below:

```yaml
pools:
  - geo: us
    id: <the_pool_id_you_got_in_step_1>
    type: remote
  - geo: null
    id: null
    type: local
```

The order in which you configure the pools dictates the priority in which the dataplane attempts to authenticate the provided API keys.

In the example above, if the remote pool is listed first, the dataplane will first reach out to the identity service and, if necessary, subsequently to the local pool.

Alternatively, you can configure the local pool first:

```yaml
pools:
  - geo: null
    id: null
    type: local
  - geo: us
    id: <the_pool_id_you_got_in_step_1>
    type: remote
```

In this configuration, the dataplane will initially check the local pool (LMDB) before querying the remote Identity Service.

If a matching key is found in any of these pools, the request will be authenticated. If the key is not found in any of the configured pools, the request will be blocked.

### Configuring Single Pools

It is also possible to configure only a single pool, either local or remote. However, only one of each type can be configured.

To configure only a remote pool:

```yaml
pools:
  - geo: us
    id: <the_pool_id_you_got_in_step_1>
    type: remote
```

In this case, the dataplane will only attempt to authenticate API keys against the remote Identity Service.

To configure only a local pool:

```yaml
pools:
  - geo: null
    id: null
    type: local
```

In this scenario, the dataplane will only check the local pool (LMDB) for API key authentication.

In both cases, if the API key is not found in the configured pool, the request will be blocked.
