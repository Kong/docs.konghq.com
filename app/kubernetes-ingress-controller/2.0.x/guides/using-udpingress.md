---
title: UDPIngress with Kong Gateway
---

This guide walks you through deploying a simple [Service][svc] that
listens for [UDP datagrams][udp], and exposes this service outside
of the cluster using Kong Gateway.

[svc]:https://kubernetes.io/docs/concepts/services-networking/service/
[udp]:https://datatracker.ietf.org/doc/html/rfc768

## Overview

Some of the most common UDP-based services available on the internet are
[DNS servers][dns]. These servers are an important part of the infrastructure
of the internet, and are also [present by default][kubedns] in Kubernetes
clusters to allow [Pods][pods] within the cluster to look up other pods' IP
addresses by name.

For this example, you will:
* Deploy your own [CoreDNS][coredns] server, which is the default
DNS server Kubernetes uses for internal DNS
* Deploy a CoreDNS `Pod` and `Service`
* Route UDP traffic to it using `UDPIngress`

This guide assumes that you've deployed the Kong Kubernetes Ingress Controller (KIC)
using the [Helm Chart][chart]. If you have deployed the KIC in a different way, you
may need to make some manual adjustments to some of the provided instructions.

[dns]:https://datatracker.ietf.org/doc/html/rfc1035
[kubedns]:https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/
[pods]:https://kubernetes.io/docs/concepts/workloads/pods/
[coredns]:https://coredns.io/
[chart]:https://github.com/kong/charts

## Installation

Follow the [deployment](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/overview) documentation to install
the {{site.kic_product_name}} on your Kubernetes cluster.

> **Note**: This feature is compatible with:
> * Kong Gateway versions 2.0.0 and above.
> * Kong Ingress Controller versions 2.0.0 and above.

## Create a namespace

First, create a namespace for testing DNS services and `UDPIngress`.

{% navtabs %}
{% navtab Manifest %}

Apply the following manifest to the cluster to create the namespace:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: udpingress-example
```

{% endnavtab %}
{% navtab kubectl %}

Use the shorthand version with `kubectl` to deploy the namespace:

```shell
$ kubectl create namespace udpingress-example
```

{% endnavtab %}
{% endnavtabs %}

You'll be using this namespace in the upcoming sections, and when you're done testing
you can delete it.

## Deploy CoreDNS

For this example, deploy a default CoreDNS server that only serves up DNS requests.

First, you need to configure CoreDNS with a [Core File][corefile].

Save the following [ConfigMap][cfgmap] as `corefile.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: coredns
  namespace: udpingress-example
data:
  Corefile: |-
    .:53 {
        errors
        health {
           lameduck 5s
        }
        ready
        kubernetes cluster.local in-addr.arpa ip6.arpa {
           pods insecure
           fallthrough in-addr.arpa ip6.arpa
           ttl 30
        }
        forward . /etc/resolv.conf {
           max_concurrent 1000
        }
        cache 30
        loop
        reload
        loadbalance
    }
```

This simple configuration tells our CoreDNS pods to forward all DNS requests to [nameservers][nameservers] present in `/etc/resolv.conf`.

By default, `/etc/resolve.conf` points to the standard kube-dns service provided by the cluster.

Next, apply the `corefile.yaml`:

```shell
$ kubectl apply -f corefile.yaml
```

Now the cluster is ready for the [Deployment][deployment] manifest.

Save the following file as `coredns-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: coredns
  namespace: udpingress-example
  labels:
    app: coredns
spec:
  replicas: 1
  selector:
    matchLabels:
      app: coredns
  template:
    metadata:
      labels:
        app: coredns
    spec:
      containers:
      - args:
        - -conf
        - /etc/coredns/Corefile
        image: coredns/coredns
        imagePullPolicy: IfNotPresent
        name: coredns
        ports:
        - containerPort: 53
          protocol: UDP
        volumeMounts:
        - mountPath: /etc/coredns
          name: config-volume
      volumes:
      - configMap:
          defaultMode: 420
          items:
          - key: Corefile
            path: Corefile
          name: coredns
        name: config-volume
```

Note that this `Deployment` mounts the `corefile` configuration data
we created above into the pods so that CoreDNS can load them.

Apply the `Deployment` configuration file:

```shell
$ kubectl apply -f coredns-deployment.yaml
```

Watch the pods with `kubectl -n udpingress-example get pods`. Once they are
running, you can move on to the next sections: exposing the pods through
`Service` and `UDPIngress`.

[corefile]:https://coredns.io/manual/toc/#configuration
[nameservers]:https://datatracker.ietf.org/doc/html/rfc1035#section-6
[cfgmap]:https://kubernetes.io/docs/concepts/configuration/configmap/
[deployment]:https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

## Expose CoreDNS through a Service

A Kubernetes [Service][svc] is a fundamental network abstraction layer
that allows you to load-balance traffic to pods in the cluster. `Services` are
ultimately the DNS names that the Kong Gateway will be routing our UDP traffic to.

The following manifest exposes the CoreDNS Deployment from the previous section via a service.

Save this manifest as `coredns-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: coredns
  namespace: udpingress-example
