---
title: Create a Route
content-type: tutorial
book: kgo-konnect-get-started
chapter: 3
---

{:.note}
> These examples require that you have `jq` installed on your machine. You can also use the [Konnect UI](https://cloud.konghq.com) to configure services and routes.

Your `DataPlane` should now be running, but there are no routing rules to tell {{ site.base_gateway }} how to proxy traffic. In this tutorial we will use the Konnect API to configure and test routing.

## Before you begin

1. Visit the Gateway Manager section of Konnect and fetch your control plane ID. This is available on the _Data Plane Nodes_ page next to the _Control Plane ID_ label. Export a variable that contains this value:

    ```bash
    export CP_UUID="a62e9a4c-d47..."
    ```

1. Generate a [personal access token](https://cloud.konghq.com/global/account/tokens) to use the Konnect API.
1. Set the value of the variable `KONNECT_TOKEN` to the personal access token that you generated.

    ```bash
    export KONNECT_TOKEN="kpat_pYyaCgDWv..."
    ```

## Create Kong Entities

1.  Create a service and a route in your {{ site.konnect_short_name }} control plane using the variables that you set.

The following commands create a service named _Sample_ and a route that proxies all traffic to mockbin.org:

```bash
SERVICE_ID=$(curl -sS -H "Authorization: Bearer $KONNECT_TOKEN" https://us.api.konghq.com/v2/control-planes/$CP_UUID/core-entities/services -d name=Sample -d url=https://mockbin.org | jq -r .id)

curl -sS -H "Authorization: Bearer $KONNECT_TOKEN" https://us.api.konghq.com/v2/control-planes/$CP_UUID/core-entities/services/$SERVICE_ID/routes -d "paths[]=/"
```

## Send test traffic

Once the service and route are created, you can send traffic to the proxy and it will forward the request to mockbin.org. We'll use Mockbin's `/request` endpoint to echo back the request we made in the response.

To make a request to the proxy we need to fetch the LoadBalancer IP address using `kubectl get services`:

```bash
export PROXY_IP=$(kubectl get services -n kong -o json | jq -r '.items[] | .status.loadBalancer?|.ingress[]?|.ip')
echo "Proxy IP: $PROXY_IP"
```

{:.note}
> Note: if your cluster can not provision LoadBalancer type Services then you may not receive an IP address

To test the routing rules that you just created, use `curl` to make a request to the proxy IP:

```bash
curl $PROXY_IP/request/hello
```

## Delete the test service

You can delete the test service after you verify that {{ site.kgo_product_name }} and {{ site.konnect_short_name }} are working.

1.  To delete the `Sample` service.

```bash
curl -sS -H "Authorization: Bearer $KONNECT_TOKEN" https://us.api.konghq.com/v2/runtime-groups/$CP_UUID/core-entities/services/$SERVICE_ID -X DELETE
```

## Next steps

Now that you have a `DataPlane` that has configuration from Konnect you can explore all of the capabilities that {{ site.base_gateway }} provides.

* [Configuring {{ site.base_gateway }} in Konnect](/konnect/runtime-manager/configuration/)
* [Upgrading {{ site.kgo_product_name }} managed data planes](/gateway-operator/{{ page.release }}/production/upgrade/data-plane/rolling/)