---
title: Kong Mesh Changelog
no_search: true
no_version: true
---

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

   - `--mode` now accepts now accepts the values `standalone`, `zone`, and `global`. `zone` replaces `remote`, which is still available in earlier versions.

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

- ⚠️ All installation scripts are updated to a new location, because Bintray is shutting down. If you've written automation scripts that refer to the Bintray location, you need to update your scripts to point to the new location.
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
