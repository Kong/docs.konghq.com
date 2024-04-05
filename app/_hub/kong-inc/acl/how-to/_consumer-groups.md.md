---
nav_title: Using ACLs with consumer groups
title: Using ACLs with consumer groups

minimum_version: 3.6.x
---

## ACL configuration with {{site.base_gateway}}

This example covers a common use case: as an API owner, you want to regulate access based on the type of request methods and consumer groups. Specifically, the goal is to allow consumers in the dev group to perform GET, POST, and PUT requests on all routes, while reserving the DELETE request functionality exclusively for consumers in the admin group.


### Create consumers

Using the API, create two consumers, `admin` and `dev`.

1. Create consumer `admin`:
     ```bash
     curl -i -X POST http://localhost:8001/consumers \
        --data "username=admin"
     ```
2. Create consumer `dev`:
     ```bash
     curl -i -X POST http://localhost:8001/consumers \
        --data "username=dev"
    ```
The response for each request contains a UUID in the `id` field that you will need for the rest of the guide. 

### Create consumer groups 

1. Using the API, create a consumer group for `dev`:
     ```bash
     curl -i -X POST http://localhost:8001/consumer_groups \
         --data "name=dev"
     ```

1. Then create a consumer group for `admin`:
     
     ```bash
     curl -i -X POST http://localhost:8001/consumer_groups \
       --data "name=admin"
     ```

1. Add a consumer to the `admin` group by using the UUID of the specific consumer:

    ```bash
    curl -i -X POST http://localhost:8001/consumer_groups/admin/consumers \
      --data "consumer=8a4bba3c-7f82-45f0-8121-ed4d2847c4a4"
    ```
1. Add a different consumer to the `dev` group:

    ```bash
    curl -i -X POST http://localhost:8001/consumer_groups/dev/consumers \
      --data "consumer=8a4bba3c-7f82-45f0-8121-ed4d2847c4a4"
    ```

### Create routes 

Using the Admin API and the [expressions router](/gateway/latest/key-concepts/routes/expressions/), create two routes: one that matches `GET`, `POST` and `PUT`, and one that only matches `DELETE`. 

1. Create a route that matches when the method is _not_ `DELETE`:

    ```bash
    curl --request POST \
      --url http://localhost:8001/services/example-service/routes \
      --form-string name=devs-and-admins \
      --form-string expression='http.path == "/example" && http.method != "DELETE"'
    ```

1. Create a route that matches when the method _is_ DELETE:
    
    ```bash
    curl --request POST \
      --url http://localhost:8001/services/example-service/routes \
      --form-string name=only-admins \
      --form-string expression='http.path == "/example" && http.method == "DELETE"'
    ```


### Set up the ACL plugin

Scope the plugin to each of these routes with the respective `allow` configuration.

Enable the ACL plugin on the `devs-and-admin` route, setting the `allow` field to accept both groups:

<!--vale off-->
{% plugin_example %}
plugin: kong-inc/acl
name: acl
config:
  include_consumer_groups: true
  allow:
    - dev
    - admin
targets:
  - route
formats:
  - curl
  - konnect
  - yaml
  - kubernetes
{% endplugin_example %}
<!--vale on-->

Enable another ACL plugin instance on the `only-admins` route, setting the `allow` field set to only accept the `admin` group:

<!--vale off-->
{% plugin_example %}
plugin: kong-inc/acl
name: acl
config:
  include_consumer_groups: true
  allow:
    - admin
targets:
  - route
formats:
  - curl
  - konnect
  - yaml
  - kubernetes
{% endplugin_example %}
<!--vale on-->
