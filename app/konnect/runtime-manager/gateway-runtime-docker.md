---
title: Set up a Kong Gateway Runtime with Docker
no_version: true
---
Set up a Docker [runtime](/konnect/overview/#konnect-key-concepts-and-terminology)
through the
[{{site.konnect_short_name}} Runtime Manager](/konnect/runtime-manager) and
configure your {{site.base_gateway}} instance to accept configuration from
{{site.konnect_short_name}}. The Runtime Manager keeps track of all runtimes
associated with the {{site.konnect_short_name}} SaaS account.

You have the following options when configuring a new runtime with Docker:
* Use the [quick setup](#quick-setup) script, which generates a data plane
running on `localhost`.
* Use the [advanced setup](#advanced-setup) to customize your installation.

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

## Quick setup

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

## Advanced setup

### Generate certificates
{% include /md/konnect/runtime-certs.md %}

### Configure the runtime

Next, pull the {{site.base_gateway}} Docker image, and configure a
{{site.base_gateway}} runtime using the certificate, the private key, and the
remaining configuration details on the **Configure Runtime** page.

1. Using Docker, pull the following image:

    ```bash
    $ docker pull kong-docker-kong-gateway-docker.bintray.io/kong-enterprise-edition:{{site.data.kong_latest_ee.version}}-alpine
    ```

    You should now have your {{site.base_gateway}} image locally.

2. Verify that it worked, and find the image ID matching your repository:

    ```bash
    $ docker images
    ```

3. Tag the image ID for easier use, replacing `<IMAGE_ID>` with the one
matching your repository:

    ```bash
    $ docker tag <IMAGE_ID> kong-ee
    ```

4. Back in {{site.konnect_short_name}}, copy the
codeblock from the **Configuration Parameters** section.

5. Replace the values in `KONG_CLUSTER_CERT`, `KONG_CLUSTER_CERT_KEY`,
and `KONG_CLUSTER_CA_CERT` with the paths to your certificate files.

6. Using the provided values, bring up a new container.

    See [Parameters](/konnect/runtime-manager/runtime-parameter-reference) for
    descriptions and the matching fields in {{site.konnect_short_name}}.

    ```sh
    $ docker run -d --name kong-gateway-dp1 \
      -e "KONG_ROLE=data_plane" \
      -e "KONG_DATABASE=off" \
      -e "KONG_ANONYMOUS_REPORTS=off" \
      -e "KONG_VITALS_TTL_DAYS=723" \
      -e "KONG_CLUSTER_MTLS=pki" \
      -e "KONG_CLUSTER_CONTROL_PLANE=<example.cp.konnect.foo>:443" \
      -e "KONG_CLUSTER_SERVER_NAME=<kong-cpoutlet-example.service>" \
      -e "KONG_CLUSTER_TELEMETRY_ENDPOINT=<example.tp.konnect.foo>:443" \
      -e "KONG_CLUSTER_TELEMETRY_SERVER_NAME=<kong-telemetry-example.service>" \
      -e "KONG_CLUSTER_CERT=/<path-to-file>/cluster.crt" \
      -e "KONG_CLUSTER_CERT_KEY=/<path-to-file>/cluster.key" \
      -e "KONG_LUA_SSL_TRUSTED_CERTIFICATE=system,/<path-to-file>/ca.crt" \
      --mount type=bind,source="$(pwd)",target=<path-to-keys-and-certs>,readonly \
      -p 8000:8000 \
      kong-ee
    ```

    `-p 8000:8000` sets the proxy URL to `http://localhost:8000`.
    To change this, bind the port to a different host. For example, you can
    explicitly set an IP:

    ```sh
    -p 127.0.0.1:8000:8000
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
traffic from consumers, and forwarding it to upstream services.

The default proxy URL `http://localhost:8000`. If you configured a different
host above, replace `localhost` with your hostname. Use this URL,
along with any routes you set, to access your services.

For example, to access a service with the route `/mock`, use
`http://localhost:8000/mock`, or `http://example-host:8000/mock`.
