---
title: Running the Kubernetes Ingress Controller with Istio
---

This guide walks you through deploying Kong as the gateway for [Istio][istio] to
combine the features of Kong for ingress traffic with Istio's mesh
functionality.

[istio]:https://istio.io

## Overview

[Istio][istio] is a popular [service mesh][mesh] that enables [traffic
management][traffic-management], [security][security] and [observability][obs]
features for [Kubernetes][k8s] clusters.

With Kong as the gateway for Istio you can leverage the
mesh features of Istio intra-cluster while enabling Kong's rich feature set
for ingress traffic from outside the cluster.

In this guide, you will:

* Install Istio `v1.11` and Kong Gateway in your cluster.
* Deploy an example Istio-enabled application.
* Deploy an `Ingress` customized with a `KongPlugin` for the example application.
* Make requests to the sample application via Kong and Istio.
* Explore observability features of Istio to visualize cluster traffic.

[istio]:https://istio.io
[mesh]:https://istio.io/latest/docs/concepts/
[traffic-management]:https://istio.io/latest/docs/concepts/traffic-management/
[security]:https://istio.io/latest/docs/concepts/security/
[obs]:https://istio.io/latest/docs/concepts/observability/
[k8s]:https://kubernetes.io

### Prerequisites

* A Kubernetes `v1.19` (or newer) cluster
* [kubectl][kubectl] `v1.19` (or newer)
* [Helm][helm] `v3.5` (or newer)
* [cURL][curl] `v7` (or newer)

You can use a managed cluster from a cloud provider such as [AWS (EKS)][eks],
[Google Cloud (GKE)][gke] or [Azure (AKS)][aks], or you can work locally with 
tools such as [Minikube][minikube] or [Microk8s][microk8s].

Your Kubernetes cluster needs to be capable of provisioning
  `LoadBalancer` type [Services][svc] (if you're not certain what this means,
  see the [relevant documentation][svc-lb]). Cloud providers will generally
  automate `LoadBalancer` type `Service` provisioning with their default
  settings, but for other cluster types you may need to check your Kubernetes
  distribution's documentation for options to enable this.

Several examples using `kubectl` in this guide assume the test
  cluster you want to use is the current default cluster context. If you're
  uncertain what this means or if you need to reconfigure `kubectl` to allow
  for this, make sure to review the
  [configuring access to multiple clusters][contexts] documentation and make
  any changes needed before continuing.

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

### Downloading & Verifying Istio

In this guide you'll work with the [istioctl installation method][istioctl] 
because it's the community recommended method. The [Istio Installation Guides][istio-install] 
explain alternative deployment mechanisms.

For other installation methods, see also the
  [Istio FAQ][install-method-faq] for more details on the differences
  between methods. If you use one of the other installation mechanisms note that the
  examples in this guide may not work without experiementation and manual
  intervention.

Download the `istioctl` command-line utility for your platform:

{% navtabs %}
{% navtab Command %}

```console
$ curl -s -L https://istio.io/downloadIstio | ISTIO_VERSION=1.11.2 sh -
```

{% endnavtab %}
{% navtab Response %}

```console
Downloading istio-1.11.2 from https://github.com/istio/istio/releases/download/1.11.2/istio-1.11.2-linux-amd64.tar.gz ...

Istio 1.11.2 Download Complete!

Istio has been successfully downloaded into the istio-1.11.2 folder on your system.

Next Steps:
See https://istio.io/latest/docs/setup/install/ to add Istio to your Kubernetes cluster.

To configure the istioctl client tool for your workstation,
add the /home/kong/Downloads/istio/istio-1.11.2/bin directory to your environment path variable with:
    export PATH="$PATH:/home/kong/Downloads/istio/istio-1.11.2/bin"

Begin the Istio pre-installation check by running:
    istioctl x precheck

Need more information? Visit https://istio.io/latest/docs/setup/install/
```

