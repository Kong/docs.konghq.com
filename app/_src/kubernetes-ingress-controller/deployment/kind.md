---
title: Kong for Kubernetes with Kong Enterprise
---

This guide walks through setting up the {{site.kic_product_name}} using Kong
Enterprise. This architecture is described in detail in [this doc](/kubernetes-ingress-controller/{{page.kong_version}}/concepts/k4k8s-with-kong-enterprise).

We assume that we start from scratch and you don't have Kong Enterprise
deployed. For the sake of simplicity, we will deploy Kong Enterprise and
its database in Kubernetes itself. You can safely run them outside
Kubernetes as well.

## Prerequisites

Before we can deploy the {{site.kic_product_name}} with Kong Enterprise,
we need to satisfy the following prerequisites:

- [Kong Enterprise License secret](#kong-enterprise-license-secret)
- [Kong Enterprise bootstrap password](#kong-enterprise-bootstrap-password)

In order to create these secrets, let's provision the `kong`
namespace first:

```bash
$ kubectl create namespace kong
namespace/kong created
```

### Set up Kind cluster

```bash
cat <<EOF | kind create cluster --config=-
kind: Cluster
name: kong
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF
```

### Kong Enterprise License secret

Kong Enterprise requires a valid license to run.
As part of sign up for Kong Enterprise, you should have received a license file.
Save the license file temporarily to disk and execute the following:

```bash
$ kubectl create secret generic kong-enterprise-license --from-file=license=./license.json -n kong
secret/kong-enterprise-license created
```

Please note that `-n kong` specifies the namespace in which you are deploying
  the {{site.kic_product_name}}. If you are deploying in a different namespace,
  please change this value.

### Kong Enterprise bootstrap password

Next, we need to create a secret containing the password using which we can login into Kong Manager.
Please replace `cloudnative` with a random password of your choice and note it down.

```bash
$ kubectl create secret generic kong-enterprise-superuser-password  -n kong --from-literal=password=cloudnative
secret/kong-enterprise-superuser-password created
```

Once these are created, we are ready to deploy Kong Enterprise
Ingress Controller.

## Install

```bash
kubectl apply -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/v{{ page.kong_version | replace: ".x", ".0" }}/deploy/single/all-in-one-postgres-enterprise.yaml
```

It takes a little while to bootstrap the database.
Once bootstrapped, you should see the {{site.kic_product_name}} running with
Kong Enterprise as its core:

```bash
$ kubectl get pods -n kong
NAME                            READY   STATUS      RESTARTS   AGE
ingress-kong-548b9cff98-n44zj   2/2     Running     0          21s
kong-migrations-pzrzz           0/1     Completed   0          4m3s
postgres-0                      1/1     Running     0          4m3s
```

Apply kind specific patches to forward the hostPorts to the ingress controller, set taint tolerations, and schedule it to the custom labeled node.

```bash
kubectl patch deployment -n kong ingress-kong -p '{"spec":{"template":{"spec":{"containers":[{"name":"proxy","ports":[{"containerPort":8000,"hostPort":80,"name":"proxy","protocol":"TCP"},{"containerPort":8443,"hostPort":443,"name":"proxy-ssl","protocol":"TCP"}]}],"nodeSelector":{"ingress-ready":"true"},"tolerations":[{"key":"node-role.kubernetes.io/control-plane","operator":"Equal","effect":"NoSchedule"},{"key":"node-role.kubernetes.io/master","operator":"Equal","effect":"NoSchedule"}]}}}}'
```

Apply kind specific patch to change service type to NodePort

```bash
kubectl patch service -n kong kong-proxy -p '{"spec":{"type":"NodePort"}}'
kubectl patch service -n kong kong-manager -p '{"spec":{"type":"NodePort"}}'
kubectl patch service -n kong kong-admin -p '{"spec":{"type":"NodePort"}}'
```

```bash
kubectl get services -n kong
NAME                      TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)                      AGE
kong-admin                NodePort    10.96.66.102    <none>        80:30980/TCP                 62m
kong-manager              NodePort    10.96.244.156   <none>        80:31640/TCP                 62m
kong-proxy                NodePort    10.96.87.68     <none>        80:31134/TCP,443:32025/TCP   62m
kong-validation-webhook   ClusterIP   10.96.37.107    <none>        443/TCP                      62m
postgres                  ClusterIP   10.96.84.4      <none>        5432/TCP                     62m
```

### Setup Kong Manager

Set up the ingress rules for Admin, Manager and Proxy

```bash
echo "
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: kong-proxy
  namespace: kong
spec:
  ingressClassName: kong
  rules:
  - host: kong.127-0-0-1.nip.io
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: kong-proxy
            port: 
              number: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: kong-admin
  namespace: kong
spec:
  ingressClassName: kong
  rules:
  - host: admin-api.127-0-0-1.nip.io
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: kong-admin
            port: 
              number: 80
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: kong-manager
  namespace: kong
spec:
  ingressClassName: kong
  rules:
  - host: manager.127-0-0-1.nip.io
    http:
      paths:
      - path: /
        pathType: ImplementationSpecific
        backend:
          service:
            name: kong-manager
            port: 
              number: 80
" | kubectl apply -f -
```

Next, if you browse to the IP address or host of the kong-manager service in your Browser, which in our case is <http://manager.127-0-0-1.nip.io/>. Kong Manager should load in your browser. Try logging in to the Manager with the username kong_admin and the password you supplied in the prerequisite, it should fail. The reason being we've not yet told Kong Manager where it can find the Admin API.

Let's set that up. We will take the External IP address of kong-admin service and set the environment variable KONG_ADMIN_API_URI:

We will use the admin.127.nip.io to set up the Admin API

```bash
kubectl patch deployment -n kong ingress-kong -p "{\"spec\": { \"template\" : { \"spec\" : {\"containers\":[{\"name\":\"proxy\",\"env\": [{ \"name\" : \"KONG_ADMIN_API_URI\", \"value\": \"http://admin-api.127-0-0-1.nip.io\" }]}]}}}}"
```

It will take a few minutes to roll out the updated deployment and once the new
`ingress-kong` pod is up and running, you should be able to log into the Kong Manager UI.

As you follow along with other guides on how to use your newly deployed the {{site.kic_product_name}},
you will be able to browse Kong Manager and see changes reflected in the UI as Kong's
configuration changes.

## Using Kong for Kubernetes with Kong Enterprise

Let's setup an environment variable to hold the IP address of `kong-proxy` service:

```bash
export PROXY_IP="proxy.127-0-0-1.nip.io"

curl proxy.127-0-0-1.nip.io/
{"message":"no Route matched with those values"}%

```

Once you've installed Kong for Kubernetes Enterprise, please follow our
[getting started](/kubernetes-ingress-controller/{{page.kong_version}}/guides/getting-started) tutorial to learn more.

## Customizing by use-case

The deployment in this guide is a point to start using Ingress Controller.
Based on your existing architecture, this deployment will require custom
work to make sure that it needs all of your requirements.

In this guide, there are three load-balancers deployed for each of
Kong Proxy, Kong Admin and Kong Manager services. It is possible and
recommended to instead have a single Load balancer and then use DNS names
and Ingress resources to expose the Admin and Manager services outside
the cluster.
