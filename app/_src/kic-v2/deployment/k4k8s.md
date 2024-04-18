---
title: Kong for Kubernetes
---

Kong for Kubernetes is an Ingress Controller based on the
Open-Source {{site.base_gateway}}. It consists of two components:

- **Kong** the Open-Source Gateway
- **Controller** a daemon process that integrates with the Kubernetes platform and configures Kong.

## Installers

Kong for Kubernetes can be installed using an installer of
your choice. After the installation is complete, see the [getting started](/kubernetes-ingress-controller/{{page.release}}/guides/getting-started) tutorial to learn more.

{% navtabs %}
{% navtab YAML manifests %}


You can install {{ site.kic_product_name }} with a single `kubectl apply` for testing purposes:

```bash
$ kubectl apply -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/v{{ page.release }}/deploy/single/all-in-one-dbless.yaml
```

There are additional instructions for the following platforms:

- [Minikube](/kubernetes-ingress-controller/{{page.release}}/deployment/minikube/)
- [Google Kubernetes Engine(GKE) by Google](/kubernetes-ingress-controller/{{page.release}}/deployment/gke/)
- [Elastic Kubernetes Service(EKS) by Amazon](/kubernetes-ingress-controller/{{page.release}}/deployment/eks/)
- [Azure Kubernetes Service(AKS) by Microsoft](/kubernetes-ingress-controller/{{page.release}}/deployment/aks/)

{% endnavtab %}
{% navtab Kustomize %}

{:.important}
> Kustomize manifests are provided for illustration purposes only and are not officially supported by Kong.
There is no guarantee of backwards compatibility or upgrade capabilities for our Kustomize manifests.
For a production setup with Kong support, use the [Helm chart](https://github.com/kong/charts).

1. Install Kong for Kubernetes using Kustomize:

    ```bash
    kubectl apply -k github.com/kong/kubernetes-ingress-controller/config/base
    ```
    You can use the above URL as a base kustomization and build on top of it
    to make it suite better for your cluster and use-case.
1. Kubernetes exposes the proxy through a Kubernetes service. Run the following commands to store the load balancer IP address in a variable named `PROXY_IP`:

    ```bash
    HOST=$(kubectl get svc --namespace kong kong-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    PORT=$(kubectl get svc --namespace kong kong-proxy -o jsonpath='{.spec.ports[0].port}')
    export PROXY_IP=${HOST}:${PORT}
    echo $PROXY_IP  
    ```
{% endnavtab %}
{% navtab Helm %}

1. Install {{site.kic_product_name}} and {{ site.base_gateway }} with Helm:

    ```
    $ helm repo add kong https://charts.konghq.com
    $ helm repo update
    $ helm install kong kong/ingress -n kong --create-namespace
    ```
1. Kubernetes exposes the proxy through a Kubernetes service. Run the following commands to store the load balancer IP address in a variable named `PROXY_IP`:

    ```
    HOST=$(kubectl get svc --namespace kong kong-gateway-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    PORT=$(kubectl get svc --namespace kong kong-gateway-proxy -o jsonpath='{.spec.ports[0].port}')
    export PROXY_IP=${HOST}:${PORT}
    echo $PROXY_IP   
    ```
{% endnavtab %}
{% endnavtabs %}
