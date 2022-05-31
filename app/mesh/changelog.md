---
title: Kong Mesh Changelog
no_search: true
no_version: true
---

## 1.8.0

> Released on **TBD**

Built on top of [Kuma 1.7.0](https://github.com/kumahq/kuma/releases/tag/1.7.0)

### Changes

New Features:

- Support for arm64
- Graceful shutdown of OPA
- Role-based AWS auth for Vault
- Add Vault AWS Auth option to set Server ID

Dependency upgrades:

- Bump github.com/aws/aws-sdk-go from 1.40.56 to 1.44.21
- Bump github.com/hashicorp/go-retryablehttp from 0.6.6 to 0.7.1
- Bump github.com/open-policy-agent/opa from 0.38.1 to 0.40.0
- Bump github.com/open-policy-agent/opa-envoy-plugin from 0.38.1-envoy-3 to 0.40.0-envoy
- Bump k8s.io/api from 0.23.6 to 0.24.1
- Bump k8s.io/apimachinery from 0.23.6 to 0.24.1
- Bump sigs.k8s.io/controller-runtime from 0.11.2 to 0.12.1

### Upgrading

## 1.7.1

> Released on **[TBD]**

Built on top of [Kuma 1.6.1](https://github.com/kumahq/kuma/releases/tag/1.6.1)

- Allow graceful shutdown of OPA

## 1.7.0

> Released on 2022/04/12
 
Built on top of [Kuma 1.6.0](https://github.com/kumahq/kuma/releases/tag/1.6.0)

### Changes

New Features:

- Add support for AWS Certificate Manager Private CA
- Inspect API support for Open Policy Agent
- Add license values to Mesh reports

Dependency upgrades:

- Bump github.com/aws/aws-sdk-go from 1.40.56 to 1.43.29
- Bump github.com/hashicorp/vault/api from 1.3.1 to 1.5.0
- Bump github.com/open-policy-agent/opa from 0.37.1 to 0.38.1
- Bump github.com/open-policy-agent/opa-envoy-plugin from 0.37.1-envoy to 0.38.1-envoy-3

### Upgrading

#### Helm
`controlPlane.resources` is now on object instead of a string. Any existing value should be adapted accordingly.

#### Zone egress and ExternalService
When an `ExternalService` has the tag `kuma.io/zone` and `ZoneEgress` is enabled then the request flow will be different after upgrading Kuma to the newest version.
Previously, the request to the `ExternalService` goes through the `ZoneEgress` in the current zone.

The flow in the newest version is different, and when `ExternalService` is defined in a different zone then the request will go through local `ZoneEgress` to `ZoneIngress` in zone where `ExternalService` is defined and leave the cluster through `ZoneEgress` in this zone.

To keep the previous behavior, remove the `kuma.io/zone` tag from the `ExternalService` definition.

#### Zone egress
Previously, when mTLS was configured and `ZoneEgress` was deployed, requests were automatically routed through `ZoneEgress`.

You must now explicitly set that traffic should be routed through `ZoneEgress` by setting `routing.zoneEgress: true` in the Mesh configuration. By default, this is set to `false`.

```yaml
type: Mesh
name: default
mtls: # mTLS is required for zoneEgress
[...]
routing:
  zoneEgress: true
```

The new approach changes the flow of requests to external services. Previously when there was no instance of `ZoneEgress` traffic was routed directly to the destination, now it won't reach the destination.

#### Gateway (experimental)
Previously, a MeshGatewayInstance generated a Deployment and Service whose names ended with a unique suffix. With this release, those objects will have the same name as the MeshGatewayInstance.

#### Inspect API
In connection with the changes around `MeshGateway` and `MeshGatewayRoute`, the output schema of the `<policy-type>/<policy>/dataplanes` has changed. Every policy can now affect both normal Dataplanes and Dataplanes configured as builtin gateways. The configuration for the latter type is done via MeshGateway resources.

Every item in the items array now has a `kind` property of either:

`SidecarDataplane`: a normal Dataplane with outbounds, inbounds, etc.
`MeshGatewayDataplane`: a MeshGateway-configured Dataplane with a new structure representing the MeshGateway it serves.
Some examples can be found in the [Inspect API docs](https://kuma.io/docs/1.6.x/reference/http-api/#inspect-api).

## 1.6.1

> Released on 2022/04/09

Built on top of [Kuma 1.5.1](https://github.com/kumahq/kuma/releases/tag/1.5.1)

- Remove the old JWT library
- Make the Open Policy Agent timeout configurable

Dependency upgrades:

- Bump github.com/open-policy-agent/opa from 0.37.2 to 0.38.1

## 1.6.0

> Released on 2022/02/24

### Changes

Built on top of [Kuma 1.5.0](https://github.com/kumahq/kuma/releases/tag/1.5.0)

- UBI images support.
- ECS EC2 and Fargate first party support.
- Update OPA agent to v0.37.2.

### Upgrading

- The `kuma.metrics.dataplane.enabled` and `kuma.metrics.zone.enabled` configurations have been removed. Kuma always generates the corresponding metrics.
- Removed support for the old Ingress (`Dataplane#networking.ingress`), which was used before Kong Mesh 1.3. If you are still using it, migrate to ZoneIngress first (see [Kuma Upgrade to 1.2.0 section](https://github.com/kumahq/kuma/blob/master/UPGRADE.md#upgrade-to-120)).

#### Kubernetes
- Migrate your kuma.io/sidecar-injection annotations to labels. The new version still supports annotations, but to  guarantee that applications can only start with a sidecar, you must use a label instead of an annotation.
Configuration parameter `kuma.runtime.kubernetes.injector.sidecarContainer.adminPort` and environment variable `KUMA_RUNTIME_KUBERNETES_INJECTOR_SIDECAR_CONTAINER_ADMIN_PORT` have been deprecated in favor of `kuma.bootstrapServer.params.adminPort` and `KUMA_BOOTSTRAP_SERVER_PARAMS_ADMIN_PORT`.

#### Universal

- You can't use `0.0.0.0` or `::` in `networking.address`. Use loopback instead.
- The Kuma DP flag `--admin-port` and environment variable `KUMA_DATAPLANE_ADMIN_PORT` have been deprecated. The admin port should be specified in Dataplane or ZoneIngress resources.

## 1.5.1

> Released on 2021/12/16

### Changes

Built on top of [Kuma 1.4.1](https://github.com/kumahq/kuma/blob/master/CHANGELOG.md#141)

- Default role-based access control (RBAC) for zone control planes is now restricted to the `admin` role.
- Performance continues to be significantly improved.
- Authentication tokens are now more secure.

### Upgrading

Before you upgrade from `1.5.0` make sure to review your RBAC configuration for zone control planes. In `1.5.1`,
RBAC for zone control planes is restricted by default. For information on how to secure access to resources, see
[the RBAC documentation](/mesh/1.5.x/features/rbac/).

Upgrades from `1.5.0` are otherwise seamless and no further steps are needed.

## 1.5.0

> Released on 2021/11/22

### Changes

Built on top of [Kuma 1.4.0](https://github.com/kumahq/kuma/blob/master/CHANGELOG.md#140)

- Role-based Access Control (RBAC) is now available.
- Support for Windows installation on Universal (VMs) is now available.
- Renewable tokens in Vault are now supported.

### Upgrading

Starting with this version, the default API server authentication method is user
tokens. To continue using client certificates (the previous default
method), you'll need to explicitly set the authentication method to client
certificates. This can be done by setting the `KUMA_API_SERVER_AUTHN_TYPE` variable to
`"clientCerts"`.

See the Kuma docs on [Configuration - Control plane](https://kuma.io/docs/1.4.0/documentation/configuration/#control-plane)
for how to set this variable.

## 1.4.1

> Released on 2021/10/06

### Changes

Built on top of [Kuma 1.3.1](https://github.com/kumahq/kuma/blob/master/CHANGELOG.md#131)

- Common Name (CN) support for Vault certificate storage is now available.
- You can now disable zones as needed.
- The number of Postgres connections is now limited to 50 by default. The default value was previously unlimited; you can still configure the limit if needed.
- You can now select a specific zone in the Kuma Service dashboard and in the Service to Service dashboard.

### Upgrading

Upgrades from `1.4.0` are seamless and no additional steps are needed.

## 1.4.0

> Released on 2021/08/26

### Changes

Built on top of [Kuma 1.3.0](https://github.com/kumahq/kuma/blob/master/CHANGELOG.md#130)

- You can now configure CA rotation in {{site.mesh_product_name}}.
- A service map topology view is available that provides visualization of service traffic dependencies.
- Support for mutual TLS in permissive mode is available, to support migrating applications into the service mesh.
- You can now customize hostnames and ports for data plane proxies with a new virtual outbound policy.
- You can more easily specify intermediate CAs with mTLS.

### Upgrading

Upgrades from `1.3.0` are seamless, but note the following:

- Outbounds generated internally are no longer listed in `dataplane.network.outbound[]`. On Kubernetes, they are automatically removed.
On Universal, to remove them you must recreate your `Dataplane` resources with `kumactl apply`. Or, if the proxy lifecycle is
managed by Kuma, restart the services.
- You may notice some proxies or zones indicated as Offline in the GUI when you upgrade the control plane. This can happen if
upgrading all instances of the control plane takes more than five (5) minutes. It's temporary, and occurs because of a new mechanism for
better tracking proxy and zone status. A heartbeat periodically increments the `generation` counter for Insights. The offline status
should disappear after all control plane instances are upgraded to 1.4.0.

## 1.3.4

> Released on 2021/09/15

Built on top of [Kuma 1.2.3](https://github.com/kumahq/kuma/blob/master/CHANGELOG.md#123)

- Moved to a Kuma fork of `go-control-plane` that fixes a Goroutine leak

## 1.3.3

> Released on 2021/07/29

### Changes

Built on top of [Kuma 1.2.3](https://github.com/kumahq/kuma/blob/master/CHANGELOG.md#123)

- kumactl now always warns when the client and server versions cannot be confirmed to match.
- The data plane proxy type is now checked for a valid value (one of `ingress` or `dataplane`).
- Improvements to the control plane.

### Upgrading

Upgrades from `1.3.0` are seamless and no additional steps are needed.

## 1.3.2

> Released on 2021/07/16

### Changes

Built on top of [Kuma 1.2.2](https://github.com/kumahq/kuma/blob/master/CHANGELOG.md#122)

- Datadog is now available as a traffic tracing option.
- Message limit for gRPC stream is increased to better support Kuma discovery service (KDS)
- Improved leader election during unexpected failures.
- Improved SDS and XDS on rapid DP restarts.
- Fixed HDS on the dpserver when bootstrapping an ingress.

### Upgrading

Upgrades from `1.3.0` are seamless and no additional steps are needed.

## 1.3.1

> Released on 2021/06/30

### Changes

Built on top of [Kuma 1.2.1](https://github.com/kumahq/kuma/blob/master/CHANGELOG.md#121)

- (Kuma) The data plane proxy now provides an advertised address to the control plane for communication in cases where the address is not directly reachable.
- (Kuma) An SNI header is now added when TLS is enabled, to permit communication with external services that require it.
- (Kong Mesh only) New parameters `pki` and `role` are available for Vault.
- (Kong Mesh only) The CNI config name is now always prefixed with `kuma-cni`.
- (Kong Mesh only) TTL is no longer validated for Vault.

### Upgrading

Upgrades from `1.3.0` are seamless and no additional steps are needed.

## 1.3.0

> Released on 2021/06/17

### Changes

Built on top of [Kuma 1.2.0](https://github.com/kumahq/kuma/blob/master/CHANGELOG.md#120)

- New L7 Traffic Routing policy to route and modify HTTP traffic per path, method, header, or any other combination, with support for regex. Traffic can be modified before reaching the final destination.
- New Rate-Limit policy to protect services from aggressive traffic. This policy can protect from downtime and improve the overall reliability of your applications.
- The "Remote" control plane is renamed to "Zone" control plane. This means the "Ingress" resource is renamed "ZoneIngress". Thanks to community users for providing the feedback that drove this effort.
- Traffic Permissions now work with external services.
- Improved performance of our DNS resolution.
- More improvements, including a fix for GCP/GKE's erratic IPv6 support.
- Updated to Envoy 1.18.3.

### Upgrading

For a Universal deployment, see the [Kuma upgrade instructions](https://github.com/kumahq/kuma/blob/master/UPGRADE.md).

For Kubernetes, you should be aware of the following changes:

#### `kumactl` on Kubernetes

- Changes in arguments/flags for `kumactl install control-plane`:

   - `--mode` now accepts the values `standalone`, `zone`, and `global`. `zone` replaces `remote`, which is still available in earlier versions.

   - `--tls-kds-remote-client-secret` flag is renamed to `--tls-kds-zone-client-secret`.

- Service `kong-mesh-global-remote-sync` is changed to `kong-mesh-global-zone-sync`. After you upgrade the global control plane, you must manually remove the old service. For example:

   ```sh
   kubectl delete -n kong-mesh-system service/kong-mesh-global-remote-sync
   ```
   The IP address or hostname that provides the KDS address when you install the control planes can change. Make sure that you update the address when you upgrade the remote control planes to the latest version.

#### Helm

Changes in values in Kong Mesh’s Helm chart:

* `kuma.controlPlane.mode` now accepts the values `standalone`, `zone`, and `global`. `zone` replaces `remote`, which is still available in earlier versions.
* `kuma.controlPlane.globalRemoteSyncService` is renamed to `kuma.controlPlane.globalZoneSyncService`.
* `kuma.controlPlane.tls.kdsRemoteClient` is renamed to `kuma.controlPlane.tls.kdsZoneClient`.

## 1.2.6

> Released on 2021/05/13

### Changes

Built on top of [Kuma 1.1.6](https://github.com/kumahq/kuma/blob/master/CHANGELOG.md#116).

- Intermediate Certificate Authorities (CAs) are now supported with Vault integration.
- You can now specify any and all tags in a Traffic Permission policy for Vault integration.
- You can now specify TCP and HTTP health checks at the same time in the same policy. The health check policy also
now includes a `reuse_connection` option.
- The `--gateway` flag is now available in the CLI.
- You can now install an ingress controller with the CLI. Kong Gateway is the first supported ingress controller.
- You can now install the Kuma demo application with the CLI.


### Upgrading

Upgrades from `1.2.x` are seamless and no additional steps are needed. Note [specific configuration requirements](https://kuma.io/docs/1.1.5/networking/dns/#data-plane-proxy-built-in-dns) for taking advantage of built-in DNS.


## 1.2.5

> Released on 2021/05/05

### Changes

Built on top of [Kuma 1.1.5](https://github.com/kumahq/kuma/blob/master/CHANGELOG.md#115).

- ⚠️ All installation scripts are updated to a new location because Bintray is shutting down. If you've written automation scripts that refer to the Bintray location, you need to update your scripts to point to the new location.
- Transparent proxying is improved.
- The GUI is improved.
- The locality is now always set in a multi-zone deployment.

### Upgrading

Upgrades from `1.2.x` are seamless and no additional steps are needed. Note [specific configuration requirements](https://kuma.io/docs/1.1.5/networking/dns/#data-plane-proxy-built-in-dns) for taking advantage of built-in DNS.

## 1.2.4

> Released on 2021/04/19

### Changes

Built on top of [Kuma 1.1.4](https://github.com/kumahq/kuma/blob/master/CHANGELOG.md#114).

Includes important bug fixes to version 1.1.3 of Kuma, plus improvements to the web UI.

### Upgrading

Upgrades from `1.2.x` are seamless and no additional steps are needed. Note [specific configuration requirements](https://kuma.io/docs/1.1.3/networking/dns/#data-plane-proxy-built-in-dns) for taking advantage of built-in DNS. See also [new documentation for the external service policy](https://kuma.io/docs/1.1.3/policies/external-services/#usage).

## 1.2.3

> Released on 2021/04/16

### Changes

Built on top of [Kuma 1.1.3](https://github.com/kumahq/kuma/blob/master/CHANGELOG.md#113). Notably:

- Built-in DNS provides support for specifying external services by original hostname and port

### Upgrading

Upgrades from `1.2.x` are seamless and no additional steps are needed. Note [specific configuration requirements](https://kuma.io/docs/1.1.3/networking/dns/#data-plane-proxy-built-in-dns) for taking advantage of built-in DNS. See also [new documentation for the external service policy](https://kuma.io/docs/1.1.3/policies/external-services/#usage).

## 1.2.2

> Released on 2021/04/09

### Changes

Built on top of Kuma 1.1.2 with [fixes and improvements](https://github.com/kumahq/kuma/blob/master/CHANGELOG.md#112). Features include:
- 19 new observability charts and golden metrics.
- IPv6 support across the service mesh.
- New threshold configuration in the Circuit Breaker policy.
- Performance improvements, especially with external services.
- Stability improvements to kuma-cp and DNS resolution.

### Upgrading

Upgrades from `1.2.0` are seamless and no additional steps are needed.

## 1.2.1

> Released on 2021/03/09

### Changes

- Fix to include the OPA CRD in the deployment
- Build on top of Kuma 1.1.1 with [fixes and improvements](https://github.com/kumahq/kuma/blob/master/CHANGELOG.md#111)

### Upgrading

Upgrades from `1.2.0` are seamless and no additional steps are needed. When using Helm to upgrade from 1.1.x to 1.2.1, the step to explicitly apply the OPA CRD is not needed anymore.

## 1.2.0

> Released on 2021/03/09

### Changes

- Added Open Policy Agent integration
- Improved authentication support for control planes in multi-zone deployments, with the Kuma Discovery Protocol (KDS)
- Added FIPS support to the data plane proxy sidecar
- Added XDSv3 for control plane to data plane proxy communication
- Build on top of Kuma 1.1.0 with [fixes and improvements](https://github.com/kumahq/kuma/blob/master/CHANGELOG.md#110)

### Upgrading

#### Kubernetes with `kumactl`

If you previously installed Kong Mesh with `kumactl install control-plane --license-path=... | kubectl apply -f -`,
you must first uninstall the previous version and then install the new version. All policies are removed when you uninstall,
so make sure to back up all related CRDs before you start. Then:

1.  Install Kong Mesh for Kubernetes using `kumactl install control-plane ...` with any additional command-line arguments you require.

2.  Delete the old Deployment, Service, Webhooks, and Validation hooks:

    ```sh
    kubectl delete -n kong-mesh-system deploy/kuma-control-plane
    kubectl delete -n kong-mesh-system service/kuma-control-plane
    kubectl delete mutatingwebhookconfiguration/kuma-admission-mutating-webhook-configuration
    kubectl delete validatingwebhookconfiguration/kuma-validating-webhook-configuration
    ```

3.  Restart all the pods in the meshes to make sure the new sidecars are deployed and connected to the newly deployed control plane.

#### Kubernetes with Helm

The supplied Helm Chart takes care of upgrading the control plane. Because of the way [Helm handles CRDs](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/), however, you must apply the new OPA CRD:

1.  Install the new CRD

    ```sh
    kubectl apply -f https://docs.konghq.com/mesh/1.2.x/patches/opa-policy.yaml
    ```

2.  Upgrade Kong Mesh with Helm:

    ```sh
    helm repo update
    helm --namespace kong-mesh-system upgrade my-kong-mesh kong-mesh/kong-mesh
    ```

3.  Restart all the pods in the meshes to make sure the new sidecars are deployed and connected to the newly deployed control plane.
