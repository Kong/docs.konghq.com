---
title: ControlPlane
---

[`ControlPlane` 's status field](/gateway-operator/{{page.release}}/reference/custom-resources/#controlplanestatus) contains invaluable information about managed {{site.kic_product_name}} deployments.

## How to retrieve it

Assuming a `ControlPlane` called `kong` you can obtain its status using the following `kubectl` command:

```bash
kubectl get controlplane kong -o jsonpath-as-json='{.status}'
```

Which should yield output similar to:

```json
[
    {
        "conditions": [
            {
                "lastTransitionTime": "2024-03-22T18:17:00Z",
                "message": "",
                "observedGeneration": 3,
                "reason": "Ready",
                "status": "True",
                "type": "Ready"
            },
            {
                "lastTransitionTime": "2024-03-22T18:17:00Z",
                "message": "pods for all Deployments are ready",
                "observedGeneration": 3,
                "reason": "PodsReady",
                "status": "True",
                "type": "Provisioned"
            }
        ]
    }
]
```
