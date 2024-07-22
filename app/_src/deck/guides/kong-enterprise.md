---
title: decK and Kong Gateway Enterprise
content_type: explanation
---

All features of decK work with both {{site.ce_product_name}} and {{site.ee_product_name}}.

For {{site.ee_product_name}}, decK provides a few additional features leveraging the
power of enterprise features.

## Compatibility

decK is compatible with {{site.ee_product_name}} 0.35 and above.

## Entities managed by decK

decK manages only the core proxy entities in {{site.ee_product_name}}. It doesn't
manage enterprise-only entities such as admins, RBAC permissions, RBAC roles,
or any entities related to Dev Portal.

For a full list, see the reference for [entities managed by decK](/deck/{{page.release}}/reference/entities/).

## RBAC

If you have authentication and RBAC configured for Kong's Admin API, provide the
RBAC token to decK so that decK can authenticate itself against the Admin API.

Use the `--headers` flag to pass the RBAC token to decK. For example, you can pass the token as a string:

{% if_version lte:1.27.x %}
```sh
deck diff --headers "kong-admin-token:<your-token>"
```
{% endif_version %}
{% if_version gte:1.28.x %}
```sh
deck gateway diff kong.yaml --headers "kong-admin-token:<your-token>"
```
{% endif_version %}


However, passing the token directly is not secure and should only be used for testing. The command and all of its flags are logged to your shell's history file, potentially leaking the token.

For a more secure approach, you can store the token in a file and load the file as you execute the command. For example:

{% if_version lte:1.27.x %}
```sh
deck diff --headers "kong-admin-token:$(cat token.txt)"
```
{% endif_version %}
{% if_version gte:1.28.x %}
```sh
deck gateway diff kong.yaml --headers "kong-admin-token:$(cat token.txt)"
```
{% endif_version %}

You can also use the `DECK_HEADERS` environment variable to supply the same token with an environment variable.

It is advised that you do not use an RBAC token with super admin privileges
with decK, and always scope down the exact permissions you need to give
decK.

### Endpoints used by decK

decK uses Kong's Admin API to communicate with {{site.base_gateway}}. 
If you have RBAC enabled, you need to give decK permissions to perform operations, or use an admin account that has these permissions. 

Here are some common endpoints hit by decK for normal operations:

* `GET, POST, PATCH, PUT, DELETE /{entityType}` or `GET, POST, PATCH, PUT, DELETE /{workspace}/{entityType}`: Perform read and write operations on entities.

   If you are running {{site.ee_product_name}}, then decK interacts with entities inside workspaces. 
   See the [Entities managed by decK](/deck/{{page.release}}/reference/entities/) reference for the full list.
   
   Note that decK also performs operations on entities enabled by plugins, such as `/basic-auths`, `/jwts`, and so on.
* `GET /`: Get the {{site.base_gateway}} version.
* `GET /{workspace}/kong`: Get entities in a workspace.
* `GET /{workspace}/workspaces/{entityType}`: Check whether the workspace or other entity exists or not.
* `GET /{workspace}/schemas/{entityType}`: Retrieves the schema for a specified entity type within a workspace and applies default settings.
* `GET /{workspace}/schemas/plugins/{pluginName}`: Retrieves the schema for a specified plugin within a workspace and applies default settings.
* `POST /workspaces`: Create missing workspaces.

To find out which endpoints your instance of decK is hitting, execute any decK command with the `--verbose 1` flag. 
This outputs all of the queries being made. For example, here's a snippet from `deck gateway dump --verbose 1`:

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

## Workspaces

decK is workspace-aware, meaning it can interact with multiple workspaces.

### Manage one workspace at a time

To manage the configuration of a specific workspace, use the `--workspace` flag with [`sync`](/deck/{{page.release}}/reference/deck_sync/),
[`diff`](/deck/{{page.release}}/reference/deck_diff),
[`ping`](/deck/{{page.release}}/reference/deck_ping),
[`dump`](/deck/{{page.release}}/reference/deck_dump), or
[`reset`](/deck/{{page.release}}/reference/deck_reset). For example, to
export the configuration of the workspace `my-workspace`:

```sh
deck dump --workspace my-workspace
```

If you do not specify a `--workspace` flag, decK uses the `default` workspace.

To set a workspace directly in the state file, use the `_workspace` parameter.
For example:

```yaml
_format_version: "3.0"
_workspace: default
services:
- name: example_service
```

{:.note}
> **Note:** decK cannot delete workspaces. If you use `--workspace` or
`--all-workspaces` with `deck reset`, decK deletes the entire configuration
inside the workspace, but not the workspace itself.

### Manage multiple workspaces

You can manage the configurations of all workspaces in {{site.ee_product_name}}
with the `--all-workspaces` flag:

{% if_version lte:1.27.x %}
```sh
deck dump --all-workspaces
```
{% endif_version %}
{% if_version gte:1.28.x %}
```sh
deck gateway dump -o kong.yaml --all-workspaces
```
{% endif_version %}

This creates one configuration file per workspace.

{% if_version gte:1.11.x %}

However, since a `workspace` is an isolated unit of configuration, decK doesn't
allow the deployment of multiple workspaces at a time. Therefore, each
workspace configuration file must be deployed individually:

{% if_version lte:1.27.x %}

```sh
deck sync -s workspace1.yaml --workspace workspace1
```

```sh
deck sync -s workspace2.yaml --workspace workspace2
```
{% endif_version %}
{% if_version gte:1.28.x %}

```sh
deck gateway sync workspace1.yaml --workspace workspace1
```

```sh
deck gateway sync workspace2.yaml --workspace workspace2
```
{% endif_version %}

{% endif_version %}

{:.important}
> Be careful when using the `--all-workspaces` flag to avoid overwriting the wrong workspace. We
recommend using the singular `--workspace` flag in most situations.
