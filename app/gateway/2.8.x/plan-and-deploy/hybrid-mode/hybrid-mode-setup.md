---
title: Deploy Kong Gateway in Hybrid Mode
---

## Prerequisites

To get started with a hybrid mode deployment, first install an instance of
{{site.base_gateway}} with TLS to be your control plane (CP) node. See the
[installation documentation](/gateway/{{page.kong_version}}/install-and-run/)
for details.

We will bring up any subsequent data plane (DP) instances in this topic.

{:.note}
> **Note:** For a hybrid mode deployment on Kubernetes, see [hybrid mode](https://github.com/Kong/charts/blob/main/charts/kong/README.md#hybrid-mode)
in the `kong/charts` repository.

## Generate a certificate/key pair

In hybrid mode, a mutual TLS handshake (mTLS) is used for authentication so the
actual private key is never transferred on the network, and communication
between CP and DP nodes is secure.

Before using hybrid mode, you need a certificate/key pair.
{{site.base_gateway}} provides two modes for handling certificate/key pairs:

* **Shared mode:** (Default) Use the Kong CLI to generate a certificate/key
pair, then distribute copies across nodes. The certificate/key pair is shared
by both CP and DP nodes.
* **PKI mode:** Provide certificates signed by a central certificate authority
(CA). Kong validates both sides by checking if they are from the same CA. This
eliminates the risks associated with transporting private keys.

{:.warning}
> **Warning:** If you have a TLS-aware proxy between the DP and CP nodes, you
must use PKI mode and set `cluster_server_name` to the CP hostname in
`kong.conf`. Do not use shared mode, as it uses a non-standard value for TLS server name
indication, and this will confuse TLS-aware proxies that rely on SNI to route
traffic.

For a breakdown of the properties used by these modes, see the
[configuration reference](#configuration-reference).

{% navtabs %}
{% navtab Shared mode %}
{:.warning}
 > **Warning:** Protect the Private Key. Ensure the private key file can only be accessed by
  Kong nodes belonging to the cluster. If the key is compromised, you must
  regenerate and replace certificates and keys on all CP and DP nodes.

1. On an existing {{site.base_gateway}} instance, create a certificate/key pair:
    ```bash
    kong hybrid gen_cert
    ```
    This will generate `cluster.crt` and `cluster.key` files and save them to
    the current directory. By default, the certificate/key pair is valid for three
    years, but can be adjusted with the `--days` option. See `kong hybrid --help`
    for more usage information.

2. Copy the `cluster.crt` and `cluster.key` files to the same directory
on all Kong CP and DP nodes; e.g., `/cluster/cluster`.
  Set appropriate permissions on the key file so it can only be read by Kong.

{% endnavtab %}
{% navtab PKI mode %}

With PKI mode, the Hybrid cluster can use certificates signed by a central
certificate authority (CA).

In this mode, the control plane and data plane don't need to use the same
`cluster_cert` and `cluster_cert_key`. Instead, Kong validates both sides by
checking if they are from the same CA.

Prepare your CA certificates on the hosts where Kong will be running.

{% navtabs %}
{% navtab CA Certificate Example %}
Typically, a CA certificate will look like this:

```
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            5d:29:73:bf:c3:da:5f:60:69:da:73:ed:0e:2e:97:6f:7f:4c:db:4b
        Signature Algorithm: ecdsa-with-SHA256
        Issuer: O = Kong Inc., CN = Hybrid Root CA
        Validity
            Not Before: Jul  7 12:36:10 2020 GMT
            Not After : Jul  7 12:36:40 2023 GMT
        Subject: O = Kong Inc., CN = Hybrid Root CA
        Subject Public Key Info:
            Public Key Algorithm: id-ecPublicKey
                Public-Key: (256 bit)
                pub:
                    04:df:49:9f:39:e6:2c:52:9f:46:7a:df:ae:7b:9b:
                    87:1e:76:bb:2e:1d:9c:61:77:07:e5:8a:ba:34:53:
                    3a:27:4c:1e:76:23:b4:a2:08:80:b4:1f:18:7a:0b:
                    79:de:ea:8c:23:94:e6:2f:57:cf:27:b4:0a:52:59:
                    90:2c:2b:86:03
                ASN1 OID: prime256v1
                NIST CURVE: P-256
        X509v3 extensions:
            X509v3 Key Usage: critical
                Certificate Sign, CRL Sign
            X509v3 Basic Constraints: critical
                CA:TRUE
            X509v3 Subject Key Identifier:
                8A:0F:07:61:1A:0F:F4:B4:5D:B7:F3:B7:28:D1:C5:4B:81:A2:B9:25
            X509v3 Authority Key Identifier:
                keyid:8A:0F:07:61:1A:0F:F4:B4:5D:B7:F3:B7:28:D1:C5:4B:81:A2:B9:25

    Signature Algorithm: ecdsa-with-SHA256
         30:45:02:20:68:3c:d1:f3:63:a2:aa:b4:59:c9:52:af:33:b7:
         3f:ca:3a:2b:1c:9d:87:0c:c0:47:ff:a2:c4:af:3e:b0:36:29:
         02:21:00:86:ce:d0:fc:ba:92:e9:59:16:1c:c3:b2:11:11:ed:
         01:5d:16:49:d0:f9:0c:1d:35:0d:40:ba:19:98:31:76:57
```
{% endnavtab %}

{% navtab CA Certificate on CP %}
Here is an example of a CA certificate on a control plane:

```
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            18:cc:a3:6b:aa:77:0a:69:c6:d5:ff:12:be:be:c0:ac:5c:ff:f1:1e
        Signature Algorithm: ecdsa-with-SHA256
        Issuer: CN = Hybrid Intermediate CA
        Validity
            Not Before: Jul 31 00:59:29 2020 GMT
            Not After : Oct 29 00:59:59 2020 GMT
        Subject: CN = control-plane.kong.yourcorp.tld
        Subject Public Key Info:
            Public Key Algorithm: id-ecPublicKey
                Public-Key: (256 bit)
                pub:
                    04:f8:3a:a9:d2:e2:79:19:19:f3:1c:58:a0:23:60:
                    78:04:1f:7e:e2:bb:60:d2:29:50:ad:7c:9b:8e:22:
                    1c:54:c2:ce:68:b8:6c:8a:f6:92:9d:0c:ce:08:d3:
                    aa:0c:20:67:41:32:18:63:c9:dd:50:31:60:d6:8b:
                    8d:f9:7b:b5:37
                ASN1 OID: prime256v1
                NIST CURVE: P-256
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment, Key Agreement
            X509v3 Extended Key Usage:
                TLS Web Client Authentication
            X509v3 Subject Key Identifier:
                70:C7:F0:3B:CD:EB:8D:1B:FF:6A:7C:E0:A4:F0:C6:4C:4A:19:B8:7F
            X509v3 Authority Key Identifier:
                keyid:16:0D:CF:92:3B:31:B0:61:E5:AB:EE:91:42:B9:60:56:0A:88:92:82

            X509v3 Subject Alternative Name:
                DNS:control-plane.kong.yourcorp.tld, DNS:alternate-control-plane.kong.yourcorp.tld
            X509v3 CRL Distribution Points:

                Full Name:
                  URI:https://crl-service.yourcorp.tld/v1/pki/crl

    Signature Algorithm: ecdsa-with-SHA256
         30:44:02:20:5d:dd:ec:a8:4f:e7:5b:7d:2f:3f:ec:b5:40:d7:
         de:5e:96:e1:db:b7:73:d6:84:2e:be:89:93:77:f1:05:07:f3:
         02:20:16:56:d9:90:06:cf:98:07:87:33:dc:ef:f4:cc:6b:d1:
         19:8f:64:ee:82:a6:e8:e6:de:57:a7:24:82:72:82:49
```
{% endnavtab %}

{% navtab CA Certificate on DP %}
Here is an example of a CA certificate on a data plane:

```
Certificate:
    Data:
        Version: 3 (0x2)
        Serial Number:
            4d:8b:eb:89:a2:ed:b5:29:80:94:31:e4:94:86:ce:4f:98:5a:ad:a0
        Signature Algorithm: ecdsa-with-SHA256
        Issuer: CN = Hybrid Intermediate CA
        Validity
            Not Before: Jul 31 00:57:01 2020 GMT
            Not After : Oct 29 00:57:31 2020 GMT
        Subject: CN = kong-dp-ce39edecp.service
        Subject Public Key Info:
            Public Key Algorithm: id-ecPublicKey
                Public-Key: (256 bit)
                pub:
                    04:19:51:80:4c:6d:8c:a8:05:63:42:71:a2:9a:23:
                    34:34:92:c6:2a:d3:e5:15:6e:36:44:85:64:0a:4c:
                    12:16:82:3f:b7:4c:e1:a1:5a:49:5d:4c:5e:af:3c:
                    c1:37:e7:91:e2:b5:52:41:a0:51:ac:13:7b:cc:69:
                    93:82:9b:2f:e2
                ASN1 OID: prime256v1
                NIST CURVE: P-256
        X509v3 extensions:
            X509v3 Key Usage: critical
                Digital Signature, Key Encipherment, Key Agreement
            X509v3 Extended Key Usage:
                TLS Web Client Authentication
            X509v3 Subject Key Identifier:
                25:82:8C:93:85:35:C3:D6:34:CF:CB:7B:D6:14:97:46:84:B9:2B:87
            X509v3 Authority Key Identifier:
                keyid:16:0D:CF:92:3B:31:B0:61:E5:AB:EE:91:42:B9:60:56:0A:88:92:82
            X509v3 CRL Distribution Points:

                Full Name:
                  URI:https://crl-service.yourcorp.tld/v1/pki/crl

    Signature Algorithm: ecdsa-with-SHA256
         30:44:02:20:65:2f:5e:30:f7:a4:28:14:88:53:58:c5:85:24:
         35:50:25:c9:fe:db:2f:72:9f:ad:7d:a0:67:67:36:32:2b:d2:
         02:20:2a:27:7d:eb:75:a6:ee:65:8b:f1:66:a4:99:32:56:7c:
         ad:ca:3a:d5:50:8f:cf:aa:6d:c2:1c:af:a4:ca:75:e8
```
{% endnavtab %}
{% endnavtabs %}

> **Note:** Certificates on CP and DP must contain the `TLS Web Server Authentication` and
`TLS Web Client Authentication` as X509v3 Extended Key Usage extension, respectively.

Kong doesn't validate the CommonName (CN) in the DP certificate; it can take an arbitrary value.

{% endnavtab %}
{% endnavtabs %}

## Set up the control plane
Next, give the control plane node the `control_plane` role, and set
certificate/key parameters to point at the location of your certificates and
keys.

{% navtabs %}
{% navtab Using Docker %}

1. In your Docker container, set the following environment variables:

    For `shared` certificate mode, use:
    ```bash
    KONG_ROLE=control_plane
    KONG_CLUSTER_CERT=/<path-to-file>/cluster.crt
    KONG_CLUSTER_CERT_KEY=/<path-to-file>/cluster.key
    ```

    For `pki` certificate mode, use:
    ```bash
    KONG_ROLE=control_plane
    KONG_CLUSTER_MTLS=pki
    KONG_CLUSTER_CA_CERT=/<path-to-file>/ca-cert.pem
    KONG_CLUSTER_CERT=/<path-to-file>/control-plane.crt
    KONG_CLUSTER_CERT_KEY=/<path-to-file>/control-plane.key
    ```
    By setting the role of the node to `control_plane`, this node will listen on
    port `0.0.0.0:8005` by default for data plane connections, and on port
    `0.0.0.0:8006` for telemetry data. These ports on the
    control plane will need to be accessible by all data planes it controls through
    any firewalls you may have in place.

    For PKI mode, `KONG_CLUSTER_CA_CERT` specifies the root CA certificate for
    `KONG_CLUSTER_CERT` and `KONG_CLUSTER_CERT_KEY`. This certificate must be
    the root CA certificate and not any of an intermediate CA. Kong allows a
    maximum of three levels of intermediate CAs to be used between the root CA
    and the cluster certificate.

    If you need to change the ports that the control plane listens on, set:
    ```bash
    KONG_CLUSTER_LISTEN=0.0.0.0:<port>
    KONG_CLUSTER_TELEMETRY_LISTEN=0.0.0.0:<port>
    ```

2. Next, start Kong, or reload Kong if it's already running:
    ```bash
    kong start
    ```
    ```bash
    kong reload
    ```

{% endnavtab %}
{% navtab Using kong.conf %}
1. In `kong.conf`, set the following configuration parameters:

    For `shared` certificate mode, use:
    ```bash
    role = control_plane
    cluster_cert = /<path-to-file>/cluster.crt
    cluster_cert_key = /<path-to-file>/cluster.key
    ```

    For `pki` certificate mode, use:
    ```bash
    role = control_plane
    cluster_mtls = pki
    cluster_ca_cert = /<path-to-file>/ca-cert.pem
    cluster_cert = /<path-to-file>/control-plane.crt
    cluster_cert_key = /<path-to-file>/control-plane.key
    ```

    By setting the role of the node to `control_plane`, this node will listen on
    port `0.0.0.0:8005` by default for data plane connections, and on port
    `0.0.0.0:8006` for telemetry data. These ports on the
    control plane will need to be accessible by all data planes it controls through
    any firewalls you may have in place.

    For PKI mode, `cluster_ca_cert` specifies the root CA certificate for
    `cluster_cert` and `cluster_cert_key`. This certificate must be the root CA
    certificate and not any of an intermediate CA. Kong allows a maximum of three
    levels of intermediate CAs to be used between the root CA and the cluster
    certificate.

    If you need to change the ports that the control plane listens on, set:
    ```bash
    cluster_listen=0.0.0.0:<port>
    cluster_telemetry_listen=0.0.0.0:<port>
    ```

2. Restart Kong for the settings to take effect:
    ```bash
    kong restart
    ```
{% endnavtab %}
{% endnavtabs %}

Note that the control plane still needs a database to
store the central configurations, although the database never needs to
be accessed by data plane nodes. You may run multiple control plane nodes to
provide load balancing and redundancy, as long as they all point to the same
backend database.

{:.note}
> **Note:** Control plane nodes cannot be used for proxying.

### (Optional) Revocation checks of data plane certificates

When Kong is running hybrid mode with PKI mode, the control plane can be configured to
optionally check for revocation status of the connecting data plane certificate.

The supported method is through Online Certificate Status Protocol (OCSP) responders.
Issued data plane certificates must contain the Certificate Authority Information Access extension
that references the URI of OCSP responder that can be reached from the control plane.

To enable OCSP checks, set the `cluster_ocsp` config on the control plane to one of the following values:

* `on`: OCSP revocation check is enabled and the data plane must pass the revocation check
to establish connection with the control plane. This implies that certificates without the
OCSP extension or unreachable OCSP responder also prevents a connection from being established.
* `off`: OCSP revocation check is disabled (default).
* `optional`: OCSP revocation check will be attempted, however, if the OCSP responder URI is not
found inside the data plane-provided certificate or communication with the OCSP responder failed,
then data plane is still allowed through.

Note that OCSP checks are only performed on the control plane against certificates provided by incoming data plane
nodes. The `cluster_ocsp` config has no effect on data plane nodes.
`cluster_oscp` affects all hybrid mode connections established from a data plane to its control plane.

## Install and start data planes
Now that the control plane is running, you can attach data plane nodes to it to
start serving traffic.

In this step, you will give all data plane nodes the `data_plane` role,
point them to the control plane, set certificate/key parameters to point at
the location of your certificates and keys, and ensure the database
is disabled.

In addition, the certificate from `cluster_cert` (in `shared` mode) or `cluster_ca_cert`
(in `pki` mode) is automatically added to the trusted chain in
[`lua_ssl_trusted_certificate`](/gateway/{{page.kong_version}}/reference/configuration/#lua_ssl_trusted_certificate).

{:.important}
> **Important:** Data plane nodes receive updates from the control plane via a format
similar to declarative config, therefore `database` has to be set to
`off` for Kong to start up properly.

See the [DP node start sequence](#dp-node-start-sequence) for more information
on how data plane nodes process configuration.


{% navtabs %}
{% navtab Using Docker %}
1. Using the [Docker installation documentation](/gateway/{{page.kong_version}}/install-and-run/docker),
follow the instructions to:
    1. [Download {{site.base_gateway}}](/gateway/{{page.kong_version}}/install-and-run/docker).
    2. [Create a Docker network](/gateway/{{page.kong_version}}/install-and-run/docker/#install-gateway-in-db-less-mode).

    {:.warning}
    > **Warning:** Do not start or create a database on this node.


1. Bring up your data plane container with the following settings:

    For `shared` certificate mode, use:

{% capture shared-mode-cp %}
{% navtabs codeblock %}
{% navtab Kong Gateway %}
```bash
docker run -d --name kong-dp --network=kong-net \
-e "KONG_ROLE=data_plane" \
-e "KONG_DATABASE=off" \
-e "KONG_PROXY_LISTEN=0.0.0.0:8000" \
-e "KONG_CLUSTER_CONTROL_PLANE=control-plane.<admin-hostname>.com:8005" \
-e "KONG_CLUSTER_TELEMETRY_ENDPOINT=control-plane.<admin-hostname>.com:8006" \
-e "KONG_CLUSTER_CERT=/<path-to-file>/cluster.crt" \
-e "KONG_CLUSTER_CERT_KEY=/<path-to-file>/cluster.key" \
--mount type=bind,source="$(pwd)"/cluster,target=<path-to-keys-and-certs>,readonly \
-p 8000:8000 \
kong/kong-gateway:{{page.kong_versions[page.version-index].ee-version}}-alpine
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
docker run -d --name kong-dp --network=kong-net \
-e "KONG_ROLE=data_plane" \
-e "KONG_DATABASE=off" \
-e "KONG_PROXY_LISTEN=0.0.0.0:8000" \
-e "KONG_CLUSTER_CONTROL_PLANE=control-plane.<admin-hostname>.com:8005" \
-e "KONG_CLUSTER_TELEMETRY_ENDPOINT=control-plane.<admin-hostname>.com:8006" \
-e "KONG_CLUSTER_CERT=/<path-to-file>/cluster.crt" \
-e "KONG_CLUSTER_CERT_KEY=/<path-to-file>/cluster.key" \
--mount type=bind,source="$(pwd)"/cluster,target=<path-to-keys-and-certs>,readonly \
-p 8000:8000 \
kong:{{page.kong_versions[page.version-index].ce-version}}-alpine
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ shared-mode-cp | indent | replace: " </code>", "</code>" }}

    For `pki` certificate mode, use:

{% capture pki-mode-cp %}
{% navtabs codeblock %}
{% navtab Kong Gateway %}
```bash
docker run -d --name kong-dp --network=kong-net \
-e "KONG_ROLE=data_plane" \
-e "KONG_DATABASE=off" \
-e "KONG_PROXY_LISTEN=0.0.0.0:8000" \
-e "KONG_CLUSTER_CONTROL_PLANE=control-plane.<admin-hostname>.com:8005" \
-e "KONG_CLUSTER_TELEMETRY_ENDPOINT=control-plane.<admin-hostname>.com:8006" \
-e "KONG_CLUSTER_MTLS=pki" \
-e "KONG_CLUSTER_SERVER_NAME=control-plane.kong.yourcorp.tld" \
-e "KONG_CLUSTER_CERT=data-plane.crt" \
-e "KONG_CLUSTER_CERT_KEY=/<path-to-file>/data-plane.crt" \
-e "KONG_CLUSTER_CA_CERT=/<path-to-file>/ca-cert.pem" \
--mount type=bind,source="$(pwd)"/cluster,target=<path-to-keys-and-certs>,readonly \
-p 8000:8000 \
kong/kong-gateway:{{page.kong_versions[page.version-index].ee-version}}-alpine
```
{% endnavtab %}
{% navtab Kong Gateway (OSS) %}
```bash
docker run -d --name kong-dp --network=kong-net \
-e "KONG_ROLE=data_plane" \
-e "KONG_DATABASE=off" \
-e "KONG_PROXY_LISTEN=0.0.0.0:8000" \
-e "KONG_CLUSTER_CONTROL_PLANE=control-plane.<admin-hostname>.com:8005" \
-e "KONG_CLUSTER_TELEMETRY_ENDPOINT=control-plane.<admin-hostname>.com:8006" \
-e "KONG_CLUSTER_MTLS=pki" \
-e "KONG_CLUSTER_SERVER_NAME=control-plane.kong.yourcorp.tld" \
-e "KONG_CLUSTER_CERT=data-plane.crt" \
-e "KONG_CLUSTER_CERT_KEY=/<path-to-file>/data-plane.crt" \
-e "KONG_CLUSTER_CA_CERT=/<path-to-file>/ca-cert.pem" \
--mount type=bind,source="$(pwd)"/cluster,target=<path-to-keys-and-certs>,readonly \
-p 8000:8000 \
kong:{{page.kong_versions[page.version-index].ce-version}}-alpine
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ pki-mode-cp | indent | replace: " </code>", "</code>" }}

    Where:

    `--name` and `--network`
    : The tag of the {{site.base_gateway}} image that you're using, and the Docker network it communicates on.

    `KONG_CLUSTER_CONTROL_PLANE`
    : Sets the address and port of the control plane (port `8005` by defaut).

    `KONG_DATABASE`
    : Specifies whether this node connects directly to a database.

    `<path-to-file>` and `target=<path-to-keys-and-certs>`
    : Are the same path, pointing to the location of the `cluster.key` and
    `cluster.crt` files.

    `KONG_CLUSTER_SERVER_NAME`
    : Specifies the SNI (Server Name Indication
    extension) to use for data plane connections to the control plane through
    TLS. When not set, data plane will use `kong_clustering` as the SNI.

    : You can also optionally use `KONG_CLUSTER_TELEMETRY_SERVER_NAME`
      to set a custom SNI for telemetry data. If not set, it defaults to
      `KONG_CLUSTER_SERVER_NAME`.

    `KONG_CLUSTER_TELEMETRY_ENDPOINT`
    : Optional setting, needed for telemetry gathering. Not available in open-source deployments.

    You can also choose to encrypt or disable the data plane configuration
    cache with some additional settings:

    `KONG_DATA_PLANE_CONFIG_CACHE_MODE`
    : Optional setting for storing the config cache, defaults to `unencrypted`.
    Change this to `encrypted` if you want to store the data plane's config cache
    in an encrypted format, or set it to `off` if you don't want to use a cache.
    Not available in open-source deployments.

    `KONG_DATA_PLANE_CONFIG_CACHE_PATH`
    : An optional custom path to the config cache. Not available in open-source
    deployments.

1. If needed, bring up any subsequent data planes using the same settings.

{% endnavtab %}
{% navtab Using kong.conf %}

1. Find the documentation for [your platform](/gateway/{{page.kong_version}}/install-and-run),
and follow the instructions in Steps 1 and 2 **only** to download
{{site.base_gateway}} and install Kong.

    {:.note}
    > **Note:** for Docker, see the **Docker** tab above. For Kubernetes, see the
    [hybrid mode documentation](https://github.com/Kong/charts/blob/main/charts/kong/README.md#hybrid-mode)
    in the `kong/charts` repository.

    {:.warning}
    > Do not start or create a database on this node.


2. In `kong.conf`, set the following configuration parameters:

    For `shared` certificate mode, use:
    ```bash
    role = data_plane
    database = off
    proxy_listen = 0.0.0.0:8000
    cluster_control_plane = control-plane.<admin-hostname>.com:8005
    cluster_telemetry_endpoint = control-plane.<admin-hostname>.com:8006
    cluster_cert = /<path-to-file>/cluster.crt
    cluster_cert_key = /<path-to-file>/cluster.key
    ```

    For `pki` certificate mode, use:
    ```bash
    role = data_plane
    database = off
    proxy_listen = 0.0.0.0:8000
    cluster_control_plane = control-plane.<admin-hostname>.com:8005
    cluster_telemetry_endpoint = control-plane.<admin-hostname>.com:8006
    cluster_mtls = pki
    cluster_server_name = control-plane.kong.yourcorp.tld
    cluster_cert = /<path-to-file>/data-plane.crt
    cluster_cert_key = /<path-to-file>/data-plane.crt
    cluster_ca_cert = /<path-to-file>/ca-cert.pem
    ```

    Where:

    `cluster_control_plane`
    : Sets the address and port of the control plane (port `8005` by defaut).

    `database`
    : Specifies whether this node connects directly to a database.

    `<path-to-file>`
    : Specifies the location of the `cluster.key` and `cluster.crt` files.

    `cluster_server_name`
    : Specifies the SNI (Server Name Indication extension)
    to use for data plane connections to the control plane through TLS. When
    not set, data plane will use `kong_clustering` as the SNI.

    : You can also optionally use `cluster_telemetry_server_name`
      to set a custom SNI for telemetry data. If not set, it defaults to
      `cluster_server_name`.

    `cluster_telemetry_endpoint`
    : Optional setting, needed for telemetry gathering. Not available in open-source deployments.

    You can also choose to encrypt or disable the data plane configuration
    cache with some additional settings:

    `data_plane_config_cache_mode`
    : Optional setting for storing the config cache, defaults to `unencrypted`.
    Change this to `encrypted` if you want to store the data plane's config cache
    in an encrypted format, or set it to `off` if you don't want to use a cache.
    Not available in open-source deployments.

    `data_plane_config_cache_path`
    : An optional custom path to the config cache. Not available in open-source
    deployments.

3. Restart Kong for the settings to take effect:
    ```bash
    kong restart
    ```
{% endnavtab %}
{% endnavtabs %}

## Verify that nodes are connected

Use the control plane’s Cluster Status API to monitor your data planes. It
provides:
* The name of the node
* The last time the node synced with the control plane
* The version of the config currently running on each data plane

To check whether the CP and DP nodes you just brought up are connected, run the
following on a control plane:
{% navtabs %}
{% navtab Using cURL %}
```bash
curl -i -X GET http://<admin-hostname>:8001/clustering/data-planes
```
{% endnavtab %}
{% navtab Using HTTPie %}
```bash
http :8001/clustering/data-planes
```
{% endnavtab %}
{% endnavtabs %}
The output shows all of the connected data plane instances in the cluster:

```json
{
    "data": [
        {
            "config_hash": "a9a166c59873245db8f1a747ba9a80a7",
            "hostname": "data-plane-2",
            "id": "ed58ac85-dba6-4946-999d-e8b5071607d4",
            "ip": "192.168.10.3",
            "last_seen": 1580623199,
            "status": "connected"
        },
        {
            "config_hash": "a9a166c59873245db8f1a747ba9a80a7",
            "hostname": "data-plane-1",
            "id": "ed58ac85-dba6-4946-999d-e8b5071607d4",
            "ip": "192.168.10.4",
            "last_seen": 1580623200,
            "status": "connected"
        }
    ],
    "next": null
}
```

## References

### DP node start sequence

When set as a DP node, {{site.base_gateway}} processes configuration in the
following order:

1. **Config cache**: If the file `config.json.gz` exists in the `kong_prefix`
path (`/usr/local/kong` by default), the DP node loads it as configuration.
2. **`declarative_config` exists**: If there is no config cache and the
`declarative_config` parameter is set, the DP node loads the specified file.
3. **Empty config**: If there is no config cache or declarative
configuration file available, the node starts with empty configuration. In this
state, it returns 404 to all requests.
4. **Contact CP Node**: In all cases, the DP node contacts the CP node to retrieve
the latest configuration. If successful, it gets stored in the local config
cache (`config.json.gz`).

### Configuration reference

Use the following configuration properties to configure {{site.base_gateway}}
in hybrid mode.

Parameter | Description | CP or DP {:width=10%:}
--------- | ----------- | ----------------------
[`role`](/gateway/{{page.kong_version}}/reference/configuration/#role) <br>*Required* | Determines whether the {{site.base_gateway}} instance is a control plane or a data plane. Valid values are `control_plane` or `data_plane`. | Both
[`cluster_listen`](/gateway/{{page.kong_version}}/reference/configuration/#cluster_listen) <br>*Optional* <br><br>**Default:** `0.0.0.0:8005`| List of addresses and ports on which the control plane will listen for incoming data plane connections. This port is always protected with Mutual TLS (mTLS) encryption. Ignored on data plane nodes. | CP
[`proxy_listen`](/gateway/{{page.kong_version}}/reference/configuration/#proxy_listen) <br>*Required* | Comma-separated list of addresses and ports on which the proxy server should listen for HTTP/HTTPS traffic. Ignored on control plane nodes. | DP
[`cluster_telemetry_listen`](/gateway/{{page.kong_version}}/reference/configuration/#cluster_telemetry_listen) <span class="badge enterprise"/> <br>*Optional* <br><br>**Default:** `0.0.0.0:8006`| List of addresses and ports on which the control plane will listen for data plane telemetry data. This port is always protected with Mutual TLS (mTLS) encryption. Ignored on data plane nodes. | CP
[`cluster_telemetry_endpoint`](/gateway/{{page.kong_version}}/reference/configuration/#cluster_telemetry_endpoint) <span class="badge enterprise"/> <br>*Required for Enterprise deployments* | The port that the data plane uses to send telemetry data to the control plane. Ignored on control plane nodes. | DP
[`cluster_control_plane`](/gateway/{{page.kong_version}}/reference/configuration/#cluster_control_plane) <br>*Required* | Address and port that the data plane nodes use to connect to the control plane. Must point to the port configured using the [`cluster_listen`](/gateway/{{page.kong_version}}/reference/configuration/#cluster_listen) property on the control plane node. Ignored on control plane nodes. | DP
[`cluster_mtls`](/gateway/{{page.kong_version}}/reference/configuration/#cluster_mtls) <br>*Optional* <br><br>**Default:** `shared` | One of `shared` or `pki`. Indicates whether hybrid mode will use a shared certificate/key pair for CP/DP mTLS or if PKI mode will be used. See below sections for differences in mTLS modes. | Both
[`data_plane_config_cache_mode`](/gateway/{{page.kong_version}}/reference/configuration/#data_plane_config_cache_mode) <span class="badge enterprise"/> <br>*Optional* <br><br>**Default:** `unencrypted` | Determines how the data plane configuration cache is stored. <br> &#8226; `unencrypted`: Stores configuration without encrypting it in `config.cache.json.gz` <br> &#8226; `encrypted`: Encrypts and stores the configuration cache in `.config.cache.jwt` (hidden file). <br> &#8226; `off`: The data plane does not cache configuration | DP
[`data_plane_config_cache_path`](/gateway/{{page.kong_version}}/reference/configuration/#data_plane_config_cache_path) <span class="badge enterprise"/> <br>*Optional* <br><br>**Default:** Kong [`prefix` path](/gateway/{{page.kong_version}}/reference/configuration/#prefix) | Path to the data plane config cache file, for example `/tmp/kong-config-cache`. If the cache mode is `encrypted`, the filename is `.config.cache.jwt` (hidden file). If the cache mode is `unencrypted`, the filename is `config.cache.json.gz`. | DP

The following properties are used differently between `shared` and `pki` modes:

Parameter | Description | Shared Mode {:width=12%:} | PKI Mode {:width=30%:}
--------- | ----------- | ------------------------- | ----------------------
[`cluster_cert`](/gateway/{{page.kong_version}}/reference/configuration/#cluster_cert) and [`cluster_cert_key`](/gateway/{{page.kong_version}}/reference/configuration/#cluster_cert_key) <br>*Required* | Certificate/key pair used for mTLS between CP/DP nodes. | Same between CP/DP nodes. | Unique certificate for each node, generated from the CA specified by `cluster_ca_cert`.
[`cluster_ca_cert`](/gateway/{{page.kong_version}}/reference/configuration/#cluster_ca_cert) <br>*Required in PKI mode* | The trusted CA certificate file in PEM format used to verify the `cluster_cert`. | *Ignored* | CA certificate used to verify `cluster_cert`, same between CP/DP nodes. *Required*
[`cluster_server_name`](/gateway/{{page.kong_version}}/reference/configuration/#cluster_server_name) <br>*Required in PKI mode* | The SNI presented by the DP node mTLS handshake. | *Ignored* | In PKI mode, the DP nodes will also verify that the Common Name (CN) or Subject Alternative Name (SAN) inside the certificate presented by CP matches the `cluster_server_name` value.
[`cluster_telemetry_server_name`](/gateway/{{page.kong_version}}/reference/configuration/#cluster_telemetry_server_name) <span class="badge enterprise"/>|  The telemetry SNI presented by the DP node mTLS handshake. If not specified, falls back on SNI set in `cluster_server_name`. | *Ignored* | In PKI mode, the DP nodes will also verify that the Common Name (CN) or Subject Alternative Name (SAN) inside the certificate presented by CP matches the `cluster_telemetry_server_name` value.

## Next steps

Now, you can start managing the cluster using the control plane. Once
all instances are set up, use the Admin API on the control plane as usual, and
these changes will be synced and updated on the data plane nodes automatically
within seconds.
