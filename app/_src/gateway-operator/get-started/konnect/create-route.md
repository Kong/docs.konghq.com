---
title: Create a Route
content-type: tutorial
book: kgo-konnect-get-started
chapter: 3
---

{:.note}
> These examples require that you have `jq` installed on your machine. You can also use the [Konnect UI](https://cloud.konghq.com) to configure services and routes.

Once your `DataPlane` is deployed it receives configuration from Konnect, but there are no routing rules available for {{ site.base_gateway }} to proxy traffic. You can use Konnect API to configure and test routing.

## Before you begin

1. In Gateway Manager, navigate to the **Overview** page of the control plane to which you added the data plane.
1. Copy the ID of the control plane in the **About this Hybrid Control Plane** section.
1. Set the value of the variable `CP_UUID` to the ID of the control plane that you copied.

    ```bash
    export CP_UUID="a62e9a4c-d47..."
    ```

1. Generate a [personal access token](https://cloud.konghq.com/global/account/tokens) to use the Konnect API.
1. Set the value of the variable `KONNECT_TOKEN` to the personal access token that you generated.

    ```bash
    export KONNECT_TOKEN="kpat_pYyaCgDWv..."
    ```

## Create Kong Entities

Create a service and a route in your {{ site.konnect_short_name }} control plane using the variables that you set.

The following commands create a service named _Sample_ and a route that proxies all traffic to httpbin.org:

```bash
SERVICE_ID=$(curl -sS -H "Authorization: Bearer $KONNECT_TOKEN" https://us.api.konghq.com/v2/control-planes/$CP_UUID/core-entities/services -d name=Sample -d url=https://httpbin.org | jq -r .id)

curl -sS -H "Authorization: Bearer $KONNECT_TOKEN" https://us.api.konghq.com/v2/control-planes/$CP_UUID/core-entities/services/$SERVICE_ID/routes -d "paths[]=/"
```

## Send test traffic

After the service and route are created, send traffic to the proxy and it will forward the request to httpbin.org. You can use httpbin's `/anything` endpoint to echo the request made in the response.

To make a request to the proxy, fetch the LoadBalancer IP address using `kubectl get services`:

```bash
export PROXY_IP=$(kubectl get services -n kong -o json | jq -r '.items[] | .status.loadBalancer?|.ingress[]?|.ip')
echo "Proxy IP: $PROXY_IP"
```

{:.note}
> Note: If your cluster can't provision LoadBalancer type Services, then you might not receive an IP address.

Test the routing rules by sending a request to the proxy IP address:

```bash
curl $PROXY_IP/anything/hello
```

## Delete the test service

You can delete the test service after you verify that {{ site.kgo_product_name }} and {{ site.konnect_short_name }} are working.

To delete the `Sample` service.

```bash
curl -sS -H "Authorization: Bearer $KONNECT_TOKEN" https://us.api.konghq.com/v2/runtime-groups/$CP_UUID/core-entities/services/$SERVICE_ID -X DELETE
```

## Next steps

Now that you have a `DataPlane` that has configuration from Konnect you can explore all of the capabilities that {{ site.base_gateway }} provides.

* [Configuring {{ site.base_gateway }} in Konnect](/konnect/runtime-manager/configuration/)
* [Upgrading {{ site.kgo_product_name }} managed data planes](/gateway-operator/{{ page.release }}/production/upgrade/data-plane/rolling/)
