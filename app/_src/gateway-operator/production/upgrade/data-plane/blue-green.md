---
title: Blue/Green Upgrades
---

## Using DataPlane

Blue/Green upgrades can be accomplished when working with the `DataPlane` resource directly.

1. To enable blue/green deployments set the `spec.deployment.rollout.strategy` on your `DataPlane` resource:

    ```yaml
    apiVersion: gateway-operator.konghq.com/v1beta1
    kind: DataPlane
    metadata:
      name: dataplane-example
    spec:
      deployment:
        rollout:
          strategy:
            blueGreen:
              promotion:
                strategy: BreakBeforePromotion
        podTemplateSpec:
          spec:
            containers:
            - name: proxy
              image: kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}
              env:
              - name: KONG_LOG_LEVEL
                value: debug
              readinessProbe:
                initialDelaySeconds: 1
                periodSeconds: 1
    ```

    > **NOTE**: Currently only `BreakBeforePromotion` is available as promotion strategy.

    When applied like this, {{ site.kgo_product_name }} will deploy new `Services` through which you'll be able to access new `Pod`s once they are available.

    By default no `Pod`s will be deployed immediately, instead {{ site.kgo_product_name }} will observe the `DataPlane` resource for `spec` changes and when any configuration drift is detected it will spawn a new "preview" `Deployment` which will contain the changes applied to the `DataPlane` resource.

1. Wait for `DataPlane` to be ready to accept changes

    ```bash
    kubectl wait dataplane dataplane-example --for=jsonpath='{.status.rollout.conditions[*].reason}'=AwaitingPromotion
    ```

1. Test it out by patching the `DataPlane` with a new `image`:

    ```bash
    kubectl patch dataplane dataplane-example --type='json' -p='[{"op": "replace", "path": "/spec/deployment/podTemplateSpec/spec/containers/0/image", "value":"kong:3.3.1"}]'
    ```

    The output should look like this:

    ```bash
    dataplane.gateway-operator.konghq.com/dataplane-example patched
    ```

    After this patch gets applied you'll be able to access the new {{ site.base_gateway }} `Pod`s via the "preview" ingress `Service`.

1. To find the "preview" `Service` you can look up `DataPlane` status, and more specifically its `rollout` field:

    ```bash
    kubectl get dataplane dataplane-example -o jsonpath-as-json='{.status.rollout}'
    ```

    The output should look like this:

    ```json
    [
        {
            "conditions": [
                {
                    "lastTransitionTime": "2023-09-21T11:40:25Z",
                    "message": "",
                    "observedGeneration": 2,
                    "reason": "AwaitingPromotion",
                    "status": "False",
                    "type": "RolledOut"
                }
            ],
            "deployment": {
                "selector": "6cf0d993-2319-43d5-bfdc-e2cadd6bd7e3"
            },
            "services": {
                "adminAPI": {
                    "addresses": [
                        {
                            "sourceType": "PrivateIP",
                            "type": "IPAddress",
                            "value": "None"
                        }
                    ],
                    "name": "dataplane-admin-dataplane-example-cx6nq"
                },
                "ingress": {
                    "addresses": [
                        {
                            "sourceType": "PrivateLoadBalancer",
                            "type": "IPAddress",
                            "value": "172.18.0.101"
                        },
                        {
                            "sourceType": "PrivateIP",
                            "type": "IPAddress",
                            "value": "10.96.28.2"
                        }
                    ],
                    "name": "dataplane-ingress-dataplane-example-2249g"
                }
            }
        }
    ]
    ```

    Here you can see the ingress `Service` name that was created for you to validate the new set of `Pod`s.
    
    Its addresses (together with their `type`s and `sourceType`s) are stored `status.rollout.services[].ingress`.

    Notice that `status.rollout.conditions[]` contains a condition with Type `RolledOut` and `Reason` set to `AwaitingPromotion`.
    This means that everything is ready to promote the `DataPlane` with staged changes.
    Before we do so, let's test it.

1. You can access the spawned "preview" `Service` by using its LB address (taken from the `status.rollout.services[].ingress.addresses[].value` field):

    ```bash
    $ curl -s -D - -o /dev/null 172.18.0.101
    HTTP/1.1 404 Not Found
    Date: Thu, 21 Sep 2023 11:40:26 GMT
    Content-Type: application/json; charset=utf-8
    Connection: keep-alive
    Content-Length: 52
    X-Kong-Response-Latency: 0
    Server: kong/3.3.1
    ```

    This way we can see that new {{ site.base_gateway }} `Pod`s have been deployed and are reachable through the "preview" ingress `Service` using the updated image.

1. Verify the old `Pod`s are still available and are still serving the traffic. You can verify that by accessing its "live" ingress `Service`

    We can get its addresses with:

    ```bash
    kubectl get dataplane dataplane-example -o jsonpath-as-json='{.status.addresses}'
    ```

    The output should look like this:

    ```bash
    [
      [
        {
            "sourceType": "PrivateLoadBalancer",
            "type": "IPAddress",
            "value": "172.18.0.100"
        },
        {
            "sourceType": "PrivateIP",
            "type": "IPAddress",
            "value": "10.96.11.156"
        }
      ],
    ]
    ```

    Knowing the LoadBalancer IP address is `172.18.0.100`, you can issue a request:

    ```bash
    $ curl -s -D - -o /dev/null 172.18.0.100
    HTTP/1.1 404 Not Found
    Date: Thu, 21 Sep 2023 11:40:26 GMT
    Content-Type: application/json; charset=utf-8
    Connection: keep-alive
    Content-Length: 52
    X-Kong-Response-Latency: 0
    Server: kong/{{ site.data.kong_latest_gateway.ce-version }}
    ```

    As you can see the live `Service` is still serving traffic using `{{ site.data.kong_latest_gateway.ce-version }}`

1. Now you can perform additional validation steps by inspecting the deployed resources.

1. Once you've validated the newly created resources, run `kubectl annotate dataplanes.gateway-operator.konghq.com dataplane-example gateway-operator.konghq.com/promote-when-ready=true` to allow {{ site.kgo_product_name }} to switch the traffic to the new `Pod`s.

   This annotation will automatically be cleared by {{ site.kgo_product_name }} once the new `Pod`s are promoted to be live.

1. Once the promotion concludes, the updated `Pod`s start serving traffic and the old `Pod`s and their `Deployment` will be deleted to conserve the resources.
