---
title: Dynamic Log Level Updates
content_type: reference
---


You can change the log level of {{site.base_gateway}} dynamically, without restarting {{site.base_gateway}}, using the Admin API. This set of endpoints can be protected using [RBAC](/gateway/{{page.release}}/admin-api/rbac/reference/#add-a-role-endpoint-permission) and changes in log level are reflected in the [audit log](/gateway/{{page.release}}/kong-enterprise/audit-log/).

The log level change is propagated to all NGINX worker nodes, including the newly spawned workers.

{:.note}
> **Note:** Changing the log level to `debug` in a production environment can rapidly fill up the disk. After debug logging, switch back to a higher level like `notice` or use a `timeout` parameter in the request query string. **The default timeout for dynamically set log levels is 60 seconds**.


## View current log level

To view the log level of an individual node, issue a `GET` request passing the desired `node` as a path parameter:

```bash
curl --request GET \
  --url http://localhost:8001/debug/node/log-level/
```

If you have the appropriate permissions, this request returns information about your current log level:

```json
{
    "message": "log level: notice"
}
```

{:.important}
> It is not possible to change the log level of the data plane or DB-less nodes.

## Modify the log level for an individual {{site.base_gateway}} node

To change the log level of an individual node, issue a `PUT` request passing the desired `node` and [`log-level`](/gateway/{{page.release}}/production/logging/log-reference/) as path parameters:

```bash
curl --request PUT \
  --url http://localhost:8001/debug/node/log-level/notice
```

If you have the appropriate permissions and the request is successful, you will receive a `200` response code and the following response body:

```json
{
	"message": "log level changed"
}
```

## Change the log level of the {{site.base_gateway}} cluster

To change the log level of every node in your cluster, issue a `PUT` request with the desired [`log-level`](/gateway/{{page.release}}/production/logging/log-reference/) specified as a path parameter:

```bash
curl --request PUT \
  --url http://localhost:8001/debug/cluster/log-level/notice
```

If you have the appropriate permissions and the request is successful, you will receive a `200` response code and the following response body:

```json
{
	"message": "log level changed"
}
```

### Manage new nodes in the cluster

To ensure that the log level of new nodes that are added to the cluster remain in sync the other nodes in the cluster, change the `log_level` entry in [`kong.conf`](/gateway/{{page.release}}/reference/configuration/#log_level) to `KONG_LOG_LEVEL`. This setting allows new nodes to join the cluster with the same log level as all the existing nodes.

## Change the log level of all control plane {{site.base_gateway}} nodes

To change the log level of the control plane nodes in your cluster, issue a `PUT` request with the desired [`log-level`](/gateway/{{page.release}}/production/logging/log-reference/) specified as a path parameter:

```bash
curl --request PUT \
  --url http://localhost:8001/debug/cluster/control-planes-nodes/log-level/notice
```

If you have the appropriate permissions and the request is successful, you will receive a `200` response code and the following response body:

```json
{
	"message": "log level changed"
}
```

