---
title: Upgrading Kong Ingress Controller
type: how-to
purpose: |
  How do I upgrade the Kong Ingress Controller. Are there any pitfalls?
---

TODO replace all the Kong and KIC mentions with the appropriate docs var
substitution.

This guide walks through the steps needed to upgrade to 3.0.x and later
versions from earlier versions, and covers changes from older versions to help
operators evaluate whether they need to make changes to their configuration. It
also covers creation of a testing environment to test the upgrade.

## Upgrade tasks

### Prerequisites

* [Helm v3][helm] is installed
* You are familiar with Helm `install` and `upgrade` operations. See the [documentation for Helm v3][helm-docs].

[helm]:https://helm.sh/
[chart]:https://github.com/kong/charts
[list-releases]:https://v3.helm.sh/docs/helm/helm_list/
[helm-docs]:https://v3.helm.sh/docs/

### Changes that require user action before upgrading

1. [Upgrade Kong](#minimum-kong-version) to version 3.4.1 or higher.
1. If you are not already using Helm, [switch to
   Helm](#plain-manifests-no-longer-supported) as your deployment mechanism.
1. [Apply the 3.0 CRDs](#update-crds).
1. [Convert KongIngress `route` and `service` fields to annotations](#migrating-route-and-service-settings-to-annotations).
1. [Remove `CombinedRoutes` and `CombinedServices` feature gates](#changes-to-route-and-service-generation) if set.
1. [Remove the KNative feature gate](#knative-support-removed) if set. As
   KNative is no longer supported, you will need to use another controller for
   KNative Ingress resources if you use them.
1. [Remove or rename](#removed-or-renamed-flags) outdated CLI arguments and
   `CONTROLLER_*` environment variables.

### Changes that do not require user action

1. The `expressions` routing engine is [now the default](#expression-routes-in-db-less-mode) for DB-less
   environments.
1. The `console` log format [has changed](#logging-changes).

### Deprecated features that can be changed after upgrading

1. [Convert KongIngress `upstream` fields to KongUpstreamPolicy](#migrating-upstream-configuration).
1. [Replace `kongCredType` field](#credential-Secrets-now-use-labels) with the
   `konghq.com/credential` label.

## Change details

### Update CRDs

Helm does not upgrade CRDs automatically. You must apply the 3.x CRDs prior to
upgrading your releases:

```bash
kubectl kustomize https://github.com/Kong/kubernetes-ingress-controller//config/crd/?v3.0.0 | kubectl apply -f -
```

### Migrate KongIngress configuration

3.0 removes support for the KongIngress `route` and `service` fields and their
subfields.

The KongIngress `upstream` field is now deprecated. The new KongUpstreamPolicy
resource is now available to hold configuration previously handled by this
section, and will become the only option for upstream configuration in an
upcoming release.

#### Migrating route and service settings to annotations

Route (Ingress) and service (Service) configuration fields previously available
in KongIngress are now all handled via [dedicated annotations][annotations].

For example, if you set the `route.https_redirect_status_code` in a
KongIngress, you should now use the `konghq.com/https-redirect-status-code`
annotation on an Ingress or HTTPRoute resource.

##### Migrating header configuration

The [`konghq.com/headers.*` annotation][headers-annotation] uses a special
format to set headers. The string after the `.` in the annotation name is the
header name and the annotation value is the header value. For example, to apply
`x-custom-header-a: example,otherexample` and `x-custom-header-b: example`
headers to requests, KongIngress configuration would look like:

```yaml
route:
  headers:
    x-custom-header-a:
    - example
    - otherexample
    x-custom-header-b:
    - example
```

The equivalent annotation configuration looks like:

```text
konghq.com/headers.x-custom-header-a: example,otherexample
konghq.com/headers.x-custom-header-b: example
```

Note that you cannot apply multiple instances of the same header annotation to
set multiple header values: you must set the CSV format within a single header.

#### Migrating upstream configuration

The `upstream` section of KongIngress resources contains a complex object that
does not easily fit in annotations. 3.x uses the new KongUpstreamPolicy
resource to configure upstream settings. The `spec` field of KongUpstreamPolicy
is the same as the `upstream` section of KongIngress. For example, if you
previously used a KongIngress like:

```yaml
apiVersion: configuration.konghq.com/v1
kind: KongIngress
metadata:
  name: sample-customization
upstream:
  hash_on: header
  hash_on_header: x-lb
  hash_fallback: ip
  algorithm: consistent-hashing
```

You will now use a KongUpstreamPolicy like:

```yaml
apiVersion: configuration.konghq.com/v1beta1
kind: KongUpstreamPolicy
metadata:
  name: sample-customization
spec:
  hashOn: 
    header: x-lb
  hashOnFallback: 
    input: ip
  algorithm: consistent-hashing
```

and apply it to a Service resource with a `konghq.com/upstream-policy:
sample-customization` annotation. TODO confirm annotation, it's not merged yet.

TODO new URL
[annotations]:https://docs.konghq.com/kubernetes-ingress-controller/2.12.x/references/annotations/
[headers-annotation]:https://docs.konghq.com/kubernetes-ingress-controller/2.12.x/references/annotations/#konghqcomheaders

### Changes to route and service generation

TODO we do have an existing section for this at https://github.com/Kong/kubernetes-ingress-controller/blob/main/FEATURE_GATES.md#differences-between-traditional-and-combined-routes
but I expect we want a section here for consistency, and may remove the above
because the gates are no longer available. That section also did not cover
combined services.

The `CombinedRoutes` and `CombinedServices` feature gates have been enabled by
default since versions 2.8.0 and 2.11.0, respectively. 3.x removes these
feature gates and the combined generators are now the only option. You must
remove these flags from the `CONTROLLER_FEATURE_GATES` environment variable if
they are present.

Combined routes groups Ingress and HTTPRoute paths using the same Service into
a single Kong route when possible. Prior to the change to combined routes, an
Ingress with the ruleset

```yaml
rules:
- http:
    paths:
    - path: /one
      pathType: Prefix
      backend:
        service:
          name: service-a
          port:
            number: 80
    - path: /two
      pathType: Prefix
      backend:
        service:
          name: service-a
          port:
            number: 80
    - path: /three
      pathType: Prefix
      backend:
        service:
          name: service-b
          port:
            number: 80
```

would result in three separate Kong routes for each individual path. After the
change, this ruleset results in one route with both `/one` and `/two` paths and
a second route for `/three`.

Combined routes use a revised naming scheme. Ingress routes formerly used a
`<namespace>.<name>.<rule index><path index>` name format (for example,
`default.httpbin.00` for the first (0-indexed) rule's first path on the
`httpbin` Ingress in the `default` namespace), whereas combined routes use a
`<namespace>.<name>.<service>.<hostname>.<port>` scheme (for example,
`default.httpbin.httpbin.ing.example.80` for all paths in the `default/httpbin`
Ingress for the `httpbin` service on port `80` with the hostname `ing.example`).

HTTPRoutes use the same `httproute.<namespace>.<name>.<rule>.<match>` scheme as
before, but the indices are the _first_ rule and match with a given backendRef,
whereas traditional would generate routes for _every_ match. If rule 1 match 2
has the same backendRef as rule 3 match 1, you'll see a single `.1.2` route with
paths from both.

Combined services consolidate services across routing resources. Prior to the
change, KIC generated separate Kong services for every Ingress that used a
Service. After the change, the service generator will generate only a single
Kong service for any use of the `service-a` Service. Kong services previously
used a `<namespace>.<ingress-name>.<service-name>.<port>` naming scheme and now
use a `<namespace>.<service-name>.<port>` naming scheme.


### Expression routes in DB-less mode

Kong 3.0 introduced a new [expression-based routing engine][expression-router]. 
This engine allows KIC to set some match criteria and route matching precedence
not possible under the original Kong routing engine. This functionality is
necessary to implement some aspects of the Gateway API specification.

DB-less configurations in the Helm chart now use the `expressions`
[`router_flavor` kong.conf setting][expression-kong-conf] by default to take
advantage of this functionality. DB-backed configurations use
`traditional_compatible` instead for backwards compatibility, as existing
route configuration from older versions cannot yet be migrated in DB mode.

Use of the new routing engine is should not change route matching outside of
cases where route precedence did not match the [Gateway API
specification][gateway-api-precedence]. The new engine does have different
performance characteristics than the old engine, but should improve matching
and configuration update speed for most configurations.

[expression-router]: https://docs.konghq.com/gateway/latest/key-concepts/routes/expressions/
[expression-kong-conf]: https://github.com/Kong/kong/blob/3.4.2/kong.conf.default#L1589-L1621
[gateway-api-precedence]: https://gateway-api.sigs.k8s.io/reference/spec/#gateway.networking.k8s.io%2fv1.HTTPRouteRule

### KNative support removed

3.0 [removes support for KNative][knative-issue]

[knative-issue]: https://github.com/Kong/kubernetes-ingress-controller/issues/2813

### Logging changes

KIC 3.0 uses a new logging engine to unify the logging implementation across
all its subsystems. Earlier versions used different logging engines in
different subsystems, which led to some logs using a different format than
others and some logs appearing at incorrect log levels.

The new logging system consolidates log levels into `debug`, `info`, and
`error`. Logs that were previously logged at the `warn` level are now logged at
`error`, as the conditions that triggered `warn` level logs were infrequent and
should not occur under normal circumstances. `fatal` and `panic` levels were
available in configuration, but were not actually used.

The new logging system changes the default `console` format. In earlier
versions, console logs used a `key=value` format:

```text
time="2023-09-21T23:07:26Z" level=info msg="the ingress class name has been set" logger=setup value=kong othervalue=pong
```

In 3.0, `console` is a mixture of unlabeled tab-delimited fields (for standard
keys such as timestamp, log level, and log section) and JSON (for fields
specific to individual log entries:

```text
2023-09-22T00:38:16.026Z        info    setup   the ingress class name has been set     {"value": "kong","othervalue":"pong"}
```

The `json` format is unchanged except for the order of fields. Earlier versions
printed fields in alphabetical order:

```json
{"level":"info","logger":"setup","msg":"the ingress class name has been set","time":"2023-09-21T23:15:15Z","value":"kong"}
```

3.0+ prints standard log fields first and entry-specific fields in the order
they were added in code:

```json
{"level":"info","time":"2023-09-22T00:28:13.006Z","logger":"setup","msg":"the ingress class name has been set","value":"kong"}
```

Although the default log setting is still `console`, `json` should be used for
production systems, or any other systems that need machine-parseable logs.

TODO maybe we should just change the default? `console` isn't compatible with
the old format, so there's not much reason to keep it as the default.

### Removed or renamed flags

3.0 removes or renames several flags that were previously deprecated, were
removed due to other changes, or were left over for compatibility after their
functionality was removed.

The CLI argument versions of flags are listed below. You must also change the
equivalent `CONTROLLER_` (for example, `CONTROLLER_SYNC_RATE_LIMIT` for
`--sync-rate-limit`) environment variable if you use those.

* `--sync-rate-limit` is now `--proxy-sync-seconds`.
* `--konnect-runtime-group-id` is now `--konnect-control-plane-id`.
* `--stderrthreshold` and `--debug-log-reduce-redundancy` have been removed
  following changes to the logging system.
* `--log-level` no longer accepts the `warn`, `fatal`, and `panic` values due
  to [consolidation of log levels](#logging-changes).
* `--update-status-on-shutdown` has been removed after its earlier
  functionality was removed.
* `--kong-custom-entities-secret` has been removed after removal of its
  functionality in 2.0.
* `--leader-elect` has been removed. The controller automatically configures
  its leader election mode based on other settings.
* `--enable-controller-ingress-extensionsv1beta1` and
  `--enable-controller-ingress-networkingv1beta1` have been removed following
  removal of support for older Ingress API versions.

### Minimum Kong version

KIC 3.0 requires Kong version 3.4.1 or higher. You must upgrade your Kong
instances to 3.4.1 prior to upgrading to KIC 3.0.

### Plain manifests no longer supported

As of 3.0, the [Helm charts][charts] are the only officially supported install
methods for Kubernetes deployments of KIC and Kong. The plain manifests that
were available at https://github.com/Kong/kubernetes-ingress-controller/blob/main/deploy/single/
are no longer available and are not supported.

TODO we have some changelog entries that are kinda confusing since they
mention individual manifests only for #4866 and #4873

[charts]: https://github.com/Kong/charts/

### Credential Secrets now use labels

Prior to 3.0, credential Secrets used a `kongCredType` field in the Secret to
indicate the Secret type. 3.0 replaces this field with a
`konghq.com/credential` label to allow the admission controller and resource
cache to filter out Secrets that KIC will not use to improve performance and
avoid interference with non-KIC Secret updates.

The `kongCredType` field is now deprecated and will be removed in a future
release.

You can use a simple [jq][jq] and kubectl script to find your credential
Secrets and generate commands to add an appropriate label:

TODO can you wrap jq queries? it'd be nice to split this over lines

```bash
kubectl get secret -A -ojson | jq -r '.items[] | select(.data.kongCredType != null) | "kubectl label secret -n \(.metadata.namespace) \(.metadata.name) konghq.com/credential=\(.data.kongCredType | @base64d )"'
```

Or, if you do not have access to all namespaces (replace `default other` with a
space-separated list of namespaces to search):

```bash
for namespace in default other; do kubectl get secret -n $namespace -ojson | jq -r '.items[] | select(.data.kongCredType != null) | "kubectl label secret -n \(.metadata.namespace) \(.metadata.name) konghq.com/credential=\(.data.kongCredType | @base64d )"'; done
```

Output is a list of kubectl commands to apply the label. For example:

```bash
kubectl label secret -n default consumer-5-key-auth konghq.com/credential=key-auth
kubectl label secret -n other consumer-10-key-auth konghq.com/credential=bee-auth
```

You do not need to remove the `kongCredType` field from Secrets after you have
added the label, but once you have added the label, the label's value will be
used instead of the field's.

[jq]: https://jqlang.github.io/jq/

## Testing environment

TODO this and following sections were copied verbatim from the 2.x upgrade
guide. They're generic and don't mention versions, covering the basics of
setting up kind as a test environment and running Helm upgrade. Dunno if we
want to keep them or not

To avoid issues with the upgrade, run it in a test environment before
deploying it to production. Create a [Kubernetes][k8s] cluster
using the same tools that deployed your production cluster, or use
a local development cluster such as [minikube][minikube] or [kind][kind].

Using Helm, check the deployed chart version:

{% navtabs codeblock %}
{% navtab Command %}

```shell
$ helm list -A
```

{% endnavtab %}
{% navtab Response %}

```shell
NAME               NAMESPACE   STATUS   CHART      APP VERSION
ingress-controller kong-system deployed kong-2.3.0 2.5
```

{% endnavtab %}
{% endnavtabs %}

In the above example, `kong-2.3.0` is the currently deployed chart version.

Using the existing chart version and the `values.yaml` configuration for
your production environment, deploy a copy to your test cluster
with the `--version` flag:

```shell
$ helm install kong-upgrade-testing kong/kong \
  --version ${YOUR_VERSION} \
  -f ${PATH_TO_YOUR_VALUES_FILE}
```
> **Note:** You may need to adjust your chart further to work in a development or
staging environment. See the [Helm chart documentation][chart-docs].
Use this testing environment to walk through the following
[upgrade steps](#upgrade) and ensure there are no problems during the
upgrade process. Once you're satisfied everything is ready,
switch to the production cluster and work through the upgrade steps again.

[k8s]:https://kubernetes.io
[minikube]:https://github.com/kubernetes/minikube
[kind]:https://github.com/kubernetes-sigs/kind
[chart-docs]: https://helm.sh/docs/topics/charts/

## Upgrade

### Configure Helm repository

Check the local `helm` installation to make sure it has the
[Kong Charts Repository][chart] loaded:

{% navtabs codeblock %}
{% navtab Command %}

```shell
helm repo list
```

{% endnavtab %}
{% navtab Response %}

```shell
NAME    URL
kong    https://charts.konghq.com
```

{% endnavtab %}
{% endnavtabs %}

If the repository is not present, add it:

```shell
$ helm repo add kong https://charts.konghq.com
```

Update the repository to pull the latest repository updates:

{% navtabs codeblock %}
{% navtab Command %}

```shell
helm repo update
```

{% endnavtab %}
{% navtab Response %}

```
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "kong" chart repository
Update Complete. ⎈Happy Helming!⎈
```

{% endnavtab %}
{% endnavtabs %}

### Perform the upgrade

Run the following command, specifying the old release name, the namespace where
you've configured {{site.base_gateway}}, and the existing `values.yaml` configuration file:

```shell
$ helm upgrade ${YOUR_RELEASE_NAME} kong/kong \
  --namespace ${YOUR_NAMESPACE} \
  -f ${PATH_TO_YOUR_VALUES_FILE}
```

After the upgrade completes there is a brief period of time before the new
resources are online. You can wait for the relevant Pod resources to complete
by watching them in your release namespace:

```shell
$ kubectl -n ${YOUR_RELEASE_NAMESPACE} get pods -w
```

Once the new pods are in a `Ready` state, the upgrade is complete.

### Rollback

If you run into problems during or after the upgrade, Helm provides a
rollback mechanism to revert to a previous revision of the release:

```shell
$ helm rollback --namespace ${YOUR_RELEASE_NAMESPACE} ${YOUR_RELEASE_NAME}
```

You can wait for the rollback to complete by watching the relevant Pod
resources:

```shell
$ kubectl -n ${YOUR_RELEASE_NAMESPACE} get pods -w
```

After a rollback, if you ran into issues in production,
consider using a [testing environment](#testing-environment) to
identify and correct these issues, or reference the
[troubleshooting documentation][troubleshooting].

[troubleshooting]:/kubernetes-ingress-controller/{{page.kong_version}}/troubleshooting/
[admission]:/kubernetes-ingress-controller/{{page.kong_version}}/deployment/admission-webhook
