---
name: Kubernetes Sidecar Injector
publisher: Kong Inc.

categories:
  - deployment

type: integration

desc: Kubernetes Kong Service Mesh
description: |
  The plugin will inject Kong dataplane nodes and form a service mesh on top of Kubernetes

source_url: https://github.com/Kong/kubernetes-sidecar-injector

kong_version_compatibility:
    community_edition:
      compatible:
        - 1.2.x
        - 1.1.x

params:
  name: kubernetes-sidecar-injector
  config:
    - name: image
      required: false
      default: "`kong`"
      value_in_examples: kong
      description: The docker image to inject

---

## Introduction

Kong `0.15.0` / `1.0.0` added the capability to proxy and route raw `tcp` and `tls`
streams and deploy Kong using a service-mesh sidecar pattern with mutual
`tls` between Kong nodes. This tutorial walks you through setting up a Kong service
mesh on Kubernetes with our [Kubernetes sidecar injector plugin](https://github.com/Kong/kubernetes-sidecar-injector)

## Prerequisites

You need Kong 1.0.0 or later running on Kubernetes including and an SSL certificate
stored as a secret that's available to the Kong control plane. The Make tasks `run_cassandra`
and `run_postgres` from the [Kong Kubernetes Repository](https://github.com/Kong/kong-dist-kubernetes)
will fully provision the prerequisite data store, Kong control plane, Kong data plane
and the SSL secret.

Alternatively follow the any of the setup instructions from 
[Kong Kubernetes Install Instructions](/install/kubernetes/) page then setup the 
SSL certificate/secret:

```
cd $(mktemp -d)

### Create a key+certificate for the control plane
cat <<EOF | kubectl create -f -
apiVersion: certificates.k8s.io/v1beta1
kind: CertificateSigningRequest
metadata:
  name: kong-control-plane.kong.svc
spec:
  request: $(openssl req -new -nodes -batch -keyout privkey.pem -subj /CN=kong-control-plane.kong.svc | base64 | tr -d '\n')
  usages:
  - digital signature
  - key encipherment
  - server auth
EOF
kubectl certificate approve kong-control-plane.kong.svc
kubectl -n kong create secret tls kong-control-plane.kong.svc --key=privkey.pem --cert=<(kubectl get csr kong-control-plane.kong.svc -o jsonpath='{.status.certificate}' | base64 --decode)
kubectl delete csr kong-control-plane.kong.svc
rm privkey.pem
```

or use the following convenience script:

```
curl -fsSL https://raw.githubusercontent.com/Kong/kong-dist-kubernetes/master/setup_certificate.sh | bash
```

## Installation Steps

Export some variables to access the Kong Admin API and Proxy:

```
$ export HOST=$(kubectl get nodes --namespace default -o jsonpath='{.items[0].status.addresses[0].address}')
$ export ADMIN_PORT=$(kubectl get svc --namespace kong kong-control-plane  -o jsonpath='{.spec.ports[0].nodePort}')
```

Enable the Sidecar Injector Plugin via the Kong Admin API:

```
curl $HOST:$ADMIN_PORT/plugins -d name=kubernetes-sidecar-injector -d config.image=kong
```

Turn on Kubernetes Sidecar Injection:

```
cat <<EOF | kubectl create -f -
apiVersion: admissionregistration.k8s.io/v1beta1
kind: MutatingWebhookConfiguration
metadata:
  name: kong-sidecar-injector
webhooks:
- name: kong.sidecar.injector
  rules:
  - apiGroups: [""]
    apiVersions: ["v1"]
    resources: ["pods"]
    operations: [ "CREATE" ]
  failurePolicy: Fail
  namespaceSelector:
    matchExpressions:
    - key: kong-sidecar-injection
      operator: NotIn
      values:
      - disabled
  clientConfig:
    service:
      namespace: kong
      name: kong-control-plane
      path: /kubernetes-sidecar-injector
    caBundle: $(kubectl config view --raw --minify --flatten -o jsonpath='{.clusters[].cluster.certificate-authority-data}')
EOF
```

or use the following convenience script:

```
curl -fsSL https://raw.githubusercontent.com/Kong/kong-dist-kubernetes/master/setup_sidecar_injector.sh | bash
```

## Usage

Going forward, any pods that start get a Kong Sidecar automatically injected, and all
data from the containers of that pod will flow through a Kong Sidecar.

For example, if we use the `bookinfo.yaml` example from Istio:

```
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.1/samples/bookinfo/platform/kube/bookinfo.yaml
```

We see that all pods received a Kong Sidecar:

```
kubectl get all
NAME                 READY   STATUS
pod/details-v1       2/2     Running
pod/productpage      2/2     Running
pod/ratings-v1       2/2     Running
pod/reviews-v1       2/2     Running
pod/reviews-v2       2/2     Running
pod/reviews-v3       2/2     Running
```

Continue to [configuring a service](/latest/getting-started/configuring-a-service/).
