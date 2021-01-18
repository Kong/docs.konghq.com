---
title: Configure a Runtime
no_search: true
no_version: true
beta: true
---

## Prerequisites
A valid license is required to set up a {{site.ee_product_name}} runtime. You
can use any existing {{site.ee_product_name}} license for this purpose.

## Generate Certificates

1. From the left navigation menu, open **Runtimes**.

    This page lists all runtimes that are currently associated with the
    {{site.konnect_short_name}} control plane.

2. Click **Configure Runtime**.

    The control plane and telemetry details on this page are specific to your
    organization. You will need them for configuring your runtime to communicate
    with {{site.konnect_short_name}}.

3. Click **Generate Certificate**.

    Three new fields appear: a certificate, a private key, and a root CA
    certificate. The contents of these fields are unique to each data
    plane/runtime configuration.

4. Save the contents of each field into a separate file in a safe location:

    * Certificate: `cluster.crt`
    * Private key: `cluster.key`
    * Root CA Certificate: `ca.crt`

    <div class="alert alert-warning">
    <b>Important:</b> Do not navigate away from this page while saving the
    certificate and key files. They are unique and will not display again.</div>

5. Store the files on your data plane's file system.

## Configure a Kong Gateway Data Plane

Configure a Kong Gateway runtime on your data plane using the certificate, the
private key, and the remaining configuration details on the **Configure
Runtime** page.

In this step, you will assign the `data_plane` role to the data plane node,
point it to the control plane, set certificate/key parameters to point at
the location of your certificates and keys, and ensure the database
is disabled.

