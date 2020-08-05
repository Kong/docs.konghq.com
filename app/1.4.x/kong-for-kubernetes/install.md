---
title: Install - Kong for Kubernetes
---

This installation topic guides you through installing and deploying Kong for Kubernetes (K4K8S), then directs you to the documentation for configuring and using the product.

## Prerequisites
- **Kubernetes cluster**: You can use [Minikube](https://kubernetes.io/docs/setup/minikube/) or a [GKE](https://cloud.google.com/kubernetes-engine/) cluster. Kong is compatible with all distributions of Kubernetes.
- **kubectl access**: You should have `kubectl` installed and configured to communicate to your Kubernetes cluster.


## Installing Kong for Kubernetes
Use one of the following installation methods to install Kong for Kubernetes:
- [YAML manifests](#yaml-manifests)
- [Helm Chart](#helm-chart)
- [Kustomize](#kustomize)


### YAML manifests
To deploy Kong via `kubectl`, use:

```
kubectl apply -f https://bit.ly/kong-ingress-dbless
```

> Important! This is not a production-grade deployment. 
Adjust “knobs” based on your use case: 
- Replicas: Ensure that you are running multiple instances of Kong to protect against outages from a single node failure.
- Performance optimization: Adjust memory settings of Kong and tailor your deployment to your use case.
- Load-balancer: Ensure that you are running a Layer-4 or TCP based balancer in front of Kong. This allows Kong to serve a TLS certificate and integrate with a cert-manager.


### Helm Chart
Kong has an official Helm Chart. To deploy Kong onto your Kubernetes cluster with Helm, use:

```
$ helm repo add kong https://charts.konghq.com
$ helm repo update

# Helm 2
$ helm install kong/kong

# Helm 3
$ helm install kong/kong --generate-name --set ingressController.installCRDs=false
```

For more information about using a Helm Chart, see chart
[documentation](https://github.com/Kong/charts/blob/main/charts/kong/README.md).

### Kustomize
Kong’s manifests for Kubernetes can be declaratively patched using Kubernetes’ [kustomize](https://kustomize.io/). An example of a remote custom build is:

```
kustomize build github.com/kong/kubernetes-ingress-controller/deploy/manifests/base
```

kustomizations are available in Kong’s [repository](https://github.com/Kong/kubernetes-ingress-controller/tree/main/deploy/manifests) for different types of deployments.


## Using a managed Kubernetes offering
If you are using a cloud-provider to install Kong on a managed Kubernetes offering, such as Google Kubernetes Engine (GKE), Amazon EKS (EKS), Azure Kubernetes Service (AKS), and so on, ensure that you have set up your Kubernetes cluster on the cloud-provider and have `kubectl` configured on your workstation.

Once you have a Kubernetes cluster and kubectl configured, installation for any cloud-provider uses one of the above methods ([YAML manifests](#yaml-manifests), [Helm Chart](#helm-chart), or [Kustomize](#kustomize)) to install Kong.

Each cloud-provider has some minor variations in how they allow configuring specific resources like Load-balancers, volumes, etc. We recommend following their documentation to adjust these settings.


## Using a database for Kong for Kubernetes
If you are using a database, we recommend running Kong in the in-memory mode (also known as DB-less) inside Kubernetes as all of the configuration is stored in the Kubernetes control-plane. This setup simplifies Kong’s operations, so no need to worry about Database provisioning, backup, availability, security, etc.
If you decide to use a database, we recommend that you run the database outside of Kubernetes. You can use a service like Amazon’s RDS or a similar managed Postgres service from your cloud-provider to automate database operations.

We do not recommend using Kong with Cassandra on Kubernetes deployments, as the features covered by Kong’s use of Cassandra are handled by other means in Kubernetes.

## Next steps…
See [Using Kong for Kubernetes](/{{page.kong_version}}/kong-for-kubernetes/using-kong-for-kubernetes) for information about Concepts, How-to guides, and Reference guides.
