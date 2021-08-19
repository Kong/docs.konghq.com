---
title: UDPIngress with Kong
---

This guide will walk you through deploying a simple [Service][svc] which
listens for [UDP datagrams][udp] and we will expose this service outside
of the cluster using Kong.

[svc]:https://kubernetes.io/docs/concepts/services-networking/service/
[udp]:https://datatracker.ietf.org/doc/html/rfc768

## Overview

One of the most common UDP based services available on the internet are
[DNS servers][dns]. These servers are an important part of the infrastructure
of the internet, and are also [present by default][kubedns] in Kubernetes
clusters to allow [Pods][pods] within the cluster to lookup other pods IP
addresses by name.

For this example we will be deploying our own [CoreDNS][coredns] server, which
is the default DNS server Kubernetes uses for internal DNS. We will deploy a
CoreDNS `Pod` and `Service`, and then route UDP traffic to it using `UDPIngress`.

This guide assumes that you've deployed the Kong Kubernetes Ingress Controller (KIC)
using the [Helm Chart][chart]. If you have deployed the KIC in another fashion, you
may need to make some manual adjustments to some of the provided instructions.

[dns]:https://datatracker.ietf.org/doc/html/rfc1035
[kubedns]:https://kubernetes.io/docs/concepts/services-networking/dns-pod-service/
[pods]:https://kubernetes.io/docs/concepts/workloads/pods/
[chart]:https://github.com/kong/charts

## Installation

Please follow the [deployment](/kubernetes-ingress-controller/{{page.kong_version}}/deployment/overview) documentation to install
the {{site.kic_product_name}} on your Kubernetes cluster.

> **Note**: This feature works with Kong versions FIXME and above.

> **Note**: This feature is available in Controller versions 2.0.0 and above.

## Creating a Namespace

For this guide we'll create a namespace just for testing DNS services and `UDPIngress`.

The following manifest can be applied to the cluster to create the namespace:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: udpingress-example
```

Or you can simply use the shorthand version with `kubectl`:

```shell
$ kubectl create namespace udpingress-example
```

This namespace will be referenced in the upcoming sections, and when you're done testing
you can delete it.

## Deploying CoreDNS

For this example, we will deploy a default CoreDNS server that will do nothing more
than serve up DNS requests.

First we're going to need to configure CoreDNS with a [Core File][corefile] in order for
it to properly serve DNS requests:

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

This configuration is basic and in practice causes all DNS requests sent to
our CoreDNS pods to forward to the [nameservers][nameservers] present in
`/etc/resolv.conf` (by default this will point to the standard `kube-dns`
service provided by the cluster).

Save the this [ConfigMap][cfgmap] as `corefile.yaml` and apply it:

```shell
$ kubectl apply -f corefile.yaml
```

Once that's complete we're ready for the [Deployment][deployment] manifest:

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

Save this file to `coredns-deployment.yaml` and apply it:

```shell
$ kubectl apply -f coredns-deployment.yaml
```

Shortly thereafter the pods should start running (see `kubectl get pods`)
and we can move on to exposing the pods via `Services` and `UDPIngress`.

[corefile]:https://coredns.io/manual/toc/#configuration
[nameservers]:https://datatracker.ietf.org/doc/html/rfc1035#section-6
[cfgmap]:https://kubernetes.io/docs/concepts/configuration/configmap/
[deployment]:https://kubernetes.io/docs/concepts/workloads/controllers/deployment/

## Exposing CoreDNS via Service

A Kubernetes [Service][svc] is one of the fundamental network abstraction layer
that allows you to load balance traffic to pods in the cluster. `Services` are
ultimately the DNS names that the Kong Gateway will be routing our UDP traffic to.

Exposing a `Deployment` via a service is easy, here's the manifest which exposes
the CoreDNS `Deployment` we made in the previous section:

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

Note that UDP port 53 is configured here, as this is [the default port for DNS][dns-port].

Save this file as `coredns-service.yaml` and apply it:

```shell
$ kubectl apply -f coredns-service.yaml
```

Now that we have a `Service` which is exposing our pods we can move on to exposing this
DNS server outside of the cluster using Kong's `UDPIngress`.

[svc]:https://kubernetes.io/docs/concepts/services-networking/service/
[dns-port]:https://datatracker.ietf.org/doc/html/rfc1035#section-4.2.1

## Exposing UDP Ports on Kong

The Kong Kubernetes Ingress Controller (KIC) at the time of writing doesn't have a
mechanism to automatically enable new UDP ports when you need them to expose your
Kubernetes UDP `Services`, so we will need to explicitly configure Kong to expose
these ports prior to deploying our `UDPIngress` resources.

If you're maintaining a `values.yaml` configuration for your Chart deployment of Kong
you will need to add a section under `udpProxy` which enables the new UDP listener:

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
$ helm upgrade --namespace <NAMESPACE> --version <CHART_VERSION> -f values.yaml <RELEASE_NAME> kong/kong
```