{% endnavtab %}
{% endnavtabs %}

You'll notice that some instructions are provided for how to
further set up the `istioctl` program locally and do pre-check validation of
the Istio installation. Make sure to add `istioctl` to your shell's path:

```console
$ export PATH="$PATH:$PWD/istio-1.11.2/bin"
```

Verify that `istioctl` is working, and run some validation checks on your
Kubernetes cluster to ensure Istio will deploy to it properly:

{% navtabs %}
{% navtab Command %}

```console
$ istioctl x precheck
```

{% endnavtab %}
{% navtab Response %}

```console
✔ No issues found when checking the cluster. Istio is safe to install or upgrade!
  To get started, check out https://istio.io/latest/docs/setup/getting-started/
```

{% endnavtab %}
{% endnavtabs %}

Now you're ready to move on to Istio deployment.

[istio-install]:https://istio.io/latest/docs/setup/install/
[istio-quickstart]:https://istio.io/latest/docs/setup/getting-started/
[istioctl]:https://istio.io/latest/docs/setup/install/istioctl/
[install-method-faq]:https://istio.io/latest/about/faq/#install-method-selection

### Deploying Istio

The `istioctl` command-line program incorporates the concept of
[profiles][istio-profiles] which provide high level customization of the Istio
deployment for specialized purposes. For the purposes of this guide we'll use
the `demo` profile which is meant for testing and evaluation.

Deploy Istio with the `demo` profile:

{% navtabs %}
{% navtab Command %}

```console
$ istioctl install --set profile=demo -y
```

{% endnavtab %}
{% navtab Response %}

```console
✔ Istio core installed
✔ Istiod installed
✔ Egress gateways installed
✔ Ingress gateways installed
✔ Installation complete
```

{% endnavtab %}
{% endnavtabs %}

The Istio components are now deployed to your cluster in the `istio-system`
[namespace][k8s-namespaces] and you're ready to deploy Kong and a sample
application.

[istio-profiles]:https://istio.io/latest/docs/setup/additional-setup/config-profiles/
[k8s-namespaces]:https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/

### Creating an Istio-enabled Namespace for {{site.kic_product_name}}

To integrate Istio's mesh functionality in any given Kubernetes
[Pod][k8s-pods], a [namespace][k8s-namespaces] must be [labeled][k8s-labels]
with the `istio-injection=enabled` label to instruct [IstioD][istiod] (the main
control program for Istio) to manage the pods and add them to the mesh network.

This guide shows how to create a distinct Istio-enabled namespace for our Kong
pods so that they will automatically be joined to the mesh network:

{% navtabs %}
{% navtab Command %}

```console
$ kubectl create namespace kong-istio
```

{% endnavtab %}
{% navtab Response %}

```console
namespace/kong-istio created
```

{% endnavtab %}
{% endnavtabs %}

The `kong-istio` namespace must then be enabled for Istio mesh:

{% navtabs %}
{% navtab Command %}

```console
$ kubectl label namespace kong-istio istio-injection=enabled
```

{% endnavtab %}
{% navtab Response %}

```console
namespace/kong-istio labeled
```

{% endnavtab %}
{% endnavtabs %}

The `kong-istio` namespace is now ready for us to deploy Kong and our sample
applications.

[k8s-pods]:https://kubernetes.io/docs/concepts/workloads/pods/
[k8s-namespaces]:https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
[k8s-labels]:https://kubernetes.io/docs/concepts/overview/working-with-objects/labels/
[istiod]:https://istio.io/latest/docs/ops/deployment/architecture/#istiod

### Deploy {{site.kic_product_name}}

We'll use the [Kong Helm Chart][chart] to deploy the {{site.kic_product_name}}
to our Istio-enabled `kong-istio` namespace so we can start proxying
traffic from outside the cluster to our mesh-enabled services.

Make sure you have the Kong Helm repository configured locally:

