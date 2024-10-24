---
title: Kong Gateway Operator Changelog
no_version: true
---

Changelog for supported {{ site.kgo_product_name }} versions.

## 1.4.0

**Release Date** TBA

### Added

- Proper `User-Agent` header is now set on outgoing HTTP requests.
  [#387](https://github.com/Kong/gateway-operator/pull/387)
- Introduce `KongPluginInstallation` CRD to allow installing custom Kong
  plugins distributed as container images.
  [#400](https://github.com/Kong/gateway-operator/pull/400), [#424](https://github.com/Kong/gateway-operator/pull/424), [#474](https://github.com/Kong/gateway-operator/pull/474), [#560](https://github.com/Kong/gateway-operator/pull/560), [#615](https://github.com/Kong/gateway-operator/pull/615), [#476](https://github.com/Kong/gateway-operator/pull/476)
- Extended `DataPlane` API with a possibility to specify `PodDisruptionBudget` to be
  created for the `DataPlane` deployments via `spec.resources.podDisruptionBudget`.
  [#464](https://github.com/Kong/gateway-operator/pull/464)
- Add `KonnectAPIAuthConfiguration` reconciler.
  [#456](https://github.com/Kong/gateway-operator/pull/456)
- Add support for Konnect tokens in `Secrets` in `KonnectAPIAuthConfiguration`
  reconciler.
  [#459](https://github.com/Kong/gateway-operator/pull/459)
- Add `KonnectControlPlane` reconciler.
  [#462](https://github.com/Kong/gateway-operator/pull/462)
- Add `KongService` reconciler for Konnect control planes.
  [#470](https://github.com/Kong/gateway-operator/pull/470)
- Add `KongUpstream` reconciler for Konnect control planes.
  [#593](https://github.com/Kong/gateway-operator/pull/593)
- Add `KongConsumer` reconciler for Konnect control planes.
  [#493](https://github.com/Kong/gateway-operator/pull/493)
- Add `KongRoute` reconciler for Konnect control planes.
  [#506](https://github.com/Kong/gateway-operator/pull/506)
- Add `KongConsumerGroup` reconciler for Konnect control planes.
  [#510](https://github.com/Kong/gateway-operator/pull/510)
- Add `KongCACertificate` reconciler for Konnect CA certificates.
  [#626](https://github.com/Kong/gateway-operator/pull/626)
- Add `KongCertificate` reconciler for Konnect Certificates.
  [#643](https://github.com/Kong/gateway-operator/pull/643)
- Added command line flags to configure the certificate generator job's images.
  [#516](https://github.com/Kong/gateway-operator/pull/516)
- Add `KongPluginBinding` reconciler for Konnect Plugins.
  [#513](https://github.com/Kong/gateway-operator/pull/513), [#535](https://github.com/Kong/gateway-operator/pull/535)
- Add `KongTarget` reconciler for Konnect Targets.
  [#627](https://github.com/Kong/gateway-operator/pull/627)
- Add `KongVault` reconciler for Konnect Vaults.
  [#597](https://github.com/Kong/gateway-operator/pull/597)
- Add `KongKey` reconciler for Konnect Keys.
  [#646](https://github.com/Kong/gateway-operator/pull/646)
- Add `KongKeySet` reconciler for Konnect KeySets.
  [#657](https://github.com/Kong/gateway-operator/pull/657)
- Add `KongDataPlaneClientCertificate` reconciler for Konnect DataPlaneClientCertificates.
  [#694](https://github.com/Kong/gateway-operator/pull/694)
- The `KonnectExtension` CRD has been introduced. Such a CRD can be attached
  to a `DataPlane` via the extensions field to have a konnect-flavored `DataPlane`.
  [#453](https://github.com/Kong/gateway-operator/pull/453),
  [#578](https://github.com/Kong/gateway-operator/pull/578),
  [#736](https://github.com/Kong/gateway-operator/pull/736)
- Entities created in Konnect are now labeled (or tagged for those that does not
  support labels) with origin Kubernetes object's metadata: `k8s-name`, `k8s-namespace`,
  `k8s-uid`, `k8s-generation`, `k8s-kind`, `k8s-group`, `k8s-version`.
  [#565](https://github.com/Kong/gateway-operator/pull/565)
- Add `KongService`, `KongRoute`, `KongConsumer`, and `KongConsumerGroup` watchers
  in the `KongPluginBinding` reconciler.
  [#571](https://github.com/Kong/gateway-operator/pull/571)
- Annotating the following resource with the `konghq.com/plugins` annotation results in
  the creation of a managed `KongPluginBinding` resource:
  - `KongService` [#550](https://github.com/Kong/gateway-operator/pull/550)
  - `KongRoute` [#644](https://github.com/Kong/gateway-operator/pull/644)
  - `KongConsumer` [#676](https://github.com/Kong/gateway-operator/pull/676)
  - `KongConsumerGroup` [#684](https://github.com/Kong/gateway-operator/pull/684)
    These `KongPluginBinding`s are taken by the `KongPluginBinding` reconciler
    to create the corresponding plugin objects in Konnect.
- `KongConsumer` associated with `ConsumerGroups` is now reconciled in Konnect by removing/adding
  the consumer from/to the consumer groups.
  [#592](https://github.com/Kong/gateway-operator/pull/592)
- Add support for `KongConsumer` credentials:
  - basic-auth [#625](https://github.com/Kong/gateway-operator/pull/625)
  - API key [#635](https://github.com/Kong/gateway-operator/pull/635)
  - ACL [#661](https://github.com/Kong/gateway-operator/pull/661)
  - JWT [#678](https://github.com/Kong/gateway-operator/pull/678)
  - HMAC Auth [#687](https://github.com/Kong/gateway-operator/pull/687)
- Add support for `KongRoute`s bound directly to `KonnectGatewayControlPlane`s (serviceless routes).
  [#669](https://github.com/Kong/gateway-operator/pull/669)
- Allow setting `KonnectGatewayControlPlane`s group membership
  [#697](https://github.com/Kong/gateway-operator/pull/697)
- Apply Konnect-related customizations to `DataPlane`s that properly reference `KonnectExtension`
  resources.
  [#714](https://github.com/Kong/gateway-operator/pull/714)
- The KonnectExtension functionality is enabled only when the `--enable-controller-konnect`
  flag or the `GATEWAY_OPERATOR_ENABLE_CONTROLLER_KONNECT` env var is set.
  [#738](https://github.com/Kong/gateway-operator/pull/738)

### Fixed

- Fixed `ControlPlane` cluster wide resources not migrating to new ownership labels
  (introduced in 1.3.0) when upgrading the operator form 1.2 (or older) to 1.3.0.
  [#369](https://github.com/Kong/gateway-operator/pull/369)
- Requeue instead of reporting an error when a finalizer removal yields a conflict.
  [#454](https://github.com/Kong/gateway-operator/pull/454)
- Requeue instead of reporting an error when a GatewayClass status update yields a conflict.
  [#612](https://github.com/Kong/gateway-operator/pull/612)
- Guard object counters with checks whether CRDs for them exist
  [#710](https://github.com/Kong/gateway-operator/pull/710)
- Do not reconcile Gateways nor assign any finalizers when the referred GatewayClass is not supported.
  [#711](https://github.com/Kong/gateway-operator/pull/711)
- Fixed setting `ExternalTrafficPolicy` on `DataPlane`'s ingress `Service` during update and patch operations.
  [#750](https://github.com/Kong/gateway-operator/pull/750)

### Changes

- Default version of `ControlPlane` is bumped to 3.3.1
  [#580](https://github.com/Kong/gateway-operator/pull/580)
- Default version of `DataPlane` is bumped to 3.8.0
  [#572](https://github.com/Kong/gateway-operator/pull/572)
- Gateway API has been bumped to v1.2.0
  [#674](https://github.com/Kong/gateway-operator/pull/674)

## 1.3.0

**Release Date** 2024/06/24

### Fixes

* Fix the `ControlPlane` extensions controller to gracefully handle the
  absence of a {{site.ee_product_name}} license on startup.
* Do not require existence of `certmanager.io/v1.certificates` CRD when
  `KonnectCertificateOptions` is empty in `DataPlane`.
* Fix version reporting in logs and via `-version` CLI arg
* Fix enforcing up to date `ControlPlane`'s `ValidatingWebhookConfiguration`

### Changes

* `Gateway` do not have their `Ready` status condition set anymore.
* This aligns with Gateway API and its conformance test suite.
* `Gateway`s' listeners now have their `attachedRoutes` count filled in status.
* Detect when `ControlPlane` has its admission webhook disabled via
* `CONTROLLER_ADMISSION_WEBHOOK_LISTEN` environment variable and ensure that
* relevant webhook resources are not created/deleted.
* The `OwnerReferences` on cluster-wide resources to indicate their owner are now
* replaced by a proper set of labels to identify `kind`, `namespace`, and
* `name` of the owning object.
* Default version of `ControlPlane` is bumped to 3.2.0

### Breaking Changes

* Changes project layout to match `kubebuilder` `v4`. Some import paths (due to dir renames) have changed
  `apis` -> `api` and `controllers` -> `controller`.

### Added

* Add `ExternalTrafficPolicy` to `DataPlane`'s `ServiceOptions`

## 1.2.3

**Release Date** 2024/04/24

### Fixes

* Fixed an issue where the managed `Gateway`s controller wasn't able to reduce
  the created `DataPlane` objects when too many were created.
* `Gateway` controller will no longer set `DataPlane` deployment's replicas
  to the default value when `DataPlaneOptions` in `GatewayConfiguration` define
  a scaling strategy. This effectively allows users to use `DataPlane` horizontal
  autoscaling with `GatewayConfiguration` because the generated `DataPlane` deployment
  won't be rejected.
* Made creating a `DataPlane` index conditional based on enabling the `ControlPlane`
  controller. This allows KGO to run without the `ControlPlane` CRD with its controller
  disabled.

## 1.2.2

**Release Date** 2024/04/23

### **NOTE: Retracted**

v1.2.2 was retracted due to a misplaced git tag.
Due to [Golang's proxy caching modules indefinitely][goproxy] we needed to retract this version.
v1.2.3 contains all the changes that v1.2.2 intended to contain.

[goproxy]: https://sum.golang.org/#faq-retract-version

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
