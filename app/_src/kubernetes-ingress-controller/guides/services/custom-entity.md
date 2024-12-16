---
title: Using Custom Entities
type: how-to
purpose: |
  How to create custom Kong entities
alpha: true

overrides:
  alpha:
    false:
      gte: 3.4.x
---

{{ site.kic_product_name }} provides an interface to configure {{ site.base_gateway }} entities using CRDs.

Some {{ site.base_gateway }} plugins define custom entities that require configuration. These entities can be configured using the [`KongCustomEntity` resource][kongcustomentity_crd_ref].

{% if_version lte:3.2.x %}
{:.note}
> **Note:** The KongCustomEntity controller is an opt-in feature. You must enable it by
> setting feature gate `KongCustomEntity` to `true` to enable the controller.
{% endif_version %}

The `KongCustomEntity` resource contains a `type` field which indicates the type of Kong entity to create, and a `fields` property which can contain any values that need to be set on an entity.

In the following example, a `degraphql_routes` entity is created with two properties, `uri` and `query`.

```yaml
spec:
  type: degraphql_routes
  fields:
    uri: "/contacts"
    query: "query{ contacts { name } }"
```

This corresponds to the `uri` and `query` parameters documented in the [plugin documentation](/hub/kong-inc/degraphql/#available-endpoints)

[kongcustomentity_crd_ref]: /kubernetes-ingress-controller/{{page.release}}/reference/custom-resources/#kongcustomentity

## Tutorial: DeGraphQL custom entities

{% include /md/kic/prerequisites.md release=page.release disable_gateway_api=false enterprise=true %}

This example configures custom entities for the `degraphql` plugin, which allows you to access a GraphQL endpoint as a REST API.

## Create a GraphQL Service

The `degraphql` plugin requires an upstream GraphQL API. For this tutorial, we'll use [Hasura] to create an example GraphQL service:

[Hasura]: https://hasura.io/

```bash
echo 'apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: hasura
    hasuraService: custom
  name: hasura
  namespace: default
spec:
  replicas: 1
  selector:
    matchLabels:
      app: hasura
  template:
    metadata:
      labels:
        app: hasura
    spec:
      containers:
      - image: hasura/graphql-engine:v2.38.0
        imagePullPolicy: IfNotPresent
        name: hasura
        env:
        - name: HASURA_GRAPHQL_DATABASE_URL
          value: postgres://user:password@localhost:5432/hasura_data
        - name: HASURA_GRAPHQL_ENABLE_CONSOLE
          value: "true"
        - name: HASURA_GRAPHQL_DEV_MODE
          value: "true"
        ports:
        - name: http
          containerPort: 8080
          protocol: TCP
        resources: {}
      - image: postgres:15
        name: postgres
        env:
        - name: POSTGRES_USER
          value: "user"
        - name: POSTGRES_PASSWORD
          value: "password"
        - name: POSTGRES_DB
          value: "hasura_data"
---
apiVersion: v1
kind: Service
metadata:
  labels:
    app: hasura
  name: hasura
  namespace: default
spec:
  ports:
  - protocol: TCP
    port: 80
    targetPort: 8080
  selector:
    app: hasura
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hasura-ingress-console
  annotations:
    konghq.com/strip-path: "true"
spec:
  ingressClassName: kong
  rules:
  - http:
      paths:
      - path: /hasura
        pathType: Prefix
        backend:
          service:
            name: hasura
            port:
              number: 80' | kubectl apply -f -
```

Once the Hasura Pod is running, create an API to return contact details using the Hasura API:

```bash
curl -X POST -H "Content-Type:application/json" -H "X-Hasura-Role:admin" http://${PROXY_IP}/hasura/v2/query -d '{"type": "run_sql","args": {"sql": "CREATE TABLE contacts(id serial NOT NULL, name text NOT NULL, phone text NOT NULL, PRIMARY KEY(id));"}}'
curl -X POST -H "Content-Type:application/json" -H "X-Hasura-Role:admin" http://${PROXY_IP}/hasura/v2/query -d $'{"type": "run_sql","args": {"sql": "INSERT INTO contacts (name, phone) VALUES (\'Alice\',\'0123456789\');"}}'
curl -X POST -H "Content-Type:application/json" -H "X-Hasura-Role:admin" http://${PROXY_IP}/hasura/v1/metadata -d '{"type": "pg_track_table","args": {"schema": "public","name": "contacts"}}'
```

## Configure the degraphql plugin

The degraphql entity requires you to configure a mapping between paths and GraphQL queries. In this example, we'll map the `/contact` path to `query{ contacts { name } }`.

The `KongPlugin` CRD creates a new `degraphql` plugin, and the `KongCustomEntity` CRD attaches the `fields` to the `KongPlugin` in `parentRef`.

```yaml
echo '---
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  namespace: default
  name: degraphql-example
plugin: degraphql
config:
  graphql_server_path: /v1/graphql
---
apiVersion: configuration.konghq.com/v1alpha1
kind: KongCustomEntity
metadata:
  namespace: default
  name: degraphql-route-example
spec:
  type: degraphql_routes
  fields:
    uri: "/contacts"
    query: "query{ contacts { name } }"
  controllerName: kong
  parentRef:
    group: "configuration.konghq.com"
    kind: "KongPlugin"
    name: "degraphql-example"
' | kubectl apply -f -
```

Once the `KongPlugin` is configured, you can attach it to an `Ingress`:

```bash
echo '
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: demo-graphql
  annotations:
    konghq.com/plugins: "degraphql-example"
spec:
  ingressClassName: kong
  rules:
  - http:
      paths:
      - path: /contacts
        pathType: Prefix
        backend:
          service:
            name: hasura
            port:
              number: 80' | kubectl apply -f -
```

## Test the Service with the degraphql Plugin

You can access the `demo-graphql` ingress with the `degraphql`
plugin attached to verify the `degraphql` plugin and `degraphql_routes` entity works:

```bash
  curl http://${PROXY_IP}/contacts
```

The `curl` command should return

```
{"data":{"contacts":[{"name":"Alice"}]}}
```

which matches the data inserted in the previous steps.

{% if_version gte:3.4.x %}

## Troubleshooting
### Invalid `KongCustomEntity` Configuration

Each `KongCustomEntity` is validated against the schema from Kong.
If the configuration is invalid, an `Event` with the reason set to `KongConfigurationTranslationFailed` will be emitted.
The `involvedObject` of this `Event` will be set to the `KongCustomEntity` resource.

For more information on observability with events, see our [events guide][events_guide].

[events_guide]: /kubernetes-ingress-controller/{{page.release}}/production/observability/events
{% endif_version %}