{% navtabs %}
{% navtab Command %}

```console
$ helm repo add kong https://charts.konghq.com && helm repo update
```

{% endnavtab %}
{% navtab Response %}

```console
"kong" has been added to your repositories
Hang tight while we grab the latest from your chart repositories...
...Successfully got an update from the "kong" chart repository
Update Complete. ⎈Happy Helming!⎈
```

{% endnavtab %}
{% endnavtabs %}

Deploy the chart:

{% navtabs %}
{% navtab Command %}

```console
$ helm install -n kong-istio kong-istio kong/kong
```

{% endnavtab %}
{% navtab Response %}

```console
NAME: kong-istio
NAMESPACE: kong-istio
STATUS: deployed
```

{% endnavtab %}
{% endnavtabs %}

You can verify that Kong is deployed and the Istio sidecar container is injected
properly into Kong by running `kubectl describe` to [review the
events][k8s-describe-pod] for the `Pod`:

{% navtabs %}
{% navtab Command %}

```console
$ kubectl describe pod -n kong-istio -l app.kubernetes.io/instance=kong-istio
```

{% endnavtab %}
{% navtab Response %}

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

{% endnavtab %}
{% endnavtabs %}

[chart]:https://github.com/Kong/charts
[k8s-describe-pod]:https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application-introspection/#using-kubectl-describe-pod-to-fetch-details-about-pods

### Deploy "BookInfo" Example Application

For this step we'll deploy Istio's [BookInfo][bookinfo] application, which is
a basic example application commonly used to exercise and evaluate Istio's
mesh features.

Similar to what we did in previous steps for the Kong pods we'll need to create
and label a namespace where the `BookInfo` app will be deployed so it will
be automatically joined to the mesh network.

Create the namespace:

{% navtabs %}
{% navtab Command %}

```console
$ kubectl create namespace bookinfo
```

{% endnavtab %}
{% navtab Response %}

```console
namespace/bookinfo created
```

{% endnavtab %}
{% endnavtabs %}

Label the namespace for Istio injection:

{% navtabs %}
{% navtab Command %}

```console
$ kubectl label namespace bookinfo istio-injection=enabled
```

{% endnavtab %}
{% navtab Response %}

```console
namespace/bookinfo labeled
```

{% endnavtab %}
{% endnavtabs %}


Deploy the `BookInfo` app from the Istio bundle:

{% navtabs %}
{% navtab Command %}

```console
$ kubectl -n bookinfo apply -f istio-1.11.2/samples/bookinfo/platform/kube/bookinfo.yaml
```

{% endnavtab %}
{% navtab Response %}

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

{% endnavtab %}
{% endnavtabs %}

Wait until the application is up by waiting for the relevant deployment to be
available before proceeding to the next steps:

{% navtabs %}
{% navtab Command %}

```console
$ kubectl -n bookinfo wait --timeout 120s --for=condition=Available deployment productpage-v1
```

{% endnavtab %}
{% navtab Response %}

```console
deployment.apps/productpage-v1 condition met
```

{% endnavtab %}
{% endnavtabs %}

[bookinfo]:https://istio.io/latest/docs/examples/bookinfo/

### Access BookInfo Externally with Kong Gateway

So far we've deployed our `BookInfo` application in an entirely internal way,
but with everything up and running we're ready to expose the service for
access from outside the cluster using [Ingress][ingress].

Save the following file as `bookinfo-ingress.yaml`:

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

Apply the `bookinfo-ingress.yaml` manifests:

{% navtabs %}
{% navtab Command %}

```console
$ kubectl apply -f bookinfo-ingress.yaml
```

{% endnavtab %}
{% navtab Response %}

```console
ingress.networking.k8s.io/productpage created
```

{% endnavtab %}
{% endnavtabs %}

We're ready to start making connections to the `BookInfo` product page, but
we'll need the `LoadBalancer` IP address of the Kong Gateway to make our HTTP requests.

