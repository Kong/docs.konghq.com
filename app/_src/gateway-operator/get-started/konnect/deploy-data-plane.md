---
title: Deploy a Data Plane
content-type: tutorial
book: kgo-konnect-get-started
chapter: 2
---

To attach a {{ site.kgo_product_name }} data plane to {{ site.konnect_short_name }} the data plane needs to know which endpoint to connect to, and how to authenticate the requests.

To get the endpoint and the authentication details of the data plane:

1. [Log in to {{ site.konnect_short_name }}](https://cloud.konghq.com/login).
1. Navigate to {% konnect_icon runtimes %} [**Gateway Manager**](https://cloud.konghq.com/gateway-manager), choose the control plane, and click **New DataPlane Node**.
1. In the **Create a Data Plane Node** page select *Kubernetes* as the **Platform**.
1. Click **Generate Certificate**  in step 3.
1. Save the contents of **Cluster Certificate** in a file named `tls.crt`. Save the contents of **Cluster Key** in a file named `tls.key`.
1. Create a namespace named `kong` in the Kubernetes cluster:

   ```bash
   kubectl create namespace kong
   ```
1. Create a Kubernetes secret containing the cluster certificate:

    ```bash
    kubectl create secret tls konnect-client-tls --cert=./tls.crt --key=./tls.key
    ```

{% if_version lte:1.3.x %}

1. In the **Configuration parameters** step 4, find the value of `cluster_server_name`. The first segment of that value is the control plane ID for your cluster. For example, if the value of `cluster_server_name` is `36fc5d01be.us.cp0.konghq.com`, then the control plane ID of the cluster is `36fc5d01be`.

1. Replace `YOUR_CP_ID` with your control plane ID in the following manifest and deploy the data plane with `kubectl apply`:

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
                - name: konnect-client-tls
                  mountPath: /etc/secrets/konnect-client-tls/
                  readOnly: true
            volumes:
              - name: cluster-certificate
              - name: konnect-client-tls
                secret:
                  secretName: konnect-client-tls
                  defaultMode: 420
    ' | kubectl apply -f -
    ```

    The result should look like this:

    ```text
    dataplane.gateway-operator.konghq.com/dataplane-example configured
    ```

{% endif_version %}

{% if_version gte:1.4.x %}

1. Extract the following values from the **Configuration parameters** step 4:
   1. `CP_ID`: Find the value of `cluster_server_name`. The first segment of that value is the control plane ID for your cluster. For example, if the value of `cluster_server_name` is `36fc5d01be.us.cp0.konghq.com`, then the control plane ID of the cluster is `36fc5d01be`
   1. `REGION`:  Find the value in the bottom left corner of the screen.
{%- if_version lt:1.5.0 %}
   1. `HOSTNAME`:  The server you are connected please set `konghq.com`.
{%- endif_version %}

2. Now, create a [`KonnectExtension` resource](/gateway-operator/{{ page.release }}/reference/custom-resources#konnectextension). In the following manifest, replace the placeholders for aforementioned with the values you just noted, and deploy it with `kubectl apply`:

   ```yaml
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
    ' | kubectl apply -f -
    ```

    The result should look like this:

    ```text
    konnectextension.gateway-operator.konghq.com/example-konnect-config created
    ```

3. Deploy your data plane that references such a `KonnectExtension` with `kubectl apply`:

    ```yaml
    echo '
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

    The result should look like this:

    ```text
    dataplane.gateway-operator.konghq.com/dataplane-example created
    ```

{% endif_version %}
