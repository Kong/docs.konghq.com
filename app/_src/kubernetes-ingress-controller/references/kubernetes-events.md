---
title: Kubernetes Events
---

Kubernetes API allows creating events to notify users about changes in the cluster. Events are treated as informative,
best-effort, supplemental data which might be helpful in debugging issues. Some of the built-in events users might be
familiar with are `CrashLoopBackOff`, `ImagePullBackOff`, `FailedScheduling`, etc.
Every event has a set of fields defined in the [Event](https://kubernetes.io/docs/reference/kubernetes-api/cluster-resources/event-v1/#Event) 
API object schema. The most relevant of those in the context of {{site.kic_product_name}} are:

- **Reason** - a short, machine-friendly string that describes the reason for emitting an event, can be treated 
  as a category (e.g. `KongConfigurationTranslationFailed`, `KongConfigurationApplyFailed`, etc.).
- **Message** - a human-readable description of the event with a detailed explanation of what happened (e.g. 
  `invalid methods: cannot set 'methods' when 'protocols' is 'grpc' or 'grpcs'`).
- **Type** - a string that describes the type of the event (e.g. `Warning`, `Normal`, etc.).
- **InvolvedObject** - a reference to the object(s) that the event is about (e.g. `Ingress`, `KongPlugin`, etc.).

## Emitted Events

All the events that are emitted by {{site.kic_product_name}} are listed in the table below.

| Reason                               | Type       | Meaning                                                                                                                                                                         | Involved objects                                                                                                                                                                                                                                            |
|--------------------------------------|------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `KongConfigurationTranslationFailed` | ⚠️ Warning | During the translation of Kubernetes resources into a Kong state, a conflict was detected. The involved object(s) were skipped to unblock building the Kong state without them. | Any of the supported resources (e.g. `Ingress`, `KongPlugin`, `HTTPRoute`, etc.)                                                                                                                                                                            |
| `KongConfigurationApplyFailed`       | ⚠️ Warning | A Kong state built from Kubernetes resources was rejected by the {{site.base_gateway}} Admin API. The update of the configuration was not effective.                            | In the case of a failure caused by a specific object - any of the supported resources (e.g. `Ingress`, `KongPlugin`, `HTTPRoute`, etc.). When a specific causing object couldn't be identified, the event is attached to the {{site.kic_product_name}} Pod. |
| `KongConfigurationSucceeded`         | ℹ️ Normal  | A Kong state built from Kubernetes resources was successfully applied to the {{site.base_gateway}} Admin API.                                                                   | {{site.kic_product_name}} Pod.                                                                                                                                                                                                                              |

## Inspecting Events

Although {{site.kic_product_name}} provides Prometheus metrics to monitor the current state of the configuration translation and application 
processes (`ingress_controller_translation_count`, `ingress_controller_configuration_push_count`, 
see [Prometheus Metrics][prometheus] for details), it's recommended to use the events to get more information
about the root cause of the issue when the metrics indicate that something went wrong.

Events can be inspected using the `kubectl get events` command. Their `reason` field might be used to filter a specific
kind of events (e.g. `KongConfigurationApplyFailed`).

The output of the command will look similar to this:

```shell
kubectl get events --field-selector='reason=KongConfigurationApplyFailed'
LAST SEEN   TYPE       REASON                                 OBJECT                             MESSAGE
1m          Warning    KongConfigurationApplyFailed           KongPlugin/my-plugin               Plugin schema validation failed: invalid value "foo" for field "config"
```

[prometheus]: /kubernetes-ingress-controller/latest/references/prometheus
