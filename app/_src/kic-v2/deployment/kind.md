---
title: Kong for Kubernetes with Kong Gateway Enterprise
---

This guide walks through setting up the {{site.kic_product_name}} with Kong
Enterprise. This architecture is described in detail in [this doc](/kubernetes-ingress-controller/{{page.kong_version}}/concepts/k4k8s-with-kong-enterprise).

## Set up Kind cluster

First, create a `kind` cluster to deploy {{site.kic_product_name}} to:

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
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
EOF
```

Next, create a `kong` namespace for your resources:

```bash
kubectl create namespace kong
```

### Create a {{site.ee_product_name}} license secret (optional)

If you have an Enterprise license, save it to disk as `license.json` and create a secret:

```bash
kubectl create secret generic kong-enterprise-license --from-file=license=./license.json -n kong
```

### Set your Kong Manager password

The Kong Manager UI requires authentication. {{site.kic_product_name}} uses the `kong-enterprise-superuser-password`
secret to set the default value for the default `kong_admin` user.

Run the following, replacing `cloudnative` with a random password of your choice and note it down:

```bash
kubectl create secret generic kong-enterprise-superuser-password  -n kong --from-literal=password=cloudnative
```

Once these resources have been created, you're ready to deploy {{site.kic_product_name}}.

## Install {{site.base_gateway}}

```bash
kubectl apply -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/v{{ page.kong_version | replace: ".x", ".0" }}/deploy/single/all-in-one-postgres-enterprise.yaml
```

This may take a few minutes.

Once bootstrapped, run `kubectl get pods` to see your running pods:

```bash
kubectl get pods -n kong
```

You should see the {{site.kic_product_name}} running:

```
NAME                            READY   STATUS      RESTARTS   AGE
ingress-kong-548b9cff98-n44zj   2/2     Running     0          21s
kong-migrations-pzrzz           0/1     Completed   0          4m3s
postgres-0                      1/1     Running     0          4m3s
```

### Configure your ingress

{{site.base_gateway}}'s Admin API, Kong Manager UI, and the proxy will all be exposed on the same port.
Use {{site.base_gateway}} to route to the correct internal port based on the `host` provided.

Let's create some `ingress` configurations to enable this:

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

Apply the following patch to set the `KONG_ADMIN_API_URI` to the hostname you set in the ingress above:

```bash
kubectl patch deployment -n kong ingress-kong -p "{\"spec\": { \"template\" : { \"spec\" : {\"containers\":[{\"name\":\"proxy\",\"env\": [{ \"name\" : \"KONG_ADMIN_API_URI\", \"value\": \"http://admin-api.127-0-0-1.nip.io\" }]}]}}}}"
```

### Expose the proxy to your host machine

Apply the following `kind`-specific patches to make the proxy accessible on the host machine:

```bash
kubectl patch deployment -n kong ingress-kong -p '{"spec":{"template":{"spec":{"containers":[{"name":"proxy","ports":[{"containerPort":8000,"hostPort":80,"name":"proxy","protocol":"TCP"},{"containerPort":8443,"hostPort":443,"name":"proxy-ssl","protocol":"TCP"}]}]}}}}'
```

It will take a few minutes to roll out the updated deployment. Once the new
`ingress-kong` pod is up and running, visit `http://manager.127-0-0-1.nip.io` and you should be able to log
in to the Kong Manager UI.

As you follow along with other guides on how to use your newly deployed {{site.kic_product_name}},
you will be able to browse Kong Manager and see changes reflected in the UI as Kong's
configuration changes.

## Making a request through the proxy

Let's set up an environment variable to hold the IP address of `kong-proxy` service:

```bash
export PROXY_IP="proxy.127-0-0-1.nip.io"
curl $PROXY_IP
```

Output:

```
{"message":"no Route matched with those values"}%
```

This `$PROXY_IP` variable will be used in future guides. Follow our
[getting started](/kubernetes-ingress-controller/{{page.kong_version}}/guides/getting-started) tutorial to learn more.