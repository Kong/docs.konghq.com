---
title: Kong for Kubernetes Enterprise
---

Kong for Kubernetes Enterprise is an enhanced version of
the Open-Source Ingress Controller. It includes all
Enterprise plugins and comes with 24x7 support for worry-free
production deployment.
This is available only for enterprise customers of Kong, Inc.

## Before you begin

1. Create the `kong` namespace in the cluster to create a secret.

    ```bash
    $ kubectl create namespace kong
    ```
    The results should look like this:
    ```text
    namespace/kong created
    ```
1. Create {{site.ee_product_name}} [License secret](#kong-enterprise-license-secret)

{% include_cached /md/kic/kong-enterprise-license-secret.md version=page.version %}

### Installing {{site.ee_product_name}}

Kong for Kubernetes Enterprise can be installed using an installer of your choice. After the installation is complete, see the [getting started](/kubernetes-ingress-controller/{{page.release}}/guides/getting-started) tutorial to learn more.

{% navtabs %}
{% navtab YAML manifests %}
1. Install Kong for Kubernetes Enterprise using YAML manifests.

    ```bash
    kubectl apply -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/v{{ page.version }}/deploy/single/all-in-one-dbless-k4k8s-enterprise.yaml
    ```
    The results should look like this:
    ```text
    role.rbac.authorization.k8s.io/kong-leader-election created
    clusterrole.rbac.authorization.k8s.io/kong-ingress created
    clusterrole.rbac.authorization.k8s.io/kong-ingress-crds created
    clusterrole.rbac.authorization.k8s.io/kong-ingress-gateway created
    clusterrole.rbac.authorization.k8s.io/kong-ingress-knative created
    rolebinding.rbac.authorization.k8s.io/kong-leader-election created
    clusterrolebinding.rbac.authorization.k8s.io/kong-ingress created
    clusterrolebinding.rbac.authorization.k8s.io/kong-ingress-crds created
    clusterrolebinding.rbac.authorization.k8s.io/kong-ingress-gateway created
    clusterrolebinding.rbac.authorization.k8s.io/kong-ingress-knative created
    service/kong-admin created
    service/kong-proxy created
    service/kong-validation-webhook created
    deployment.apps/ingress-kong created
    deployment.apps/proxy-kong created
    ingressclass.networking.k8s.io/kong created
    ```
1. Check if the {{site.kic_product_name}} is ready.     
    ```bash
    $ kubectl get pods -n kong
    ```
    The results should look like this:
    ```text
    NAME                            READY   STATUS    RESTARTS   AGE
    ingress-kong-6ffcf8c447-5qv6z   2/2     Running   1          44m
    ```
    It takes a few minutes the first time you set this up.
1. Check if the `kong-proxy` service is deployed.

    ```bash
    $ kubectl get service kong-proxy -n kong
    ```
    The results should look like this:
    ```text
    NAME         TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                      AGE
    kong-proxy   LoadBalancer   10.63.254.78   192.168.99.100   80:32697/TCP,443:32365/TCP   22h
    ```

   > Note: Depending on the Kubernetes distribution you are using, you might or might not see an external IP address assigned to the service. To obtain an IP address for a Kubernetes Service of type `LoadBalancer`, see your cloud provider's documentation.

1. Kubernetes exposes the proxy through a Kubernetes service. Run the following commands to store the load balancer IP address in a variable named `PROXY_IP`:

    ```bash
    $ export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong kong-proxy)
    echo $PROXY_IP
    ```
    The results should look like this:
    ```text
    192.168.99.100
    ```

    {:.note}
    > Note: It may take a while for your cloud provider to actually associate the
    IP address to the `kong-proxy` Service.

{% endnavtab %}
{% navtab Kustomize %}
{:.important}
> Kustomize manifests are provided for illustration purposes only and are not officially supported by Kong.
There is no guarantee of backwards compatibility or upgrade capabilities for our Kustomize manifests.
For a production setup with Kong support, use the [Helm chart](https://github.com/kong/charts).

1. Install Kong for Kubernetes using Kustomize:

    ```bash
    kubectl apply -k github.com/kong/kubernetes-ingress-controller/config/variants/enterprise
    ```
    You can use this as a base kustomization and build on top of it for your cluster and use-case.

    The results should look like this:
    ```text
    role.rbac.authorization.k8s.io/kong-leader-election created
    clusterrole.rbac.authorization.k8s.io/kong-ingress created
    clusterrole.rbac.authorization.k8s.io/kong-ingress-crds created
    clusterrole.rbac.authorization.k8s.io/kong-ingress-gateway created
    clusterrole.rbac.authorization.k8s.io/kong-ingress-knative created
    rolebinding.rbac.authorization.k8s.io/kong-leader-election created
    clusterrolebinding.rbac.authorization.k8s.io/kong-ingress created
    clusterrolebinding.rbac.authorization.k8s.io/kong-ingress-crds created
    clusterrolebinding.rbac.authorization.k8s.io/kong-ingress-gateway created
    clusterrolebinding.rbac.authorization.k8s.io/kong-ingress-knative created
    service/kong-admin created
    service/kong-proxy created
    service/kong-validation-webhook created
    deployment.apps/ingress-kong created
    deployment.apps/proxy-kong created
    ingressclass.networking.k8s.io/kong created
    ```

1. Kubernetes exposes the proxy through a Kubernetes service. Run the following commands to store the load balancer IP address in a variable named `PROXY_IP`:

    ```bash
    HOST=$(kubectl get svc --namespace kong kong-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    PORT=$(kubectl get svc --namespace kong kong-proxy -o jsonpath='{.spec.ports[0].port}')
    export PROXY_IP=${HOST}:${PORT}
    echo $PROXY_IP  
    ```
    The results should look like this:
    ```text
    192.168.99.100:80
    ```
{% endnavtab %}
{% navtab Helm %}
You can use Helm to install Kong using the official Helm chart:
1. Create a `values.yaml` file with these details to deploy using Helm charts.
    ```
    gateway:
        image:
          repository: kong/kong-gateway
          tag: {{ site.data.kong_latest_gateway.ee-version }}
        env:
          LICENSE_DATA:
            valueFrom:
              secretKeyRef:
                name: kong-enterprise-license
                key: license
    ```
1. Install {{site.kic_product_name}} and {{ site.base_gateway }} with Helm:

    ```
    $ helm repo add kong https://charts.konghq.com
    $ helm repo update
    $ helm install kong kong/ingress -n kong --create-namespace --values ./values.yaml
    ```
    The results should look like this:
    ```text
    NAME: kong
    LAST DEPLOYED: Fri Oct  6 14:41:16 2023
    NAMESPACE: kong
    STATUS: deployed
    REVISION: 1
    TEST SUITE: None
    ```
1. Kubernetes exposes the proxy through a Kubernetes service. Run the following commands to store the load balancer IP address in a variable named `PROXY_IP`:

    ```
    HOST=$(kubectl get svc --namespace kong kong-gateway-proxy -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
    PORT=$(kubectl get svc --namespace kong kong-gateway-proxy -o jsonpath='{.spec.ports[0].port}')
    export PROXY_IP=${HOST}:${PORT}
    echo $PROXY_IP   
    ```
    The results should look like this:
    ```text
    192.168.99.100:80
    ```
{% endnavtab %}
{% endnavtabs %}
