---
title: Running the Kubernetes Ingress Controller with Istio
---

This guide walks you through deploying {{site.base_gateway}} with {{site.kic_product_name}} 
as the gateway for [Istio][istio] as your service mesh solution.

See the [version compatibility reference][compat] for the
tested compatible versions of {{site.kic_product_name}} and Istio.

[istio]:https://istio.io
[compat]:/kubernetes-ingress-controller/{{page.kong_version}}/references/version-compatibility/#istio

## Overview

[Istio][istio] is a popular [service mesh][mesh] that enables [traffic
management][traffic-management], [security][security], and [observability][obs]
features for [Kubernetes][k8s] clusters.

With {{site.base_gateway}} and Istio, you can combine the
mesh features of Istio inside your cluster with Kong's rich feature set
for ingress traffic from outside the cluster.

This guide shows how to:

* Install Istio and {{site.base_gateway}} with {{site.kic_product_name}} in your cluster.
* Deploy an example Istio-enabled application.
* Deploy an `Ingress` customized with a Kong plugin for the example application.
* Make requests to the sample application via Kong and Istio.
* Explore the observability features of Istio to visualize cluster traffic.

[istio]:https://istio.io
[mesh]:https://istio.io/latest/docs/concepts/
[traffic-management]:https://istio.io/latest/docs/concepts/traffic-management/
[security]:https://istio.io/latest/docs/concepts/security/
[obs]:https://istio.io/latest/docs/concepts/observability/
[k8s]:https://kubernetes.io

### Prerequisites

* A Kubernetes cluster, v1.19 or later
* [kubectl][kubectl] v1.19 or later
* [Helm][helm] v3.5 or later
* [cURL][curl] version 7.x.x

You can use a managed cluster from a cloud provider, such as [AWS (EKS)][eks],
[Google Cloud (GKE)][gke], or [Azure (AKS)][aks], or you can work locally with 
tools such as [Minikube][minikube] or [Microk8s][microk8s].

Your Kubernetes cluster must provision
  `LoadBalancer` type [Services][svc]. Cloud providers generally
  automate `LoadBalancer` type `Service` provisioning with their default
  settings, but if you run your cluster elsewhere you might need to check 
  the relevant documentation for details. See also the Kubernetes documentation  
  for [external load balancers][svc-lb].

Some of the `kubectl` calls in this guide assume your test
  cluster is the current default cluster context. To check, or for more 
  information, see the Kubernetes documentation on 
  [configuring access to multiple clusters][contexts].

[kubectl]:https://kubernetes.io/docs/tasks/tools/#kubectl
[helm]:https://helm.sh/
[curl]:https://github.com/curl/curl
[eks]:https://aws.amazon.com/eks/
[gke]:https://cloud.google.com/kubernetes-engine/
[aks]:https://azure.microsoft.com/services/kubernetes-service/
[minikube]:https://github.com/kubernetes/minikube
[microk8s]:https://microk8s.io/
[svc]:https://kubernetes.io/docs/concepts/services-networking/service/
[svc-lb]:https://kubernetes.io/docs/tasks/access-application-cluster/create-external-load-balancer/#external-load-balancer-providers
[contexts]:https://kubernetes.io/docs/tasks/access-application-cluster/configure-access-multiple-clusters/

### Download and verify Istio

This guide shows how to install with [istioctl][istioctl], 
because it's the community recommended method. The [Istio installation guides][istio-install] 
explain alternative deployment mechanisms.

You can also explore the
  [Istio FAQ][install-method-faq] for more information about the differences
  between methods. However, if you choose another installation method,
  you might need to adjust the examples in this guide.

1.  Download the `istioctl` command-line utility for your platform:

    ```console
    curl -s -L https://istio.io/downloadIstio | ISTIO_VERSION=1.11.2 sh -
    ```

    The response includes instructions to set up the `istioctl` program locally and perform 
    pre-check validation of the Istio installation. 
    
1.  Make sure to add `istioctl` to your shell's path:

    ```console
    export PATH="$PATH:$PWD/istio-1.11.2/bin"
    ```

1.  Verify that `istioctl` is working, and run checks on your
Kubernetes cluster to ensure Istio will deploy to it properly:

    ```console
    istioctl x precheck
    ```

[istio-install]:https://istio.io/latest/docs/setup/install/
[istio-quickstart]:https://istio.io/latest/docs/setup/getting-started/
[istioctl]:https://istio.io/latest/docs/setup/install/istioctl/
[install-method-faq]:https://istio.io/latest/about/faq/#install-method-selection

### Deploy Istio

