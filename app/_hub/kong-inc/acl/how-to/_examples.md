---
nav_title: ACL Examples
title: ACL Examples
---

## ACL configuration with {{site.base_gateway}}

This example covers a common use case: as an API owner, you want to regulate access based on the type of request methods and consumer groups. Specifically, the goal is to allow consumers in the dev group to perform GET, POST, and PUT requests on all routes, while reserving the DELETE request functionality exclusively for consumers in the admin group.


### Create consumer groups 

Using the API, create a consumer group for  `dev`
```bash
curl --request POST \
    --url http://localhost:8001/consumer_groups \
    --header 'Content-Type: application/json' \
    --header 'accept: application/json' \
    --data '{"name":"dev"}'
```

Then create a consumer group for `admin`:

```bash
curl --request POST \
  --url http://localhost:8001/consumer_groups \
  --header 'Content-Type: application/json' \
  --header 'accept: application/json' \
  --data '{"name":"admin",}'
``` 

Add a consumer to the `admin` group by using the UUID of the specific consumer:

```bash
        curl --request POST \
          --url http://localhost:8001/consumer_groups/admin/consumers \
          --header 'Content-Type: application/json' \
          --header 'accept: application/json' \
          --data '{"consumer":"8a4bba3c-7f82-45f0-8121-ed4d2847c4a4"}'
```
Then add a consumer to the `dev` group. 

```bash
curl --request POST \
  --url http://localhost:8001/consumer_groups/dev/consumers \
  --header 'Content-Type: application/json' \
  --header 'accept: application/json' \
  --data '{"consumer":"8a4bba3c-7f82-45f0-8121-ed4d2847c4a4"}'
```

### Create routes 

Using the Admin API and the [expressions router](/gateway/latest/key-concepts/routes/expressions/), create two routes: one that matches `GET`, `POST` and `PUT`, and one that only matches `DELETE`. 

Create a route that matches when the method is _not_ `DELETE`:

```bash
curl --request POST \
  --url http://localhost:8001/services/example-service/routes \
  --form-string name=devs-and-admins \
  --form-string expression='http.path == "/example" && http.method != "DELETE"'
```

Create a route that matches when the method _is_ DELETE:
```bash
curl --request POST \
  --url http://localhost:8001/services/example-service/routes \
  --form-string name=only-admins \
  --form-string expression='http.path == "/example" && http.method == "DELETE"'
```


### Set up the ACL plugin

Scope the plugin to each of these routes with the respective `allow` configuration.

Enable the ACL plugin on the `devs-and-admin` route, setting the `allow` field to accept both groups:

```bash
curl -X POST http://localhost:8001/routes/devs-and-admin/plugins \
    --data "name=acl"  \
    --data "config.allow[]=dev"  \
    --data "config.allow[]=admin"
```

Enable another ACL plugin instance on the `only-admins` route, setting the `allow` field set to only accept the `admin` group:

```bash
curl -X POST http://localhost:8001/routes/admins-only/plugins \
    --data "name=acl"  \
    --data "config.allow=admin"
```
