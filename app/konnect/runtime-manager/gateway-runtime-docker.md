---
title: Set up a Kong Gateway Runtime with Docker
no_version: true
---
Set up a Docker [runtime](/konnect/#konnect-key-concepts-and-terminology)
through the
[{{site.konnect_short_name}} Runtime Manager](/konnect/runtime-manager) and
configure your {{site.base_gateway}} instance to accept configuration from
{{site.konnect_short_name}}. The Runtime Manager keeps track of all runtimes
associated with the {{site.konnect_saas}} account.

You have the following options when configuring a new runtime with Docker:
* Use the [quick setup](#quick-setup) script, which generates a data plane
running on `localhost`.
* Use the [advanced setup](#advanced-setup) to customize your installation.

<div class="alert alert-ee blue">
<b>Note:</b> Kong does not host runtimes. You must install and host your own
runtime instances.
</div>

## Quick setup

### Prerequisites

* You have **Runtime Admin** or **Organization Admin** permissions in
{{site.konnect_saas}}.
* The quick setup script requires Docker and a Unix shell (for example, bash or
  zshell). Platform-specific tools and permissions:
  * **All platforms:** [Docker](https://docs.docker.com/get-docker/) and [jq](https://stedolan.github.io/jq/) installed
  * **Linux:** User added to the [`docker` group](https://docs.docker.com/engine/install/linux-postinstall/)
  * **Windows:** Docker Desktop [installed](https://docs.docker.com/docker-for-windows/install/#install-docker-desktop-on-windows) and [integrated with a WSL 2 backend](https://docs.docker.com/docker-for-windows/wsl/). If you can't set up a WSL 2 backend, see the [advanced](#advanced-setup) instructions for
  a custom Docker setup instead.

### Run the quick setup script

1. From the left navigation menu, open **Runtimes**.

    For the first runtime, the page opens to a **Configure New Runtime** form.

    Once configured, this page lists all runtimes associated with the
    {{site.konnect_saas}} account.

2. (Optional) If this is not the first runtime configuration, click
**Configure New Runtime**.

3. Click **Copy Script**.

    You can expand the codeblock by clicking **Show** to see the entire script.

4. Replace the placeholder for `<your-password>` with your own
{{site.konnect_saas}} password.

5. Run the script on any host you choose.

    This script creates a Docker container running a simple
    {{site.base_gateway}} instance and connects it to your
    {{site.konnect_saas}} account.

6. Click **Done** to go to the Runtime Manager overview.

    Once the script has finished running, the Runtimes Manager will
    include a new entry for your instance.
    <!-- and the tag in the **Node Status** column should say
    **Connected**.-->

## Advanced setup

### Prerequisites

* You have **Runtime Admin** or **Organization Admin** permissions in
{{site.konnect_saas}}.
* Tools and permissions:
  * **All platforms:** [Docker](https://docs.docker.com/get-docker/) installed
  * **Linux:** User added to the [`docker` group](https://docs.docker.com/engine/install/linux-postinstall/)
  * **[Windows](https://docs.docker.com/docker-for-windows/install/#install-docker-desktop-on-windows) and [MacOS](https://docs.docker.com/docker-for-mac/install/):** Docker Desktop installed

### Generate certificates
{% include /md/konnect/runtime-certs.md %}

### Start Kong Gateway

Use the following `docker run` command sample as a guide to compile your actual values:

{% navtabs codeblock %}
{% navtab Any Unix shell %}
```sh
$ docker run -d --name kong-dp \
  -e "KONG_ROLE=data_plane" \
  -e "KONG_DATABASE=off" \
  -e "KONG_VITALS_TTL_DAYS=732" \
  -e "KONG_CLUSTER_MTLS=pki" \
  -e "KONG_CLUSTER_CONTROL_PLANE={example.cp.konnect.foo}:443" \
  -e "KONG_CLUSTER_SERVER_NAME={kong-cpoutlet-example.service}" \
  -e "KONG_CLUSTER_TELEMETRY_ENDPOINT={example.tp.konnect.foo}:443" \
  -e "KONG_CLUSTER_TELEMETRY_SERVER_NAME={kong-telemetry-example.service}" \
  -e "KONG_CLUSTER_CERT=/{PATH_TO_FILE}/tls.crt" \
  -e "KONG_CLUSTER_CA_CERT=/{PATH_TO_FILE}/ca.crt" \
  -e "KONG_CLUSTER_CERT_KEY=/{PATH_TO_FILE}/tls.key" \
  --mount type=bind,source="$(pwd)",target={PATH_TO_KEYS_AND_CERTS},readonly \
  -p 8000:8000 \
  kong/kong-gateway:2.8.0.0-alpine
```
{% endnavtab %}
{% navtab Windows PowerShell %}
```powershell
docker run -d --name kong-dp `
  -e "KONG_ROLE=data_plane" `
  -e "KONG_DATABASE=off" `
  -e "KONG_VITALS_TTL_DAYS=732" `
  -e "KONG_CLUSTER_MTLS=pki" `
  -e "KONG_CLUSTER_CONTROL_PLANE={EXAMPLE.CP.KONNECT.FOO}:443" `
  -e "KONG_CLUSTER_SERVER_NAME={KONG-CPOUTLET-EXAMPLE.SERVICE}" `
  -e "KONG_CLUSTER_TELEMETRY_ENDPOINT={EXAMPLE.TP.KONNECT.FOO}:443" `
  -e "KONG_CLUSTER_TELEMETRY_SERVER_NAME={KONG-TELEMETRY-EXAMPLE.SERVICE}" `
  -e "KONG_CLUSTER_CERT=/{PATH_TO_FILE}/tls.crt" `
  -e "KONG_CLUSTER_CA_CERT=/{PATH_TO_FILE}/ca.crt" `
  -e "KONG_CLUSTER_CERT_KEY=/{PATH_TO_FILE}/tls.key" `
  --mount type=bind,source="$(pwd)",target={PATH_TO_KEYS_AND_CERTS},readonly `
  -p 8000:8000 `
  kong/kong-gateway:2.8.0.0-alpine
```
{% endnavtab %}
{% endnavtabs %}

1. Replace the values in `KONG_CLUSTER_CERT`, `KONG_CLUSTER_CA_CERT`, and
`KONG_CLUSTER_CERT_KEY` with the paths to your certificate and key files.

2. Check the **Linux** or **Kubernetes** tabs in the Konnect UI to find the values for
        `KONG_CLUSTER_CONTROL_PLANE`, `KONG_CLUSTER_SERVER_NAME`,
        `KONG_CLUSTER_TELEMETRY_ENDPOINT`, and `KONG_CLUSTER_TELEMETRY_SERVER_NAME`,
        then substitute them in the example below.

    ![Konnect Runtime Parameters](/assets/images/docs/konnect/konnect-runtime-manager.png)

    See [Parameters](/konnect/runtime-manager/runtime-parameter-reference) for
    descriptions and the matching fields in {{site.konnect_short_name}}.

3. `-p 8000:8000` sets the proxy URL to `http://localhost:8000`.
        If you want to change this, bind the port to a different host. For example,
        you can explicitly set an IP:

      ```sh
      -p 127.0.0.1:8000:8000
      ```

4. Run the `docker run` command with your substituted values.

5. On the **Configure New Runtime** page, click **Done** to go to the Runtime
Manager overview.

    The Runtime Manager will include a new entry for your instance.

## Access services using the proxy URL

{{site.base_gateway}} uses port `8000` for the proxy, taking incoming
traffic from consumers, and forwarding it to upstream services.

The default proxy URL is `http://localhost:8000`. If you configured a different
host above, replace `localhost` with your hostname. Use this URL,
along with any routes you set, to access your services.

For example, to access a service with the route `/mock`, use
`http://localhost:8000/mock`, or `http://example-host:8000/mock`.
