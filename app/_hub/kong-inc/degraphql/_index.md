---
name: DeGraphQL
publisher: Kong Inc.
version: 0.1.0
desc: Transform a GraphQL upstream into a REST API
description: |
  This plugin transforms a GraphQL upstream into a traditional endpoint by mapping URIs into GraphQL queries.
type: plugin
enterprise: true
plus: true
categories:
  - transformations
kong_version_compatibility:
  enterprise_edition:
    compatible:
      - 2.8.x
      - 2.7.x
      - 2.6.x
      - 2.5.x
      - 2.4.x
      - 2.3.x
      - 2.2.x
      - 2.1.x
      - 1.5.x
      - 1.3-x
params:
  name: degraphql
  service_id: true
  dbless_compatible: 'yes'
  config: null
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
  $ curl -X POST http://localhost:8001/services \
    --data name="github" \
    --data url="https://api.github.com"
  $ curl -X POST http://localhost:8001/services/github/routes \
    --data paths="/api"
  ```

### 2. Configure the Plugin on the Service

The plugin takes over the service. From this point on, the service represents
our REST api and not the graphql endpoint itself. It will return a 404 Not Found
if no DeGraphQL routes have been configured.

  ```bash
  $ curl -X POST http://localhost:8001/services/github/plugins \
    --data name="degraphql"
  ```

### 3. Configure DeGraphQL Routes on the Service

Once the Plugin is activated on a Service, we can add our own routes to build
our service, by defining URIs and associating them to GraphQL queries.

  ```bash
  $ curl -X POST http://localhost:8001/services/github/degraphql/routes \
    --data uri="/me" \
    --data query="query { viewer { login } }"

  $ curl http://localhost:8000/api/me \
    --header "Authorization: Bearer some-token"
  {
      "data": {
          "viewer": {
              "login": "you"
          }
      }
  }
  ```

GraphQL Query Variables can be defined on URIs:

  ```bash
  $ curl -X POST http://localhost:8001/services/github/degraphql/routes \
    --data uri='/:owner/:name' \
    --data query='query ($owner:String! $name:String!){
                    repository(owner:$owner, name:$name) {
                      name
                      forkCount
                      description
                   }
                 }'

  $ curl http://localhost:8000/api/kong/kong \
    --header "Authorization: Bearer some-token"
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

The same Variables can also be provided as GET arguments:

  ```bash
  $ curl -X POST http://localhost:8001/services/github/degraphql/routes \
    --data uri='/repo' \
    --data query='query ($owner:String! $name:String!){
                    repository(owner:$owner, name:$name) {
                      name
                      forkCount
                      description
                    }
                  }'

  $ curl "http://localhost:8000/api/repo?owner=kong&name=kuma" \
    --header "Authorization: Bearer some-token"
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
