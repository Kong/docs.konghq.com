---
title: Kong Mesh Changelog
no_search: true
no_version: true
---

## 1.2.2

> Released on 2021/04/09

### Changes

- Build on top of Kuma 1.1.2 with [fixes and improvements](https://github.com/kumahq/kuma/blob/master/CHANGELOG.md#112)

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
