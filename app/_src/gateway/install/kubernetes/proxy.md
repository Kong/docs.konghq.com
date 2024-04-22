---
title: Install Kong Gateway
book: kubernetes-install
chapter: 2
---

This guide explains how to deploy {{ site.base_gateway }} on Kubernetes without using [{{ site.konnect_saas }}](/konnect/gateway-manager/data-plane-nodes/) or [{{ site.kic_product_name }}](/kubernetes-ingress-controller/latest/get-started/).

{:.important}
> **{{ site.konnect_saas }} is recommended for new installations to reduce deployment complexity.**
> <br />
> Let Kong run the control plane and database for you. With {{ site.konnect_saas }}, you only need to run the data planes. <a href="https://konghq.com/products/kong-konnect/register?utm_medium=referral&utm_source=docs&utm_campaign=gateway-konnect&utm_content=kubernetes-install">Get started in under 5 minutes</a>.

These instructions configure {{ site.base_gateway }} to use separate control plane and data plane deployments. This is the recommended production installation method.

## Prerequisites

- [`Helm 3`](https://helm.sh/)
- [`kubectl`](https://kubernetes.io/docs/tasks/tools/) v1.19 or later
- A running PostgreSQL database

### Helm Setup

Kong provides a Helm chart for deploying  {{ site.base_gateway }}. Add the `charts.konghq.com` repository and run `helm repo update` to ensure that you have the latest version of the chart.

```bash
helm repo add kong https://charts.konghq.com
helm repo update
```

## Secrets


### {{ site.ee_product_name }} License

First, create the `kong` namespace:

```bash
kubectl create namespace kong
```

Next, create a {{site.ee_product_name}} license secret:

{% navtabs %}
{% navtab Kong Gateway Enterprise Free Mode%}

    kubectl create secret generic kong-enterprise-license --from-literal=license="'{}'" -n kong

{% endnavtab %}
{% navtab Kong Gateway Enterprise Licensed Mode%}

   > Ensure you are in the directory that contains a `license.json` file before running this command. 

    kubectl create secret generic kong-enterprise-license --from-file=license=license.json -n kong

{% endnavtab %}
{% endnavtabs %}

### Clustering Certificates

{{ site.base_gateway }} uses mTLS to secure the control plane/data plane communication when running in hybrid mode.

1. Generate a TLS certificate using OpenSSL.

    ```bash
    openssl req -new -x509 -nodes -newkey ec:<(openssl ecparam -name secp384r1) -keyout ./tls.key -out ./tls.crt -days 1095 -subj "/CN=kong_clustering"
    ```

1. Create a Kubernetes secret containing the certificate.

    ```
    kubectl create secret tls kong-cluster-cert --cert=./tls.crt --key=./tls.key -n kong
    ```

## Installation

### Control Plane

The control plane contains all {{ site.base_gateway }} configurations. The configuration is stored in a PostgreSQL database.

1. Create a `values-cp.yaml` file.

{% capture values_file %}
{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
{% include md/gateway/k8s-install-proxy-cp.md release=page.release package='ee' %}
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
{% include md/gateway/k8s-install-proxy-cp.md release=page.release package='oss' %}
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}

{{ values_file | indent }}

1. _(Optional)_ If you want to deploy a Postgres database within the cluster for testing purposes, add the following to the bottom of `values-cp.yaml`.

    ```yaml
    # This is for testing purposes only
    # DO NOT DO THIS IN PRODUCTION
    # Your cluster needs a way to create PersistantVolumeClaims
    # if this option is enabled
    postgresql:
      enabled: true
      auth:
        password: demo123
    ```

1. Update the database connection values in `values-cp.yaml`.

    - `env.pg_database`: The database name to use
    - `env.pg_user`: Your database username
    - `env.pg_password`: Your database password
    - `env.pg_host`: The hostname of your Postgres database
    - `env.pg_ssl`: Use SSL to connect to the database

1. Set your Kong Manager super admin password in `values-cp.yaml`.

    - `env.password`: The Kong Manager super admin password

1. Run `helm install` to create the release.

    ```bash
    helm install kong-cp kong/kong -n kong --values ./values-cp.yaml
    ```

1. Run `kubectl get pods -n kong`. Ensure that the control plane is running as expected.

    ```
    NAME                                 READY   STATUS
    kong-cp-kong-7bb77dfdf9-x28xf        1/1     Running
    ```

### Data Plane

The {{ site.base_gateway }} data plane is responsible for processing incoming traffic. It receives the routing configuration from the control plane using the clustering endpoint.

1. Create a `values-dp.yaml` file.

{% capture values_file %}
{% navtabs_ee codeblock %}
{% navtab Kong Gateway %}
{% include md/gateway/k8s-install-proxy-dp.md release=page.release package='ee' %}
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
{% include md/gateway/k8s-install-proxy-dp.md release=page.release package='oss' %}
{% endnavtab %}
{% endnavtabs_ee %}
{% endcapture %}

{{ values_file | indent }}

1. Run `helm install` to create the release.

   ```bash
   helm install kong-dp kong/kong -n kong --values ./values-dp.yaml
   ```

1. Run `kubectl get pods -n kong`. Ensure that the data plane is running as expected.

    ```
    NAME                                 READY   STATUS
    kong-dp-kong-5dbcd9f6b9-f2w49        1/1     Running
    ```

## Testing

{{ site.base_gateway }} is now running. To send some test traffic, try the following:

1. Fetch the `LoadBalancer` address for the `kong-dp` service and store it in the `PROXY_IP` environment variable

    ```bash
    PROXY_IP=$(kubectl get service --namespace kong kong-dp-kong-proxy -o jsonpath='{range .status.loadBalancer.ingress[0]}{@.ip}{@.hostname}{end}')
    ```

1. Make a HTTP request to your `$PROXY_IP`. This will return a `HTTP 404` served by {{ site.base_gateway }}

    ```bash
    curl $PROXY_IP/mock/anything
    ```

1. In another terminal, run `kubectl port-forward` to set up port forwarding and access the admin API.

    ```bash
    kubectl port-forward -n kong service/kong-cp-kong-admin 8001
    ```

1. Create a mock service and route

    ```bash
    curl localhost:8001/services -d name=mock  -d url="http://httpbin.org"
    curl localhost:8001/services/mock/routes -d "paths=/mock"
    ```

1. Make a HTTP request to your `$PROXY_IP` again. This time {{ site.base_gateway }} will route the request to httpbin.

    ```bash
    curl $PROXY_IP/mock/anything
    ```
