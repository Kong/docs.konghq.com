---
title: Set up a Kong Gateway Runtime on Kubernetes
no_version: true
---
Set up a Kubernetes [runtime](/konnect/overview/#konnect-key-concepts-and-terminology)
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
* [Helm](https://helm.sh/docs/intro/install/) is installed.

## Generate certificates

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

## Set up Helm

On your runtime's system, create a namespace and pull down the `kong` Helm repo.

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

## Configure the runtime

Next, configure a {{site.base_gateway}} runtime using the
certificate, the private key, and the remaining configuration details on the
**Configure Runtime** page.

### Configure secrets

Store the certificates and key you generated through the Runtime Manager in
Kubernetes secrets.

1. Create a `tls` secret using the `cluster.cert` and `cluster.key` files
you saved earlier:

    ```bash
    $ kubectl create secret tls kong-cluster-cert -n kong \
      --cert=/tmp/cluster.crt \
      --key=/tmp/cluster.key
    ```

2. Create a generic secret for the CA cert:

    ```bash
    $ kubectl create secret generic kong-cluster-ca -n kong \
      --from-file=ca.crt=/tmp/ca.crt
    ```

### Write configuration

4. In the **Configuration Parameters** section, copy the codeblock.

5. Using the
[data plane template](https://github.com/Kong/charts/blob/main/charts/kong/example-values/minimal-kong-hybrid-data.yaml),
create a `values.yaml` file.
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

6. Apply the `values.yaml`.

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

<div class="alert alert-ee warning">
<b>Important:</b> Certificates expire after 30 days and must be renewed. See
<a href="/konnect/runtime-manager/renew-certificates">Renew Certificates</a>.
</div>

## Access services using the proxy URL

{{site.base_gateway}} uses port `8000` for the proxy, taking incoming
traffic from Consumers, and forwarding it to upstream Services.

The default proxy URL for a runtime generated by the Quick Start script is
`http://localhost:8000`. If you configured a different host, replace `localhost`
with your hostname. Use this URL, along with any Routes you set, to access your
Services.

For example, to access a Service with the Route `/mock`, use
`http://localhost:8000/mock`.

<!-- To change the default URL, see [link TBA].-->