spec:
  ports:
  - port: 53
    protocol: UDP
    targetPort: 53
  selector:
    app: coredns
  type: ClusterIP
```

This configuration uses UDP port 53, which is [the default port for DNS][dns-port].

Apply the manifest:

```shell
$ kubectl apply -f coredns-service.yaml
```

Now that you have a `Service` to expose the pods, you can expose this
DNS server outside of the cluster using Kong's `UDPIngress` resource.

[svc]:https://kubernetes.io/docs/concepts/services-networking/service/
[dns-port]:https://datatracker.ietf.org/doc/html/rfc1035#section-4.2.1

## Exposing UDP Ports on Kong

The Kong Kubernetes Ingress Controller (KIC) doesn't have a
mechanism to automatically enable new UDP ports for exposing your
Kubernetes UDP `Services`, so you need to explicitly configure Kong Gateway to expose
these ports prior to deploying any `UDPIngress` resources.

If you're maintaining a `values.yaml` configuration for your Helm deployment of Kong Gateway,
add a section under `udpProxy` to enable the new UDP listener:

```yaml
udpProxy:
  enabled: true
  type: LoadBalancer
  stream:
  - containerPort: 9999
    servicePort: 9999
    protocol: UDP
```

Once you've made the necessary configurations you can apply your changes:

```
$ helm upgrade --namespace {NAMESPACE} --version {CHART_VERSION} -f values.yaml {RELEASE_NAME} kong/kong
```

Replace `{NAMESPACE}`, `{CHART_VERSION}` and `{RELEASE_NAME}` with the values you deployed Kong Gateway with.

Alternatively, if you are using command line flags to deploy and manage Kong Gateway,
the same configuration can be achieved with flags:

```shell
$ helm upgrade --namespace {NAMESPACE} --version {CHART_VERSION} {RELEASE_NAME} kong/kong \
  --set "udpProxy.enabled=true" \
  --set "udpProxy.type=LoadBalancer" \
  --set "udpProxy.stream[0].containerPort=9999"
  --set "udpProxy.stream[0].servicePort=9999"
  --set "udpProxy.stream[0].protocol=UDP"
```

Watch the services using `kubectl get services` and wait for the `LoadBalancer` service to be ready for the Gateway.
Once the service up, Kong Gateway is ready to serve UDP traffic on the external port `9999`
using `UDPIngress` resources.

## Deploying UDPIngress

Now that Kong Gateway is listening on `9999`, you can create a `UDPIngress` resource which will attach
the CoreDNS service to that port so you can make DNS requests to it from outside the cluster.

Save the following file as `coredns-udpingress.yaml`:

```yaml
apiVersion: configuration.konghq.com/v1beta1
kind: UDPIngress
metadata:
  name: minudp
  namespace: udpingress-example
  annotations:
    kubernetes.io/ingress.class: kong
spec:
  rules:
  - backend:
      serviceName: coredns
      servicePort: 53
    port: 9999
```

This configuration binds the Kong Gateway port `9999` to the `Service` port `53` for our DNS server.

Apply the `coredns-udpingress.yaml` manifests:

```shell
$ kubectl apply -f coredns-udpingress.yaml
```

You can now make DNS requests via Kong Gateway.

## Verification

Now that setup is complete, all that's left to do is verify that everything is working
by making a DNS request to our CoreDNS server.

> **Note:** This example assumes you have the `dig` command available on your local
 system. If you don't, refer to your operating system documentation for a similar DNS 
 lookup tool.

First, retrieve the IP address of the UDP load balancer service that we
configured in previous sections:

```shell
$ export KONG_UDP_ENDPOINT="$(kubectl -n {NAMESPACE} get service {RELEASE_NAME}-kong-udp-proxy \
    -o=go-template='{% raw %}{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}{% endraw %}')"
```

Replace `{NAMESPACE}` and `{RELEASE_NAME}` with the values
you originally provided to `helm install` in your own environment.

Now that you've stored the IP in the environment variable `KONG_UDP_ENDPOINT`, you can use
that with `dig` to do a DNS lookup through the CoreDNS server you set up and exposed
using `UDPIngress`:

{% navtabs codeblock %}
{% navtab Command %}

```shell
$ dig @${KONG_UDP_ENDPOINT} -p 9999 konghq.com
```

{% endnavtab %}
{% navtab Response %}

```shell
;; ANSWER SECTION:
konghq.com.		30	IN	A	34.83.126.248

;; Query time: 60 msec
;; SERVER: <KONG_UDP_ENDPOINT>#9999
;; WHEN: Thu Aug 19 08:39:16 EDT 2021
;; MSG SIZE  rcvd: 77
```

{% endnavtab %}
{% endnavtabs %}

Verify that the `{KONG_UDP_ENDPOINT}` in the `SERVER` section of the response above ends
up being equal to your `${KONG_UDP_ENDPOINT}` value.

Now you're equipped to route UDP traffic into your Kubernetes cluster with Kong Gateway! 
