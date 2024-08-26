---
title: Failure Modes and Processing in {{site.kic_product_name}}
type: reference
purpose: |
  What categories of failures would happen in {{site.kic_product_name}} running ? How would them be processed?
---

Different kinds of failures could happen during the running of {{site.kic_product_name}}, including fetching kubernetes resources, translating kubernetes resources to Kong configuration, applying configuration to {{site.gateway_product_name}}, uploading configuration and status of nodes to {{site.konnect_product_name}}. {{site.kic_product_name}} will use different methods to process the failures, and leave error logs or other evidences like prometheus metrics and kubernetes events for observing the failures.

The article will introduce possible categories of failures could happen and how {{site.kic_product_name}} will process them.

## Errors in Reconciling Kubernetes Resources

When the controllers reconciling a specific kind of kubernetes resources run into errors in reconciling a kubernetes resource, a `Reconciler error` line of log will be recorded and the resource will be re-queued for another round of reconciliation. Also, prometheus metric `controller_runtime_reconcile_errors_total` stores the total number of reconcile errors per controller from start of {{site.kic_product_name}}. You can find keyword `Reconciler error` in logs of {{site.kic_product_name}} container to see detailed errors of them.

## Failures in Translating Configuration

When {{site.kic_product_name}} found kubernetes resources that can not be correctly translated to Kong configuration (For example, an `Ingress` used a non-exist `Service` as its backend), a translation failure is generated with namespace and name of objects causing the failure. The kubernetes objects causing translation failures will not be translated to Kong configuration in the translation process. Kubernetes events and prometheus metrics could help to observe the translation failures. If {{site.kic_product_name}} is integrated with {{site.konnect_product_name}}, it will report that translation error happened in uploading node status.

{{site.kic_product_name}} collects all translation failures and generate a kubernetes `Event` with `Warning` type and `KongConfigurationTranslationFailed` reason per each causing object in a translation failure. Prometheus metrics could also reflect the statics of translation failures: `ingress_controller_translation_broken_resource_count` is the count of translation failures happened in the latest translation, and `ingress_controller_translation_count` with label `success=false` is the total number of translation procedures where translation failures happen.

You can use `kubectl get events -n <namespace> --field-selector reason="KongConfigurationTranslationFailed"` to fetch events generated for translation failures. For example, if an `Ingress` `ing-1` in namespace `test` used a non-exist `Service` as its backend, you can get the event by the following command:

```bash
$ kubectl get events -n test --field-selector reason="KongConfigurationTranslationFailed"

LAST SEEN   TYPE      REASON                               OBJECT                    MESSAGE
18m         Warning   KongConfigurationTranslationFailed   ingress/ing-1   failed to resolve Kubernetes Service for backend: failed to fetch Service test/httpbin-deployment-1: Service test/httpbin-deployment-1 not found
```

## Failures in Applying Configuration to {{site.gateway_product_name}}

When {{site.kic_product_name}} failed to apply translated Kong configuration to {{site.gateway_product_name}} (usually because the translated configuration is rejected by {{site.gateway_product_name}}), {{site.kic_product_name}} will try to recover from the failure, and also record the failure by logs, kubernetes events and prometheus metrics.

{{site.kic_product_name}} would try to apply configuration that was previously successfully applied to {{site.gateway_product_name}} to new instances of {{site.gateway_product_name}} to achieve best effort for making them available. If feature gate `FallbackConfiguration` is enabled, {{site.kic_product_name}} would discover the kubernetes objects that causes the configuration invalid, and try to build a fallback configuration from valid objects and parts of last valid configuration that are built from the broken objects. See [fallback configuration][fallback configuration] for reference.

You can observe failures in applying configuration from kubernetes events and prometheus metrics. {{site.kic_product_name}}  will generate an event with `Warning` type and `KongConfigurationApplyFailed` reason attached to the pod itself when failed to apply configuration. For each object that causes the configuration invalid, {{site.kic_product_name}} will also generate an event `Warning` type and `KongConfigurationApplyFailed` reason attached to the object. The prometheus metric `ingress_controller_configuration_push_count` with label `success=false` shows the total number of configuration applying failures by reason and URL of {{site.gateway_product_name}} admin API, and metric `ingress_controller_configuration_push_broken_resource_count` could reflect the number of kubernetes resources that caused error in the last configuration push. If the CLI flag `--dump-config` is enabled, The endpoint `/debug/config/raw-error` is enabled on the debug server port of {{site.kic_product_name}} to fetch the raw error returned from {{site.gateway_product_name}} if applying configuration failed.

For example, if we create an `Ingress` with `ImplementationSpecific` path type and an invalid regex in `Path` (This can only be done only when validating webhook is disabled. Otherwise it will be rejected by the webhook.):

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

You can get the kubernetes events by the following command:

```bash
$ kubectl get events --all-namespaces --field-selector reason=KongConfigurationApplyFailed
NAMESPACE   LAST SEEN   TYPE      REASON                         OBJECT                                 MESSAGE
default     2m9s        Warning   KongConfigurationApplyFailed   ingress/ingress-invalid-regex          invalid paths.1: should start with: / (fixed path) or ~/ (regex path)
kong        15s         Warning   KongConfigurationApplyFailed   pod/kong-controller-779cb796f4-7q7c2   failed to apply Kong configuration to https://10.244.1.43:8444: HTTP status 400 (message: "failed posting new config to /config")
```

Both events attached to the invalid ingress and attached to the {{site.kic_product_name}} pod are recorded. 

## Failures in Uploading Configuration to {{site.konnect_product_name}}

When {{site.kic_product_name}} is integrated with {{site.konnect_product_name}} and it failed to send configuration to {{site.konnect_product_name}}, it will generate error logs for failed requests and record the failure to prometheus metrics, and update the node status of itself to {{site.konnect_product_name}}. {{site.kic_product_name}} will parse errors returned from {{site.konnect_product_name}} on failure of uploading configuration and log a line with error level for each Kong entity failed to create/update/delete, with a message `Failed to send request to Konnect`. The prometheus metric `ingress_controller_configuration_push_count` and `ingress_controller_configuration_push_duration_milliseconds_bucket` with the value of label `dataplane` being the URL of {{site.konnect_product_name}} and `success=false` APIs can also reflect failures of uploading configuration to {{site.konnect_product_name}}.

[fallback configuration]: /kubernetes-ingress-controller/{{page.release}}/guides/high-availability/fallback-config