Gather the `LoadBalancer` address and store it in the local `PROXY_IP`
environment variable:

```console
$ export PROXY_IP=$(kubectl -n kong-istio get svc kong-istio-kong-proxy -o=jsonpath='{.status.loadBalancer.ingress[0].ip}')
```

> **NOTE** for some cluster types (such as with AWS), the `.ip` in the above
command does not work because the `LoadBalancer` provisioner does not provide an IP
address but instead only provides a DNS name. For these situations either
replace `.ip` with `.hostname`, or you can find the external host 
in the output of
`kubectl get svc kong-istio-kong-proxy`. In any case make sure the contents
of your local `PROXY_IP` environment variable end up as that value.

Once you've checked the contents of `$PROXY_IP` you can make a connection to
the `BookInfo` application via Kong:

{% navtabs %}
{% navtab Command %}

```console
$ curl -s -v http://$PROXY_IP | head -4
```

{% endnavtab %}
{% navtab Response %}

```console
$ curl -s -v http://$PROXY_IP | head -4
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

{% endnavtab %}
{% endnavtabs %}

Note the following in the response:

- `<title>Simple Bookstore App</title>` - indicates that we're connected
  properly to the `BookInfo` app as expected.
- `server: istio-envoy` - shows that the Istio mesh network is in use for
  the `BookInfo` product page.
- `via: kong/2.5.0` - indicates that we've pass through the Kong Gateway to our
  backend `BookInfo` service.

[ingress]:https://kubernetes.io/docs/concepts/services-networking/ingress/

### Configure Ratelimits with Kong

The `BookInfo` app is now accessible outside of the cluster but we've yet to
take advantage of Kong features  when accessing it. To demonstrate Kong
features for Istio enabled services, we'll create a [KongPlugin][kongplugin]
that enforces Kong rate-limiting on ingress requests to the `BookInfo`
service.

Save the following `KongPlugin` as `bookinfo-ratelimiter.yaml`:

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

This plugin will add rate limiting to the `BookInfo` application and limit
outside access to 30 requests per minute.

Apply the `bookinfo-ratelimiter.yaml` manifest:

{% navtabs %}
{% navtab Command %}

```console
$ kubectl apply -f bookinfo-ratelimiter.yaml
```

{% endnavtab %}
{% navtab Response %}

```console
kongplugin.configuration.konghq.com/rate-limit created
```

{% endnavtab %}
{% endnavtabs %}

Now let's [annotate][anns] our previously created `Ingress` resource for the
`BookInfo` app to attach our ratelimiter to it:

{% navtabs %}
{% navtab Command %}

```console
$ kubectl -n bookinfo patch ingress productpage -p '{"metadata":{"annotations":{"konghq.com/plugins":"rate-limit"}}}'
```

{% endnavtab %}
{% navtab Response %}

```console
ingress.networking.k8s.io/productpage patched
```

{% endnavtab %}
{% endnavtabs %}

We should see the ratelimiter reflected in the
headers in responses from the product page:

{% navtabs %}
{% navtab Command %}

```console
$ curl -s -v http://$PROXY_IP 2>&1 | grep ratelimit
```

{% endnavtab %}
{% navtab Response %}

```console
< x-ratelimit-remaining-minute: 26
< x-ratelimit-limit-minute: 30
< ratelimit-remaining: 26
< ratelimit-limit: 30
< ratelimit-reset: 2
```

{% endnavtab %}
{% endnavtabs %}

Now you've got an Istio mesh enable service with Kong features available to it!

For more examples of features you can take advantage of with Kong see our
[available guides][kic-guides] and experiment further with this environment.

[kongplugin]:/kubernetes-ingress-controller/{{page.kong_version}}/guides/using-kongplugin-resource/
[anns]:https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/
[kic-guides]:/kubernetes-ingress-controller/{{page.kong_version}}/guides/overview/

### Mesh Network Observability with Kiali

We now have an Istio enabled `BookInfo` app running now which we can access
externally via Kong and we've seen the ingress features Kong can provide us at
the edge of the mesh network. In the following example we'll focus on exploring
some of the [observability][obs] features of Istio inside the mesh network.

For observability Istio includes a web console called [Kiali][kiali] that can
provide [topology][kiali-topology], [health][kiali-health] and 
[other features][kiali-features] to give you insights
into your application traffic.

To support metrics related features of Kiali we'll need to deploy
Istio's [Prometheus][prometheus] metrics server:

{% navtabs %}
{% navtab Command %}

```console
$ kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.11/samples/addons/prometheus.yaml
```

{% endnavtab %}
{% navtab Response %}

```console
serviceaccount/prometheus created
configmap/prometheus created
clusterrole.rbac.authorization.k8s.io/prometheus created
clusterrolebinding.rbac.authorization.k8s.io/prometheus created
service/prometheus created
deployment.apps/prometheus created
```

{% endnavtab %}
{% endnavtabs %}

We'll also install [Grafana][graphana] which includes visualization
dashboards for Istio:

{% navtabs %}
{% navtab Command %}

```console
$ kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.11/samples/addons/grafana.yaml
```

{% endnavtab %}
{% navtab Response %}

```console
serviceaccount/grafana created
configmap/grafana created
service/grafana created
deployment.apps/grafana created
configmap/istio-grafana-dashboards created
configmap/istio-services-grafana-dashboards created
```

{% endnavtab %}
{% endnavtabs %}

We can now move on to deploying Kiali itself:

{% navtabs %}
{% navtab Command %}

```console
$ kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.11/samples/addons/kiali.yaml
```

{% endnavtab %}
{% navtab Response %}

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

{% endnavtab %}
{% endnavtabs %}

Now we'll need to generate some traffic for our `BookInfo`
app to populate metrics:

```console
$ COUNT=25 ; until [ $COUNT -le 0 ]; do curl -s -o /dev/null http://$PROXY_IP ; ((COUNT--)); done
```

Since this sample version of Kiali isn't tuned for security and is meant to be
cluster internal only, we won't expose this via Kong. Instead, we'll use the
[port-forwarding][k8s-port-forwarding] functionality available in `istioctl` to
tunnel our connection to the Kiali service.

Run the following command in a new terminal. This will run a `port-forward` to
Kiali for you in the background and open it up in your web browser:

{% navtabs %}
{% navtab Command %}

```console
$ istioctl dashboard kiali
```

{% endnavtab %}
{% navtab Response %}

```console
http://localhost:20001/kiali
```

{% endnavtab %}
{% endnavtabs %}

This command should have automatically opened http://localhost:20001/kiali
in your web browser, but if not then navigate to that page manually.

You're now connected to Kiali and have a window into the traffic moving across
your mesh network. Familiarize yourself with Kiali and graphically view the
topology for your `BookInfo` application's web requests:

- Choose _Workloads_ from the menu on the left.
- Select `bookinfo` in the _Namespace_ drop-down menu.
- Click the _productpage-v1_ service name.
- In the top-right corner change the `Last <time>` dropdown to `Last 1h`.
- Click the three dots button in the top-right corner of _Graph Overview_ and click _Show full graph_.
- Select `kong-istio` alongside `bookinfo` in the _Namespace_ diagram.

What you're seeing now is a connection graph spanning from the Kong Gateway we
deployed at the edge of our cluster down to the backend `BookInfo` application
and with this you should have a sense of some of the fundamental capabilities
of Istio. The Kiali console for Istio provides a wide range of features. To
explore beyond this guide and learn Kiali further, see the
[Kiali Documentation][kiali-docs].

To explore Istio features and operations further, check out the [Istio Task
Documentation][istio-tasks], which includes several walkthroughs for a variety
of other Istio features.

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
