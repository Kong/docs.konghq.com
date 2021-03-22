---
title: Setting up a Kong Gateway Runtime
no_version: true
---
Set up a [runtime](/konnect/overview/#konnect-key-concepts-and-terminology)
through the
[{{site.konnect_short_name}} Runtime Manager](/konnect/runtime-manager) and
configure your {{site.base_gateway}} instance to accept configuration from
{{site.konnect_short_name}}. The Runtime Manager keeps track of all runtimes
associated with the {{site.konnect_short_name}} SaaS account.

<div class="alert alert-ee blue">
<b>Note:</b> Kong does not host runtimes. You must install and host your own
runtime instances.
</div>

## Prerequisites

* You have a {{site.konnect_product_name}} account. Contact your sales
representative for access.
* (Quick Setup only) Tools and permissions:
  * **All platforms:** [Docker](https://docs.docker.com/get-docker/) and [jq](https://stedolan.github.io/jq/) installed
  * **Linux:** User added to the [`docker` group](https://docs.docker.com/engine/install/linux-postinstall/)
  * **Windows:** Docker Desktop [installed](https://docs.docker.com/docker-for-windows/install/#install-docker-desktop-on-windows) and [integrated with a WSL 2 backend](https://docs.docker.com/docker-for-windows/wsl/)
* Advanced setup on Kubernetes: Helm installed

## Set up a New Runtime Instance

{% navtabs %}
{% navtab Quick Setup %}

1. From the left navigation menu, open **Runtimes**.

    For the first runtime, the page opens to a **Configure New Runtime** form.

    Once configured, this page lists all runtimes associated with the
    {{site.konnect_short_name}} SaaS account.

2. (Optional) If this is not the first runtime configuration, click
**Configure New Runtime**.

3. Click **Copy Script**.

    You can expand the codeblock by clicking **Show** to see the entire script.

4. Replace the placeholder for `<your-password>` with your own
{{site.konnect_short_name}} SaaS password.

5. Run the script on any host you choose.

    This script creates a Docker container running a simple
    {{site.base_gateway}} instance and connects it to your
    {{site.konnect_short_name}} SaaS account.

6. Click **Done** to go to the Runtime Manager overview.

    Once the script has finished running, the Runtimes Manager will
    include a new entry for your instance.
    <!-- and the tag in the **Node Status** column should say
    **Connected**.-->

{% endnavtab %}
{% navtab Advanced %}

1. From the left navigation menu, select **Runtimes**.

    For the first runtime, the page opens to a **Configure New Runtime** form.

    Once configured, this page lists all runtimes associated with the
    {{site.konnect_short_name}} SaaS account.

2. (Optional) If this is not the first runtime configuration, click
**Configure New Runtime**.

3. Click **Generate Certificate**.

    Three new fields appear: a certificate, a private key, and a root CA
    certificate. The contents of these fields are unique to each
    runtime configuration.

4. Save the contents of each field into a separate file in a safe location:

    * Certificate: `cluster.crt`
    * Private key: `cluster.key`
    * Root CA Certificate: `ca.crt`

    <div class="alert alert-warning">
    <b>Important:</b> Do not navigate away from this page while saving the
    certificate and key files. They are unique and won't display again.</div>

5. Store the files on your runtime's local filesystem.

Next, configure a {{site.base_gateway}} runtime using the
certificate, the private key, and the remaining configuration details on the
**Configure Runtime** page.

{% navtabs %}
{% navtab Docker %}

1. (Optional, if no gateway data plane exists) Using the
[Docker installation documentation](/enterprise/latest/deployment/installation/docker),
follow the instructions to:
    1. [Download {{site.base_gateway}} 2.3.2.0 or later](/enterprise/latest/deployment/installation/docker#pull-image).
    2. [Create a Docker network](/enterprise/latest/deployment/installation/docker/#create-network).

    <div class="alert alert-warning">
        Do not start or create a database on this node.
    </div>

2. In the **Configuration Parameters** section, copy the codeblock.

3. Replace the values in `KONG_CLUSTER_CERT`, `KONG_CLUSTER_CERT_KEY`,
and `KONG_CLUSTER_CA_CERT` with the paths to your certificate files.

4. Apply the parameters to your gateway instance as environment variables and
reload {{site.base_gateway}}.

    See [Parameters](#parameters) for descriptions and the matching fields in
    {{site.konnect_short_name}}.

    ```sh
    $ echo "KONG_ROLE=data_plane \
      KONG_DATABASE=off \
      KONG_ANONYMOUS_REPORTS=off \
      KONG_CLUSTER_MTLS=pki \
      KONG_CLUSTER_CONTROL_PLANE=<example.cp.konnect.foo>:443 \
      KONG_CLUSTER_SERVER_NAME=<kong-cpoutlet-example.service> \
      KONG_CLUSTER_TELEMETRY_ENDPOINT=<example.tp.konnect.foo>:443 \
      KONG_CLUSTER_TELEMETRY_SERVER_NAME=<kong-telemetry-example.service> \
      KONG_CLUSTER_CERT=/<path-to-file>/cluster.crt \
      KONG_CLUSTER_CERT_KEY=/<path-to-file>/cluster.key \
      KONG_LUA_SSL_TRUSTED_CERTIFICATE=system,/<path-to-file>/ca.crt \
      kong reload exit" | docker exec -i <kong-container-id> /bin/sh
    ```

    Or, if bringing up a new container:

    ```sh
    $ docker run -d --name kong-gateway-dp1 --network=kong-gateway-net \
      -e "KONG_ROLE=data_plane" \
      -e "KONG_DATABASE=off" \
      -e "KONG_ANONYMOUS_REPORTS=off" \
      -e "KONG_CLUSTER_MTLS=pki" \
      -e "KONG_CLUSTER_CONTROL_PLANE=<example.cp.konnect.foo>:443" \
      -e "KONG_CLUSTER_SERVER_NAME=<kong-cpoutlet-example.service>" \
      -e "KONG_CLUSTER_TELEMETRY_ENDPOINT=<example.tp.konnect.foo>:443" \
      -e "KONG_CLUSTER_TELEMETRY_SERVER_NAME=<kong-telemetry-example.service>" \
      -e "KONG_CLUSTER_CERT=/<path-to-file>/cluster.crt" \
      -e "KONG_CLUSTER_CERT_KEY=/<path-to-file>/cluster.key" \
      -e "KONG_LUA_SSL_TRUSTED_CERTIFICATE=system,/<path-to-file>/ca.crt" \
      --mount type=bind,source="$(pwd)"/cluster,target=<path-to-keys-and-certs>,readonly \
      -p 8000:8000 \
      -p 8001:8001 \
      kong-gateway-dp1
    ```

5. On the **Configure New Runtime** page, click **Done** to go to the Runtime
Manager overview.

    The Runtime Manager will include a new entry for your instance.

{% endnavtab %}
{% navtab kong.conf (universal) %}

1. (Optional, if no gateway data plane exists) Find the documentation for
[your platform](/enterprise/latest/deployment/installation),
and follow the instructions in Steps 1 and 2 **only** to download and install
{{site.base_gateway}} 2.3.2.0.

    <div class="alert alert-warning">
        Do not start or create a database on this node.
    </div>

2. In the **Configuration Parameters** section, copy the codeblock.

3. Replace the values in `KONG_CLUSTER_CERT`, `KONG_CLUSTER_CERT_KEY`,
and `KONG_CLUSTER_CA_CERT` with the paths to your certificate files.

4. Open your instance's `kong.conf` file. Remove the `KONG_` prefix from the
parameters in the sample codeblock and add the parameters to the file:

    ```sh
    role = data_plane
    database = off
    anonymous_reports = off
    cluster_mtls = pki
    cluster_control_plane = <example.cp.konnect.foo>:443
    cluster_server_name = <kong-cpoutlet-example.service>
    cluster_telemetry_endpoint = <example.tp.konnect.foo>:443
    cluster_telemetry_server_name = <kong-telemetry-example.service>
    cluster_cert = /<path-to-file>/cluster.crt
    cluster_cert_key = /<path-to-file>/cluster.crt
    lua_ssl_trusted_certificate = system,/<path-to-file>/ca.crt
    ```

    See [Parameters](#parameters) for descriptions and the matching fields
    in {{site.konnect_short_name}}.

5. Restart {{site.base_gateway}} for the settings to take effect:

    ```sh
    $ kong restart
    ```

6. On the **Configure New Runtime** page, click **Done** to go to the Runtime
Manager overview.

    The Runtime Manager will include a new entry for your instance.

{% endnavtab %}
{% navtab Helm %}

1. If you already have a {{site.base_gateway}} instance configured with Helm,
move onto the next step.

    If this is a new instance, set up the following:

    1. Create a namespace:
        ```sh
        $ kubectl create namespace kong
        ```

    2. Add the Kong charts repository:
        ```bash
        $ helm repo add kong https://charts.konghq.com
        ```

    3. Update Helm:
        ```bash
        $ helm repo update
        ```

2. Create a `tls` secret using the `cluster.cert` and `cluster.key` files
you saved earlier:

    ```bash
    $ kubectl create secret tls kong-cluster-cert \
      --cert=/tmp/cluster.crt \
      --key=/tmp/cluster.key
    ```

3. Create a generic secret for the CA cert:

    ```bash
    $ kubectl create secret generic kong-cluster-ca \
      --from-file=ca.crt=/tmp/ca.crt
    ```

4. In the **Configuration Parameters** section, copy the codeblock.

5. Open your instance's `values.yml` file, or use the
[data plane template](https://github.com/Kong/charts/blob/main/charts/kong/example-values/minimal-kong-hybrid-data.yaml).
Remove the `KONG_` prefix from the parameters in the sample codeblock and add
the following parameters to the file.

    Make sure to replace the values in `cluster_cert`, `cluster_cert_key`,
    and `cluster_ca_cert` with references to the secret you created earlier:

    ```yaml
    secretVolumes:
    - kong-cluster-cert
    - kong-cluster-ca
    admin:
      enabled: false
    env:
      role: data_plane
      database: "off"
      anonymous_reports: off
      cluster_mtls: pki
      cluster_control_plane: <example.cp.konnect.foo>:443
      cluster_server_name: <kong-cpoutlet-example.service>
      cluster_telemetry_endpoint: <example.tp.konnect.foo>:443
      cluster_telemetry_server_name: <kong-telemetry-example.service>
      cluster_ca_cert: /etc/secrets/kong-cluster-ca/ca.crt
      cluster_cert: /etc/secrets/kong-cluster-cert/tls.crt
      cluster_cert_key: /etc/secrets/kong-cluster-cert/tls.key
      lua_ssl_trusted_certificate: system,/etc/secrets/kong-cluster-ca/ca.crt
    ```

    See [Parameters](#parameters) for descriptions and the matching fields
    in {{site.konnect_short_name}}.

6. Apply the `values.yml`.

    Existing instance:
    ```bash
    $ helm upgrade my-kong kong/kong -n kong \
      --values ./values.yaml
    ```

    New instance:
    ```bash
    $ helm install my-kong kong/kong -n kong \
      --values ./values.yaml
    ```

7. On the **Configure New Runtime** page, click **Done** to go to the Runtime
Manager overview.

    The Runtime Manager will include a new entry for your instance.

{% endnavtab %}
{% endnavtabs %}

{% endnavtab %}
{% endnavtabs %}

## Advanced Parameters for Kong Gateway {#parameters}

Refer to these parameters when using the **Advanced** runtime setup option.

 Parameter                            | Field in {{site.konnect_short_name}} | Description and Value
:-------------------------------------|:------------------------------|:----------------------
 [`role`](/enterprise/latest/property-reference/#role) | n/a  | The role of the node, in this case `data_plane`.
 [`database`](/enterprise/latest/property-reference/#database) | n/a | Specifies whether this node connects directly to a database. For a data plane, this setting is always `off`.
 [`cluster_mtls`](/enterprise/latest/property-reference/#cluster_mtls) | n/a | Enables mTLS on connections between the control plane and the data plane. In this case, set to  `"pki"`.
 [`cluster_control_plane`](/enterprise/latest/property-reference/#cluster_control_plane) | n/a | Sets the address of the {{site.konnect_short_name}} control plane. Must be in the format `host:port`, with port set to `443`. <br><br> **Example:**<br>Control Plane Endpoint in Konnect:<br>`https://example.cp.khcp.konghq.com`<br>Configuration value:<br>`example.cp.khcp.konghq.com:443`
 [`cluster_server_name`](/enterprise/latest/property-reference/#cluster_server_name) | n/a | The SNI (Server Name Indication extension) to use for data plane connections to the control plane through TLS. When not set, data plane will use `kong_clustering` as the SNI.
 [`cluster_telemetry_endpoint`](/enterprise/latest/property-reference/#cluster_telemetry_endpoint) | n/a | The address that the data plane uses to send Vitals telemetry data to the control plane. Must be in the format `host:port`, with port set to `443`. <br><br> **Example:**<br>Telemetry Endpoint in Konnect:<br>`https://example.tp.khcp.konghq.com`<br>Configuration value:<br>`example.tp.khcp.konghq.com:443`
 [`cluster_telemetry_server_name`](/enterprise/latest/property-reference/#cluster_telemetry_server_name) | n/a | The SNI (Server Name Indication extension) to use for Vitals telemetry data.
 [`cluster_ca_cert`](/enterprise/latest/property-reference/#cluster_ca_cert) | **Certificate** | The trusted CA certificate file, in PEM format, used to verify the `cluster_cert`. 
 [`cluster_cert`](/enterprise/latest/property-reference/#cluster_cert) | **Certificate** | The certificate used for mTLS between CP/DP nodes.
 [`cluster_cert_key`](/enterprise/latest/property-reference/#cluster_cert_key) | **Private Key** | The private key used for mTLS between CP/DP nodes.
 [`lua_ssl_trusted_certificate`](/enterprise/latest/property-reference/#lua_ssl_trusted_certificate) | **Root CA Certificate** | Lists files as trusted by OpenResty. Accepts a comma-separated list of paths. If you have already specified a different `lua_ssl_trusted_certificate`, adding the content of `cluster.crt` into that file achieves the same result.

## Access Services using the Proxy URL

{{site.base_gateway}} uses port `8000` for the proxy, taking incoming
traffic from Consumers, and forwarding it to upstream Services.

The default proxy URL for a runtime generated by the Quick Start script is
`http://localhost:8000`. If you configured a different host, replace `localhost`
with your hostname. Use this URL, along with any Routes you set, to access your
Services.

For example, to access a Service with the Route `/mock`, use
`http://localhost:8000/mock`.

<!-- To change the default URL, see [link TBA].-->
