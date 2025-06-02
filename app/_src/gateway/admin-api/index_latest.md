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

{% if_version lte:3.7.x %}

| Spec | Insomnia link |
|-------|---------------|
| [Enterprise API](/gateway/api/admin-ee/latest/){:target="_blank"} | <a href="https://insomnia.rest/run/?label=Kong%20Gateway%20Enterprise%20{{page.short_version}}&uri=https%3A%2F%2Fraw.githubusercontent.com%2FKong%2Fdocs.konghq.com%2Fmain%2Fapi-specs%2FGateway-EE%2F{{page.short_version}}%2Fkong-ee-{{page.short_version}}.yaml" target="_blank"> <img src="https://insomnia.rest/images/run.svg" alt="Run in Insomnia" class="no-image-expand"></a> |
|  [Open source API](/gateway/api/admin-oss/latest/){:target="_blank"} | <a href="https://insomnia.rest/run/?label=Kong%20Gateway%20OSS%20{{page.short_version}}&uri=https%3A%2F%2Fraw.githubusercontent.com%2FKong%2Fdocs.konghq.com%2Fmain%2Fapi-specs%2FGateway-OSS%2F{{page.short_version}}%2Fkong-oss-{{page.short_version}}.yaml" target="_blank"><img src="https://insomnia.rest/images/run.svg" alt="Run in Insomnia" class="no-image-expand"></a> |

{% endif_version %}
{% if_version gte:3.8.x lte:3.9.x %}

| Spec | Insomnia link |
|-------|---------------|
| [Enterprise API](/gateway/api/admin-ee/latest/){:target="_blank"} |<a href="https://insomnia.rest/run/?label=Kong%20Gateway%20Enterprise%20{{page.short_version}}&uri=https%3A%2F%2Fraw.githubusercontent.com%2FKong%2Fdocs.konghq.com%2Fmain%2Fapi-specs%2FGateway-EE%2F{{page.short_version}}%2Fkong-ee.yaml" target="_blank"><img src="https://insomnia.rest/images/run.svg" alt="Run in Insomnia" class="no-image-expand"></a> |
|  [Open source API](/gateway/api/admin-oss/latest/){:target="_blank"} | <a href="https://insomnia.rest/run/?label=Kong%20Gateway%20OSS%20{{page.short_version}}&uri=https%3A%2F%2Fraw.githubusercontent.com%2FKong%2Fdocs.konghq.com%2Fmain%2Fapi-specs%2FGateway-OSS%2F{{page.short_version}}%2Fkong-oss.yaml" target="_blank"> <img src="https://insomnia.rest/images/run.svg" alt="Run in Insomnia" class="no-image-expand"></a> |

{% endif_version %}

{% if_version gte:3.10.x %}

| Spec | Insomnia link |
|-------|---------------|
| [Enterprise API](/gateway/api/admin-ee/latest/){:target="_blank"} |<a href="https://insomnia.rest/run/?label=Kong%20Gateway%20Enterprise%20{{page.short_version}}&uri=https%3A%2F%2Fraw.githubusercontent.com%2FKong%2Fdocs.konghq.com%2Fmain%2Fapi-specs%2FGateway-EE%2F{{page.short_version}}%2Fkong-ee.yaml" target="_blank"><img src="https://insomnia.rest/images/run.svg" alt="Run in Insomnia" class="no-image-expand"></a> |

{% endif_version %}

See the following links for individual entity documentation:

{% if_version lte:3.9.x %}

{% navtabs %}
{% navtab Enterprise endpoints %}


