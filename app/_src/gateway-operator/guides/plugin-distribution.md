---
title: Kong custom plugin distribution with KongPluginInstallation
---
{{ site.kgo_product_name }} can install Kong custom plugins packaged as container images. This guide shows how to package, install, and use a custom plugin in {{site.base_gateway}} instances managed by the {{ site.kgo_product_name }}.

{% include md/kgo/prerequisites.md version=page.version release=page.release kongPluginInstallation=true %}

{% include md/custom-plugin.md %}

2. Build a container image that includes the plugin code.

   Plugin-related files should be at the root of the image, so the Dockerfile for the plugin would look like this:

   ```bash
   echo 'FROM scratch

   COPY myheader /
   ' > Dockerfile
   ```

   where `myheader` is a directory that contains `handler.lua` and `schema.lua`.

   Build the image:

   ```bash
   docker build -t myheader:1.0.0 .
   ```

   Next, push the image to a public or private registry available to the Kubernetes cluster where {{ site.kgo_product_name }} is running. 

   ```bash
   docker tag myheader:1.0.0 <YOUR-REGISTRY-ADDRESS>/myheader:1.0.0
   docker push <YOUR-REGISTRY-ADDRESS>/myheader:1.0.0
   ```

   In this example, the plugin is available in the public registry (Docker Hub) as `kong/plugin-example:1.0.0`. The following steps use the same source.