Istio provides [configuration profiles][istio-profiles] to let you customize your Istio 
deployment, and default profiles are included with the installation. This guide works with 
the `demo` profile, which is meant for testing and evaluation.

Deploy Istio with the `demo` profile:

```console
istioctl install --set profile=demo -y
```

[istio-profiles]:https://istio.io/latest/docs/setup/additional-setup/config-profiles/
[k8s-namespaces]:https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/

### Create an Istio-enabled namespace for {{site.kic_product_name}}

To integrate Istio's mesh functionality in any given Kubernetes
[Pod][k8s-pods], a [namespace][k8s-namespaces] must be [labeled][k8s-labels]
with the `istio-injection=enabled` label to instruct [IstioD][istiod] -- the main
control program for Istio -- to manage the pods and add them to the mesh network.

1.  Create the Istio-enabled namespace:

    ```console
    kubectl create namespace kong-istio
    ```

1.  Enable the namespace for the Istio mesh:

    ```console
    kubectl label namespace kong-istio istio-injection=enabled
    ```

[k8s-pods]:https://kubernetes.io/docs/concepts/workloads/pods/
[k8s-namespaces]:https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
[k8s-labels]:https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
[istiod]:https://istio.io/latest/docs/ops/deployment/architecture/#istiod

### Deploy {{site.base_gateway}} and {{site.kic_product_name}}

The [Kong Helm Chart][chart] deploys a Pod that includes containers for 
{{site.base_gateway}} and {{site.kic_product_name}}. Here's how to deploy it 
to the Istio-enabled `kong-istio` namespace.

1.  Make sure you have the Kong Helm repository configured locally:

    ```console
    helm repo add kong https://charts.konghq.com && helm repo update
    ```

1.  Deploy the chart:

    ```console
    helm install -n kong-istio kong-istio kong/kong
    ```

1.  Verify that Kong containers are deployed and the Istio sidecar container is injected
properly: 

    ```console
    kubectl describe pod -n kong-istio -l app.kubernetes.io/instance=kong-istio
    ```
    The output should look like: 

    ```console
    Events:
      Type     Reason     From               Message
      ----     ------     ----               -------
      Normal   Scheduled  default-scheduler  Successfully assigned kong-istio/kong-istio-kong-8f875f9fd-qsv4p to gke-istio-testing-default-pool-403b2219-l5ns
      Normal   Pulled     kubelet            Container image "docker.io/istio/proxyv2:1.11.2" already present on machine
      Normal   Created    kubelet            Created container istio-init
      Normal   Started    kubelet            Started container istio-init
      Normal   Pulling    kubelet            Pulling image "kong/kubernetes-ingress-controller:1.3"
      Normal   Pulled     kubelet            Successfully pulled image "kong/kubernetes-ingress-controller:1.3" in 2.645390171s
      Normal   Created    kubelet            Created container ingress-controller
      Normal   Started    kubelet            Started container ingress-controller
      Normal   Pulling    kubelet            Pulling image "kong:2.5"
      Normal   Pulled     kubelet            Successfully pulled image "kong:2.5" in 3.982679281s
      Normal   Created    kubelet            Created container proxy
      Normal   Started    kubelet            Started container proxy
      Normal   Pulled     kubelet            Container image "docker.io/istio/proxyv2:1.11.2" already present on machine
      Normal   Created    kubelet            Created container istio-proxy
      Normal   Started    kubelet            Started container istio-proxy
    ```

    See also the Kubernetes documentation on [using kubectl to fetch pod details][k8s-describe-pod].

[chart]:https://github.com/Kong/charts
[k8s-describe-pod]:https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application-introspection/#using-kubectl-describe-pod-to-fetch-details-about-pods

### Deploy BookInfo example application

The Istio [BookInfo][bookinfo] application provides a basic example that lets 
you explore and evaluate Istio's mesh features.

As in previous steps, you create a namespace, add the appropriate label, and 
then deploy.

1.  Create the namespace:

    ```console
    kubectl create namespace bookinfo
    ```

1.  Label the namespace for Istio injection:

    ```console
    kubectl label namespace bookinfo istio-injection=enabled
    ```


1.  Deploy the `BookInfo` app from the Istio bundle:

    ```console
    kubectl -n bookinfo apply -f istio-1.11.2/samples/bookinfo/platform/kube/bookinfo.yaml
    ```
    
    The response should look like:

    ```console
    service/details created
    serviceaccount/bookinfo-details created
    deployment.apps/details-v1 created
    service/ratings created
    serviceaccount/bookinfo-ratings created
    deployment.apps/ratings-v1 created
    service/reviews created
    serviceaccount/bookinfo-reviews created
    deployment.apps/reviews-v1 created
    deployment.apps/reviews-v2 created
    deployment.apps/reviews-v3 created
    service/productpage created
    serviceaccount/bookinfo-productpage created
    deployment.apps/productpage-v1 created
    ```

