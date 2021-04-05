---
title: Set up a Kong Gateway Runtime with Docker
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

## Set up a new runtime instance

{% navtabs %}
{% navtab Quick setup %}

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
{% endnavtabs %}

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
