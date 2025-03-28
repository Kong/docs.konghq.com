---
title: Create a Route
content-type: tutorial
book: kgo-konnect-get-started
chapter: 3
---

Now that you have a Control Plane and Data Plane, it's time to configure a Service and Route to handle traffic.

## Create a service

Creating the `KongService` object in your Kubernetes cluster will provision a {{site.konnect_product_name}} service in
your [Gateway Manager](/konnect/gateway-manager).
You can refer to the CR [API](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongservice)
to see all the available fields.

Your `KongService` must be associated with a `KonnectGatewayControlPlane` object that you've created in your cluster.  It will make it part of the Gateway control plane's configuration.

Create a `KongService` by applying the following YAML manifest:

```yaml
echo '
kind: KongService
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  name: service
  namespace: default
spec:
  name: service
  host: httpbin.konghq.com
  controlPlaneRef:
    type: konnectNamespacedRef # This indicates that an in cluster reference is used
    konnectNamespacedRef:
      name: gateway-control-plane # Reference to the KonnectGatewayControlPlane object
  ' | kubectl apply -f -
```

At this point, you should see the Service in the Gateway Manager UI.

## Create a route

Creating the `KongRoute` object in your Kubernetes cluster will provision a {{site.konnect_product_name}} route in
your [Gateway Manager](/konnect/gateway-manager).
You can refer to the CR [API](/gateway-operator/{{ page.release }}/reference/custom-resources/#kongroute) to see all the available fields.

### Associate a route with a service

You can create a `KongRoute` associated with a `KongService` by applying the following YAML manifest:

```yaml
echo '
kind: KongRoute
apiVersion: configuration.konghq.com/v1alpha1
metadata:
  name: route-with-service
  namespace: default
spec:
  name: route-with-service
  protocols:
  - http
  paths:
  - /
  serviceRef:
    type: namespacedRef
    namespacedRef:
      name: service # KongService reference
' | kubectl apply -f -
```


## Send test traffic

After the service and route are created, send traffic to the proxy and it will forward the request to httpbin.konghq.com. You can use httpbin's `/anything` endpoint to echo the request made in the response.

To make a request to the proxy, fetch the LoadBalancer IP address using `kubectl get services`:

```bash
export PROXY_IP=$(kubectl get services -o json | jq -r '.items[] | .status.loadBalancer?|.ingress[]?|.ip')
echo "Proxy IP: $PROXY_IP"
```

{:.note}
> Note: If your cluster can't provision LoadBalancer type Services, then you might not receive an IP address.

Test the routing rules by sending a request to the proxy IP address:

```bash
curl $PROXY_IP/anything/hello
```