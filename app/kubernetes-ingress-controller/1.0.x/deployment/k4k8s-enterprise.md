---
title: Kong for Kubernetes Enterprise
---

Kong for Kubernetes Enterprise is an enhanced version of
the Open-Source Ingress Controller. It includes all
Enterprise plugins and comes with 24x7 support for worry-free
production deployment.
This is available to enterprise customers of Kong, Inc. only.

## Prerequisites

Before we can deploy Kong, we need to satisfy one prerequisite: create a license
secret.

To create this secret, provision the `kong` namespace first:

```bash
$ kubectl create namespace kong
namespace/kong created
```

### Kong Enterprise License secret

Enterprise version requires a valid license to run.  
As part of sign up for Kong Enterprise, you should have received a license file.
If you do not have one, please contact your sales representative.
Save the license file temporarily to disk with filename `license`
and execute the following:

```bash
$ kubectl create secret generic kong-enterprise-license --from-file=license=./license.json -n kong
secret/kong-enterprise-license created
```

Please note that `-n kong` specifies the namespace in which you are deploying
  the {{site.kic_product_name}}. If you are deploying in a different namespace,
  please change this value.

## Installers

Once the secret is in-place, we can proceed with installation.

Kong for Kubernetes can be installed using an installer of
your choice:

### YAML manifests

Execute the following to install Kong for Kubernetes Enteprise using YAML
manifests:

```bash
$ kubectl apply -f https://bit.ly/k4k8s-enterprise-install
```

It takes a few minutes the first time this setup is done.

```bash
$ kubectl get pods -n kong
NAME                            READY   STATUS    RESTARTS   AGE
ingress-kong-6ffcf8c447-5qv6z   2/2     Running   1          44m
```

You can also see the `kong-proxy` service:

```bash
$ kubectl get service kong-proxy -n kong
NAME         TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                      AGE
kong-proxy   LoadBalancer   10.63.254.78   35.233.198.16   80:32697/TCP,443:32365/TCP   22h
```

> Note: Depending on the Kubernetes distribution you are using, you might or might
not see an external IP address assigned to the service. Please see
your provider's guide on obtaining an IP address for a Kubernetes Service of
type `LoadBalancer`.

Let's setup an environment variable to hold the IP address:

```bash
$ export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong kong-proxy)
```

> Note: It may take a while for your cloud provider to actually associate the
IP address to the `kong-proxy` Service.

### Kustomize

<div class="alert alert-warning">
  Kustomize manifests are provided for illustration purposes only and are not officially supported by Kong.
  There is no guarantee of backwards compatibility or upgrade capabilities for our Kustomize manifests.
  For a production setup with Kong support, use the <a href="https://github.com/kong/charts">Helm Chart</a>.
</div>

Use Kustomize to install Kong for Kubernetes Enterprise:

```
kustomize build github.com/kong/kubernetes-ingress-controller/deploy/manifests/enterprise-k8s
```

You can use the above URL as a base kustomization and build on top of it
as well.

Once installed, set an environment variable, $PROXY_IP with the External IP address of
the `kong-proxy` service in `kong` namespace:

```
export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong kong-proxy)
```

### Helm

You can use Helm to install Kong via the official Helm chart:

```
$ helm repo add kong https://charts.konghq.com
$ helm repo update

# Helm 2
$ helm install kong/kong \
    --name demo --namespace kong \
    --values values.yaml

# Helm 3
$ helm install kong/kong --generate-name
    --namespace kong \
    -f values.yaml \
    --set ingressController.installCRDs=false
```

### Example values.yaml
```
image:
  repository: kong/kong-gateway
  tag: 2.2.1.0-alpine
env:
  LICENSE_DATA:
    valueFrom:
      secretKeyRef:
        name: kong-enterprise-license
        key: license
```

Once installed, set an environment variable, $PROXY_IP with the External IP address of
the `demo-kong-proxy` service in `kong` namespace:

```
export PROXY_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" service -n kong demo-kong-proxy)
```

## Using Kong for Kubernetes Enterprise

Once you've installed Kong for Kubernetes Enterprise, please follow our
[getting started](/kubernetes-ingress-controller/{{page.kong_version}}/guides/getting-started) tutorial to learn more.
