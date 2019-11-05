---

name: DeGraphQL
publisher: Kong Inc.
version: 1.3.x

desc: Transform a GraphQL upstream into a REST API
description: |
  This plugin transforms a GraphQL upstream into a traditional endpoint by mapping uris into GraphQL queries.

type: plugin
enterprise: true
categories:
  - transformations

kong_version_compatibility:
    enterprise_edition:
      compatible:
        - 1.3.x

params:
  name: degraphql
  service_id: true
  config:

---
## Usage

DeGraphQL needs a graphql endpoint to query. As an example, we are going to
build a REST API around https://api.github.com GraphQL service. For that reason
examples are going to include the header `Authorization: Bearer some-token`.

Note this plugin differs from other plugins as far as configuration goes. It
needs to be activated on a service that points to a GraphQL endpoint
(sans `/graphql`).

### 1. Create a Service and a Route in Kong:

  ```bash
  $ http :8001/services name=github url=https://api.github.com
  $ http -f :8001/services/github/routes paths=/api
  ```

### 2. Configure the Plugin on the Service

The plugin takes over the service. From this point on, the service represents
our REST api and not the graphql endpoint itself. It will return a 404 Not Found
if no DeGraphQL routes have been configured.

  ```bash
  $ http :8001/services/github/plugins name=degraphql
  ```

### 3. Configure DeGraphQL Routes on the Service

Once the Plugin is activated on a Service, we can add our own routes to build
our service, by defining uris and associating them to GraphQL queries.

  ```bash
  $ http :8001/services/github/degraphql/routes uri='/me' \
          query='query { viewer { login } }'

  $ http :8000/api/me "Authorization: Bearer some-token"
  {
      "data": {
          "viewer": {
              "login": "you"
          }
      }
  }
  ```

GraphQL Query Variables can be defined on uris

  ```bash
  $ http :8001/services/github/degraphql/routes uri='/:owner/:name' \
       query='query ($owner:String! $name:String!){
                repository(owner:$owner, name:$name) {
                  name
                  forkCount
                  description
                }
              }'

  $ http :8000/api/kong/kong "Authorization: Bearer some-token"
  {
    "data": {
        "repository": {
            "description": "🦍 The Cloud-Native API Gateway ",
            "forkCount": 2997,
            "name": "kong"
        }
    }
  }
  ```

The same Variables can also be provided as GET arguments

  ```bash
  $ http :8001/services/github/degraphql/routes uri='/repo' \
       query='query ($owner:String! $name:String!){
                repository(owner:$owner, name:$name) {
                  name
                  forkCount
                  description
                }
              }'

  $ http GET :8000/api/repo "Authorization: Bearer some-token" \
         owner=kong name=kuma
  {
    "data": {
        "repository": {
            "description": "🐻 The Universal Service Mesh",
            "forkCount": 48,
            "name": "kuma"
        }
    }
  }
  ```

### Available endpoints

**List defined DeGraphQL Routes for a service**

<div class="endpoint get">/services/:service_name/degraphql/routes</div>

**Create a DeGraphQL Route for a Service**

<div class="endpoint post">/services/:service_name/degraphql/routes</div>

| Attributes | Description
| -------------- | -------
|`uri` | path to map to a GraphQL query
|`query` | GraphQL query to map to uri

**Edit a DeGraphQL Route for a Service**

<div class="endpoint patch">/services/:service_name/degraphql/routes/:id</div>

| Attributes | Description
| -------------- | -------
|`uri` | path to map to a GraphQL query
|`query` | GraphQL query to map to uri


**Delete a DeGraphQL Route for a Service**

<div class="endpoint delete">/services/:service_name/degraphql/routes/:id</div>
