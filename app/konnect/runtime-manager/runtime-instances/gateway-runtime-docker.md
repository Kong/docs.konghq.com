---
title: Set up a Kong Gateway Runtime with Docker
content_type: how-to
---
Set up a Docker runtime instance through the
[{{site.konnect_short_name}} Runtime Manager](/konnect/runtime-manager) and
configure your instance to accept configuration from
{{site.konnect_short_name}}. The Runtime Manager keeps track of all runtime
instances associated with the {{site.konnect_saas}} account.

You have the following options when configuring a new runtime instance with Docker:
* Use the quick setup script, which generates a data plane container
running on `localhost`.
* Use the advanced setup to customize your installation.

{:.note}
> **Note:** Kong does not host runtimes. You must install and host your own
runtime instances.

## Quick setup

### Prerequisites

* The quick setup script requires [Docker](https://docs.docker.com/get-docker/) and a Unix shell

* Platform-specific tools and permissions:
  * **MacOS**: [Docker Desktop](https://docs.docker.com/docker-for-mac/install/)
  * **Linux:** User added to the [`docker` group](https://docs.docker.com/engine/install/linux-postinstall/)
  * **Windows:** [Docker Desktop installed](https://docs.docker.com/docker-for-windows/install/#install-docker-desktop-on-windows) and [integrated with a WSL 2 backend](https://docs.docker.com/docker-for-windows/wsl/).
  If you can't set up a WSL 2 backend, see the [advanced](#custom-setup) instructions for
  a custom Docker setup instead.

### Run the quick setup script

1. Open the {% konnect_icon runtimes %} **Runtime Manager**.

1. Select a runtime group.

1. Click **Create runtime instance**.

1. Choose the tile for your platform: MacOS, Windows, or Linux (Docker).

1. Click **Generate script**, then click **Copy** to copy it to your clipboard.

1. Run the script on any host you choose.

    This script creates a Docker container running a simple
    {{site.base_gateway}} instance and connects it to your
    {{site.konnect_saas}} account.

1. Click **Done** to go to the Runtime Instances overview, where you will
see a new entry for your instance.

## Custom setup

### Prerequisites

Tools and permissions:
* **All platforms:** [Docker](https://docs.docker.com/get-docker/) and a Unix shell
* **Linux:** User added to the [`docker` group](https://docs.docker.com/engine/install/linux-postinstall/)
* **[Windows](https://docs.docker.com/docker-for-windows/install/#install-docker-desktop-on-windows) and [MacOS](https://docs.docker.com/docker-for-mac/install/):** Docker Desktop installed

### Generate certificates
{% include /md/konnect/runtime-certs.md %}

### Start {{site.base_gateway}}

Use the following `docker run` command sample as a guide to compile your actual values:

{% navtabs codeblock %}
{% navtab Any Unix shell %}
```sh

docker run -d \
        -e "KONG_ROLE=data_plane" \
        -e "KONG_DATABASE=off" \
        -e "KONG_ANONYMOUS_REPORTS=off" \
        -e "KONG_VITALS_TTL_DAYS=723" \
        -e "KONG_CLUSTER_MTLS=pki" \
        -e "KONG_CLUSTER_CONTROL_PLANE=91288f8ed2.us.cp0.konghq.com:443" \
        -e "KONG_CLUSTER_SERVER_NAME=91288f8ed2.us.cp0.konghq.com" \
        -e "KONG_CLUSTER_TELEMETRY_ENDPOINT=91288f8ed2.us.tp0.konghq.com:443" \
        -e "KONG_CLUSTER_TELEMETRY_SERVER_NAME=91288f8ed2.us.tp0.konghq.com" \
        -e "KONG_CLUSTER_CERT_STRING='-----BEGIN PRIVATE KEY-----\-----END PRIVATE KEY-----\r\n'" \
        -e "KONG_CLUSTER_CERT_KEY_STRING='-----BEGIN CERTIFICATE-----\-----END CERTIFICATE-----\r\n'" \
        -e "KONG_LUA_SSL_TRUSTED_CERTIFICATE=system,/config/cluster.crt" \
        -p "$KONNECT_RUNTIME_PORT":8000 \
        -p "$KONNECT_RUNTIME_PORT_SECURE":8443 \
        kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}

```
{% endnavtab %}
{% navtab Windows PowerShell %}
```powershell
docker run -d \
        -e "KONG_ROLE=data_plane" `
        -e "KONG_DATABASE=off" `
        -e "KONG_ANONYMOUS_REPORTS=off" `
        -e "KONG_VITALS_TTL_DAYS=723" `
        -e "KONG_CLUSTER_MTLS=pki" `
        -e "KONG_CLUSTER_CONTROL_PLANE=91288f8ed2.us.cp0.konghq.com:443" `
        -e "KONG_CLUSTER_SERVER_NAME=91288f8ed2.us.cp0.konghq.com" `
        -e "KONG_CLUSTER_TELEMETRY_ENDPOINT=91288f8ed2.us.tp0.konghq.com:443" `
        -e "KONG_CLUSTER_TELEMETRY_SERVER_NAME=91288f8ed2.us.tp0.konghq.com" `
        -e "KONG_CLUSTER_CERT_STRING='-----BEGIN PRIVATE KEY-----\-----END PRIVATE KEY-----\r\n'" `
        -e "KONG_CLUSTER_CERT_KEY_STRING='-----BEGIN CERTIFICATE-----\-----END CERTIFICATE-----\r\n'" `
        -e "KONG_LUA_SSL_TRUSTED_CERTIFICATE=system,/config/cluster.crt" `
        -p "$KONNECT_RUNTIME_PORT":8000 `
        -p "$KONNECT_RUNTIME_PORT_SECURE":8443 `
        kong/kong-gateway:{{ site.data.kong_latest_gateway.ee-version }}

```
{% endnavtab %}
{% endnavtabs %}

1. Replace the values in `KONG_CLUSTER_CERT_STRING` and
`KONG_CLUSTER_CERT_KEY_STRING` with the path to your certificate and key files.

2. Check the **Linux** or **Kubernetes** tiles in the {{site.konnect_short_name}} UI to find the values for
        `KONG_CLUSTER_CONTROL_PLANE`, `KONG_CLUSTER_SERVER_NAME`,
        `KONG_CLUSTER_TELEMETRY_ENDPOINT`, and `KONG_CLUSTER_TELEMETRY_SERVER_NAME`,
        then substitute them in the command sample.

    See [Parameters](/konnect/runtime-manager/runtime-instances/runtime-parameter-reference/) for
    descriptions and the matching fields in {{site.konnect_short_name}}.

3. `-p 8000:8000` sets the proxy URL to `http://localhost:8000`.
        If you want to change this, bind the port to a different host. For example,
        you can explicitly set an IP:

      ```sh
      -p 127.0.0.1:8000:8000
      ```

4. Run the `docker run` command with your substituted values.

6. In {{site.konnect_short_name}}, click **Done** to go to the Runtime Instances overview, where you will
see a new entry for your instance.


## Access services using the proxy URL

{{site.base_gateway}} uses port `8000` for the proxy, taking incoming
traffic from consumers, and forwarding it to upstream services.

The default proxy URL is `http://localhost:8000`. If you configured a different
host above, replace `localhost` with your hostname. Use this URL,
along with any routes you set, to access your services.

For example, to access a service with the route `/mock`, use
`http://localhost:8000/mock`, or `http://example-host:8000/mock`.
