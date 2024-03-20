---
title: Kong Gateway Operator Changelog
no_version: true
---

Changelog for supported {{ site.kgo_product_name }} versions.

## 1.2.1

**Release Date** 2024/03/20

### Fixes

* Fixed an issue where operator wasn't able to update `ControlPlane` `ClusterRole` or `ClusterRoleBinding`
  when they got out of date.
* Add missing watch RBAC policy rule for cert-manager's Certificate resources

### Changes

* KGO now uses `GATEWAY_OPERATOR_` prefix for all flags, including the `zap` related logging flags.

## 1.2.0

**Release Date** 2024/03/15

## Highlights

* 🎓 The Managed `Gateway`s feature is now GA.
* 🎓 `ControlPlane` and `GatewayConfig` APIs have been promoted to `v1beta1`.
* ✨ `DataPlane`s managed by `Gateway`s can be now scaled horizontally through the
  `GatewayConfiguration` API.
* ✨ `Gateway` listeners are dynamically mapped to the `DataPlane` proxy service ports.
* 🧠 The new feature `AIGateway` has been released in `alpha` stage.
* ✨ {{site.kgo_product_name}} exposes metrics with latency that can be used for autoscaling of your workloads.
* ✨ Automated handling of certificates for Konnect's PKI mode with cert-manager.

## Added

* Added support for specifying command line flags through environment
  variables having the `GATEWAY_OPERATOR_` prefix.
* Add horizontal autoscaling for `DataPlane`s using its `scaling.horizontal` spec
  field.
* `ControlPlane`s now use Gateway Discovery by default, with Service DNS Strategy.
  Additionally, the `DataPlane` readiness probe has been changed to `/status/ready`
  when the `DataPlane` is managed by a `Gateway`.
* `Gateway`s and `Listener`s `Accepted` and `Conflicted` conditions are now set
  and enforced based on the Gateway API specifications.
* `ControlPlane` `ClusterRole`s and `ClusterRoleBinding`s are enforced and kept
  up to date by the `ControlPlane` controller.
* The `Gateway` listeners are now dynamically mapped to `DataPlane` ingress service
  ports. This means that the change of a `Gateway` spec leads to a `DataPlane` reconfiguration,
  along with an ingress service update.
* `--enable-controller-gateway` and `--enable-controller-controlplane` command
  line flags are set to `true` by default to enable controllers for `Gateway`s
  and `ControlPlane`s.
* When the `Gateway` controller provisions a `ControlPlane`, it sets the `CONTROLLER_GATEWAY_TO_RECONCILE`
  env variable to let the `ControlPlane` reconcile
  that specific `Gateway` only.
* `ControlPlane` is now deployed with a validating webhook server turned on. This
  involves creating `ValidatingWebhookConfiguration`, a `Service` that exposes the
  webhook and a `Secret` that holds a TLS certificate. The `Secret` is mounted in
  the `ControlPlane`'s `Pod` for the webhook server to use it.
* Added `konnectCertificate` field to the DataPlane resource.
* Added `v1alpha1.AIGateway` as an experimental API. This can be enabled by
  manually deploying the `AIGateway` CRD and enabling the feature on the
  controller manager with the `--enable-controller-aigateway` flag.
* Added validation on checking if ports in `KONG_PORT_MAPS` and `KONG_PROXY_LISTEN`
  environment variables of deployment options in `DataPlane` match the `ports`
  in the ingress service options of the `DataPlane`.
* Support for KongLicense CRD to manage {{site.ee_product_name}} licenses.
* New ControlPlane extensions controller to manage control plane extensions with initial support for `DataPlaneMetricsExtension`.
* DataPlane Prometheus metrics scrapping support for `DataPlaneMetricsExtension`.
* DataPlane resources can provision cert-manager Certificate resources from a (Cluster) Issuer for use with Konnect's PKI mode.
* ControlPlane extensions controller now checks for a valid Kong enterprise license.

### Changes

