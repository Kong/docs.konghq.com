---
nav_title: 
title: How to configure realms

minimum_version: 3.10.x
---


API Keys that are stored centrally in Konnect to be shared across multiple Gateways can be validated by configuring `identity_realms` field in the key-auth plugin.

### Configuring Multiple realms

In the key-auth plugin configuration, add the `identity_realms` field as shown below:

```yaml
identity_realms:
  - region: us
    id: <realm_id>
    scope: realm
  - scope: cp
```

The order in which you configure the identity_realms dictates the priority in which the dataplane attempts to authenticate the provided API keys.

In the example above, if the realm is listed first, the dataplane will first reach out to the realm. If the API key is not found in the realm, the dataplane will look for the API key in the control plane config. 

Alternatively, you can configure the look up in the control plane config first, followed by a lookup in the realm as necessary:

```yaml
identity_realms:
  - scope: cp
  - region: us
    id: <realm_id>
    scope: realm
```

In this configuration, the dataplane will initially check the control plane configuration (LMDB) for the API key before looking up the API Key in the realm.

If a matching key is found in any of these realms, the request will be authenticated. If the key is not found in any of the configured realms, the request will be blocked.

### Configuring Single Realm

It is also possible to configure only a single `identity_realm`, either the control plane configuration or a realm. 

To configure only a realm:

```yaml
identity_realms:
  - region: us
    id: <realm_id>
    scope: realm
```

In this case, the dataplane will only attempt to authenticate API keys against the realm.

To configure a look up only in the control plane config

```yaml
identity_realms:
  - scope: cp
```

In this scenario, the dataplane will only check the control plane configuration (LMDB) for API key authentication.

In both cases, if the API key is not found either in the realm or the control plane configuration, the request will be blocked.
