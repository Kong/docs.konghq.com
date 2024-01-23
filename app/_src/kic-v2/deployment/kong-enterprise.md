---
title: Kong for Kubernetes Enterprise (DB Mode)
---

Learn to set up the {{site.kic_product_name}} using {{site.ee_product_name}}. This architecture is described in detail in [Kong for Kubernetes with {{site.ee_product_name}}](/kubernetes-ingress-controller/{{page.release}}/concepts/k4k8s-with-kong-enterprise/).

To start from scratch deploy {{site.ee_product_name}} and its database in Kubernetes itself. You can safely run them outside
Kubernetes as well.

## Before you begin
* Create the `kong` namespace.
    ```bash
    $ kubectl create namespace kong
    ```
    The results should look like this:
    ```text
    namespace/kong created
    ```

* Create {{site.ee_product_name}} bootstrap password. Replace `cloudnative` with a random password of your choice and note it down
    ```bash
    $ kubectl create secret generic kong-enterprise-superuser-password  -n kong --from-literal=password=cloudnative
    ```
    The results should look like this:
    ```text
    secret/kong-enterprise-superuser-password created
    ```

* Create [{{site.ee_product_name}} License secret](#kong-enterprise-license-secret)

{% include_cached /md/kic/kong-enterprise-license-secret.md version=page.version %}    

## Install {{site.ee_product_name}} Ingress Controller
1. Deploy {{site.ee_product_name}} Ingress Controller.
    ```bash
    kubectl apply -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/v{{ page.version }}/deploy/single/all-in-one-postgres-enterprise.yaml
    ```
    It takes a little while to bootstrap the database. Once bootstrapped, you should see the {{site.kic_product_name}} running with {{site.ee_product_name}} as its core

1. Check if {{site.kic_product_name}}  and the database is deployed.
    ```bash
    $ kubectl get pods -n kong
    ```
    The results should look like this:
    ```text
    NAME                            READY   STATUS      RESTARTS   AGE
    ingress-kong-548b9cff98-n44zj   2/2     Running     0          21s
    kong-migrations-pzrzz           0/1     Completed   0          4m3s
    postgres-0                      1/1     Running     0          4m3s
    ```
1. Check if the `kong-proxy` service is running in the cluster.

    ```bash
    $ kubectl get services -n kong
    ```
    The results should look like this:
    ```text
    NAME                      TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)                      AGE
    kong-admin                LoadBalancer   10.63.255.85    34.83.95.105    80:30574/TCP                 4m35s
    kong-manager              LoadBalancer   10.63.247.16    34.83.242.237   80:31045/TCP                 4m34s
    kong-proxy                LoadBalancer   10.63.242.31    35.230.122.13   80:32006/TCP,443:32007/TCP   4m34s
    kong-validation-webhook   ClusterIP      10.63.240.154   <none>          443/TCP                      4m34s
    postgres                  ClusterIP      10.63.241.104   <none>          5432/TCP                     4m34s

    ```

    > Note: Depending on the Kubernetes distribution you are using, you might or might
    not see an external IP assigned to the three `LoadBalancer` type services. Please see
    your provider's documentation to obtain an IP address for a Kubernetes Service of
    type `LoadBalancer`. If you are running minikube, an external IP address may not be listed.
    For more information about accessing the service of type `LoadBalancer` in minikube,
    see [LoadBalancer access](https://minikube.sigs.k8s.io/docs/handbook/accessing/#loadbalancer-access).

1. Setup Kong Manager. 
   If you browse to Kong Manager with the ip address and login as `kong_admin` and the password you provided in the earlier step, it fails. You need to take the External IP address of `kong-admin` service and set the environment variable `KONG_ADMIN_IP`:
    ```bash
    export KONG_ADMIN_IP=$(kubectl get svc -n kong kong-admin --output=jsonpath='{.status.loadBalancer.ingress[0].ip}')
    kubectl patch deployment -n kong ingress-kong -p "{\"spec\": { \"template\" : { \"spec\" : {\"containers\":[{\"name\":\"proxy\",\"env\": [{ \"name\" : \"KONG_ADMIN_API_URI\", \"value\": \"${KONG_ADMIN_IP}\" }]}]}}}}"
    ```

    It takes a few minutes to roll out the updated deployment and after the new
    `ingress-kong` pod is up and running, you should be able to log into the Kong Manager UI.

    As you follow along with other guides on how to use your newly deployed the {{site.kic_product_name}},
    you can browse Kong Manager and see changes reflected in the UI as Kong's configuration changes.

1.  Setup an environment variable to hold the IP address of `kong-proxy` service.

    ```bash
    $ export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong kong-proxy)
    ```

After you've installed Kong for {{site.ee_product_name}}, follow our [getting started](/kubernetes-ingress-controller/{{page.release}}/guides/getting-started) tutorial to learn more.

## Customizing by use-case

The deployment in this guide is a point to start using Ingress Controller.
Based on your existing architecture, this deployment requires custom
work to make sure that it needs all of your requirements.

In this guide, there are three load-balancers deployed for each of
Kong Proxy, Kong Admin and Kong Manager services. It is possible and
recommended to instead have a single Load balancer and then use DNS names
and Ingress resources to expose the Admin and Manager services outside
the cluster.
