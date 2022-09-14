---
title: Install on Kubernetes
---

This page explains how to install {{site.base_gateway}} with {{site.kic_product_name}} in DB-less mode. To install with a database, see the documentation on installing with [Helm](/gateway/{{page.kong_version}}/install/kubernetes/helm-quickstart).

This page also includes the equivalent commands for OpenShift.

In DB-less mode on Kubernetes, the config is stored in etcd, the Kubernetes native data store. For more information, see [Kubernetes Deployment Options](/gateway/{{page.kong_version}}/install/kubernetes/deployment-options).

The {{site.base_gateway}} software is governed by the
[Kong Software License Agreement](https://konghq.com/kongsoftwarelicense).
{{site.ce_product_name}} is licensed under an
[Apache 2.0 license](https://github.com/Kong/kong/blob/master/LICENSE).

## Prerequisites

- A Kubernetes cluster, v1.19 or later
- `kubectl` v1.19 or later
- (Enterprise only) A `license.json` file from Kong

## Create namespace

Create the namespace for {{site.base_gateway}} with {{site.kic_product_name}}. For example:

{% navtabs codeblock %}
{% navtab Kubernetes %}
```sh
kubectl create namespace kong
```
{% endnavtab %}
{% navtab OpenShift %}
```sh
oc new-project kong
```
{% endnavtab %}
{% endnavtabs %}

## Create license secret
{:.badge .enterprise}

1.  Save your license file temporarily with the filename `license` (no file extension).

1.  Run:

{% capture the_code %}
{% navtabs codeblock %}
{% navtab Kubernetes %}
```sh
kubectl create secret generic kong-enterprise-license --from-file=<absolute-path-to>/license -n kong
```
{% endnavtab %}
{% navtab OpenShift %}
```sh
oc create secret generic kong-enterprise-license --from-file=./license -n kong
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

## Deploy

1.  Run one of the following:

{% capture the_code %}
{% navtabs codeblock %}
{% navtab Kubernetes %}
```sh
kubectl apply -f https://bit.ly/k4k8s-enterprise-install
```
{% endnavtab %}
{% navtab Kubernetes (OSS) %}
```sh
kubectl apply -f https://bit.ly/kong-ingress-dbless
```
{% endnavtab %}
{% navtab OpenShift %}
```sh
oc create -f https://bit.ly/k4k8s-enterprise-install
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

    This might take a few minutes.

1.  Check the install status:

{% capture the_code %}
{% navtabs codeblock %}
{% navtab Kubernetes %}
```sh
kubectl get pods -n kong
```
{% endnavtab %}
{% navtab OpenShift %}
```sh
oc get pods -n kong
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

1.  To make HTTP requests, you need the IP address of the load balancer. Get the `loadBalancer` address and store it in a local `PROXY_IP` environment variable:

    {:.note}
    > **Note:** Some cluster providers only provide a DNS name for load balancers. In this case, specify `.hostname` instead of `.ip`.

    ```sh
    export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong kong-proxy)
    ```

    If you're testing locally and have not deployed a loadbalancer, you can port forward the `kong-proxy` service to test:

    ```sh
    kubectl port-forward -n kong svc/kong-proxy 8000:80
    ```

    Then in a different terminal window:

    ```sh
    export PROXY_IP=localhost:8000
    ```

1.  Verify that the value of `$PROXY_IP` matches the value of the external host:

    ```sh
    echo $PROXY_IP
    ```

    This should match the `EXTERNAL_IP` value of the `kong-proxy` service returned by the Kubernetes API:

{% capture the_code %}
{% navtabs codeblock %}
{% navtab Kubernetes %}
```sh
kubectl get service kong-proxy -n kong
```
{% endnavtab %}
{% navtab OpenShift %}
```sh
oc get service kong-proxy -n kong
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

1. Invoke a test request:
    ```sh
    curl $PROXY_IP
    ```

    This should return the following response from Gateway:

    ```sh
    {"message":"no Route matched with those values"}
    ```

## Next steps

See the [Kong Ingress Controller docs](/kubernetes-ingress-controller/) for  how-to guides, reference guides, and more.
