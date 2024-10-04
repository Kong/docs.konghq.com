---
title: Create a Gateway
content-type: tutorial
book: kgo-kic-get-started
chapter: 2
---

{% assign gatewayConfigApiVersion = "v1beta1" %}
{% if_version lte:1.1.x %}
{% assign gatewayConfigApiVersion = "v1alpha1" %}
{% endif_version %}

{% if_version lte: 1.1.x %}
{:.note}
> **Note:** `Gateway` and `ControlPlane` controllers are still `alpha` so be sure
> to use the [installation steps from this guide](/gateway-operator/{{ page.release }}/get-started/kic/install/)
> in order to get your `Gateway` up and running.
{% endif_version %}

Creating `GatewayClass` and `Gateway` resources in Kubernetes causes {{ site.kgo_product_name }} to create a {{ site.kic_product_name }} and {{ site.base_gateway }} deployment. 

## GatewayConfiguration

You can customize your {{ site.kic_product_name }} and {{ site.base_gateway }} deployments using the `GatewayConfiguration` CRD. This allows you to control the image being used, and set any required environment variables.
{%- if_version gte:1.2.x %}
 If you are creating a KIC in {{site.konnect_short_name}} deployment, you need to customize the deployment to contain your control plane ID and authentication certificate.
{%- endif_version %}

{% navtabs gc %}
{% if_version gte:1.2.x %}
{% navtab Konnect %}

