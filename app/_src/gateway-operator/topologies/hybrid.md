---
title: Hybrid Deployments
---

{{ site.kgo_product_name }} deploys and manages `DataPlane` resources that connect to a externally managed Control Plane using a Hybrid Mode deployment.

The external control plane may be a {{ site.konnect_product_name }} control plane, or a self-managed control plane.

## Installation

{% navtabs %}
{% navtab Konnect %}

{% if_version gte:1.4.x %}
```yaml
# Ensure that you create a secret containing your cluster certificate before applying this
# kubectl create secret tls konnect-client-tls -n kong --cert=./tls.crt --key=./tls.key
# See https://docs.konghq.com/gateway-operator/{{ page.release }}/get-started/konnect/install/ for complete instructions
echo '
kind: KonnectExtension
apiVersion: gateway-operator.konghq.com/v1alpha1
metadata:
  name: example-konnect-config
  namespace: kong
spec:
  controlPlaneRef:
    type: konnectID
    konnectID: <CP_ID>
  controlPlaneRegion: <REGION>
{%- if_version lt:1.5.0 %}
  serverHostname: <HOSTNAME>
{%- endif_version %}
  konnectControlPlaneAPIAuthConfiguration:
    clusterCertificateSecretRef:
      name: konnect-client-tls
---
apiVersion: gateway-operator.konghq.com/v1beta1
kind: DataPlane
metadata:
  name: dataplane-example
  namespace: kong
spec:
  extensions:
  - kind: KonnectExtension
    name: example-konnect-config
    group: gateway-operator.konghq.com
  deployment:
    podTemplateSpec:
      spec:
        containers:
        - name: proxy
          image: kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}
          env:
          - name: KONG_LOG_LEVEL
            value: debug
' | kubectl apply -f -
```
{% endif_version %}

{% if_version lte:1.3.x %}
```yaml
# Ensure that you create a secret containing your cluster certificate before applying this
# kubectl create secret tls konnect-client-tls -n kong --cert=./tls.crt --key=./tls.key

echo "
apiVersion: gateway-operator.konghq.com/v1beta1
kind: DataPlane
metadata:
  name: dataplane-example
  namespace: kong
spec:
  deployment:
    podTemplateSpec:
      spec:
        containers:
        - name: proxy
          image: kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}
          env:
            - name: KONG_ROLE
              value: data_plane
            - name: KONG_DATABASE
              value: "off"
            - name: KONG_CLUSTER_MTLS
              value: pki
            - name: KONG_CLUSTER_CONTROL_PLANE
              value: YOUR_CP_ID.us.cp0.konghq.com:443
            - name: KONG_CLUSTER_SERVER_NAME
              value: YOUR_CP_ID.us.cp0.konghq.com
            - name: KONG_CLUSTER_TELEMETRY_ENDPOINT
              value: YOUR_CP_ID.us.tp0.konghq.com:443
            - name: KONG_CLUSTER_TELEMETRY_SERVER_NAME
              value: YOUR_CP_ID.us.tp0.konghq.com
            - name: KONG_CLUSTER_CERT
              value: /etc/secrets/kong-cluster-cert/tls.crt
            - name: KONG_CLUSTER_CERT_KEY
              value: /etc/secrets/kong-cluster-cert/tls.key
            - name: KONG_LUA_SSL_TRUSTED_CERTIFICATE
              value: system
            - name: KONG_KONNECT_MODE
              value: "on"
            - name: KONG_VITALS
              value: "off"
          volumeMounts:
            - name: cluster-certificate
              mountPath: /var/cluster-certificate
            - name: kong-cluster-cert
              mountPath: /etc/secrets/kong-cluster-cert/
              readOnly: true
        volumes:
          - name: cluster-certificate
          - name: kong-cluster-cert
            secret:
              secretName: kong-cluster-cert
              defaultMode: 420
" | kubectl apply -f -
```
{% endif_version %}

{% endnavtab %}
{% navtab Self Managed %}
```yaml
# Ensure that you create a secret containing your cluster certificate before applying
# kubectl create secret tls kong-cluster-cert -n kong --cert=./tls.crt --key=./tls.key

# Note that the cluster_control_plane value will differ depending on your environment.
# control-plane-release-name will change to your CP release name, 
# hybrid will change to whatever namespace it resides in.

echo "
apiVersion: gateway-operator.konghq.com/v1beta1
kind: DataPlane
metadata:
  name: dataplane-example
  namespace: kong
spec:
  deployment:
    podTemplateSpec:
      spec:
        containers:
        - name: proxy
          image: kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}
          env:
          - name: KONG_ROLE
            value: data_plane
          - name: KONG_DATABASE
            value: "off"
          - name: KONG_CLUSTER_CERT
            value: /etc/secrets/kong-cluster-cert/tls.crt
          - name: KONG_CLUSTER_CERT_KEY
            value: /etc/secrets/kong-cluster-cert/tls.key
          - name: KONG_LUA_SSL_TRUSTED_CERTIFICATE
            value: system
          - name: KONG_CLUSTER_CONTROL_PLANE
            value: control-plane-release-name-kong-cluster.hybrid.svc.cluster.local:8005
          - name: KONG_CLUSTER_TELEMETRY_ENDPOINT
            value: control-plane-release-name-kong-clustertelemetry.hybrid.svc.cluster.local:8006
          volumeMounts:
            - name: cluster-certificate
              mountPath: /var/cluster-certificate
            - name: kong-cluster-cert
              mountPath: /etc/secrets/kong-cluster-cert/
              readOnly: true
        volumes:
          - name: cluster-certificate
          - name: kong-cluster-cert
            secret:
              secretName: kong-cluster-cert
              defaultMode: 420
```
{% endnavtab %}
{% endnavtabs %}

For more information about hybrid mode, see the {{ site.base_gateway }} [hybrid mode documentation](/gateway/latest/production/deployment-topologies/hybrid-mode/).