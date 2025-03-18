---
title: Migrate Konnect DataPlanes from KGO v1.4.x to v1.5.x
---

TODO: double check and put the following in a better form

This document helps to migrate from `gateway-operator.konghq.com` to `konnect.konghq.com` `KonnectExtension`.

1. install new crds
	1. Force conflicts in case the CRDs were installed via helm: `kustomize build https://github.com/kong/kubernetes-configuration/crd/gateway-operator | kubectl apply --server-side --force-conflicts -f -`
2. Label cert secret: `kubectl label secret -n kong konnect-client-tls konghq.com/konnect-dp-cert=true`
3. upgrade to new controller version
4. create:
	1. `KonnectAPIAuthConfiguration`
	2. The new `KonnectExtension.konnect.kongh.com` (must reference the Konnect CP by KonnectID)
5. flip the dataplane to use the new extension: Change group
6. remove the finalizer from the old extension: `kubectl patch konnectextensions.gateway-operator.konghq.com example-konnect-config -n kong -p '{"metadata":{"finalizers":null}}' --type=merge`
7. delete the old `gateway-operator.konghq.com` extension