To get the endpoint and the authentication details of the data plane.
1. [Log in to {{ site.konnect_short_name }}](https://cloud.konghq.com/login).
1. Navigate to {% konnect_icon runtimes %} [**Gateway Manager**](https://cloud.konghq.com/us/gateway-manager), click **New Control Plane** and select **{{ site.kic_product_name }}**.
1. Enter a name for your new control plane 
1. In the _Connect to KIC_ section, click **Generate Script**.
1. Click **Generate Certificate** in step 3.
1. Save the contents of **Cluster Certificate** in a file named `tls.crt`. Save the contents of **Cluster Key** in a file named `tls.key`.
1. Create a Kubernetes secret containing the cluster certificate:

    ```bash
    kubectl create secret tls konnect-client-tls --cert=./tls.crt --key=./tls.key
    ```
1. In the **Configuration parameters** step 4, find the value of `runtimeGroupID`. Replace `YOUR_CP_ID` with the control plane ID in the following manifest.
1. In the **Configuration parameters** step 4, find the value of `cluster_telemetry_endpoint`. The first segment of that value is the control plane endpoint for your cluster. For example, if the value of `cluster_telemetry_endpoint` is `36fc5d01be.us.cp0.konghq.com`, then the control plane endpoint of the cluster is `36fc5d01be`. Replace `YOUR_CP_ENDPOINT` with your control plane ID in the following manifest.
1. Deploy the data plane with `kubectl apply`:

```yaml
echo 'kind: GatewayConfiguration
apiVersion: gateway-operator.konghq.com/{{ gatewayConfigApiVersion }}
metadata:
  name: kong
  namespace: default
spec:
  controlPlaneOptions:
    deployment:
      podTemplateSpec:
        spec:
          containers:
          - name: controller
            image: kong/kubernetes-ingress-controller:{{ site.data.kong_latest_KIC.version }}
            env:
              - name: CONTROLLER_KONNECT_ADDRESS
                value: https://us.kic.api.konghq.com
              - name: CONTROLLER_KONNECT_LICENSING_ENABLED
                value: "true"
              - name: CONTROLLER_KONNECT_RUNTIME_GROUP_ID
                value: YOUR_CP_ID
              - name: CONTROLLER_KONNECT_SYNC_ENABLED
                value: "true"
              - name: CONTROLLER_KONNECT_TLS_CLIENT_CERT
                valueFrom:
                  secretKeyRef:
                    key: tls.crt
                    name: konnect-client-tls
              - name: CONTROLLER_KONNECT_TLS_CLIENT_KEY
                valueFrom:
                  secretKeyRef:
                    key: tls.key
                    name: konnect-client-tls
            volumeMounts:
              - name: cluster-certificate
                mountPath: /var/cluster-certificate
          volumes:
          - name: cluster-certificate
  dataPlaneOptions:
    deployment:
      podTemplateSpec:
        spec:
          containers:
          - name: proxy
            image: kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}
            readinessProbe:
              initialDelaySeconds: 1
              periodSeconds: 1
            env:
              - name: KONG_DATABASE
                value: "off"
              - name: KONG_CLUSTER_CONTROL_PLANE
                value: YOUR_CP_ENDPOINT.us.cp0.konghq.com:443
              - name: KONG_CLUSTER_SERVER_NAME
                value: YOUR_CP_ENDPOINT.us.cp0.konghq.com
              - name: KONG_CLUSTER_TELEMETRY_ENDPOINT
                value: YOUR_CP_ENDPOINT.us.tp0.konghq.com:443
              - name: KONG_CLUSTER_TELEMETRY_SERVER_NAME
                value: YOUR_CP_ENDPOINT.us.tp0.konghq.com
              - name: KONG_CLUSTER_MTLS
                value: pki
              - name: KONG_CLUSTER_CERT
                value: /etc/secrets/konnect-client-tls/tls.crt
              - name: KONG_CLUSTER_CERT_KEY
                value: /etc/secrets/konnect-client-tls/tls.key
              - name: KONG_LUA_SSL_TRUSTED_CERTIFICATE
                value: system
              - name: KONG_KONNECT_MODE
                value: "on"
              - name: KONG_VITALS
                value: "off"
            volumeMounts:
              - name: cluster-certificate
                mountPath: /var/cluster-certificate
              - name: konnect-client-tls
                mountPath: /etc/secrets/konnect-client-tls/
                readOnly: true
          volumes:
          - name: cluster-certificate
          - name: konnect-client-tls
            secret:
              secretName: konnect-client-tls
              defaultMode: 420' | kubectl apply -f -
```
{% endnavtab %}
{% endif_version %}
{% navtab On-Prem %}

Use the following example to customize the log level of {{ site.kic_product_name }}:

```yaml
echo 'kind: GatewayConfiguration
apiVersion: gateway-operator.konghq.com/{{ gatewayConfigApiVersion }}
metadata:
  name: kong
  namespace: default
spec:
  dataPlaneOptions:
    deployment:
      podTemplateSpec:
        spec:
          containers:
          - name: proxy
            image: kong:{{ site.data.kong_latest_gateway.ce-version }}
            readinessProbe:
              initialDelaySeconds: 1
              periodSeconds: 1
  controlPlaneOptions:
    deployment:
      podTemplateSpec:
        spec:
          containers:
          - name: controller
            image: kong/kubernetes-ingress-controller:{{ site.data.kong_latest_KIC.version }}
            env:
            - name: CONTROLLER_LOG_LEVEL
              value: debug' | kubectl apply -f -
```
{% endnavtab %}
{% endnavtabs %}

The results should look like this:

```text
gatewayconfiguration.gateway-operator.konghq.com/kong created
```

## GatewayClass

To use the Gateway API resources to configure your routes, you need to create a `GatewayClass` instance and create a `Gateway` resource that listens on the ports that you need.

```yaml
echo '
kind: GatewayClass
apiVersion: gateway.networking.k8s.io/v1beta1
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
kind: Gateway
apiVersion: gateway.networking.k8s.io/v1beta1
metadata:
  name: kong
  namespace: default
spec:
  gatewayClassName: kong
  listeners:
  - name: http
    protocol: HTTP
    port: 80' | kubectl apply -f -
```

The results should look like this:

```text
gatewayclass.gateway.networking.k8s.io/kong created
gateway.gateway.networking.k8s.io/kong created
```
