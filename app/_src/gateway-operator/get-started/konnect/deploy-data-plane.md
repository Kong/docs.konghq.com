---
title: Deploy a Data Plane
content-type: tutorial
book: kgo-konnect-get-started
chapter: 2
---

In order for {{ site.kgo_product_name }} data planes to attach to {{ site.konnect_short_name }} they need to know which endpoint to connect to, and how to authenticate their requests.

To get this information, [log in to {{ site.konnect_short_name }}](https://cloud.konghq.com/login) and visit _Gateway Manager_. Select a Control Plane and then create a _New Runtime Instance_.

Follow the instructions on the screen, but stop once you have created a secret in step 3:

```bash
kubectl create secret tls kong-cluster-cert -n kong --cert=/{PATH_TO_FILE}/tls.crt --key=/{PATH_TO_FILE}/tls.key
```

The instructions in {{ site.konnect_short_name }} use Helm to deploy a dataplane instance, but we want to use {{ site.kgo_product_name }}.

We installed {{ site.kgo_product_name }} in the previous step, which means we can create a `DataPlane` resource directly on the server and the operator will deploy an instance for us.

The final step is to find your control plane ID in step 4 of the {{ site.konnect_short_name }} UI. Your control plane ID is the first segment of `cluster_server_name`.

For example, a `cluster_server_name` of `36fc5d01be.us.cp0.konghq.com` means that my control plane ID is `36fc5d01be`.

Replace `YOUR_CP_ID` in the manifest below with your control plane ID and apply with `kubectl apply`:

```yaml
echo '
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
' | kubectl apply -f -
```