3. Install the plugin using the `KongPluginInstallation` resource. This resource makes the plugin available for instances of {{site.base_gateway}} resources.

   ```yaml
   echo '
   kind: KongPluginInstallation
   apiVersion: gateway-operator.konghq.com/v1alpha1
   metadata:
     name: custom-plugin-myheader
   spec:
     image: kong/plugin-example:1.0.0
   ' | kubectl apply -f -
   ```

   Learn more about the `KongPluginInstallation` resource in the [CRD reference documentation](/gateway-operator/{{page.release}}/reference/custom-resources/#kongplugininstallation).

   Verify that the plugin is fetched and available by examining the status of the `KongPluginInstallation` resource:

   ```bash
   kubectl get kongplugininstallations.gateway-operator.konghq.com -o jsonpath-as-json='{.items[*].status}'
   ```

   The output should look like this:

   ```json
   [
     {
         "conditions": [
             {
                 "lastTransitionTime": "2024-10-09T19:39:39Z",
                 "message": "plugin successfully saved in cluster as ConfigMap",
                 "observedGeneration": 1,
                 "reason": "Ready",
                 "status": "True",
                 "type": "Accepted"
             }
         ],
         "underlyingConfigMapName": "custom-plugin-myheader-hnzf9"
     }
   ]
   ```

   In case of problems, respective `conditions` or respective resources will provide more information.

   {:.note}
    > The `KongPluginInstallation` resource creates a `ConfigMap` with the plugin content. Additional `ConfigMap`s are created when a plugin is referenced by other resources. The operator automatically manages the lifecycle of all these `ConfigMap`s.

4. Make the plugin available in a `Gateway` resource by referencing it in the `spec.dataPlaneOptions.spec.pluginsToInstall` field of the `GatewayConfiguration` resource.
   Plugins can be referenced across namespaces without any additional configuration.

   ```yaml
   echo '
   kind: GatewayConfiguration
   apiVersion: gateway-operator.konghq.com/v1beta1
   metadata:
     name: kong
     namespace: default
   spec:
     dataPlaneOptions:
       deployment:
         replicas: 2
         podTemplateSpec:
           spec:
             containers:
               - name: proxy
                 image: kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}
                 readinessProbe:
                   initialDelaySeconds: 1
                   periodSeconds: 1
       pluginsToInstall:
         - name: custom-plugin-myheader
     controlPlaneOptions:
       deployment:
         podTemplateSpec:
           spec:
             containers:
               - name: controller
                 image: kong/kubernetes-ingress-controller:{{ site.data.kong_latest_KIC.version }}
                 readinessProbe:
                   initialDelaySeconds: 1
                   periodSeconds: 1
   ---
   apiVersion: gateway.networking.k8s.io/v1
   kind: GatewayClass
   metadata:
     name: kong
   spec:
     controllerName: konghq.com/gateway-operator
     parametersRef:
       group: gateway-operator.konghq.com
       kind: GatewayConfiguration
       name: kong
       namespace: default
   ---
   apiVersion: gateway.networking.k8s.io/v1
   kind: Gateway
   metadata:
     name: kong
     namespace: default
   spec:
     gatewayClassName: kong
     listeners:
       - name: http
         protocol: HTTP
         port: 80
   ' | kubectl apply -f -
   ```

5. Deploy an example service and expose it by configuring `HTTPRoute` with the custom plugin:

   ```bash
   kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/echo-service.yaml
   ```

   Next, add the `HTTPRoute` with the custom plugin. The configuration of the plugin is provided with the `KongPlugin` CRD, where the 
   field `plugin` is set to the name of the `KongPluginInstallation` resource.

   ```yaml
   echo '
   apiVersion: configuration.konghq.com/v1
   kind: KongPlugin
   metadata:
     name: myheader
   plugin: custom-plugin-myheader
   config:
     header_value: my-first-plugin
   ---
   apiVersion: gateway.networking.k8s.io/v1
   kind: HTTPRoute
   metadata:
     name: httproute-echo
     namespace: default
     annotations:
       konghq.com/strip-path: "true"
       konghq.com/plugins: myheader
   spec:
     parentRefs:
       - name: kong
     rules:
       - matches:
           - path:
               type: PathPrefix
               value: /echo
         backendRefs:
           - name: echo
             kind: Service
             port: 1027
   ' | kubectl apply -f -
   ```

   This example `HTTPRoute` routes requests to the `echo` service and applies the plugin to responses.

6. Ensure that everything is up and running and make a request to the service.

   To call the API, fetch the `PROXY_IP` for the Gateway:

   ```bash
   export PROXY_IP=$(kubectl get gateway kong -o jsonpath='{.status.addresses[0].value}')
   ```

   Make a `curl` request to the service:

   ```bash
   curl -I $PROXY_IP/echo
   ```

   The response should include the custom header set by the plugin:

   ```txt
   HTTP/1.1 200 OK
   Content-Type: text/plain; charset=utf-8
   Content-Length: 61
   Connection: keep-alive
   Date: Wed, 09 Oct 2024 20:21:23 GMT
   Server: kong/3.8.0.0-enterprise-edition
   myheader: my-first-plugin
   X-Kong-Upstream-Latency: 3
   X-Kong-Proxy-Latency: 0
   Via: 1.1 kong/3.8.0.0-enterprise-edition
   X-Kong-Request-Id: 6eec26150170fe3547bc1a4a20e93d74
   ```

## Troubleshooting

Everything needed to debug problematic `KongPluginInstallation`s can be found in the `status` of the respective resource.

For instance, if the plugin referenced in the `GatewayConfiguration` does not exist, examine the status of the `Gateway` resource:

```bash
kubectl get gateway -o jsonpath-as-json='{.items[*].status.conditions}'
```

Pay attention to the status of the resources:

```json
[
    [
        {
            "lastTransitionTime": "2024-10-10T15:58:52Z",
            "message": "All listeners are accepted.",
            "observedGeneration": 1,
            "reason": "Accepted",
            "status": "True",
            "type": "Accepted"
        },
        {
            "lastTransitionTime": "2024-10-10T15:58:52Z",
            "message": "There are other conditions that are not yet ready",
            "observedGeneration": 1,
            "reason": "Pending",
            "status": "False",
            "type": "Programmed"
        },
        {
            "lastTransitionTime": "2024-10-10T15:58:52Z",
            "message": "Waiting for the resource to become ready",
            "observedGeneration": 1,
            "reason": "WaitingToBecomeReady",
            "status": "False",
            "type": "DataPlaneReady"
        },
        {
            "lastTransitionTime": "2024-10-10T15:58:52Z",
            "message": "Resource has been created",
            "observedGeneration": 1,
            "reason": "ResourceCreatedOrUpdated",
            "status": "False",
            "type": "ControlPlaneReady"
        }
    ]
]
```

In this case, the `DataPlane` is not ready. 
You can now look at the `DataPlane`'s status:

```bash
kubectl get dataplanes.gateway-operator.konghq.com -o jsonpath-as-json='{.items[*].status.conditions}'
```

This provides more information about the specific resource:

```json
[
    [
        {
            "lastTransitionTime": "2024-10-10T15:58:54Z",
            "message": "referenced KongPluginInstallation default/additional-custom-plugin-4 not found",
            "observedGeneration": 1,
            "reason": "ReferencedResourcesNotAvailable",
            "status": "False",
            "type": "Ready"
        }
    ]
]
```

In this case, you can see that `KongPluginInstallation` in the namespace `default` with the name `additional-custom-plugin-4` is not found.

Following the approach described above, you can troubleshoot any issues related to the `KongPluginInstallation` resource.
Sometimes troubleshooting may lead to examining the `status` field of the `KongPluginInstallation` resource itself (for example, referencing a non-existent image or an image that doesn't contain a valid plugin).
