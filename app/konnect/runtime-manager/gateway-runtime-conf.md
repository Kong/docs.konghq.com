---
title: Set up a Kong Gateway Runtime using kong.conf
no_version: true
---
Using `kong.conf`, set up a [runtime](/konnect/overview/#konnect-key-concepts-and-terminology)
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

You have a {{site.konnect_product_name}} account. Contact your sales
representative for access.

## Generate certificates

{% include /md/konnect/runtime-certs.md %}

## Configure the runtime

1. Find the documentation for
[your platform](/enterprise/latest/deployment/installation),
and follow the instructions in Steps 1 and 2 **only** to download and install
{{site.base_gateway}} 2.3.2.0.

    <div class="alert alert-warning">
        Do not start or create a database on this node.
    </div>

2. Back in {{site.konnect_short_name}}, copy the
codeblock from the **Configuration Parameters** section.

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

    See [Parameters](/konnect/runtime-manager/runtime-parameter-reference) for
    descriptions and the matching fields in {{site.konnect_short_name}}.

5. Restart {{site.base_gateway}} for the settings to take effect:

    ```sh
    $ kong restart
    ```

6. On the **Configure New Runtime** page, click **Done** to go to the Runtime
Manager overview.

    The Runtime Manager will include a new entry for your instance.

<div class="alert alert-ee warning">
<b>Important:</b> Certificates expire after 30 days and must be renewed. See
<a href="/konnect/runtime-manager/renew-certificates">Renew Certificates</a>.
</div>

## Access services using the proxy URL

{{site.base_gateway}} uses port `8000` for the proxy, taking incoming
traffic from consumers, and forwarding it to upstream services.

The default proxy UR is `http://localhost:8000`. If you configured a different
host, replace `localhost` with your hostname. Use this URL, along with any
routes you set, to access your services.

For example, to access a service with the route `/mock`, use
`http://localhost:8000/mock`, or `http://example-host:8000/mock`.