1.  Wait until the application is up:

    ```console
    kubectl -n bookinfo wait --timeout 120s --for=condition=Available deployment productpage-v1
    ```

[bookinfo]:https://istio.io/latest/docs/examples/bookinfo/

### Access BookInfo externally through Kong Gateway

At this point the BookInfo application is available only internally. Here's how 
to expose it as a service with [Ingress][ingress].

1.  Save the following as `bookinfo-ingress.yaml`:

    ```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: productpage
      namespace: bookinfo
    spec:
      ingressClassName: kong
      rules:
      - http:
          paths:
          - path: /
            pathType: ImplementationSpecific
            backend:
              service:
                name: productpage
                port:
                  number: 9080
    ```

1.  Apply the manifest:

    ```console
    kubectl apply -f bookinfo-ingress.yaml
    ```

1.  To make HTTP requests using Kong Gateway as ingress, you need the IP address of the 
load balancer. Get the `LoadBalancer` address and store it in a local `PROXY_IP`
environment variable:

    ```console
    export PROXY_IP=$(kubectl -n kong-istio get svc kong-istio-kong-proxy -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
    ```

    If you're running your cluster on AWS, specify `.hostname` instead of `.ip`. This is because the AWS load balancer 
    provides only a DNS name. This can also happen with other cluster providers.

    Make sure to check that the value of `$PROXY_IP` is the value of the external host. 
    You can check with `kubectl get svc kong-istio-kong-proxy`.

1.  Make an external connection request:

    ```console
    curl -s -v http://$PROXY_IP | head -4
    ```
    
    The response should look like:

    ```console
    curl -s -v http://$PROXY_IP | head -4
    *   Trying 127.0.0.1:80...
    * Connected to 127.0.0.1 (127.0.0.1) port 80 (#0)
    > GET / HTTP/1.1
    > Host: 127.0.0.1
    > User-Agent: curl/7.76.1
    > Accept: */*
    >
    * Mark bundle as not supporting multiuse
    < HTTP/1.1 200 OK
    < content-type: text/html; charset=utf-8
    < content-length: 1683
    < server: istio-envoy
    < x-envoy-upstream-service-time: 6
    < x-kong-upstream-latency: 4
    < x-kong-proxy-latency: 1
    < via: kong/2.5.0
    < x-envoy-decorator-operation: kong-istio-kong-proxy.kong-istio.svc.cluster.local:80/*
    <
    { [1079 bytes data]
    * Connection #0 to host 127.0.0.1 left intact
    <!DOCTYPE html>
    <html>
      <head>
        <title>Simple Bookstore App</title>
    ```

Note the following in the response:

- `<title>Simple Bookstore App</title>` - connected to the `BookInfo` app as expected.
- `server: istio-envoy` - the Istio mesh network is in use for the `BookInfo` product page.
- `via: kong/2.5.0` -  {{site.base_gateway}} provides the connection to the backend `BookInfo` service.

[ingress]:https://kubernetes.io/docs/concepts/services-networking/ingress/

### Configure rate limiting with a Kong plugin

To demonstrate Kong features for Istio enabled services, you can create a [KongPlugin][kongplugin]
to enforce Kong rate-limiting on ingress requests to the `BookInfo`
service. The plugin adds rate limiting to the `BookInfo` application and limits outside access to 30 requests per minute.

1.  Save the following as `bookinfo-ratelimiter.yaml`:

    ```yaml
    apiVersion: configuration.konghq.com/v1
    kind: KongPlugin
    metadata:
      name: rate-limit
      namespace: bookinfo
    plugin: rate-limiting
    config:
      minute: 30
      policy: local
    ```

1.  Apply the manifest:

    ```console
    kubectl apply -f bookinfo-ratelimiter.yaml
    ```

1.  Add an annotation to the `Ingress` resource to attach rate limiting:

    ```console
    kubectl -n bookinfo patch ingress productpage -p '{"metadata":{"annotations":{"konghq.com/plugins":"rate-limit"}}}'
    ```

1.  Inspect the headers in the response from the BookInfo product page:

    ```console
    curl -s -v http://$PROXY_IP 2>&1 | grep ratelimit
    ```

    The response should look like:

    ```console
    < x-ratelimit-remaining-minute: 26
    < x-ratelimit-limit-minute: 30
    < ratelimit-remaining: 26
    < ratelimit-limit: 30
    < ratelimit-reset: 2
    ```

