Clusters running GKE versions 1.18 and later automatically provision load balancers in response to `Ingress` resources being created.

GKE requires a `BackendConfig` resource to be created for Kong deployments to be marked as healthy.

1. Create a `BackendConfig` [resource](https://cloud.google.com/kubernetes-engine/docs/concepts/ingress#interpreted_hc) to configure health checks.

    ```yaml
    echo "apiVersion: cloud.google.com/v1
    kind: BackendConfig
    metadata:
      name: kong-hc
      namespace: kong
    spec:
      healthCheck:
        checkIntervalSec: 15
        port: 8100
        type: HTTP
        requestPath: /status" | kubectl apply -f -
    ```

2. This `BackendConfig` is attached to the `{{ include.service }}` service using the `annotations` key in `values-{{ include.release }}.yaml`

{:.important}
> GKE provisions one load balancer per `Ingress` definition. Following this guide will result in multiple load balancers being created.