* The `GatewayConfiguration` API has been promoted from `v1alpha1` to `v1beta1`.
* The `ControlPlane` API has been promoted from `v1alpha1` to `v1beta1`.
* The CRD's short names of `ControlPlane`, `DataPlane` and `GatewayConfiguration`
  has been changed to `kocp`, `kodp` and `kogc`.
* `ControlPlane` ({{site.kic_product_name}}) default and minimum version has been
  bumped to 3.1.2.
* `DataPlane` ({{site.base_gateway}}) default version has been bumped to `v3.6.0`.

### Fixes

* Fixed a problem where the operator would not set the defaults to `PodTemplateSpec`
  patch and because of that it would detect a change and try to reconcile the owned
  resource where in fact the change was not there.
  One of the symptoms of this bug could have been a `StartupProbe` set in `PodSpec`
  preventing the `DataPlane` from getting correct status information.
* If the Gateway controller is enabled, `DataPlane` and `ControlPlane` controllers
  get enabled as well.
* Fix applying the `PodTemplateSpec` patch so that it's not applied when the
  calculated patch (resulting from the generated manifest and current in-cluster
  state) is empty.
  One of the symptoms of this bug was that when users tried to apply a `ReadinessProbe`
  which specified a port name instead of a number (which is what's generated by
  the operator) it would never reconcile and the status conditions would never get
  up to date `ObservedGeneration`.
* Fix manager RBAC permissions which prevented the operator from being able to
  create `ControlPlane`'s `ClusterRole`s, list pods or list `EndpointSlices`.
* `DataPlane`s with BlueGreen rollout strategy enabled will now have its Ready status
  condition updated to reflect "live" `Deployment` and `Service`s status.
* The `ControlPlane` `election-id` has been changed so that every `ControlPlane`
  has its own `election-id`, based on the `ControlPlane` name. This prevents `pod`s
  belonging to different `ControlPlane`s from competing for the same lease.
* Fill in the defaults for `env` and `volumes` when comparing the in-cluster spec
  with the generated spec.
* Do not flap `DataPlane`'s `Ready` status condition when e.g. ingress `Service`
  can't get an address assigned and `spec.network.services.ingress.`annotations`
  is non-empty.
* Update or recreate a `ClusterRoleBinding` for control planes if the existing
  one does not contain the `ServiceAccount` used by `ControlPlane`, or
  `ClusterRole` is changed.
* Retry reconciling `Gateway`s when provisioning owned `DataPlane` fails.

## 1.1.0

**Release Date** 2023/11/20

### Added

* Add support for `ControlPlane` `v3.0` by updating the generated `ClusterRole`.

### Changes

* Bump `ControlPlane` default version to `v3.0`.
* Bump Gateway API to v1.0.

### Fixes

* Operator `Role` generation is fixed. As a result it contains now less rules
  hence the operator needs less permissions to run.

## 1.0.3

**Release Date** 2023/11/06

### Fixes

* Fix an issue where operator is upgraded from an older version and it orphans
  old `DataPlane` resources.

### Added

* Setting `spec.deployment.podTemplateSpec.spec.volumes` and
  `spec.deployment.podTemplateSpec.spec.containers[*].volumeMounts` on `ControlPlane`s
  is now allowed.

## 1.0.2

**Release Date** 2023/10/18

### Changed

* Bump dependencies

## 1.0.1

**Release Date** 2023/10/02

### Fixes

* Fix flapping of `Gateway` managed `ControlPlane` `spec` field when applied without `controlPlaneOptions` set.

### Changes

* Bump `ControlPlane` default version to `v2.12`.
* Bump `WebhookCertificateConfigBaseImage` to `v1.3.0`.

## 1.0.0

**Release Date** 2023/09/27

### Features

* Deploy and configure {{ site.base_gateway }} services
* Customise deployments using `PodTemplateSpec` to deploy sidecars, set node affinity and more.
* Upgrade Data Planes using a rolling restart or blue/green deployments