Replace `<NAMESPACE>`, `<CHART_VERSION>` and `<RELEASE_NAME>` with the values you deployed Kong with.

Alternatively if you are using only command line flags to deploy and manage Kong
the same configuration can be achieved with flags:

```shell
$ helm upgrade --namespace <NAMESPACE> --version <CHART_VERSION> <RELEASE_NAME> kong/kong \
  --set "udpProxy.enabled=true" \
  --set "udpProxy.type=LoadBalancer" \
  --set "udpProxy.stream[0].containerPort=9999"
  --set "udpProxy.stream[0].servicePort=9999"
  --set "udpProxy.stream[0].protocol=UDP"
```

Wait for the `LoadBalancer` service to be ready for the Gateway (see `kubectl get services`)
and once it's up Kong is ready to serve UDP traffic on port `9999` external to the cluster
using `UDPIngress` resources.

## Deploying UDPIngress

Now that Kong is listening on `9999` we can create a `UDPIngress` resource which will attach
our CoreDNS service to that port so we can make DNS requests to it from outside the cluster.

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

The above binds the Kong Gateway port `9999` to the `Service` port `53` for our DNS server.

Save the file as `coredns-udpingress.yaml` and apply it:

```shell
$ kubectl apply -f coredns-udpingress.yaml
```

We can now make DNS requests via Kong.

## Verification

The exercise is complete and all that's left to do is verify that everything is working
by making a DNS request to our CoreDNS server.

This example assumes you have the `dig` command available on your local system, but if
you don't look to your operating system documentation for a similar DNS lookup tool.

Firstly you'll need to retrieve the IP address of the UDP load balancer service that we
configured in previous sections:

```shell
$ export KONG_UDP_ENDPOINT="$(kubectl -n <NAMESPACE> get service <RELEASE_NAME>-kong-udp-proxy \
    -o=go-template='{{range .status.loadBalancer.ingress}}{{.ip}}{{end}}')"
```

Note that in the above you'll need to replace `<NAMESPACE>` and `<RELEASE_NAME>` with the values
you originally provided to `helm install` in your own environment.

Now that we've stored the IP in the environment variable `KONG_UDP_ENDPOINT` we can use
that with `dig` to make a DNS lookup through the CoreDNS server we set up and exposed
using `UDPIngress`:

```shell
$ dig @${KONG_UDP_ENDPOINT} konghq.com
;; ANSWER SECTION:
konghq.com.		30	IN	A	34.83.126.248

;; Query time: 60 msec
;; SERVER: <KONG_UDP_ENDPOINT>#9999
;; WHEN: Thu Aug 19 08:39:16 EDT 2021
;; MSG SIZE  rcvd: 77
```

Verify that the `<KONG_UDP_ENDPOINT>` in the `SERVER` section of the response above ends
up being equal to your `${KONG_UDP_ENDPOINT}` value.

Now you're equipped to route UDP traffic into your Kubernetes cluster with Kong! 🥳
