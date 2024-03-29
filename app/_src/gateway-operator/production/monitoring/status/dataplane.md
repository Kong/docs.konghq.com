---
title: DataPlane
---

[`DataPlane` 's status field](/gateway-operator/{{page.release}}/reference/custom-resources/#dataplanestatus) contains invaluable information about managed {{site.base_gateway}} deployments.

## How to retrieve it

Let's use the following `DataPlane` as an example:

```
echo '
apiVersion: gateway-operator.konghq.com/v1beta1
kind: DataPlane
metadata:
  name: example
spec:
  deployment:
    podTemplateSpec:
      metadata:
        labels:
          dataplane-pod-label: example
        annotations:
          dataplane-pod-annotation: example
      spec:
        containers:
        - name: proxy
          image: kong/kong-gateway:3.6.1.1 ' | kubectl apply -f -
```

To wait for the `DataPlane` to get ready we can use the following command:

```bash
kubectl wait -n default dataplane example --for=condition=Ready
```

After a couple of seconds we should see:

```bash
dataplane.gateway-operator.konghq.com/example condition met
```

Having this `DataPlane` deployed we can get all sorts of information from its `status` field.

For example, if you'd like to get its addresses you can simply run:

```bash
kubectl get -n default dataplane example -o jsonpath-as-json='{.status.addresses}'
```

Which could yield:

```json
[
    [
        {
            "sourceType": "PrivateLoadBalancer",
            "type": "IPAddress",
            "value": "172.18.128.1"
        },
        {
            "sourceType": "PrivateIP",
            "type": "IPAddress",
            "value": "10.96.194.111"
        }
    ]
]
```

## DataPlane proxy service

To get `DataPlane`'s proxy `Service` name you can query the `.status.service` field like so:

```bash
kubectl get -n default dataplane dataplane-example -o jsonpath-as-json='{.status.service}'
```

```yaml
[
    "dataplane-ingress-dataplane-example-sj54n"
]
```

## Troubleshooting using status condition

If your `DataPlane` does not work you can start by looking at its `.status.conditions` field.

```bash
kubectl get -n default dataplane dataplane-example -o jsonpath-as-json='{.status.conditions}'
```

Which can give you more insight into the underlying problem:

```json
[
    [
        {
            "lastTransitionTime": "2024-03-22T17:59:13Z",
            "message": "Waiting for the resource to become ready: Deployment dataplane-dataplane-example-bdqjq is not ready yet",
            "observedGeneration": 2,
            "reason": "WaitingToBecomeReady",
            "status": "False",
            "type": "Ready"
        }
    ]
]
```