| [Information Routes]( /gateway/api/admin-ee/latest/#/operations/get-endpoints){:target="_blank"} | [Health Routes](/gateway/api/admin-ee/latest/#/operations/get-status){:target="_blank"} | [Tags](/gateway/api/admin-ee/latest/#/operations/get-tags){:target="_blank"} |
| [Debug Routes]( /gateway/api/admin-ee/latest/#/operations/put-debug-cluster-control-planes-nodes-log-level-log_level){:target="_blank"} | [Services](/gateway/api/admin-ee/latest/#/operations/list-service){:target="_blank"} | [Routes](/gateway/api/admin-ee/latest/#/operations/list-route){:target="_blank"} |
| [Consumers]( /gateway/api/admin-ee/latest/#/operations/list-consumer){:target="_blank"} | [Plugins](/gateway/api/admin-ee/latest/#/operations/list-plugins-with-consumer){:target="_blank"} | [Certificates](/gateway/api/admin-ee/latest/#/operations/list-certificate){:target="_blank"} |
| [CA Certificates]( /gateway/api/admin-ee/latest/#/operations/list-ca_certificate){:target="_blank"} | [SNIs](/gateway/api/admin-ee/latest/#/operations/list-sni-with-certificate){:target="_blank"} | [Upstreams](/gateway/api/admin-ee/latest/#/operations/list-upstream){:target="_blank"} |
| [Targets]( /gateway/api/admin-ee/latest/#/operations/list-target-with-upstream){:target="_blank"} | [Vaults](/gateway/api/admin-ee/latest/#/operations/list-vault){:target="_blank"} | [Keys](/gateway/api/admin-ee/latest/#/operations/list-key){:target="_blank"} |
| [Filter Chains]( /gateway/api/admin-ee/latest/#/operations/get-filter-chains){:target="_blank"} | [Licenses](/gateway/api/admin-ee/latest/#/operations/get-licenses){:target="_blank"} | [Workspaces](/gateway/api/admin-ee/latest/#/operations/list-workspace){:target="_blank"} |
| [RBAC]( /gateway/api/admin-ee/latest/#/operations/get-rbac-users){:target="_blank"} | [Admins](/gateway/api/admin-ee/latest/#/operations/get-admins){:target="_blank"} | [Consumer Groups](/gateway/api/admin-ee/latest/#/operations/get-consumer_groups){:target="_blank"} |
| [Event Hooks]( /gateway/api/admin-ee/latest/#/operations/get-event-hooks){:target="_blank"} | [Keyring and Data Encryption](/gateway/api/admin-ee/latest/#/operations/get-keyring){:target="_blank"} | [Audit Logs](/gateway/api/admin-ee/latest/#/operations/get-audit-requests){:target="_blank"} |

{% if_version gte:3.10.x %}
| [Partials](/gateway/api/admin-ee/latest/#/operations/partials){:target="_blank"} | | |
{% endif_version %}


{% endnavtab %}
{% navtab OSS endpoints %}
| [Information Routes](/gateway/api/admin-oss/latest/#/operations/get-endpoints){:target="_blank"} | [Health Routes](/gateway/api/admin-oss/latest/#/operations/get-status){:target="_blank"} | [Tags](/gateway/api/admin-oss/latest/#/operations/get-tags){:target="_blank"} |
| [Debug Routes](/gateway/api/admin-oss/latest/#/operations/put-debug-cluster-control-planes-nodes-log-level-log_level){:target="_blank"} | [Services](/gateway/api/admin-oss/latest/#/operations/list-service){:target="_blank"} | [Routes](/gateway/api/admin-oss/latest/#/operations/list-route){:target="_blank"} |
| [Consumers](/gateway/api/admin-oss/latest/#/operations/list-consumer){:target="_blank"} | [Plugins](/gateway/api/admin-oss/latest/#/operations/list-plugins-for-consumer){:target="_blank"} | [Certificates](/gateway/api/admin-oss/latest/#/operations/list-certificate){:target="_blank"} |
| [CA Certificates](/gateway/api/admin-oss/latest/#/operations/list-ca_certificate){:target="_blank"} | [SNIs](/gateway/api/admin-oss/latest/#/operations/get-sni-with-certificate){:target="_blank"} | [Upstreams](/gateway/api/admin-oss/latest/#/operations/list-upstream){:target="_blank"} |
| [Targets](/gateway/api/admin-oss/latest/#/operations/list-targets-for-upstream){:target="_blank"} | [Vaults](/gateway/api/admin-oss/latest/#/operations/list-vault){:target="_blank"} | [Keys](/gateway/api/admin-oss/latest/#/operations/list-key){:target="_blank"} |
| [Filter Chains](/gateway/api/admin-oss/latest/#/operations/get-filter-chains){:target="_blank"} | | |
{% endnavtab %}
{% endnavtabs %}

{% endif_version %}

{% if_version gte:3.10.x %}

| [Information Routes](/gateway/api/admin-ee/latest/#/operations/get-endpoints){:target="_blank"} | [Health Routes](/gateway/api/admin-ee/latest/#/operations/get-status){:target="_blank"} | [Tags](/gateway/api/admin-ee/latest/#/operations/get-tags){:target="_blank"} |
| [Debug Routes](/gateway/api/admin-ee/latest/#/operations/put-debug-cluster-control-planes-nodes-log-level-log_level){:target="_blank"} | [Services](/gateway/api/admin-ee/latest/#/operations/list-service){:target="_blank"} | [Routes](/gateway/api/admin-ee/latest/#/operations/list-route){:target="_blank"} |
| [Consumers](/gateway/api/admin-ee/latest/#/operations/list-consumer){:target="_blank"} | [Plugins](/gateway/api/admin-ee/latest/#/operations/list-plugins-with-consumer){:target="_blank"} | [Certificates](/gateway/api/admin-ee/latest/#/operations/list-certificate){:target="_blank"} |
| [CA Certificates](/gateway/api/admin-ee/latest/#/operations/list-ca_certificate){:target="_blank"} | [SNIs](/gateway/api/admin-ee/latest/#/operations/list-sni-with-certificate){:target="_blank"} | [Upstreams](/gateway/api/admin-ee/latest/#/operations/list-upstream){:target="_blank"} |
| [Targets](/gateway/api/admin-ee/latest/#/operations/list-target-with-upstream){:target="_blank"} | [Vaults](/gateway/api/admin-ee/latest/#/operations/list-vault){:target="_blank"} | [Keys](/gateway/api/admin-ee/latest/#/operations/list-key){:target="_blank"} |
| [Filter Chains](/gateway/api/admin-ee/latest/#/operations/get-filter-chains){:target="_blank"} | [Licenses](/gateway/api/admin-ee/latest/#/operations/get-licenses){:target="_blank"} | [Workspaces](/gateway/api/admin-ee/latest/#/operations/list-workspace){:target="_blank"} |
| [RBAC](/gateway/api/admin-ee/latest/#/operations/get-rbac-users){:target="_blank"} | [Admins](/gateway/api/admin-ee/latest/#/operations/get-admins){:target="_blank"} | [Consumer Groups](/gateway/api/admin-ee/latest/#/operations/consumer_groups/){:target="_blank"} |
| [Event Hooks](/gateway/api/admin-ee/latest/#/operations/get-event-hooks){:target="_blank"} | [Keyring and Data Encryption](/gateway/api/admin-ee/latest/#/operations/get-keyring){:target="_blank"} | [Audit Logs](/gateway/api/admin-ee/latest/#/operations/get-audit-requests){:target="_blank"} |

{% endif_version %}

## DB-less mode

In [DB-less mode](/gateway/{{page.release}}/production/deployment-topologies/db-less-and-declarative-config/),
you [configure {{site.base_gateway}} declaratively](/gateway/{{page.release}}/admin-api/declarative-configuration/).
The Admin API for each Kong node functions independently, reflecting the memory state of that particular Kong node. 
This is the case because there is no database coordination between Kong nodes. 
Therefore, the Admin API is mostly read-only. 

When running {{site.base_gateway}} in DB-less mode, the Admin API can only perform tasks related to handling the declarative config:
* [Validating configurations against schemas](/gateway/api/admin-oss/latest/#/operations/post-schemas-entity-validate)
* [Validating plugin configurations against schemas](/gateway/api/admin-oss/latest/#/operations/post-schemas-plugins-validate)
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

## HTTP status response codes

The following status codes are returned in HTTP responses:

| HTTP Code | HTTP Description | Notes | Request method |
| --------- | ---------------- | ----- | ------------- |
| 200 | OK | The request succeeded. The result of a `200` request depends on the request type: <br>- `GET`: The resource was fetched and sent in the message body. <br>- `PUT` or `POST`:  The resource that describes the result of the action is sent in the message body. <br>- `PATCH`: ? | `GET`, `POST`, `PATCH`, `PUT` |
| 201 | Created | The request succeeded and a new resource was created. | `POST` |
| 204 | No Content | There is no content in the request to send. | `DELETE` |
| 400 | Bad Request | The server can't or won't send the request because of an error by the client. | `POST`, `PATCH`, `PUT` |
| 401 | Unauthorized | The client is unauthenticated. | `GET`, `POST`, `DELETE`, `PATCH`, `PUT` |
| 404 | Not Found | The server can't find the resource you requested. With an API, this can mean that the endpoint is valid but the resource doesn't exist. | `GET`, `PATCH`, `PUT` |
| 405 | Method Not Allowed | The server knows the request method, but it isn't supported by the resource. | `PUT` |
| 409 | Conflict | A request conflicts with the current state of the server.  | `POST` |

## Using the API in workspaces 
{:.badge .enterprise}

{% include_cached /md/gateway/admin-api-workspaces.md %}

