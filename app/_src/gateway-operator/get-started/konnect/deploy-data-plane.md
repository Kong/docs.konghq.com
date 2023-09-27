---
title: Deploy a Data Plane
content-type: tutorial
book: kgo-konnect-get-started
chapter: 2
---

To attach a {{ site.kgo_product_name }} data plane to {{ site.konnect_short_name }} the data plane needs to know which endpoint to connect to, and how to authenticate the requests.

To get the endpoint and the authentication details of the data plane.
1.  [Log in to {{ site.konnect_short_name }}](https://cloud.konghq.com/login).
1.  Navigate to {% konnect_icon runtimes %} [**Gateway Manager**](https://cloud.konghq.com/us/gateway-manager), choose the control plane, and click **Create a New Data Plane Node**.
1.  In the **Create a Data Plane Node** page select *Kubernetes* as the **Platform**.
1.  Create a namespace named `kong` in the Kubernetes cluster
    ```bash
    kubectl create namespace kong
    ```
1.  Click **Generate Certificate**  in step 3.
1. Save the contents of **Cluster Certificate** in a file named `tls.crt`. Save the contents of **Cluster Key** in a file named `tls.key`.
1.  Create a Kubernetes secret containing the cluster certificate:

    ```bash
    kubectl create secret tls kong-cluster-cert -n kong --cert=/{PATH_TO_FILE}/tls.crt --key=/{PATH_TO_FILE}/tls.key
    ```
1. In the **Configuration parameters** step 4, find the value of  `cluster_server_name`. The first segment of that value is the control plane ID for your cluster. For example, if the value of `cluster_server_name` is `36fc5d01be.us.cp0.konghq.com`, then the control plane ID of the cluster is `36fc5d01be`.
1.  Replace `YOUR_CP_ID` with your control plane ID in the following manifest and deploy the data plane with `kubectl apply`:

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
    The results should look like this:

    ```text
    dataplane.gateway-operator.konghq.com/dataplane-example configured
    ```
