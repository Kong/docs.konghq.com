---
title: Kong Mesh Changelog
no_search: true
no_version: true
skip_read_time: true
---

## 1.2.0

> Released on 2021/03/09

### Changes 

- Adding the Open Policy Agent integration
- Authentication support for the Kuma Discovery Protocol (KDS) used in multi-zone deployments to connect
- FIPS enabled side-car
- Uses XDSv3 for Control Plane to Data plane proxy communication
- Build on top of Kuma 1.1.0 with warious small [fixes and improvements](https://github.com/kumahq/kuma/blob/master/CHANGELOG.md#110)

### Upgrading

#### Kubernetes with `kumactl`

If the previous installation of Kong Mesh was done using `kumactl install control-plane --license-path=... | kubectl apply -f -`,
the upgrade needs to first uninstall the previous version and then install the new one from scratch. This also means that all the
policies will be removed. We do recommend to backup all the related CRDs before applying the upgrade.

1. Install Kong Mesh for Kubernetes using `kumactl install control-plane ...` applyion all the neede customization command line arguments

2. Delete the old Deployment, Service, Webhooks, Validation Hooks using the following commands

```sh
kubectl delete -n kong-mesh-system deploy/kuma-control-plane
kubectl delete -n kong-mesh-system service/kuma-control-plane
kubectl delete mutatingwebhookconfiguration/kuma-admission-mutating-webhook-configuration
kubectl delete validatingwebhookconfiguration/kuma-validating-webhook-configuration
```

3. Restart all the pods in the meshes to make sure the new side-cars are deployed and connected to the newly deployed Control Plane

#### Kubernetes with Helm

The supplied Helm Chart will take care of the upgrades of the control plane. However, due to how [Helm handles CRDs](https://helm.sh/docs/chart_best_practices/custom_resource_definitions/)
we need to apply the new OPA CRD. The steps for the upgrade are as follows

1. Install the new CRD

```sh
kubectl apply -f https://docs.konghq.com/mesh/1.2.x/patches/opa-policy.yaml
```

2. Upgrade Kong Mesh with Helm:
```sh
helm repo update
helm --namespace kong-mesh-system upgrade my-kong-mesh kong-mesh/kong-mesh
```

3. Restart all the pods in the meshes to make sure the new side-cars are deployed and connected to the newly deployed Control Plane

