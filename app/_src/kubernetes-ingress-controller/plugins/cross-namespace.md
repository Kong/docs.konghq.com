---
title: Using plugins across namespaces
type: how-to
purpose: |
  Configure plugins in one namespace that interact with resources in another.
---

Plugins can interact with resources across different Kubernetes namespaces.
_KongClusterPlugin_ resources create plugins available for resources in any
namespace, but require cluster-level permissions and may not be appropriate for
all environments. This guide covers the use of _ReferenceGrant_ resources to
grant selective permissions to allow _KongPlugin_ resources in one namespace to
modify resources in another.

> **Note**: This guide requires {{site.kic_product_name}} version 3.2 or higher
> and the [_ReferenceGrant_](https://gateway-api.sigs.k8s.io/api-types/referencegrant/)
> resource definition from the [Gateway API](https://gateway-api.sigs.k8s.io/).
> _ReferenceGrant_ may not be available on all Kubernetes clusters. 

## Example use case

Kim manages [consumers](/kubernetes-ingress-controller/{{page.release}}/reference/custom-resources/#kongconsumer)
for Example Organization. They have permission to the `qyzylorda` namespace and
creates consumers and credentials in it.

Luka manages Example Organization's `httpbin` Service in the `kualalumpur`
namespace. Luka wants to apply different rate limits to different consumers,
but they do not have full access to the `qyzylorda` namespace, and Kim does not
have access to the `kualalumpur` namespace. To manage these limits, Kim can
create _ReferenceGrants_ that permit Luka's _KongPlugins_ in `kualalumpur` to
interact with _KongConsumers_ in `qyzylorda` namespace.

## Create the test environment

Install [{{site.kic_product_name}} and the Gateway APIs](/kubernetes-ingress-controller/{{page.release}}/get-started/).

{:.note}
> This guide requires the Gateway API _ReferenceGrant_ resource, which
> is not available by default on all Kubernetes clusters.
> {{site.kic_product_name}} does support cross-namespace plugin configuration
> with the older Ingress API if ReferenceGrant is installed. This guide only
> demonstrates use of the Gateway API's HTTPRoute resource, but is generally
> applicable to Ingress as well. Example cross-namespace configuration in this
> guide interacts with Service and KongConsumer resources to be routing
> API-agnostic.

## Create namespaces

Create the two test namespaces:

```bash
kubectl create namespace qyzylorda
kubectl create namespace kualalumpur
```

The result should look like:

```text
namespace/qyzylorda created
namespace/kualalumpur created
```

## Create routes and services

Create a Service and Deployment in `kualalumpur`:

```bash
kubectl create -f https://docs.konghq.com/assets/kubernetes-ingress-controller/examples/httpbin-service.yaml -n kualalumpur
```

The result should look like:

```text
service/httpbin created
deployment.apps/httpbin created
```

Create an HTTPRoute to access the Service:

```bash
echo "
apiVersion: gateway.networking.k8s.io/v1
kind: HTTPRoute
metadata:
  name: bintang
  annotations:
    konghq.com/strip-path: 'true'
spec:
  parentRefs:
  - name: kong
  rules:
  - matches:
    - path:
        type: Exact
        value: /bintang
    backendRefs:
    - name: httpbin
      kind: Service
      port: 80
" | kubectl apply -n kualalumpur -f -
```

The result should look like:
```text
httproute.gateway.networking.k8s.io/bintang created
```

Create a authentication plugin:

```bash
echo '
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: httpbin-basic-auth
config:
  hide_credentials: true
plugin: basic-auth
' | kubectl apply -n kualalumpur -f -
```

The result should look like:
```text
kongplugin.configuration.konghq.com/httpbin-basic-auth created
``` 
and attach it to the Service:

```bash
kubectl annotate service httpbin -n kualalumpur konghq.com/plugins=httpbin-basic-auth
``` 

The result should look like:
```text
service/httpbin annotated
``` 

## Create consumers and credentials

Create Secrets to add `basic-auth` credentials for two consumers:

```bash
echo '
---
apiVersion: v1
kind: Secret
metadata:
  name: aygerim-basic-auth
  labels:
    konghq.com/credential: basic-auth
stringData:
    username: aygerim
    password: aygerim-password
---
apiVersion: v1
kind: Secret
metadata:
  name: rustem-basic-auth
  labels:
    konghq.com/credential: basic-auth
stringData:
    username: rustem
    password: rustem-password
' | kubectl apply -n qyzylorda -f -
```

The results should look like:
```text
secret/aygerim-basic-auth created
secret/rustem-basic-auth created
```

Create a consumers named `aygerim` and `rustem` that use these credentials:

{% include /md/kic/consumer.md release=page.release name='aygerim' credName='aygerim-basic-auth' namespace='qyzylorda' %}

{% include /md/kic/consumer.md release=page.release name='rustem' credName='rustem-basic-auth' namespace='qyzylorda' %}

> TODO the addition of namespace here doesn't appear to be taking, and also
> something horrible is happening between the import and markdown handling,
> where the imported code blocks and prose are all being wrapped in code blocks
> for the final render. Import caching maybe screwy?

## Grant cross-namespace permissions

Luka and Kim wants to limit the amount of requests to the `httpbin` Service on
a per-consumer basis.  Because they only have access to their own namespaces,
they need to create rules that allow interactions accross them.

By default, resources that support the [`konghq.com/plugins` annotation](/kubernetes-ingress-controller/{{page.release}}/reference/annotations/#konghqcomplugins)
can only attach plugins in their same namespace. ReferenceGrant resources can
grant permission to use plugins to resources in other namespaces.

To allow this cross-namespace interaction, Kim asks Luka to create a
ReferenceGrant in `kualalumpur` that allows KongConsumers in `qyzylorda` to use
KongPlugins in `kualalumpur`:

```bash
echo '
apiVersion: gateway.networking.k8s.io/v1beta1
kind: ReferenceGrant
metadata:
  name: qyzylorda-rate-limit
  namespace: kualalumpur
spec:
  from:
  - group: "configuration.konghq.com"
    kind: KongConsumer
    namespace: qyzylorda
  to:
  - group: "configuration.konghq.com"
    kind: KongPlugin
' | kubectl apply -f -
```

The results should look like:
```text
referencegrant.gateway.networking.k8s.io/qyzylorda-rate-limit created
```

Such ReferenceGrants allow the `from` resource (KongConsumers in the `qyzylorda`
namespace) to interact with KongPlugins in the ReferenceGrant's namespace
(`kualalumpur`).

## Create the cross-namespace plugins

With the ReferenceGrant in place, Luka can create the `rate-limiting`
KongPlugins:

```bash
echo '
---
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: rate-limit-aygerim
  annotations:
    kubernetes.io/ingress.class: kong
config:
  minute: 10
  policy: local
plugin: rate-limiting
---
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: rate-limit-rustem
  annotations:
    kubernetes.io/ingress.class: kong
config:
  minute: 5
  policy: local
plugin: rate-limiting
' | kubectl apply -f - -n kualalumpur
```

The result should look like:
```text
kongplugin.configuration.konghq.com/rate-limit-aygerim created
kongplugin.configuration.konghq.com/rate-limit-rustem created
``` 

## Attach the plugins to their resources

> TODO we probably have a bit of a pickle here: you can't have two of the same
> type of plugin attached to a given resource, and you can't create the
> associations in a single apply because they need to be applied by different
> users. The order of events here is thus quite persnickety:
> - If you attach the plugins to the consumers first, as this does, it will
>   apply to _all_ their requests initially, not just those to the
>   `kualalumpur/httpbin` Service.
> - If you reverse the order, and apply the annotations to the Service first,
>   you'll be attempting to apply two of the same kind of plugin to a single
>   resource, which is invalid. This will either cause a lock-up or trigger an
>   admission webhook block (IIRC we have a check that tries to see if you've
>   requested multiple of the same plugin) because we want to pretend that
>   eventual consistency isn't a property of Kubernetes by design :facepalm:
>
> You can maybe dance around this by annotating first and creating the plugins
> after (the missing plugins will be ignored AFAIK), but the level of knowledge
> you need to not trigger badness is obscene and rather unintuitive. Hurray
> conflicting models!

{:.note}
> In practice, you would likely not manually apply plugin configuration first
> to the KongConsumers and second to the Services while they are live, as doing
> so creates a window of time where the limits apply to _all_ requests from
> those consumers, not just requests to the relevant Service. This guide does
> so to demonstrate creation of the necessary configuration in separate steps.
>
> In a real-world scenario, you should consider either managing configuration
> out of band (via externally-managed configuration deployed to the cluster via
> a continuous deployment system), during an outage window, or before the
> services or consumers are put into live use.

With the plugins in place, each namespace administrator can attach them to the
resources in their respective namespaces.

Kim attaches the plugins to the KongConsumers in `qyzylorda`. They use the
`<namespace>:<kongplugin-resource-name>` format in the plugin name to indicate
that the requested KongPlugin resides in another namespace:

```bash
kubectl annotate kongconsumer aygerim -n qyzylorda konghq.com/plugins=kualalumpur:rate-limit-aygerim
kubectl annotate kongconsumer rustem -n qyzylorda konghq.com/plugins=kualalumpur:rate-limit-rustem
``` 

The result should look like:

```text
kongconsumer.configuration.konghq.com/aygerim annotated
kongconsumer.configuration.konghq.com/rustem annotated
``` 

Luka attaches the plugins to the `httpbin` Service in `kualalumpur`:

```bash
kubectl annotate service httpbin --overwrite -n kualalumpur konghq.com/plugins=httpbin-basic-auth,rate-limit-aygerim,rate-limit-rustem
``` 

Note that this command overrides the entire plugin annotation, so it needs to
include the `httpbin-basic-auth` plugin from earlier in the list, not just the
new rate limiting plugins.

The result should look like:

```text
service/httpbin annotated
``` 

## Test the configuration

Send a request using the `aygerim` consumer:

```bash
curl -sv $PROXY_IP/bintang/status/200 -u aygerim:aygerim-password 2>&1 | grep "X-RateLimit-Remaining-Minute"
```
The results should show the remaining limit expected for `aygerim`. Since
`aygerim` can send 10 requests per minute, and has sent 1, the response should
indicate there are 9 requests remaining:

```text
< X-RateLimit-Remaining-Minute: 9
```

Send a request using the `rustem` consumer:

```bash
curl -sv $PROXY_IP/bintang/status/200 -u rustem:rustem-password 2>&1 | grep "X-RateLimit-Remaining-Minute"
```
The results should show the remaining limit expected for `rustem`. Since
`rustem` can send 5 requests per minute, and has sent 1, the response should
indicate there are 4 requests remaining:

```text
< X-RateLimit-Remaining-Minute: 4
```
