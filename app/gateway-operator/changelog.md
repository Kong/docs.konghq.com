---
title: Kong Gateway Operator Changelog
no_version: true
---

Changelog for supported {{ site.kgo_product_name }} versions.

## 1.6.1

**Release date**: 2025-05-28

### Changes

- Allowed the `kubectl rollout restart` operation for Deployment resources created via DataPlane CRD.
  [#1660](https://github.com/Kong/gateway-operator/pull/1660)

## 1.6.0

**Release date**: 2025-05-07

### Added

- In `KonnectGatewayControlPlane` fields `Status.Endpoints.ControlPlaneEndpoint`
  and `Status.Endpoints.TelemetryEndpoint` are filled with respective values from Konnect.
  [#1415](https://github.com/Kong/gateway-operator/pull/1415)
- Add `namespacedRef` support for referencing networks in `KonnectCloudGatewayDataPlaneGroupConfiguration`
  [#1423](https://github.com/Kong/gateway-operator/pull/1423)
- Introduced new CLI flags:
  - `--logging-mode` (or `GATEWAY_OPERATOR_LOGGING_MODE` env var) to set the logging mode (`development` can be set
    for simplified logging).
  - `--validate-images` (or `GATEWAY_OPERATOR_VALIDATE_IMAGES` env var) to enable ControlPlane and DataPlane image
    validation (it's set by default to `true`).
  [#1435](https://github.com/Kong/gateway-operator/pull/1435)
- Add support for `-enforce-config` for `ControlPlane`'s `ValidatingWebhookConfiguration`.
  This allows to use operator's `ControlPlane` resources in AKS clusters.
  [#1512](https://github.com/Kong/gateway-operator/pull/1512)
- `KongRoute` can be migrated from serviceless to service bound and vice versa.
  [#1492](https://github.com/Kong/gateway-operator/pull/1492)
- Add `KonnectCloudGatewayTransitGateway` controller to support managing Konnect
  transit gateways.
  [#1489](https://github.com/Kong/gateway-operator/pull/1489)
- Added support for setting `PodDisruptionBudget` in `GatewayConfiguration`'s `DataPlane` options.
  [#1526](https://github.com/Kong/gateway-operator/pull/1526)
- Added `spec.watchNamespace` field to `ControlPlane` and `GatewayConfiguration` CRDs
  to allow watching resources only in the specified namespace.
  When `spec.watchNamespace.type=list` is used, each specified namespace requires
  a `WatchNamespaceGrant` that allows the `ControlPlane` to watch resources in the specified namespace.
  Aforementioned list is extended with `ControlPlane`'s own namespace which doesn't
  require said `WatchNamespaceGrant`.
  [#1388](https://github.com/Kong/gateway-operator/pull/1388)
  [#1410](https://github.com/Kong/gateway-operator/pull/1410)
  [#1555](https://github.com/Kong/gateway-operator/pull/1555)
  For more information on this please see [this guide](/gateway-operator/latest/guides/hardening/control-plane-watch-namespaces/).
- Implemented `Mirror` and `Origin` `KonnectGatewayControlPlane`s.
  [#1496](https://github.com/Kong/gateway-operator/pull/1496)

### Changes

- Deduce `KonnectCloudGatewayDataPlaneGroupConfiguration` region based on the attached
  `KonnectAPIAuthConfiguration` instead of using a hardcoded `eu` value.
  [#1409](https://github.com/Kong/gateway-operator/pull/1409)
- Support `NodePort` as ingress service type for `DataPlane`
  [#1430](https://github.com/Kong/gateway-operator/pull/1430)
- Allow setting `NodePort` port number for ingress service for `DataPlane`.
  [#1516](https://github.com/Kong/gateway-operator/pull/1516)
- Updated `kubernetes-configuration` dependency for adding `scale` subresource for `DataPlane` CRD.
  [#1523](https://github.com/Kong/gateway-operator/pull/1523)
- Bump `kong/kubernetes-configuration` dependency to v1.4.0
  [#1574](https://github.com/Kong/gateway-operator/pull/1574)

### Fixes

- Fix setting the defaults for `GatewayConfiguration`'s `ReadinessProbe` when only
  timeouts and/or delays are specified. Now the `HTTPGet` field is set to `/status/ready`
  as expected with the `Gateway` scenario.
  [#1395](https://github.com/Kong/gateway-operator/pull/1395)
- Fix ingress service name not being applied when using `GatewayConfiguration`.
  [#1515](https://github.com/Kong/gateway-operator/pull/1515)
- Fix ingress service port name setting.
  [#1524](https://github.com/Kong/gateway-operator/pull/1524)

## 1.5.1

**Release date**: 2025-04-01

### Added

- Add `namespacedRef` support for referencing networks in `KonnectCloudGatewayDataPlaneGroupConfiguration`
  [#1425](https://github.com/Kong/gateway-operator/pull/1425)
- Set `ControlPlaneRefValid` condition to false when reference to `KonnectGatewayControlPlane` is invalid
  [#1421](https://github.com/Kong/gateway-operator/pull/1421)

### Changes

- Deduce `KonnectCloudGatewayDataPlaneGroupConfiguration` region based on the attached
  `KonnectAPIAuthConfiguration` instead of using a hardcoded `eu` value.
  [#1417](https://github.com/Kong/gateway-operator/pull/1417)
- Bump `kong/kubernetes-configuration` dependency to v1.3.

## 1.5.0

**Release date**: 2025-03-12

### Breaking Changes

- Added check of whether using `Secret` in another namespace in `AIGateway`'s
  `spec.cloudProviderCredentials` is allowed. If the `AIGateway` and the `Secret`
  referenced in `spec.cloudProviderCredentials` are not in the same namespace,
  there MUST be a `ReferenceGrant` in the namespace of the `Secret` that allows
  the `AIGateway`s to reference the `Secret`.
  This may break usage of `AIGateway`s that is already using `Secret` in
  other namespaces as AI cloud provider credentials.
  [#1161](https://github.com/Kong/gateway-operator/pull/1161)
- Migrate KGO CRDs to the kubernetes-configuration repo.
  With this migration process, we have removed the `api` and `pkg/clientset` from the KGO repo.
  This is a breaking change which requires manual action for projects that use operator's Go APIs.
  In order to migrate please use the import paths from the [kong/kubernetes-configuration][kubernetes-configuration] repo instead.
  For example:
  `github.com/kong/gateway-operator/api/v1beta1` becomes
  `github.com/kong/kubernetes-configuration/api/gateway-operator/v1beta1`.
  [#1148](https://github.com/Kong/gateway-operator/pull/1148)
- Support for the `konnect-extension.gateway-operator.konghq.com` CRD has been interrupted. The new
  API `konnect-extension.konnect.konghq.com` must be used instead.
  [#1183](https://github.com/Kong/gateway-operator/pull/1183)
- Migrate KGO CRDs conditions to the kubernetes-configuration repo.
  With this migration process, we have moved all conditions from the KGO repo to [kubernetes-configuration][kubernetes-configuration].
  This is a breaking change which requires manual action for projects that use operator's Go conditions types.
  In order to migrate please use the import paths from the [kong/kubernetes-configuration][kubernetes-configuration] repo instead.
  [#1281](https://github.com/Kong/gateway-operator/pull/1281)
  [#1305](https://github.com/Kong/gateway-operator/pull/1305)
  [#1306](https://github.com/Kong/gateway-operator/pull/1306)
  [#1318](https://github.com/Kong/gateway-operator/pull/1318)

[kubernetes-configuration]: https://github.com/Kong/kubernetes-configuration

### Added

- Added `Name` field in `ServiceOptions` to allow specifying name of the
  owning service. Currently specifying ingress service of `DataPlane` is
  supported.
  [#966](https://github.com/Kong/gateway-operator/pull/966)
- Added support for global plugins with `KongPluginBinding`'s `scope` field.
  The default value is `OnlyTargets` which means that the plugin will be
  applied only to the targets specified in the `targets` field. The new
  alternative is `GlobalInControlPlane` that will make the plugin apply
  globally in a control plane.
  [#1052](https://github.com/Kong/gateway-operator/pull/1052)
- Added `-cluster-ca-key-type` and `-cluster-ca-key-size` CLI flags to allow
  configuring cluster CA private key type and size. Currently allowed values:
  `rsa` and `ecdsa` (default).
  [#1081](https://github.com/Kong/gateway-operator/pull/1081)
- The `GatewayClass` Accepted Condition is set to `False` with reason `InvalidParameters`
  in case the `.spec.parametersRef` field is not a valid reference to an existing
  `GatewayConfiguration` object.
  [#1021](https://github.com/Kong/gateway-operator/pull/1021)
- The `SupportedFeatures` field is properly set in the `GatewayClass` status.
  It requires the experimental version of Gateway API (as of v1.2.x) installed in
  your cluster, and the flag `--enable-gateway-api-experimental` set.
  [#1010](https://github.com/Kong/gateway-operator/pull/1010)
- Added support for `KongConsumer` `credentials` in Konnect entities support.
  Users can now specify credentials for `KongConsumer`s in `Secret`s and reference
  them in `KongConsumer`s' `credentials` field.
  - `basic-auth` [#1120](https://github.com/Kong/gateway-operator/pull/1120)
  - `key-auth` [#1168](https://github.com/Kong/gateway-operator/pull/1168)
  - `acl` [#1187](https://github.com/Kong/gateway-operator/pull/1187)
  - `jwt` [#1208](https://github.com/Kong/gateway-operator/pull/1208)
  - `hmac` [#1222](https://github.com/Kong/gateway-operator/pull/1222)
- Added prometheus metrics for Konnect entity operations in the metrics server:
  - `gateway_operator_konnect_entity_operation_count` for number of operations.
  - `gateway_operator_konnect_entity_operation_duration_milliseconds` for duration of operations.
  [#953](https://github.com/Kong/gateway-operator/pull/953)
- Added support for `KonnectCloudGatewayNetwork` CRD which can manage Konnect
  Cloud Gateway Network entities.
  [#1136](https://github.com/Kong/gateway-operator/pull/1136)
- Reconcile affected `KonnectExtension`s when the `Secret` used as Dataplane
  certificate is modified. A secret must have the `konghq.com/konnect-dp-cert`
  label to trigger the reconciliation.
  [#1250](https://github.com/Kong/gateway-operator/pull/1250)
- When the `DataPlane` is configured in Konnect, the `/status/ready` endpoint
  is set as the readiness probe.
  [#1235](https://github.com/Kong/gateway-operator/pull/1253)
- Added support for `KonnectDataPlaneGroupConfiguration` CRD which can manage Konnect
  Cloud Gateway DataPlane Group configurations entities.
  [#1186](https://github.com/Kong/gateway-operator/pull/1186)
- Supported `KonnectExtension` to attach to Konnect control planes by setting
  namespace and name of `KonnectGatewayControlPlane` in `spec.konnectControlPlane`.
  [#1254](https://github.com/Kong/gateway-operator/pull/1254)
- Added support for `KonnectExtension`s on `ControlPlane`s.
  [#1262](https://github.com/Kong/gateway-operator/pull/1262)
- Added support for `KonnectExtension`'s `status` `controlPlaneRefs` and `dataPlaneRefs`
  fields.
  [#1297](https://github.com/Kong/gateway-operator/pull/1297)
- Added support for `KonnectExtension`s on `Gateway`s via `GatewayConfiguration`
  extensibility.
  [#1292](https://github.com/Kong/gateway-operator/pull/1292)
- Added `-enforce-config` flag to enforce the configuration of the `ControlPlane`
  and `DataPlane` `Deployment`s.
  [#1307](https://github.com/Kong/gateway-operator/pull/1307)
- Added Automatic secret provisioning for `KonnectExtension` certificates.
  [#1304](https://github.com/Kong/gateway-operator/pull/1304)

### Changed

- `KonnectExtension` does not require `spec.serverHostname` to be set by a user
  anymore - default is set to `konghq.com`.
  [#947](https://github.com/Kong/gateway-operator/pull/947)
- Support KIC 3.4
  [#972](https://github.com/Kong/gateway-operator/pull/972)
- Allow more than 1 replica for `ControlPlane`'s `Deployment` to support HA deployments of KIC.
  [#978](https://github.com/Kong/gateway-operator/pull/978)
- Removed support for the migration of legacy labels so upgrading the operator from 1.3 (or older) to 1.5.0,
  should be done through 1.4.1
  [#976](https://github.com/Kong/gateway-operator/pull/976)
- Move `ControlPlane` `image` validation to CRD CEL rules.
  [#984](https://github.com/Kong/gateway-operator/pull/984)
- Remove usage of `kube-rbac-proxy`.
  Its functionality of can be now achieved by using the new flag `--metrics-access-filter`
  (or a corresponding `GATEWAY_OPERATOR_METRICS_ACCESS_FILTER` env).
  The default value for the flag is `off` which doesn't restrict the access to the metrics
  endpoint. The flag can be set to `rbac` which will configure KGO to verify the token
  sent with the request.
  For more information on this migration please consult
  [kubernetes-sigs/kubebuilder#3907][kubebuilder_3907].
  [#956](https://github.com/Kong/gateway-operator/pull/956)
- Move `DataPlane` ports validation to `ValidationAdmissionPolicy` and `ValidationAdmissionPolicyBinding`.
  [#1007](https://github.com/Kong/gateway-operator/pull/1007)
- Move `DataPlane` db mode validation to CRD CEL validation expressions.
  With this change only the `KONG_DATABASE` environment variable directly set in
  the `podTemplateSpec` is validated. `EnvFrom` is not evaluated anymore for this validation.
  [#1049](https://github.com/Kong/gateway-operator/pull/1049)
- Move `DataPlane` promotion in progress validation to CRD CEL validation expressions.
  This is relevant for `DataPlane`s with BlueGreen rollouts enabled only.
  [#1054](https://github.com/Kong/gateway-operator/pull/1054)
- Move `DataPlane`'s rollout strategy validation of disallowed `AutomaticPromotion`
  to CRD CEL validation expressions.
  This is relevant for `DataPlane`s with BlueGreen rollouts enabled only.
  [#1056](https://github.com/Kong/gateway-operator/pull/1056)
- Move `DataPlane`'s rollout resource strategy validation of disallowed `DeleteOnPromotionRecreateOnRollout`
  to CRD CEL validation expressions.
  This is relevant for `DataPlane`s with BlueGreen rollouts enabled only.
  [#1065](https://github.com/Kong/gateway-operator/pull/1065)
- The `GatewayClass` Accepted Condition is set to `False` with reason `InvalidParameters`
  in case the `.spec.parametersRef` field is not a valid reference to an existing
  `GatewayConfiguration` object.
  [#1021](https://github.com/Kong/gateway-operator/pull/1021)
- Validating webhook is now disabled by default. At this point webhook doesn't
  perform any validations.
  These were all moved either to CRD CEL validation expressions or to the
  `ValidationAdmissionPolicy`.
  Flag remains in place to not cause a breaking change for users that rely on it.
  [#1066](https://github.com/Kong/gateway-operator/pull/1066)
- Remove `ValidatingAdmissionWebhook` from the operator.
  As of now, all the validations have been moved to CRD CEL validation expressions
  or to the `ValidationAdmissionPolicy`.
  All the flags that were configuring the webhook are now deprecated and do not
  have any effect.
  They will be removed in next major release.
  [#1100](https://github.com/Kong/gateway-operator/pull/1100)
- Konnect entities that are attached to a Konnect CP through a `ControlPlaneRef`
  do not get an owner relationship set to the `ControlPlane` anymore hence
  they are not deleted when the `ControlPlane` is deleted.
  [#1099](https://github.com/Kong/gateway-operator/pull/1099)
- Remove the owner relationship between `KongService` and `KongRoute`.
  [#1178](https://github.com/Kong/gateway-operator/pull/1178)
- Remove the owner relationship between `KongTarget` and `KongUpstream`.
  [#1279](https://github.com/Kong/gateway-operator/pull/1279)
- Remove the owner relationship between `KongCertificate` and `KongSNI`.
  [#1285](https://github.com/Kong/gateway-operator/pull/1285)
- Remove the owner relationship between `KongKey`s and `KongKeysSet`s and `KonnectGatewayControlPlane`s.
  [#1291](https://github.com/Kong/gateway-operator/pull/1291)
- Check whether an error from calling Konnect API is a validation error by
  HTTP status code in Konnect entity controller. If the HTTP status code is
  `400`, we consider the error as a validation error and do not try to requeue
  the Konnect entity.
  [#1226](https://github.com/Kong/gateway-operator/pull/1226)
- Credential resources used as Konnect entities that are attached to a `KongConsumer`
  resource do not get an owner relationship set to the `KongConsumer` anymore hence
  they are not deleted when the `KongConsumer` is deleted.
  [#1259](https://github.com/Kong/gateway-operator/pull/1259)

[kubebuilder_3907]: https://github.com/kubernetes-sigs/kubebuilder/discussions/3907

### Fixes

- Fix `DataPlane`s with `KonnectExtension` and `BlueGreen` settings. Both the Live
  and preview deployments are now customized with Konnect-related settings.
  [#910](https://github.com/Kong/gateway-operator/pull/910)
- Remove `RunAsUser` specification in jobs to create webhook certificates
  because Openshift does not specifying `RunAsUser` by default.
  [#964](https://github.com/Kong/gateway-operator/pull/964)
- Fix watch predicates for types shared between KGO and KIC.
  [#948](https://github.com/Kong/gateway-operator/pull/948)
- Fix unexpected error logs caused by passing an odd number of arguments to the logger
  in the `KongConsumer` reconciler.
  [#983](https://github.com/Kong/gateway-operator/pull/983)
- Fix checking status when using a `KonnectGatewayControlPlane` with KIC CP type
  as a `ControlPlaneRef`.
  [#1115](https://github.com/Kong/gateway-operator/pull/1115)
- Fix setting `DataPlane`'s readiness probe using `GatewayConfiguration`.
  [#1118](https://github.com/Kong/gateway-operator/pull/1118)
- Fix handling Konnect API conflicts.
  [#1176](https://github.com/Kong/gateway-operator/pull/1176)

## 1.4.2

**Release date**: 2025-01-23

### Fixed

- Bump `kong/kubernetes-configuration` dependency to v1.0.8 that fixes the issue with `spec.headers`
  in `KongRoute` CRD by aligning to the expected schema (instead of `map[string]string`, it should be
  `map[string][]string`).
  Please make sure you update the KGO channel CRDs accordingly in your cluster:
  `kustomize build github.com/Kong/kubernetes-configuration/config/crd/gateway-operator\?ref=v1.0.8 | kubectl apply -f -`
  [#1072](https://github.com/Kong/gateway-operator/pull/1072)

## 1.4.1

**Release date**: 2024/11/28

- Fix setting the `ServiceAccountName` for `DataPlane`'s `Deployment`.
  [#897](https://github.com/Kong/gateway-operator/pull/897)
- Fixed setting `ExternalTrafficPolicy` on `DataPlane`'s ingress `Service` when
  the requested value is empty.
  [#898](https://github.com/Kong/gateway-operator/pull/898)
- Set 0 members on `KonnectGatewayControlPlane` which type is set to group.
  [#896](https://github.com/Kong/gateway-operator/pull/896)
- Fixed a `panic` in `KonnectAPIAuthConfigurationReconciler` occurring when nil
  response was returned by Konnect API when fetching the organization information.
  [#901](https://github.com/Kong/gateway-operator/pull/901)
- Bump sdk-konnect-go version to 0.1.10 to fix handling global API endpoints.
  [#894](https://github.com/Kong/gateway-operator/pull/894)

## 1.4.0

**Release date**: 2024/10/31

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

**Release date**: 2024/06/24

### Fixes

- Fix the `ControlPlane` extensions controller to gracefully handle the
  absence of a {{site.ee_product_name}} license on startup.
- Do not require existence of `certmanager.io/v1.certificates` CRD when
  `KonnectCertificateOptions` is empty in `DataPlane`.
- Fix version reporting in logs and via `-version` CLI arg
- Fix enforcing up to date `ControlPlane`'s `ValidatingWebhookConfiguration`

### Changes

- `Gateway` do not have their `Ready` status condition set anymore.
- This aligns with Gateway API and its conformance test suite.
- `Gateway`s' listeners now have their `attachedRoutes` count filled in status.
- Detect when `ControlPlane` has its admission webhook disabled via
- `CONTROLLER_ADMISSION_WEBHOOK_LISTEN` environment variable and ensure that
- relevant webhook resources are not created/deleted.
- The `OwnerReferences` on cluster-wide resources to indicate their owner are now
- replaced by a proper set of labels to identify `kind`, `namespace`, and
- `name` of the owning object.
- Default version of `ControlPlane` is bumped to 3.2.0

### Breaking Changes

- Changes project layout to match `kubebuilder` `v4`. Some import paths (due to dir renames) have changed
  `apis` -> `api` and `controllers` -> `controller`.

### Added

- Add `ExternalTrafficPolicy` to `DataPlane`'s `ServiceOptions`

## 1.2.3

**Release date**: 2024/04/24

### Fixes

- Fixed an issue where the managed `Gateway`s controller wasn't able to reduce
  the created `DataPlane` objects when too many were created.
- `Gateway` controller will no longer set `DataPlane` deployment's replicas
  to the default value when `DataPlaneOptions` in `GatewayConfiguration` define
  a scaling strategy. This effectively allows users to use `DataPlane` horizontal
  autoscaling with `GatewayConfiguration` because the generated `DataPlane` deployment
  won't be rejected.
- Made creating a `DataPlane` index conditional based on enabling the `ControlPlane`
  controller. This allows KGO to run without the `ControlPlane` CRD with its controller
  disabled.

## 1.2.2

**Release date**: 2024/04/23

### **NOTE: Retracted**

v1.2.2 was retracted due to a misplaced git tag.
Due to [Golang's proxy caching modules indefinitely][goproxy] we needed to retract this version.
v1.2.3 contains all the changes that v1.2.2 intended to contain.

[goproxy]: https://sum.golang.org/#faq-retract-version

## 1.2.1

**Release date**: 2024/03/20

### Fixes

- Fixed an issue where operator wasn't able to update `ControlPlane` `ClusterRole` or `ClusterRoleBinding`
  when they got out of date.
- Add missing watch RBAC policy rule for cert-manager's Certificate resources

### Changes

- KGO now uses `GATEWAY_OPERATOR_` prefix for all flags, including the `zap` related logging flags.

## 1.2.0

**Release date**: 2024/03/15

## Highlights

- 🎓 The Managed `Gateway`s feature is now GA.
- 🎓 `ControlPlane` and `GatewayConfig` APIs have been promoted to `v1beta1`.
- ✨ `DataPlane`s managed by `Gateway`s can be now scaled horizontally through the
  `GatewayConfiguration` API.
- ✨ `Gateway` listeners are dynamically mapped to the `DataPlane` proxy service ports.
- 🧠 The new feature `AIGateway` has been released in `alpha` stage.
- ✨ {{site.kgo_product_name}} exposes metrics with latency that can be used for autoscaling of your workloads.
- ✨ Automated handling of certificates for Konnect's PKI mode with cert-manager.

## Added

- Added support for specifying command line flags through environment
  variables having the `GATEWAY_OPERATOR_` prefix.
- Add horizontal autoscaling for `DataPlane`s using its `scaling.horizontal` spec
  field.
- `ControlPlane`s now use Gateway Discovery by default, with Service DNS Strategy.
  Additionally, the `DataPlane` readiness probe has been changed to `/status/ready`
  when the `DataPlane` is managed by a `Gateway`.
- `Gateway`s and `Listener`s `Accepted` and `Conflicted` conditions are now set
  and enforced based on the Gateway API specifications.
- `ControlPlane` `ClusterRole`s and `ClusterRoleBinding`s are enforced and kept
  up to date by the `ControlPlane` controller.
- The `Gateway` listeners are now dynamically mapped to `DataPlane` ingress service
  ports. This means that the change of a `Gateway` spec leads to a `DataPlane` reconfiguration,
  along with an ingress service update.
- `--enable-controller-gateway` and `--enable-controller-controlplane` command
  line flags are set to `true` by default to enable controllers for `Gateway`s
  and `ControlPlane`s.
- When the `Gateway` controller provisions a `ControlPlane`, it sets the `CONTROLLER_GATEWAY_TO_RECONCILE`
  env variable to let the `ControlPlane` reconcile
  that specific `Gateway` only.
- `ControlPlane` is now deployed with a validating webhook server turned on. This
  involves creating `ValidatingWebhookConfiguration`, a `Service` that exposes the
  webhook and a `Secret` that holds a TLS certificate. The `Secret` is mounted in
  the `ControlPlane`'s `Pod` for the webhook server to use it.
- Added `konnectCertificate` field to the DataPlane resource.
- Added `v1alpha1.AIGateway` as an experimental API. This can be enabled by
  manually deploying the `AIGateway` CRD and enabling the feature on the
  controller manager with the `--enable-controller-aigateway` flag.
- Added validation on checking if ports in `KONG_PORT_MAPS` and `KONG_PROXY_LISTEN`
  environment variables of deployment options in `DataPlane` match the `ports`
  in the ingress service options of the `DataPlane`.
- Support for KongLicense CRD to manage {{site.ee_product_name}} licenses.
- New ControlPlane extensions controller to manage control plane extensions with initial support for `DataPlaneMetricsExtension`.
- DataPlane Prometheus metrics scrapping support for `DataPlaneMetricsExtension`.
- DataPlane resources can provision cert-manager Certificate resources from a (Cluster) Issuer for use with Konnect's PKI mode.
- ControlPlane extensions controller now checks for a valid Kong enterprise license.

### Changes

- The `GatewayConfiguration` API has been promoted from `v1alpha1` to `v1beta1`.
- The `ControlPlane` API has been promoted from `v1alpha1` to `v1beta1`.
- The CRD's short names of `ControlPlane`, `DataPlane` and `GatewayConfiguration`
  has been changed to `kocp`, `kodp` and `kogc`.
- `ControlPlane` ({{site.kic_product_name}}) default and minimum version has been
  bumped to 3.1.2.
- `DataPlane` ({{site.base_gateway}}) default version has been bumped to `v3.6.0`.

### Fixes

- Fixed a problem where the operator would not set the defaults to `PodTemplateSpec`
  patch and because of that it would detect a change and try to reconcile the owned
  resource where in fact the change was not there.
  One of the symptoms of this bug could have been a `StartupProbe` set in `PodSpec`
  preventing the `DataPlane` from getting correct status information.
- If the Gateway controller is enabled, `DataPlane` and `ControlPlane` controllers
  get enabled as well.
- Fix applying the `PodTemplateSpec` patch so that it's not applied when the
  calculated patch (resulting from the generated manifest and current in-cluster
  state) is empty.
  One of the symptoms of this bug was that when users tried to apply a `ReadinessProbe`
  which specified a port name instead of a number (which is what's generated by
  the operator) it would never reconcile and the status conditions would never get
  up to date `ObservedGeneration`.
- Fix manager RBAC permissions which prevented the operator from being able to
  create `ControlPlane`'s `ClusterRole`s, list pods or list `EndpointSlices`.
- `DataPlane`s with BlueGreen rollout strategy enabled will now have its Ready status
  condition updated to reflect "live" `Deployment` and `Service`s status.
- The `ControlPlane` `election-id` has been changed so that every `ControlPlane`
  has its own `election-id`, based on the `ControlPlane` name. This prevents `pod`s
  belonging to different `ControlPlane`s from competing for the same lease.
- Fill in the defaults for `env` and `volumes` when comparing the in-cluster spec
  with the generated spec.
- Do not flap `DataPlane`'s `Ready` status condition when e.g. ingress `Service`
  can't get an address assigned and `spec.network.services.ingress.`annotations`
  is non-empty.
- Update or recreate a `ClusterRoleBinding` for control planes if the existing
  one does not contain the `ServiceAccount` used by `ControlPlane`, or
  `ClusterRole` is changed.
- Retry reconciling `Gateway`s when provisioning owned `DataPlane` fails.

## 1.1.0

**Release date**: 2023/11/20

### Added

- Add support for `ControlPlane` `v3.0` by updating the generated `ClusterRole`.

### Changes

- Bump `ControlPlane` default version to `v3.0`.
- Bump Gateway API to v1.0.

### Fixes

- Operator `Role` generation is fixed. As a result it contains now less rules
  hence the operator needs less permissions to run.

## 1.0.3

**Release date**: 2023/11/06

### Fixes

- Fix an issue where operator is upgraded from an older version and it orphans
  old `DataPlane` resources.

### Added

- Setting `spec.deployment.podTemplateSpec.spec.volumes` and
  `spec.deployment.podTemplateSpec.spec.containers[*].volumeMounts` on `ControlPlane`s
  is now allowed.

## 1.0.2

**Release date**: 2023/10/18

### Changed

- Bump dependencies

## 1.0.1

**Release date**: 2023/10/02

### Fixes

- Fix flapping of `Gateway` managed `ControlPlane` `spec` field when applied without `controlPlaneOptions` set.

### Changes

- Bump `ControlPlane` default version to `v2.12`.
- Bump `WebhookCertificateConfigBaseImage` to `v1.3.0`.

## 1.0.0

**Release date**: 2023/09/27

### Features

- Deploy and configure {{ site.base_gateway }} services
- Customise deployments using `PodTemplateSpec` to deploy sidecars, set node affinity and more.
- Upgrade Data Planes using a rolling restart or blue/green deployments
