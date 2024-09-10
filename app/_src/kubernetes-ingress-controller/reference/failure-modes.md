---
title: Failure Modes and Processing in KIC
type: reference
---

The guides describes different types of {{site.kic_product_name}} failure modes and how it processes them.

When you run {{site.kic_product_name}}, you can encounter the following failures:

| Error Example                    | Failure Mode                               |
|-----------------------------------|-----------------------------------------|
| `Reconciler error` in logs                                     | [Errors in reconciling Kubernetes resources](#errors-in-reconciling-kubernetes-resources)     |
| Non-existent service referenced by an `Ingress`(Example: `Ingress` with non-existent backend service)        | [Failures in translating configuration](#failures-in-translating-configuration)          |
| {{site.base_gateway}} rejected configuration (Example: `Ingress` with invalid regex in the path)      | [Failures in applying configuration to {{site.base_gateway}}](#failures-in-applying-configuration-to-sitebasegateway) |
| Errors when sending configuration to {{site.konnect_product_name}} (Example: Failed request logs)       | [Failures in uploading configuration to {{site.konnect_short_name}}](#failures-in-uploading-configuration-to-sitekonnectproductname) |

{{site.kic_product_name}} uses different methods to process the failures, and will leave error logs or other evidence, like Prometheus metrics and Kubernetes events so you can observe the failures.


## Errors in reconciling Kubernetes resources

When the controllers reconciling a specific kind of Kubernetes resources run into errors in reconciling a Kubernetes resource, a `Reconciler error` line of log is recorded and the resource will be re-queued for another round of reconciliation. Also, the Prometheus metric `controller_runtime_reconcile_errors_total` stores the total number of reconcile errors per controller from the start of {{site.kic_product_name}}. You can find the `Reconciler error` keyword in the {{site.kic_product_name}} container logs to see detailed errors.

## Failures in translating configuration

When {{site.kic_product_name}} finds Kubernetes resources that can't be correctly translated to {{site.base_gateway}} configuration (for example, an `Ingress` is using a non-exist `Service` as its backend), a translation failure is generated with the namespace and name of the objects causing the failure. The Kubernetes objects causing translation failures will not be translated to {{site.base_gateway}} configuration in the translation process. You can use Kubernetes events and Prometheus metrics to observe the translation failures. If {{site.kic_product_name}} is integrated with {{site.konnect_product_name}}, it will report that translation error happened in uploading node status.

{{site.kic_product_name}} collects all translation failures and generates a Kubernetes `Event` with the `Warning` type and the `KongConfigurationTranslationFailed` reason per each causing object in a translation failure. Prometheus metrics could also reflect the statistics of translation failures: 
* `ingress_controller_translation_broken_resource_count` is the number of translation failures that happened in the latest translation
* `ingress_controller_translation_count` with the `success=false` label is the total number of translation procedures where translation failures happen

You can use `kubectl get events -n <namespace> --field-selector reason="KongConfigurationTranslationFailed"` to fetch events generated for translation failures. For example, if an `Ingress` `ing-1` in namespace `test` used a non-exist `Service` as its backend, you can get the event with the following command:

```bash
$ kubectl get events -n test --field-selector reason="KongConfigurationTranslationFailed"

LAST SEEN   TYPE      REASON                               OBJECT                    MESSAGE
18m         Warning   KongConfigurationTranslationFailed   ingress/ing-1   failed to resolve Kubernetes Service for backend: failed to fetch Service test/httpbin-deployment-1: Service test/httpbin-deployment-1 not found
```

## Failures in applying configuration to {{site.base_gateway}}

When {{site.kic_product_name}} fails to apply translated {{site.base_gateway}} configuration to {{site.base_gateway}}, {{site.kic_product_name}} will try to recover from the failure, and also record the failure by logs, Kubernetes events and Prometheus metrics. This usually fails because the translated configuration is rejected by {{site.base_gateway}}.

{{site.kic_product_name}} tries to apply configuration that was previously successfully applied to {{site.base_gateway}} to new instances of {{site.base_gateway}} to achieve best effort for making them available. If the `FallbackConfiguration` feature gate is enabled, {{site.kic_product_name}} discovers the Kubernetes objects that causes the invalid configuration, and tries to build a fallback configuration from valid objects and parts of the last valid configuration that are built from the broken objects. See [fallback configuration][fallback configuration] for more information.

You can observe failures in applying configuration from Kubernetes events and Prometheus metrics. {{site.kic_product_name}} generates an event with the `Warning` type and the `KongConfigurationApplyFailed` reason attached to the pod itself when it fails to apply the configuration. For each object that causes the invalid configuration, {{site.kic_product_name}} will also generate a `Warning` event type and the `KongConfigurationApplyFailed` reason attached to the object. The Prometheus metric `ingress_controller_configuration_push_count` with the `success=false` label shows the total number of failures from applying the configuration by reason and URL of {{site.base_gateway}} admin API. In addition, the `ingress_controller_configuration_push_broken_resource_count` metric reflects the number of Kubernetes resources that caused the error in the last configuration push. If the CLI flag `--dump-config` is enabled, then the `/debug/config/raw-error` endpoint is enabled on the debug server port of {{site.kic_product_name}} which will fetch the raw error returned from {{site.base_gateway}} if applying the configuration fails.

For example, if we create an `Ingress` with the `ImplementationSpecific` path type and an invalid regex in `Path` (this can only be only be done when validating the webhook is disabled, otherwise it will be rejected by the webhook):

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  annotations:
    konghq.com/strip-path: "true"
  name: ingress-invalid-regex
  namespace: default
spec:
  ingressClassName: kong
  rules:
  - http:
      paths:
      - backend:
          service:
            name: httpbin-deployment
            port:
              number: 80
        path: /~^^/a$
        pathType: ImplementationSpecific
```

You can get the Kubernetes events:

```bash
$ kubectl get events --all-namespaces --field-selector reason=KongConfigurationApplyFailed
NAMESPACE   LAST SEEN   TYPE      REASON                         OBJECT                                 MESSAGE
default     2m9s        Warning   KongConfigurationApplyFailed   ingress/ingress-invalid-regex          invalid paths.1: should start with: / (fixed path) or ~/ (regex path)
kong        15s         Warning   KongConfigurationApplyFailed   pod/kong-controller-779cb796f4-7q7c2   failed to apply Kong configuration to https://10.244.1.43:8444: HTTP status 400 (message: "failed posting new config to /config")
```

Both the events attached to the invalid ingress and attached to the {{site.kic_product_name}} pod are recorded. 

## Failures in uploading configuration to {{site.konnect_product_name}}

When {{site.kic_product_name}} is integrated with {{site.konnect_product_name}} and it fails to send configuration to {{site.konnect_product_name}}, it will generate error logs for failed requests and record the failure to Prometheus metrics, and update the node status of itself to {{site.konnect_product_name}}. {{site.kic_product_name}} will parse errors returned from {{site.konnect_product_name}} when uploading the configuration fails and log a line at the error level for each {{site.base_gateway}} entity failed to create/update/delete, with a message `Failed to send request to Konnect`. The Prometheus metric `ingress_controller_configuration_push_count` and `ingress_controller_configuration_push_duration_milliseconds_bucket`can also reflect configuration upload failures to {{site.konnect_product_name}} where the `dataplane` label is the URL of {{site.konnect_product_name}} and `success=false` APIs.

[fallback configuration]: /kubernetes-ingress-controller/{{page.release}}/guides/high-availability/fallback-config