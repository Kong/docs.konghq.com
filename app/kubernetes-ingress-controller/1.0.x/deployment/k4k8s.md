---
title: Kong for Kubernetes
---

Kong for Kubernetes is an Ingress Controller based on the
Open-Source Kong Gateway. It consists of two components:

- **Kong**: the Open-Source Gateway
- **Controller**: a daemon process that integrates with the
  Kubernetes platform and configures Kong.

## Installers

Kong for Kubernetes can be installed using an installer of
your choice.

Once you've installed Kong for Kubernetes,
jump to the [next section](#using-kong-for-kubernetes)
on using it.

### YAML manifests

Please pick one of the following guides depending on your platform:

- [Minikube](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/minikube)
- [Google Kubernetes Engine(GKE) by Google](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/gke)
- [Elastic Kubernetes Service(EKS) by Amazon](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/eks)
- [Azure Kubernetes Service(AKS) by Microsoft](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/aks)

### Kustomize

<div class="alert alert-warning">
  Kustomize manifests are provided for illustration purposes only and are not officially supported by Kong.
  There is no guarantee of backwards compatibility or upgrade capabilities for our Kustomize manifests.
  For a production setup with Kong support, use the <a href="https://github.com/kong/charts">Helm Chart</a>.
</div>

Use Kustomize to install Kong for Kubernetes:

```
kustomize build github.com/kong/kubernetes-ingress-controller/deploy/manifests/base
```

You can use the above URL as a base kustomization and build on top of it
to make it suite better for your cluster and use-case.

Once installed, set an environment variable, $PROXY_IP with the External IP address of
the `kong-proxy` service in `kong` namespace:

```
export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong kong-proxy)
```

### Helm

You can use Helm to install Kong via the official Helm chart:

```
$ helm repo add kong https://charts.konghq.com
$ helm repo update

# Helm 2
$ helm install kong/kong

# Helm 3
$ helm install kong/kong --generate-name --set ingressController.installCRDs=false
```

Once installed, set an environment variable, $PROXY_IP with the External IP address of
the `demo-kong-proxy` service in `kong` namespace:

```
export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong demo-kong-proxy)
```

## Using Kong for Kubernetes

Once you've installed Kong for Kubernetes, please follow our
[getting started](/kubernetes-ingress-controller/{{page.kong_version}}/guides/getting-started) tutorial to learn more.
