---
title: Set up a Kong Gateway Runtime on Linux
no_version: true
---
Using `kong.conf`, set up a runtime instance through the
[{{site.konnect_short_name}} Runtime Manager](/konnect/runtime-manager) and
configure your {{site.base_gateway}} instance to accept configuration from
{{site.konnect_short_name}}. The Runtime Manager keeps track of all runtime
instances associated with the {{site.konnect_saas}} account.

{:.note}
> **Note:** Kong does not host runtimes. You must install and host your own
runtime instances.

## Prerequisites

* You have **Runtime Admin** or **Organization Admin** permissions in
{{site.konnect_saas}}.

## Generate certificates

{% include /md/konnect/runtime-certs.md %}

## Configure the runtime

Next, configure a {{site.base_gateway}} runtime instance using the
certificate, the private key, and the remaining configuration details on the
runtime instance configuration page.

1. Find the documentation for
[your platform](/gateway/latest/install-and-run),
and follow the instructions in Steps 1 and 2 **only** to download and install
{{site.base_gateway}} {{site.data.kong_latest_ee.version}}.

    {:.important}
    > You should not deploy a {{site.base_gateway}} database on this node 
    as {{site.konnect_short_name}} provides a hosted control plane with its own
    database.

2. Return to {{site.konnect_short_name}} and copy the
codeblock in the **Step 2. Configuration Parameters** section.

    ![Konnect Runtime Parameters](/assets/images/docs/konnect/konnect-runtime-manager.png)

3. Open your instance's `kong.conf` file. Add the parameters you just copied
to the file.

    The result should look something like this, replacing placeholder values
    with your own from {{site.konnect_short_name}}:

    ```sh
    role = data_plane
    database = off
    vitals_ttl_days = 732
    cluster_mtls = pki
    cluster_control_plane = {EXAMPLE.CP.KONNECT.FOO}:443
    cluster_server_name = {KONG-CPOUTLET-EXAMPLE.SERVICE}
    cluster_telemetry_endpoint = {EXAMPLE.TP.KONNECT.FOO}:443
    cluster_telemetry_server_name = {KONG-TELEMETRY-EXAMPLE.SERVICE}
    cluster_cert = /{PATH_TO_FILE}/tls.crt
    cluster_ca_cert = /{PATH_TO_FILE}/ca.crt
    cluster_cert_key = /{PATH_TO_FILE}/tls.key
    ```

    See [Parameters](/konnect/configure/runtime-manager/runtime-instances/runtime-parameter-reference) for
    descriptions and the matching fields in {{site.konnect_short_name}}.

4. Replace the values in `cluster_cert`, `cluster_ca_cert`, and
`cluster_cert_key` with the paths to your certificate and key files.

5. Restart {{site.base_gateway}} for the settings to take effect:

    ```sh
    $ kong restart
    ```

6. In Konnect, click **Done** to go to the Runtime Instances overview, where
you will see a new entry for your instance.

## Access services using the proxy URL

{{site.base_gateway}} uses port `8000` for the proxy, taking incoming
traffic from consumers, and forwarding it to upstream services.

The default proxy URL is `http://localhost:8000`. If you configured a different
host, replace `localhost` with your hostname. Use this URL, along with any
routes you set, to access your services.

For example, to access a service with the route `/mock`, use
`http://localhost:8000/mock`, or `http://example-host:8000/mock`.