{% navtabs %}
{% navtab Using Docker %}
1. Using the [Docker installation documentation](/enterprise/latest/deployment/installation/docker),
follow the instructions to:
    1. [Download {{site.ee_product_name}} 2.1 or later](/enterprise/latest/deployment/installation/docker#pull-image).
    2. [Create a Docker network](/enterprise/latest/deployment/installation/docker/#create-network).
    3. [Export the license key to a variable](/enterprise/latest/deployment/installation/docker/#license-key).

    <div class="alert alert-warning">
        Do not start or create a database on this node.
    </div>

2. Using the certificate and private key files, and the connection information
from the **Configure Runtime** page, bring up a data plane container with the
following settings.

    See [Parameters](#parameters) for descriptions and the matching fields in
    {{site.konnect_short_name}}.

    The values in the `KONG_CLUSTER_CONTROL_PLANE` and
    `KONG_CLUSTER_TELEMETRY_ENDPOINT` fields must be transformed from the values in
     Konnect as shown below.

    ```bash
    $ docker run -d --name kong-ee-dp1 --network=kong-ee-net \
    -e "KONG_ROLE=data_plane" \
    -e "KONG_DATABASE=off" \
    -e "KONG_CLUSTER_MTLS=pki" \
    -e "KONG_CLUSTER_CONTROL_PLANE=<example.cp.khcp.konghq.com>:443" \
    -e "KONG_CLUSTER_SERVER_NAME=<kong-cpoutlet-example.service>" \
    -e "KONG_CLUSTER_TELEMETRY_ENDPOINT=<example.tp.khcp.konghq.com>:443" \
    -e "KONG_CLUSTER_TELEMETRY_SERVER_NAME=<kong-telemetry-example.service>" \
    -e "KONG_CLUSTER_CERT=/<path-to-file>/cluster.crt" \
    -e "KONG_CLUSTER_CERT_KEY=/<path-to-file>/cluster.key" \
    -e "KONG_CLUSTER_CA_CERT=/<path-to-file>/ca.crt" \
    -e "KONG_LUA_SSL_TRUSTED_CERTIFICATE=/<path-to-file>/ca.crt" \
    --mount type=bind,source="$(pwd)"/cluster,target=<path-to-keys-and-certs>,readonly \
    -p 8000:8000 \
    kong-ee-dp1
    ```

{% endnavtab %}
{% navtab Using kong.conf %}

1. Find the documentation for [your platform](/enterprise/latest/deployment/installation),
and follow the instructions in Steps 1 and 2 **only** to download
{{site.ee_product_name}} 2.1 or later and the Enterprise license, then install
Kong.

    <div class="alert alert-warning">
        Do not start or create a database on this node.
    </div>

2. In `kong.conf`, set the following configuration parameters using the
certificate and private key files, and the connection information
from the **Configure Runtime** page.

    See [Parameters](#parameters) for descriptions and the matching fields
    in {{site.konnect_short_name}}.

    The values in the `cluster_control_plane` and
    `cluster_telemetry_endpoint` fields must be transformed from the values in
     Konnect as shown below.

    ```bash
    role = data_plane
    database = off
    cluster_mtls = pki
    cluster_control_plane = <example.cp.khcp.konghq.com>:443
    cluster_server_name = <kong-cpoutlet-example.service>
    cluster_telemetry_endpoint = <example.tp.khcp.konghq.com>:443
    cluster_telemetry_server_name = <kong-telemetry-example.service>
    cluster_cert = /<path-to-file>/cluster.crt
    cluster_cert_key = /<path-to-file>/cluster.crt
    cluster_ca_cert = /<path-to-file>/ca.crt
    lua_ssl_trusted_certificate = /<path-to-file>/ca.crt
    ```

3. Restart {{site.ee_product_name}} for the settings to take effect:

    ```bash
    $ kong restart
    ```
{% endnavtab %}
{% endnavtabs %}

### Parameters

 Parameter                            | Field in {{site.konnect_short_name}} {:width=20%:}| Description and Value
:-------------------------------------|:------------------------------|:----------------------
 [`role`](/enterprise/latest/property-reference/#role) | n/a  | The role of the node, in this case `data_plane`.
 [`database`](/enterprise/latest/property-reference/#database) | n/a | Specifies whether this node connects directly to a database. For a data plane, this setting is always `off`.
 [`cluster_mtls`](/enterprise/latest/property-reference/#cluster_mtls) | n/a | Enables mTLS on connections between the control plane and the data plane. In this case, set to  `"pki"`.
 [`cluster_control_plane`](/enterprise/latest/property-reference/#cluster_control_plane) | **Control Plane Endpoint** | Sets the address of the {{site.konnect_short_name}} control plane. Must be in the format `host:port`, with port set to `443`. <br><br> **Example:**<br>Control Plane Endpoint in Konnect:<br>`https://example.cp.khcp.konghq.com`<br>Configuration value:<br>`example.cp.khcp.konghq.com:443`
 [`cluster_server_name`](/enterprise/latest/property-reference/#cluster_server_name) | **Control Plane Server Name** | The SNI (Server Name Indication extension) to use for data plane connections to the control plane through TLS. When not set, data plane will use `kong_clustering` as the SNI.
 [`cluster_telemetry_endpoint`](/enterprise/latest/property-reference/#cluster_telemetry_endpoint) | **Telemetry Endpoint** | The address that the data plane uses to send Vitals telemetry data to the control plane. Must be in the format `host:port`, with port set to `443`. <br><br> **Example:**<br>Telemetry Endpoint in Konnect:<br>`https://example.tp.khcp.konghq.com`<br>Configuration value:<br>`example.tp.khcp.konghq.com:443`
 [`cluster_telemetry_server_name`](/enterprise/latest/property-reference/#cluster_telemetry_server_name) | **Telemetry Server Name** | The SNI (Server Name Indication extension) to use for Vitals telemetry data.
 [`cluster_cert`](/enterprise/latest/property-reference/#cluster_cert) | **Certificate** | The certificate used for mTLS between CP/DP nodes.
 [`cluster_cert_key`](/enterprise/latest/property-reference/#cluster_cert_key) | **Private Key** | The private key used for mTLS between CP/DP nodes.
 [`cluster_ca_cert`](/enterprise/latest/property-reference/#cluster_ca_cert) | **Root CA Certificate** | CA certificate used to verify `cluster_cert`.
 [`lua_ssl_trusted_certificate`](/enterprise/latest/property-reference/#lua_ssl_trusted_certificate) | **Root CA Certificate** | Lists files as trusted by OpenResty. Accepts a comma-separated list of paths. If you have already specified a different `lua_ssl_trusted_certificate`, adding the content of `cluster.crt` into that file achieves the same result.
