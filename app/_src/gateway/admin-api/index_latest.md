---
title: Kong Gateway Admin API
---

<!-- vale off -->

{{site.base_gateway}} comes with an **internal** RESTful Admin API for administration purposes.
 Requests to the Admin API can be sent to any node in the cluster, and Kong will
 keep the configuration consistent across all nodes.

 - `8001` is the default port on which the Admin API listens.
 - `8444` is the default port for HTTPS traffic to the Admin API.

 This API is designed for internal use and provides full control over Kong, so
 care should be taken when setting up Kong environments to avoid undue public
 exposure of this API. See [Securing the Admin API](/gateway/{{page.release}}/production/running-kong/secure-admin-api/)
 for more information about security methods.

## Documentation

The Kong Admin API is documented in OpenAPI format:

| Spec | Insomnia link |
|-------|---------------|
| [Enterprise beta API spec](/gateway/api/admin-ee/latest/) |<a href="https://insomnia.rest/run/?label=Kong%20Gateway%20Enterprise%203.4&uri=https%3A%2F%2Fraw.githubusercontent.com%2FKong%2Fdocs.konghq.com%2Fmain%2Fapi-specs%2FGateway-EE%2F3.4%2Fkong-ee-3.4.json" target="_blank"><img src="https://insomnia.rest/images/run.svg" alt="Run in Insomnia"></a>  |
|  [Open source beta API spec](/gateway/api/admin-oss/latest/) |  <a href="https://insomnia.rest/run/?label=Kong%20Gateway%20Open%20Source%203.4&uri=https%3A%2F%2Fraw.githubusercontent.com%2FKong%2Fdocs.konghq.com%2Fmain%2Fapi-specs%2FGateway-OSS%2F3.4%2Fkong-oss-3.4.json" target="_blank"><img src="https://insomnia.rest/images/run.svg" alt="Run in Insomnia"></a>|

See the following links for individual entity documentation:

{% navtabs %}
{% navtab Enterprise endpoints %}

