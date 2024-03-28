---
title: Gateway
---

[`Gateway` 's status field][gatewaystatus] contains invaluable information about managed Gateway API `Gateway` object.

[gatewaystatus]: https://gateway-api.sigs.k8s.io/reference/spec/#gateway.networking.k8s.io/v1.GatewayStatus

## How to retrieve it

<!--
Consider adding invocations of gwctl when that becomes stable and provides usefule information about the described objects.
https://github.com/kubernetes-sigs/gateway-api/tree/main/gwctl
-->

In order to retrieve the `status` field of a `Gateway` you can use the following `kubectl` command:

```bash
kubectl get gateway kong -o jsonpath-as-json='{.status}'
```

Which should yield the output similar to the one below:

```json
[
    {
        "addresses": [
            {
                "type": "IPAddress",
                "value": "172.18.128.1"
            }
        ],
        "conditions": [
            {
                "lastTransitionTime": "2024-03-22T18:17:00Z",
                "message": "All listeners are accepted.",
                "observedGeneration": 1,
                "reason": "Accepted",
                "status": "True",
                "type": "Accepted"
            },
            {
                "lastTransitionTime": "2024-03-22T18:17:00Z",
                "message": "",
                "observedGeneration": 1,
                "reason": "Programmed",
                "status": "True",
                "type": "Programmed"
            },
            {
                "lastTransitionTime": "2024-03-22T18:17:00Z",
                "message": "",
                "observedGeneration": 1,
                "reason": "Ready",
                "status": "True",
                "type": "Ready"
            },
            {
                "lastTransitionTime": "2024-03-22T18:17:00Z",
                "message": "",
                "observedGeneration": 1,
                "reason": "Ready",
                "status": "True",
                "type": "DataPlaneReady"
            },
            {
                "lastTransitionTime": "2024-03-22T18:17:00Z",
                "message": "",
                "observedGeneration": 1,
                "reason": "Ready",
                "status": "True",
                "type": "ControlPlaneReady"
            },
            {
                "lastTransitionTime": "2024-03-22T18:17:00Z",
                "message": "",
                "observedGeneration": 1,
                "reason": "Ready",
                "status": "True",
                "type": "GatewayService"
            }
        ],
        "listeners": [
            {
                "attachedRoutes": 0,
                "conditions": [
                    {
                        "lastTransitionTime": "2024-03-22T18:17:00Z",
                        "message": "",
                        "observedGeneration": 1,
                        "reason": "NoConflicts",
                        "status": "False",
                        "type": "Conflicted"
                    },
                    {
                        "lastTransitionTime": "2024-03-22T18:17:00Z",
                        "message": "",
                        "observedGeneration": 1,
                        "reason": "Accepted",
                        "status": "True",
                        "type": "Accepted"
                    },
                    {
                        "lastTransitionTime": "2024-03-22T18:17:00Z",
                        "message": "",
                        "observedGeneration": 1,
                        "reason": "Programmed",
                        "status": "True",
                        "type": "Programmed"
                    },
                    {
                        "lastTransitionTime": "2024-03-22T18:17:00Z",
                        "message": "Listeners' references are accepted.",
                        "observedGeneration": 1,
                        "reason": "ResolvedRefs",
                        "status": "True",
                        "type": "ResolvedRefs"
                    }
                ],
                "name": "http",
                "supportedKinds": [
                    {
                        "group": "gateway.networking.k8s.io",
                        "kind": "HTTPRoute"
                    }
                ]
            }
        ]
    }
]
```