For more examples of Kong features to add to your environment, see the 
[available guides][kic-guides].

[kongplugin]:/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-kongplugin-resource/
[anns]:https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
[kic-guides]:/kubernetes-ingress-controller/{{page.kong_version}}/guides/overview/

### Mesh network observability with Kiali

For observability, Istio includes a web console called [Kiali][kiali] that can
provide [topology][kiali-topology], [health][kiali-health], and 
[other features][kiali-features] to provide insights
into your application traffic.

You also need a Prometheus metrics server, and Grafana for visualization dashboards. 
Istio includes these as addons. Here's what to do:

1.  Install Prometheus:

    ```console
    kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.11/samples/addons/prometheus.yaml
    ```
    The response should look like:

    ```console
    serviceaccount/prometheus created
    configmap/prometheus created
    clusterrole.rbac.authorization.k8s.io/prometheus created
    clusterrolebinding.rbac.authorization.k8s.io/prometheus created
    service/prometheus created
    deployment.apps/prometheus created
    ```

1.  Install [Grafana][graphana]:

    ```console
    kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.11/samples/addons/grafana.yaml
    ```

    The response should look like:

    ```console
    serviceaccount/grafana created
    configmap/grafana created
    service/grafana created
    deployment.apps/grafana created
    configmap/istio-grafana-dashboards created
    configmap/istio-services-grafana-dashboards created
    ```

1.  Install Kiali:

    ```console
    kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.11/samples/addons/kiali.yaml
    ```

    The response should look like:

    ```console
    serviceaccount/kiali created
    configmap/kiali created
    clusterrole.rbac.authorization.k8s.io/kiali-viewer created
    clusterrole.rbac.authorization.k8s.io/kiali created
    clusterrolebinding.rbac.authorization.k8s.io/kiali created
    role.rbac.authorization.k8s.io/kiali-controlplane created
    rolebinding.rbac.authorization.k8s.io/kiali-controlplane created
    service/kiali created
    deployment.apps/kiali created
    ```

1.  Generate traffic for the BookInfo application, to create traffic metrics to view in Kiali:

    ```console
    COUNT=25 ; until [ $COUNT -le 0 ]; do curl -s -o /dev/null http://$PROXY_IP ; ((COUNT--)); done
    ```

1.  In a production environment, you'd access the Kiali dashboard through the Kong 
ingress. But this sample version of Kiali is meant for exploring only internal traffic on the 
cluster. You can instead use the [port-forwarding][k8s-port-forwarding] functionality that `istioctl` 
provides.

    In a new terminal, run: 

    ```console
    istioctl dashboard kiali
    ```

    This runs a `port-forward` to Kiali in the background and opens it in your web browser. 
    The response should look like:

    ```console
    http://localhost:20001/kiali
    ```

    If http://localhost:20001/kiali doesn't open automatically 
in your browser, navigate manually to the address.

You're now connected to Kiali and have a window into the traffic moving across
your mesh network. Familiarize yourself with Kiali and graphically view the
topology for your `BookInfo` application's web requests:

- Choose _Workloads_ from the menu on the left.
- Select `bookinfo` in the _Namespace_ drop-down menu.
- Select the _productpage-v1_ service name.
- In the top-right corner change the `Last <time>` dropdown to `Last 1h`.
- Select the three dots button in the top-right corner of _Graph Overview_ and select _Show full graph_.
- Select `kong-istio` alongside `bookinfo` in the _Namespace_ diagram.

You should see a connection graph that shows connections from the {{site.base_gateway}} 
deployed at the edge of your cluster down to the backend BookInfo application.
The graph demonstrates some of the fundamental capabilities of Istio, and you can 
explore further with Kiali. For more information, see the
[Kiali Documentation][kiali-docs].

The [Istio Task Documentation][istio-tasks] also provides guides for other Istio features.

[obs]:https://istio.io/latest/docs/concepts/observability/
[kiali]:https://kiali.io/
[kiali-topology]:https://kiali.io/documentation/latest/features/topology/
[kiali-health]:https://kiali.io/documentation/latest/features/health/
[kiali-features]:https://kiali.io/documentation/latest/features/
[prometheus]:https://prometheus.io
[graphana]:https://grafana.com/
[k8s-port-forwarding]:https://kubernetes.io/docs/tasks/access-application-cluster/port-forward-access-application-cluster/
[kiali-docs]:https://kiali.io/documentation/latest/
[istio-tasks]:https://istio.io/latest/docs/tasks/
