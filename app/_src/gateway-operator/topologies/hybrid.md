---
title: Hybrid Deployments
---

{{ site.kgo_product_name }} deploys and manages `DataPlane` resources that connect to a externally managed Control Plane using a Hybrid Mode deployment.

The external control plane may be a {{ site.konnect_product_name }} control plane, or a self-managed control plane.

## Example

{% navtabs %}
{% navtab Konnect %}
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
    pods:
      containerImage: kong/kong-gateway
      version: "3.4"
      volumes:
        - name: konnect-client-tls
          secret:
            secretName: konnect-client-tls
      volumeMounts:
        - name: konnect-client-tls
          mountPath: /etc/secrets/kong-cluster-cert/
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
" | kubectl apply -f -
```
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
    pods:
      containerImage: kong/kong-gateway
      version: "3.4"
      volumes:
        - name: kong-cluster-cert
          secret:
            secretName: kong-cluster-cert
      volumeMounts:
        - name: kong-cluster-cert
          mountPath: /etc/secrets/kong-cluster-cert/
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
" | kubectl apply -f -
```
{% endnavtab %}
{% endnavtabs %}