## Usage

DeGraphQL needs a GraphQL endpoint to query. As an example, we are going to
build a REST API around the `https://api.github.com` GraphQL service. For that
reason, the following examples include the header `Authorization: Bearer some-token`.

This plugin must be activated on a service that points to a GraphQL endpoint.

### Create a Service and a Route

Create a Service and Route in {{site.base_gateway}}:

```bash
curl -X POST http://localhost:8001/services \
  --data name="github" \
  --data url="https://api.github.com"

curl -X POST http://localhost:8001/services/github/routes \
  --data paths="/api"
```

### Configure the plugin on the Service

Set up the DeGraphQL plugin:

```bash
curl -X POST http://localhost:8001/services/github/plugins \
  --data name="degraphql"
```

Enabling the plugin disables regular service function. Instead, the
plugin now builds the path and GraphQL query to hit the GraphQL service
with.

From this point on, the Service represents
your REST API and not the GraphQL endpoint itself. It will return a `404 Not Found`
status code if no DeGraphQL routes have been configured.

### Configure DeGraphQL Routes on the Service

Once the plugin is activated on a Service, you can add your own routes
by defining URIs and associating them to GraphQL queries.

{:.note}
> Don't include the GraphQL server path prefix in the URI parameter
(`/graphql` by default).

```bash
curl -X POST http://localhost:8001/services/github/degraphql/routes \
  --data uri="/me" \
  --data query="query { viewer { login } }"

curl http://localhost:8000/api/me \
  --header "Authorization: Bearer some-token"
{
    "data": {
        "viewer": {
            "login": "you"
        }
    }
}
```


GraphQL query variables can be defined on URIs:

```bash
curl -X POST http://localhost:8001/services/github/degraphql/routes \
  --data uri='/:owner/:name' \
  --data query='query ($owner:String! $name:String!){
                  repository(owner:$owner, name:$name) {
                    name
                    forkCount
                    description
                 }
               }'

curl http://localhost:8000/api/kong/kong \
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

The same variables can also be provided as `GET` arguments:

```bash
curl -X POST http://localhost:8001/services/github/degraphql/routes \
  --data uri='/repo' \
  --data query='query ($owner:String! $name:String!){
                  repository(owner:$owner, name:$name) {
                    name
                    forkCount
                    description
                  }
                }'

curl "http://localhost:8000/api/repo?owner=kong&name=kuma" \
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

## Available endpoints

**List defined DeGraphQL Routes for a service**

<div class="endpoint get">/services/:service_name/degraphql/routes</div>

**Create a DeGraphQL Route for a Service**

<div class="endpoint post">/services/:service_name/degraphql/routes</div>

| Attribute | Description
| -------------- | -------
|`uri` | Path to map to a GraphQL query.
|`query` | GraphQL query to map to the URI.

**Edit a DeGraphQL Route for a Service**

<div class="endpoint patch">/services/:service_name/degraphql/routes/:id</div>

| Attribute | Description
| -------------- | -------
|`uri` | Path to map to a GraphQL query.
|`query` | GraphQL query to map to the URI.


**Delete a DeGraphQL Route for a Service**

<div class="endpoint delete">/services/:service_name/degraphql/routes/:id</div>
