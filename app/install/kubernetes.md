---
id: page-install-method
title: Install - Kong for Kubernetes
header_title: Kong for Kubernetes
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
links:
  helm_hub: "https://hub.helm.sh/charts/stable/kong"
---


Kong, by design, is configured dynamically and responds to the changes
in your infrastructure.

Kong is deployed onto Kubernetes along-with a
[Controller](https://kubernetes.io/docs/concepts/architecture/controller/),
which is responsible for configuring Kong.  
All of Kong's configuration
is done using Kubernetes resources, stored in Kubernetes' data-store (`etcd`).
You can use the power of `kubectl` (or any custom tooling around `kubectl`) to
configure Kong and get benefits of all Kubernetes, such as declarative
configuration, cloud-provider agnostic deployments, RBAC, reconciliation 
of desired state, and elastic scalability. 

Kong is configured using a combination of Ingress resource and
Custom Resource Definitions(CRDs).

You can learn more about the design and deployment model
[here](https://github.com/Kong/kubernetes-ingress-controller/tree/master/docs#concepts).

You can use one of the following tools to install Kong on Kubernetes:

## YAML manifests

To get started with Kong via `kubectl`, a simple deployment can be achieved
using:

```
kubectl apply -f https://bit.ly/kong-ingress-dbless
```

Please note that this does not serve as a production-grade deployment.
There are certain knobs that you would want to tweak based on your use-case:
- Replicas: ensure that you are running multiple instances of Kong to protect
  against outages from a single node failure.
- Kong's performance optimizaiton: You have to tweak various memory settings
  of Kong as and how you tailor the deployment to your use-case.
- Load-balancer: ensure that you are running a Layer-4 or TCP based
  balancer in-front of Kong. This makes it possible for Kong to serve TLS
  certificate and take advantage of integration with cert-manager.

## Helm Chart

Kong has an official Helm chart.

To deploy Kong onto your Kubernetes cluster with Helm:

```shell
helm repo update # get the latest charts
helm install stable/kong
```

Documentation on the Helm chart can be found
on Helm's [Hub]({{ page.links.helm_hub }}).

## Kustomize

Kong's manifests for Kubernetes can be declaratively pactched using
[kustomize](https://kustomize.io/).

Here is an example of a remote custom build:

```
kustomize build bit.ly/kong-kustomize-base
```

There are kustomizations avaialable in our
[repository](https://github.com/Kong/kubernetes-ingress-controller/tree/master/deploy/manifests)
for different types of deployments.


## Managed Kubernetes by cloud-provider

To install Kong on a managed Kubernetes offering such as GKE, EKS, AKS, etc,
please ensure that you have set up your Kubernetes cluster on the cloud-provider
and have `kubectl` configured on your workstation.

Once you've it configured, installation for any cloud-provider remains the
same, you can use any of the above methods to install Kong.

Each cloud-provider has some minor variation in how they allow configuring
specific resources like Load-balancers, volumes, etc, and we recommend
following their documentation to tweak those settings.

## Using a database

We recommend running Kong in the in-memory (also known as `DB-less`) mode
inside Kubernetes as all the configuration is stored in Kubernetes
control-plane.
This setup drastically simplifies Kong's operations as one doesn't need to
worry about Database provisioning, backup, availability, security, etc.

In case you decide to use a database, it is recommended that you run the
database outside Kubernetes. You can use a service like Amazon's RDS
or a similar managed Postgres service from your cloud-provider to
automate database operations.

We **do not** recommend using Kong with Cassandra on Kubernetes deployments,
as the features covered by Kong's use of Cassandra are taken care of by other
means in Kubernetes.

## Configuring 

Once you have got Kong installed on Kubernetes, please follow one of our
[guides](https://github.com/Kong/kubernetes-ingress-controller/tree/master/docs/guides)
to start configuring Kong.

All the documentation on how Kong works with Kubernetes can be found
at the following location:
[https://github.com/Kong/kubernetes-ingress-controller/tree/master/docs](https://github.com/Kong/kubernetes-ingress-controller/tree/master/docs)


For questions and discussion,
please visit [Kong Nation](https://discuss.konghq.com/c/kubernetes).
