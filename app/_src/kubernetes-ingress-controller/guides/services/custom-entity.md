---
title: Using Custom Entities
type: how-to
purpose: |
  How to create custom Kong entities
alpha: true
---

This document introduces how to configure a custom Kong entity by the example
of `degraphql_routes` entity and `degraphql` plugin. 
Not all Kong entities are processed in dedicated procedure of KIC. You can
configure Kong entities whose types are not supported in KIC by `KongCustomEntity`
resource: [KongCustomEntity].

**Note** The KongCustomEntity controller is an opt-in feature. You must enable it by
setting feature gate `KongCustomEntity` to `true` to enable the controller.

**Note** The following example uses `degraphql` plugin and `degraphql_routes` entity
which are only available in {{site.ee_product_name}}. So you need to try the example
with {{site.ee_product_name}} installed.

## Create a GraphQL Service

You can use [hasura] to create an example GraphQL service with the following steps:

### Create the deployment,service and the ingress to configure the GraphQL service 

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
      - path: /
        pathType: Prefix
        backend:
          service:
            name: hasura
            port:
              number: 80' | kubectl apply -f -
```

### Configure data provided in GraqhQL service

You can access http://${PROXY_IP}/console to access hasura's console to set up data
for serving GraphQL service following the [steps][hasura_console_steps].

In this step, you can create a `contacts` table under `public` schema including 3 columns:

`id` Integer auto increment; `name` Text; `phone` Text.

Then insert a row: (name = "Alice", phone = "0123456789"). 

Or you can insert data by directly calling the hasura's API:

```bash
  curl -XPOST -H"Content-Type:application/json" -H"X-Hasura-Role:admin" http://${PROXY_IP}/v2/query -d'{"type": "run_sql","args": {"sql": "CREATE TABLE contacts(id serial NOT NULL, name text NOT NULL, phone text NOT NULL, PRIMARY KEY(id));"}}'
  curl -XPOST -H"Content-Type:application/json" -H"X-Hasura-Role:admin" http://${PROXY_IP}/v2/query -d'{"type": "run_sql","args": {"sql": "INSERT INTO contacts (name, phone) VALUES ('Alice','0123456789');"}}' 
  curl -XPOST -H"Content-Type:application/json" -H"X-Hasura-Role:admin" http://${PROXY_IP}/v1/metadata -d'{"type": "pg_track_table","args": {"schema": "public","name": "contacts"}}'
```

## Create degraphql Plugin and degraphql_routes Entity

Then you can create an ingress and attach a `degraphql` plugin and
a `degrpahql_routes` entity to the ingress.

```bash
  echo '# This is the ingress to expose graqhql services. 
# Because we attached the `degraphql` plugin to the ingress, regular route matching is not available.
# So we cannot access the console, then we used two ingresses for console and graphQL service.
# You could use `curl -H"Host:graphql.service.example" http://${PROXY_IP}/...` to test function of degraphql plugin.
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: hasura-ingress-graphql
  annotations:
    konghq.com/strip-path: "true"
    konghq.com/plugins: "degraphql-example"
spec:
  ingressClassName: kong
  rules:
  - host: "graphql.service.example"
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: hasura
            port:
              number: 80
---
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  namespace: default
  name: degraphql-example
plugin: degraphql
config:
  graphql_server_path: /v1/graphql
---
# This route serves endpoint `/contacts` which extracts column `name` of all rows in `contacts` table in your `hasura_data` DB.
# You can use other query in the `query` field for fetching other data.
apiVersion: configuration.konghq.com/v1alpha1
kind: KongCustomEntity
metadata:
  namespace: default
  name: degraphql-route-example
spec:
  controllerName: kong
  type: degraphql_routes
  parentRef:
    group: "configuration.konghq.com"
    kind: "KongPlugin"
    name: "degraphql-example"
  fields:
    uri: "/contacts"
    query: "query{ contacts { name } }"
' | kubectl apply -f -
```

## Test the Service with the degraphql Plugin

You can try to access the `hasura-ingress-graphql` ingress with `degraphql`
plugin attached to verify the `degraphql` plugin and `degraphql_routes` entity works:

```bash
  curl -H"Host:graphql.service.example" http://${PROXY_IP}/contacts
```

The `curl` command should return
```
{"data":{"contacts":[{"name":"Alice"}]}}
```
which matches the data inserted in the previous steps.

[hasura]: https://hasura.io/
[hasura_console_steps]: https://hasura.io/docs/latest/getting-started/docker-simple/#step-2-connect-a-database
<!-- >
Need to be updated when custom resource reference page is updated.
[KongCustomEntity]: /reference/custom-resources/
<-->

