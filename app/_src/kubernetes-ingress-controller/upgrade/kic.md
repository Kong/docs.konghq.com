---
title: Upgrading Kong Ingress Controller
type: how-to
purpose: |
  How do I upgrade the Kong Ingress Controller. Are there any pitfalls?
---

## Upgrade {{ site.kic_product_name }}

{:.important}
> If you are upgrading to {{ site.kic_product_name }}, read the [upgrading to 3.0 section first](#upgrade-30)

### Prerequisites

1.  Ensure that you installed {{ site.kic_product_name }} 3.0, using [Helm](https://github.com/Kong/charts/).

1. Fetch the latest version of the Kong Helm chart using `helm repo update`.

1. Update your `values.yaml` file to use the latest version of {{ site.kic_product_name }}. The values to set are different depending on if you've installed with the `kong/ingress` chart or the `kong/kong` chart. You can find which chart you're using by running `helm list -A -o yaml | grep chart`.

{% capture the_code %}
{% navtabs %}
{% navtab kong/ingress %}
```yaml
controller:
  ingressController:
    image:
      tag: {{ site.data.kong_latest_KIC.release }}
```
{% endnavtab %}
{% navtab kong/kong %}
```yaml
ingressController:
  image:
    tag: {{ site.data.kong_latest_KIC.version }}
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

### Upgrade

Run the following command, specifying the old release name, the namespace where
you've configured {{site.base_gateway}}, and the existing `values.yaml` configuration file.

{% navtabs %}
{% navtab kong/ingress %}
```shell
$ helm upgrade ${YOUR_RELEASE_NAME} kong/ingress \
  --namespace ${YOUR_NAMESPACE} \
  -f ./values.yaml
```
{% endnavtab %}
{% navtab kong/kong %}
```shell
$ helm upgrade ${YOUR_RELEASE_NAME} kong/kong \
  --namespace ${YOUR_NAMESPACE} \
  -f ./values.yaml
```
{% endnavtab %}
{% endnavtabs %}

After the upgrade completes there is a brief period of time before the new
resources are online. You can wait for the relevant Pod resources to complete
by watching them in your release namespace:

```shell
$ kubectl -n ${YOUR_RELEASE_NAMESPACE} get pods -w
```

Once the new pods are in a `Ready` state, the upgrade is complete.

### Rollback

If you run into problems during or after the upgrade, Helm provides a rollback mechanism to revert to a previous revision of the release.

```shell
$ helm rollback --namespace ${YOUR_RELEASE_NAMESPACE} ${YOUR_RELEASE_NAME}
```

You can wait for the rollback to complete by watching the relevant Pod resources:

```shell
$ kubectl -n ${YOUR_RELEASE_NAMESPACE} get pods -w
```

After a rollback, if you run into issues in production, consider using a testing environment to identify and correct these issues, or reference the [troubleshooting documentation](/kubernetes-ingress-controller/{{page.release}}/reference/troubleshooting/).

## Upgrade to {{ site.kic_product_name }} 3.0 {#upgrade-30}

1. **Switch to Helm as your deployment mechanism.**

    As of {{ site.kic_product_name }} 3.0, [Helm](https://github.com/Kong/charts/) is the only officially supported install method.

1. **Upgrade Kong to version 3.4.1 or later.**

    {{ site.kic_product_name }} 3.0 requires Kong version 3.4.1 or later. You must upgrade your Kong instances to 3.4.1 before you upgrade to {{ site.kic_product_name }} 3.0.

1. **Update the {{ site.kic_product_name }} CRDs.**

    Helm does not upgrade CRDs automatically. You must apply the 3.x CRDs before you upgrade your releases.

    ```bash
    kubectl kustomize https://github.com/Kong/kubernetes-ingress-controller//config/crd/?v3.0.0 | kubectl apply -f -
    ```

1. **Convert `KongIngress` `route` and `service` fields to annotations.**

    Route (Ingress) and service (Service) configuration fields previously available in KongIngress are now all handled via [dedicated annotations][annotations] and will not be respected if set in `KongIngress`.

    For example, if you set the `route.https_redirect_status_code` in a `KongIngress` resource, you should now use the `konghq.com/https-redirect-status-code` annotation on an Ingress or HTTPRoute resource.

1. **Remove the `CombinedRoutes` and `CombinedServices` feature gates if set.**

    The `CombinedRoutes` and `CombinedServices` feature gates have been enabled by default since versions 2.8.0 and 2.11.0, respectively. Version 3.x removes these feature gates and the combined generators are now the only option. You must remove these flags from the `CONTROLLER_FEATURE_GATES` environment variable if they are present.

1. **Remove the `Knative` feature gate if set.**

    As KNative is [no longer supported](https://github.com/Kong/kubernetes-ingress-controller/issues/2813), you need to use another controller for KNative Ingress resources if you use them.

1. **Remove or rename outdated CLI arguments and `CONTROLLER_*` environment variables.**

    Version 3.0 removes or renames several flags that were previously deprecated, were
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

### Notable changes

The following changes are not considered breaking changes. However, they are notable changes from the previous version and are documented here for completeness.

#### Expression Router

Kong 3.0 introduced a new [expression-based routing engine][expression-router]. This engine allows {{ site.kic_product_name }} to set some match criteria and route matching precedence not possible under the original Kong routing engine. This functionality is necessary to implement some aspects of the Gateway API specification.

DB-less configurations in the Helm chart now use the `expressions` [`router_flavor` kong.conf setting][expression-kong-conf] by default to take advantage of this functionality. DB-backed configurations use `traditional_compatible` instead for backwards compatibility, as existing route configuration from older versions cannot yet be migrated in DB mode.

Use of the new routing engine should not change route matching outside of cases where route precedence did not match the [Gateway API specification][gateway-api-precedence]. The new engine does have different performance characteristics than the old engine, but should improve matching and configuration update speed for most configurations.

[expression-router]: https://docs.konghq.com/gateway/latest/key-concepts/routes/expressions/
[expression-kong-conf]: https://github.com/Kong/kong/blob/3.4.2/kong.conf.default#L1589-L1621
[gateway-api-precedence]: https://gateway-api.sigs.k8s.io/reference/spec/#gateway.networking.k8s.io%2fv1.HTTPRouteRule

#### Logging changes

{{ site.kic_product_name }} 3.0 uses a new logging engine to unify the logging implementation across
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

[annotations]:/kubernetes-ingress-controller/{{ page.release }}/reference/annotations/