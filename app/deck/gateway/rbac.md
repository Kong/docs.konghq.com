---
title: Manage RBAC roles
---

decK can manage {{ site.ee_product_name }} RBAC configuration using the `diff`, `sync`, and `dump` commands.

{:.important}
> decK can't manage {{ site.konnect_short_name }} permissions as they are set at the organization level, rather than the control plane level. We recommend [terraform-provider-konnect](https://github.com/Kong/terraform-provider-konnect) for your {{ site.konnect_short_name }} RBAC needs.

RBAC configuration is usually stored separately from all other configuration, and decK provides the `--rbac-resources-only` flag to ensure that only RBAC resources are in scope when running commands.

RBAC roles accept a list of `actions`, a wildcard endpoint (for example,`/services/*`), and if the role is `negative` or not. A negative RBAC role means that the actions listed are explicitly denied on the endpoint specified, even if allowed by a different permission.

```yaml
_format_version: "3.0"
rbac_roles:
- comment: Read access to all endpoints, across all workspaces
  endpoint_permissions:
  - actions:
    - read
    endpoint: '*'
    negative: false
    workspace: '*'
  name: read-only
- comment: Full access to all endpoints, across all workspaces
  endpoint_permissions:
  - actions:
    - read
    - delete
    - create
    - update
    endpoint: '*'
    negative: false
    workspace: '*'
  name: super-admin
```

## Required permissions for decK

decK uses Kong's Admin API to communicate with {{site.base_gateway}}. 
If you have RBAC enabled, you need to give decK permissions to perform operations, or use an admin account that has these permissions. 

Here are some common endpoints hit by decK for normal operations:

* `GET, POST, PATCH, PUT, DELETE /{entityType}` or `GET, POST, PATCH, PUT, DELETE /{workspace}/{entityType}`: Perform read and write operations on entities.

   If you are running {{site.ee_product_name}}, then decK interacts with entities inside workspaces. 
   See the [Entities managed by decK](/deck/reference/entities/) reference for the full list.
   
   Note that decK also performs operations on entities enabled by plugins, such as `/basic-auths`, `/jwts`, and so on.

* `GET /`: Get the {{site.base_gateway}} version.
* `GET /{workspace}/kong`: Get entities in a workspace.
* `GET /{workspace}/workspaces/{entityType}`: Check whether the workspace or other entity exists or not.
* `GET /{workspace}/schemas/{entityType}`: Retrieves the schema for a specified entity type within a workspace and applies default settings.
* `GET /{workspace}/schemas/plugins/{pluginName}`: Retrieves the schema for a specified plugin within a workspace and applies default settings.
* `POST /workspaces`: Create missing workspaces.

To find out which endpoints your instance of decK is hitting, execute any decK command with the `--verbose 1` flag.  This outputs all of the queries being made. For example, here's a snippet from `deck gateway dump --verbose 1`:

```sh
...
GET /routes?size=1000 HTTP/1.1
Host: localhost:8001
User-Agent: Go-http-client/1.1
Accept-Encoding: gzip


GET /consumers?size=1000 HTTP/1.1
Host: localhost:8001
User-Agent: Go-http-client/1.1
Accept-Encoding: gzip


GET /mtls-auths?size=1000 HTTP/1.1
Host: localhost:8001
User-Agent: Go-http-client/1.1
Accept-Encoding: gzip


GET /snis?size=1000 HTTP/1.1
Host: localhost:8001
User-Agent: Go-http-client/1.1
Accept-Encoding: gzip
...
```