| [Information Routes](href="https://docs.konghq.com/gateway/api/admin-ee/latest/#/Information/get-endpoints" target="_blank") | [Health Routes](/gateway/api/admin-ee/latest/#/Information/get-status) | [Tags](/gateway/api/admin-ee/latest/#/tags/get-tags) |
| [Debug Routes](/gateway/api/admin-ee/latest/#/debug/put-debug-cluster-control-planes-nodes-log-level-log_level) | [Services](/gateway/api/admin-ee/latest/#/Services/list-service) | [Routes](/gateway/api/admin-ee/latest/#/Routes/list-route) |
| [Consumers](/gateway/api/admin-ee/latest/#/Consumers/list-consumer) | [Plugins](/gateway/api/admin-ee/latest/#/Plugins/list-plugins-with-consumer) | [Certificates](/gateway/api/admin-ee/latest/#/Certificates/list-certificate) |
| [CA Certificates](/gateway/api/admin-ee/latest/#/CA%20Certificates/list-ca_certificate) | [SNIs](/gateway/api/admin-ee/latest/#/SNIs/list-sni-with-certificate) | [Upstreams](/gateway/api/admin-ee/latest/#/Upstreams/list-upstream) |
| [Targets](/gateway/api/admin-ee/latest/#/Targets/list-target-with-upstream) | [Vaults](/gateway/api/admin-ee/latest/#/Vaults/list-vault) | [Keys](/gateway/api/admin-ee/latest/#/Keys/list-key) |
| [Filter Chains](/gateway/api/admin-ee/latest/#/filter-chains/get-filter-chains) | [Licenses](/gateway/api/admin-ee/latest/#/licenses/get-licenses) | [Workspaces](/gateway/api/admin-ee/latest/#/Workspaces/list-workspace) |
| [RBAC](/gateway/api/admin-ee/latest/#/rbac/get-rbac-users) | [Admins](/gateway/api/admin-ee/latest/#/admins/get-admins) | [Consumer Groups](/gateway/api/admin-ee/latest/#/consumer_groups/) |
| [Event Hooks](/gateway/api/admin-ee/latest/#/Event-hooks/get-event-hooks) | [Keyring and Data Encryption](/gateway/api/admin-ee/latest/#/Keyring/get-keyring) | [Audit Logs](/gateway/api/admin-ee/latest/#/audit-logs/get-audit-requests) |
{% endnavtab %}
{% navtab OSS endpoints %}
| [Information Routes](/gateway/api/admin-oss/latest/#/Information/get-endpoints) | [Health Routes](/gateway/api/admin-oss/latest/#/Information/get-status) | [Tags](/gateway/api/admin-oss/latest/#/tags/get-tags) |
| [Debug Routes](/gateway/api/admin-oss/latest/#/debug/put-debug-cluster-control-planes-nodes-log-level-log_level) | [Services](/gateway/api/admin-oss/latest/#/Services/list-service) | [Routes](/gateway/api/admin-oss/latest/#/Routes/list-route) |
| [Consumers](/gateway/api/admin-oss/latest/#/Consumers/list-consumer) | [Plugins](/gateway/api/admin-oss/latest/#/Plugins/list-plugins-with-consumer) | [Certificates](/gateway/api/admin-oss/latest/#/Certificates/list-certificate) |
| [CA Certificates](/gateway/api/admin-oss/latest/#/CA%20Certificates/list-ca_certificate) | [SNIs](/gateway/api/admin-oss/latest/#/SNIs/list-sni-with-certificate) | [Upstreams](/gateway/api/admin-oss/latest/#/Upstreams/list-upstream) |
| [Targets](/gateway/api/admin-oss/latest/#/Targets/list-target-with-upstream) | [Vaults](/gateway/api/admin-oss/latest/#/Vaults/list-vault) | [Keys](/gateway/api/admin-oss/latest/#/Keys/list-key) |
{% endnavtab %}
{% endnavtabs %}

## DB-less mode

In [DB-less mode](/gateway/{{page.release}}/production/deployment-topologies/db-less-and-declarative-config/),
you [configure {{site.base_gateway}} declaratively](/gateway/{{page.release}}/admin-api/declarative-configuration/).
The Admin API for each Kong node functions independently, reflecting the memory state of that particular Kong node. 
This is the case because there is no database coordination between Kong nodes. 
Therefore, the Admin API is mostly read-only. 

When running {{site.base_gateway}} in DB-less mode, the Admin API can only perform tasks related to handling the declarative config:
* [Validating configurations against schemas](/gateway/api/admin-oss/latest/#/Information/post-schemas-entity-validate)
* [Validating plugin configurations against schemas](/gateway/api/admin-oss/latest/#/Information/post-schemas-plugins-validate)
* [Reloading the declarative configuration](/gateway/{{page.release}}/admin-api/declarative-configuration/)

## Supported content types

The Admin API accepts 3 content types on every endpoint:

### application/json

The `application/json` content type is useful for complex bodies (for example, complex plugin configuration).
Send a JSON representation of the data you want to send. For example:

```json
{
    "config": {
        "limit": 10,
        "period": "seconds"
    }
}
```

Here's an example of adding a route to a service named `test-service`:

```
curl -i -X POST http://localhost:8001/services/test-service/routes \
     -H "Content-Type: application/json" \
     -d '{"name": "test-route", "paths": [ "/path/one", "/path/two" ]}'
```

### application/x-www-form-urlencoded

The content type `application/x-www-form-urlencoded` is useful for basic request bodies. 
You can use it in most situations.
Note that when sending nested values, Kong expects nested objects to be referenced
with dotted keys. Example:

```
config.limit=10&config.period=seconds
```

When specifying arrays, send the values in order, or use square brackets (numbering
inside the brackets is optional but if provided it must be 1-indexed, and
consecutive). 

Here's an example route added to a service named `test-service`:

```sh
curl -i -X POST http://localhost:8001/services/test-service/routes \
     -d "name=test-route" \
     -d "paths[1]=/path/one" \
     -d "paths[2]=/path/two"
```

The following two examples are identical to the one above, but less explicit:
```sh
curl -i -X POST http://localhost:8001/services/test-service/routes \
     -d "name=test-route" \
     -d "paths[]=/path/one" \
     -d "paths[]=/path/two"

curl -i -X POST http://localhost:8001/services/test-service/routes \
    -d "name=test-route" \
    -d "paths=/path/one" \
    -d "paths=/path/two"
```

### multipart/form-data

The `multipart/form-data` content type is similar to URL-encoded. This content type uses dotted keys to reference nested
objects. Here is an example of sending a Lua file to the pre-function Kong plugin:

```sh
curl -i -X POST http://localhost:8001/services/plugin-testing/plugins \
     -F "name=pre-function" \
     -F "config.access=@custom-auth.lua"
```

When specifying arrays for this content-type, the array indices must be specified.
For example, here's a route added to a service named `test-service`:

```sh
curl -i -X POST http://localhost:8001/services/test-service/routes \
     -F "name=test-route" \
     -F "paths[1]=/path/one" \
     -F "paths[2]=/path/two"
```

## Using the API in workspaces 
{:.badge .enterprise}

{% include_cached /md/gateway/admin-api-workspaces.md %}

