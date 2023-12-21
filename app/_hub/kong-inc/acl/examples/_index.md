---
nav_title: ACL Examples
title: ACL Examples
---

## Examples


### Simple ACL Examples

**Use-Case: As an API Owner, I want to allow GET/POST/PUT access all consumers with who are in Consumer Group `dev`. In addition I want only DELETE to be available to consumers who are in Consumer Group `admin`**


Step 1: Setup Consumers and Consumer Groups

Create two Consumer Groups that represent the two roles: dev and admin.
Add Consumers to that group

(link to consumer groups for further explanation)

Step 2: Setup routes

Setup two routes, one that only matches GET, POST and PUT, one that only matches DELETE

(note that this examples uses expressions router (link to this article https://docs.konghq.com/gateway/3.5.x/key-concepts/routes/expressions/ ))

A route that matches when the method is _not_ DELETE
```bash
curl --request POST \
  --url http://localhost:8001/services/example-service/routes \
  --form-string name=devs-and-admins \
  --form-string expression='http.path == "/example" && http.method != "DELETE"'
```

A route that matches when the method _is_ DELETE
```bash
curl --request POST \
  --url http://localhost:8001/services/example-service/routes \
  --form-string name=only-admins \
  --form-string expression='http.path == "/example" && http.method == "DELETE"'
```

Step 3: Setup ACL plugins

Scope the plugin to to each of these routes with the respective `allow` configuration


The `devs-and-admin` route will have the `allow` field set to both of the groups

```bash
curl -X POST http://localhost:8001/routes/devs-and-admin/plugins \
    --data "name=acl"  \
    --data "config.allow=dev"  \
    --data "config.allow=admin" \
```

The `only-admins` route will have the `allow` field set to only the `admin` group.

```bash
curl -X POST http://localhost:8001/routes/admins-only/plugins \
    --data "name=acl"  \
    --data "config.allow=admin" \
```
