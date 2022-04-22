---
title: Hybrid Mode Deployment
---


## Introduction

Traditionally, Kong has always required a database, which could be either
Postgres or Cassandra, to store its configured entities such as Routes,
Services and Plugins. In Kong 1.1 we added the capability to run Kong without
a database, using only in-memory storage for entities: we call this [**DB-less mode**][db-less].

In Kong 2.0, we introduced a new method of deploying Kong which is
called the **Hybrid mode**, also known as **Control Plane / Data Plane Separation (CP/DP)**.

In this mode Kong nodes in a cluster are separated into two roles: control plane (CP), where configuration is managed and the Admin API is served from,
and data plane (DP), which serves traffic for the proxy. Each DP node is connected to one of the CP nodes. Instead of accessing the
database contents directly in the traditional deployment method, the DP nodes maintains
connection with CP nodes, and receives the latest configuration.

Deploying using Hybrid mode has a number of benefits:

* Drastically reduce the amount of traffic on the database, since only CP nodes need a
  direct connection to the database.
* Increased security, in an event where one of the DP nodes gets intruded, an attacker
  won't be able to affect other nodes in the Kong cluster.
* Easiness of management, since an admin will only need to interact with the CP nodes to control
  and monitor the status of the entire Kong cluster.

## Configuration Properties

Hybrid Mode introduces the following configuration properties:

Parameter | Description
--- | ---
`cluster_listen` *Optional* | List of addresses and ports on which the control plane will listen for incoming data plane connections. Defaults to `0.0.0.0:8005`. Note this port is always protected with Mutual TLS (mTLS) encryption. Ignored on data plane nodes.
`cluster_control_plane` *Required* | Address and port that the data plane nodes use to connect to the control plane. Must point to the port configured using the `cluster_listen` property on the control plane node. Ignored on control plane nodes.
`cluster_mtls` *Optional* | One of `"shared"` or `"pki"`. Indicates whether Hybrid Mode will use a shared certificate/key pair for CP/DP mTLS or if PKI mode will be used. Defaults to `"shared"`. See below sections for differences in mTLS modes.

The following properties are used differently between "shared" and "PKI" modes:

Parameter | Description | Shared Mode | PKI Mode
--- | --- | --- | ---
`cluster_cert` and `cluster_cert_key` *Required* | Certificate/key pair used for mTLS between CP/DP nodes. | Same between CP/DP nodes. | Unique certificate for each node, generated from the CA specified by `cluster_ca_cert`.
`cluster_ca_cert` *Required in PKI mode* | The trusted CA certificate file in PEM format used to verify the `cluster_cert`. | *Ignored* | CA certificate used to verify `cluster_cert`, same between CP/DP nodes. *Required*
`cluster_server_name` *Required in PKI mode* | The SNI Server Name presented by the DP node mTLS handshake. | *Ignored* | In PKI mode the DP nodes will also verify that the Common Name (CN) or Subject Alternative Name (SAN) inside certificate presented by CP matches the `cluster_server_name` value.

## Topology

![Example Hybrid Mode Topology](/assets/images/docs/hybrid-mode.png "Example Hybrid Mode Topology")

## Generating Certificate/Key Pair

Before using the Hybrid Mode, it is necessary to have a shared certificate/key pair generated
so that the communication security between CP and DP nodes can be established.

This certificate/key pair is shared by both CP and DP nodes, mutual TLS handshake (mTLS) is used
for authentication so the actual private key is never transferred on the network.

<div class="alert alert-warning">
  <strong>Protect the Private Key!</strong> Ensure the private key file can only be accessed by
  Kong nodes belonging to the cluster. If key is suspected to be compromised it is necessary to
  re-generate and replace certificate and keys on all the CP/DP nodes.
</div>

To create a certificate/key pair:

```
kong hybrid gen_cert
```

This will generate `cluster.crt` and `cluster.key` files and save them to the current directory.
By default it is valid for 3 years, but can be set longer or shorter with the `--days` option.

See `kong hybrid --help` for more usage information.

The `cluster.crt` and `cluster.key` files need to be transferred to both Kong CP and DP nodes.
Observe proper permission setting on the key file to ensure it can only be read by Kong.

## Setting Up Kong Control Plane Nodes

Starting the control plane is fairly simple. Aside from the database configuration
which is the same as today, we need to specify the "role" of the node to "control\_plane".
This will cause Kong to listen on `0.0.0.0:8005` by default for data plane
connections. The `8005` port on the control plane will need to be
accessible by all the data plane it controls through any firewalls you may have
in place.

In addition, the `cluster_cert` and `cluster_cert_key` configuration need to point to
the certificate/key pair that was generated above.

```
KONG_ROLE=control_plane KONG_CLUSTER_CERT=cluster.crt KONG_CLUSTER_CERT_KEY=cluster.key kong start
```

Or in `kong.conf`:

```
role = control_plane
cluster_cert = cluster.crt
cluster_cert_key = cluster.key
```

Note that control plane still needs a database (Postgres or Cassandra) to store the
"source of truth" configurations, although the database never needs to be access by
data plane nodes. You may run more than a single control plane nodes to provide load balancing
and redundancy as long as they points to the same backend database.

## PKI mode

Starting in Kong 2.1, the Hybrid cluster can use certificates signed by a central certificate authority (CA).
This mode can be activated by setting `cluster_mtls` to `"pki"` in `kong.conf`. The default value is `"shared"`.

In PKI mode, the control plane and data plane don't need to use the same `cluster_cert` and `cluster_cert_key`.
Instead, Kong validates both sides by checking if they are issued by configured CA. This eliminates the risk of
transporting private keys around.

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
An example CP certificate will be:

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
An example DP certificate will be:

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

Set the following configuration parameters in `kong.conf` on the control plane:

```
cluster_mtls = pki
cluster_ca_cert = /path/to/ca-cert.crt
cluster_cert = control-plane.crt
cluster_cert_key = control-plane.key
```

`cluster_ca_cert` specifies the root CA certificate for `cluster_cert` and `cluster_cert_key`. This
certificate must be the root CA certificate and not any of an intermediate CA.
Kong allows at most `3` levels of intermediate CAs to be used between the root CA and the cluster certificate.

Set the following configuration parameters in `kong.conf` on the data plane:

```
cluster_mtls = pki
cluster_server_name = control-plane.kong.yourcorp.tld
cluster_cert = data-plane.crt
cluster_cert_key = data-plane.crt
```

`cluster_server_name` specifies the SNI (Server Name Indication extension) to use for data plane
connections to the control plane through TLS. When not set, data plane will use `kong_clustering` as the SNI.

## Revocation check of Data Plane certificates

When Kong is running Hybrid mode with PKI mode, the Control Plane can be configured to
optionally check for revocation status of the connecting Data Plane certificate.

The supported method is through Online Certificate Status Protocol (OCSP) responders.
Issued data plane certificates must contain the Certificate Authority Information Access extension
that references the URI of OCSP responder that can be reached from the Control Plane.

To enable OCSP checks, set the `cluster_ocsp` config on the Control Plane to one of the following values:

* `on`: OCSP revocation check is enabled and the Data Plane must pass the revocation check
to establish connection with the Control Plane. This implies that certificates without the
OCSP extension or unreachable OCSP responder also prevents a connection from being established.
* `off`: OCSP revocation check is disabled (default).
* `optional`: OCSP revocation check will be attempted, however, if the OCSP responder URI is not
found inside the Data Plane-provided certificate or communication with the OCSP responder failed,
then Data Plane is still allowed through.

Note that OCSP checks are only performed on the Control Plane against certificates provided by incoming Data Plane
nodes. The `cluster_ocsp` config has no effect on Data Plane nodes.
`cluster_oscp` affects all Hybrid mode connections established from a Data Plane to its Control Plane.


## Starting Data Plane Nodes

Now that a control plane is running, it is not very useful if no data plane nodes are
talking to it and serving traffic (remember control plane nodes can not be used
for proxying). To start the data plane, all we need to do is to specify the "role"
to "data\_plane", give it the address and port of where the control plane can be reached
and the node automatically connects and syncs itself up with the current configuration.

Similar to the CP config above, `cluster_cert` and `cluster_cert_key` configuration need to
point to the same files as the CP has. In addition, the certificate from `cluster_cert`
(in "shared" mode) or `cluster_ca_cert` (in "pki" mode) is automatically added to the trusted
chain in `lua_ssl_trusted_certificate`.

**Note:** In this release of the Hybrid Mode, the data plane receives updates from the Control
Plane via a format that is similar to the Declarative Config, therefore the `database`
property has to be set to `off` for Kong to start up properly.

```
KONG_ROLE=data_plane KONG_CLUSTER_CONTROL_PLANE=control-plane.example.com:8005 KONG_CLUSTER_CERT=cluster.crt KONG_CLUSTER_CERT_KEY=cluster.key KONG_DATABASE=off kong start
```

Or in `kong.conf`:

```
role = data_plane
cluster_control_plane = control-plane.example.com:8005
database = off
cluster_cert = cluster.crt
cluster_cert_key = cluster.key
```

### DP Node Start Sequence

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


## Checking the status of the cluster

<div class="alert alert-warning">
  <strong>If you used Hybrid mode before Kong 2.2:</strong>
  The original `/clustering/status` endpoint has been deprecated and will
  not contain all values as returned by the new Admin API endpoint below. Eventually,
  the `/clustering/status` endpoint will be removed and it is strongly
  recommended to now use the `/clustering/data-planes` endpoint
  instead.
</div>

You may want to check the status of the Kong cluster from time to time, such as
checking to see the which nodes are actively receiving config updates from
control plane, or when was it last updated. This can be achieved by using the
control plane's new Cluster Status API:

```
# on control plane node
http :8001/clustering/data-planes


{
    "data": [
        {
            "config_hash": "a9a166c59873245db8f1a747ba9a80a7",
            "hostname": "data-plane-2",
            "id": "ed58ac85-dba6-4946-999d-e8b5071607d4",
            "ip": "192.168.10.3",
            "last_seen": 1580623199,
            "ttl": 1139376,
            "version": "2.2.1",
        },
        {
            "config_hash": "a9a166c59873245db8f1a747ba9a80a7",
            "hostname": "data-plane-1",
            "id": "ed58ac85-dba6-4946-999d-e8b5071607d4",
            "ip": "192.168.10.4",
            "last_seen": 1580623200,
            "ttl": 1139377,
            "version": "2.3.0",
        }
    ],
    "next": null
}
```

The Cluster Status API provides helpful information such as
the name of the node and last time it synced with the control plane, as
well as config version currently running on them.

## Managing the cluster using Control Plane nodes

Once the nodes are setup, use the Admin API on the control plane as usual,
those changes will be synced and updated on the data plane nodes
automatically within seconds.

### Version compatibility

{{site.ce_product_name}} control planes only allow connections from data planes
with the same major version.
Control planes won't allow connections from data planes with newer minor versions.

For example, a {{site.ce_product_name}} v2.5.2 control plane:

- Accepts a {{site.ce_product_name}} 2.5.0, 2.5.1 and 2.5.2 data plane
- Accepts a {{site.ce_product_name}} 2.3.8, 2.2.1 and 2.2.0 data plane
- Accepts a {{site.ce_product_name}} 2.5.3 data plane (newer patch version on the data plane is accepted)
- Rejects a {{site.ce_product_name}} 1.0.0 data plane (major version differs)
- Rejects a {{site.ce_product_name}} 2.6.0 data plane (minor version on data plane is newer)

Furthermore, for every plugin that is configured on the {{site.ce_product_name}}
control plane, new configs are only pushed to data planes that have those configured
plugins installed and loaded. The major version of those configured plugins must
be the same on both the control planes and data planes. Also, the minor versions of the plugins on the data planes
could not be newer than versions installed on the control planes. Note that similar to
{{site.ce_product_name}} version checks, plugin patch versions are also ignored
when determining the compatibility.

{:.important}
> Configured plugins means any plugin that is either enabled globally or configured by Services, Routes, or Consumers.

For example, if a {{site.ce_product_name}} control plane has `plugin1` v1.1.1
and `plugin2` v2.1.0 installed, and `plugin1` is configured by a `Route` object:

- It accepts {{site.ce_product_name}} data planes with `plugin1` v1.1.2,
and `plugin2` not installed.
- It accepts {{site.ce_product_name}} data planes with `plugin1` v1.1.2,
`plugin2` v2.1.0, and  `plugin3` v9.8.1 installed.
- It rejects {{site.ce_product_name}} data planes with `plugin1` v1.2.0,
 and `plugin2` v2.1.0 installed (minor version of plugin on data plane is newer).
- It accepts {{site.ce_product_name}} data planes with `plugin1` v1.1.1,
 and `plugin3` v9.8.1 installed.
- It rejects {{site.ce_product_name}} data planes with `plugin1` not installed
(plugin configured on control plane but not installed on data plane).

If the compatibility checks fail, the control plane stops
pushing out new configs to the incompatible data planes to avoid breaking them.

When new configs are sent from control planes to data planes, the data planes
run their own schema validator against a control plane supplied DB-less config. Data planes
reject any config that does not pass the schema validation.

One exception to the validation on data planes is that if the value of a control plane
supplied field is `null` and the data plane's schema does not have information about
this `null` valued field, then the field is simply ignored.

If a config can not be pushed to a data plane due to failure of the
compatibility checks, the control plane will contain `warn` level lines in the
`error.log` similar to the following:
```
unable to send updated configuration to DP node with hostname: localhost.localdomain ip: 127.0.0.1 reason: version mismatches, CP version: 2.2 DP version: 2.1
unable to send updated configuration to DP node with hostname: localhost.localdomain ip: 127.0.0.1 reason: CP and DP does not have same set of plugins installed or their versions might differ
```

In addition, the `/clustering/data-planes` Admin API endpoint will return
the version of the data plane node and the latest config hash the node is
using. These will help detect version incompatibilities from the
control plane side.

## Fault tolerance

A valid question you may ask is: What would happen if control plane nodes are down,
will the data plane keep functioning? The answer is yes. Data plane caches
the latest configuration it received from the control plane on the local disk.
In case the control plane stops working, the data plane will keep serving requests using
cached configurations. It does so while constantly trying to reestablish communication
with the control plane.

This means that the Data Plane nodes can be stopped even for extended periods
of time, and the Data Plane will still proxy traffic normally.  Data Plane
nodes can be restarted while in disconnected mode, and will load the last
configuration in the cache to start working. When the Control Plane is brought
up again, the Data Plane nodes will contact them and resume connected mode.

### Disconnected Mode

The viability of the Data Plane while disconnected means that Control Plane
updates or database restores can be done with peace of mind. First bring down
the Control Plane, perform all required downtime processes, and only bring up
the Control Plane after verifying the success and correctness of the procedure.
During that time, the Data Plane will keep working with the latest configuration.

A new Data Plane node can be provisioned during Control Plane downtime. This
requires either copying the config cache file (`config.json.gz`) from another
Data Plane node, or using a declarative configuration. In either case, if it
has the role of `"data_plane"`, it will also keep trying to contact the Control
Plane until it's up again.

To change a disconnected Data Plane node's configuration, you have to remove
the config cache file (`config.json.gz`), ensure the `declarative_config`
parameter or the `KONG_DECLARATIVE_CONFIG` environment variable is set, and set
the whole configuration in the referenced YAML file.

## Limitations

### Plugins compatibility

This version of Hybrid Mode uses declarative config as the config sync format which
means it has the same limitations as declarative config as of today. Please refer
to the [Plugin Compatibility section][plugin-compat]
of declarative config documentation for more information.

## Readonly Status API endpoints on Data Plane

Several readonly endpoints from the [Admin API](/gateway-oss/{{page.kong_version}}/admin-api)
are exposed to the [Status API](/gateway-oss/{{page.kong_version}}/configuration/#status_listen) on data planes, including the following:

- GET /upstreams/{upstream}/targets/
- [GET /upstreams/{upstream}/health/](/gateway-oss/{{page.kong_version}}/admin-api/#show-upstream-health-for-node)
- [GET /upstreams/{upstream}/targets/all/](/gateway-oss/{{page.kong_version}}/admin-api/#list-all-targets)
- GET /upstreams/{upstream}/targets/{target}

Please refer to [Upstream objects](/gateway-oss/{{page.kong_version}}/admin-api/#upstream-object) in the Admin API documentation for more information about the
endpoints.

---

[plugin-compat]: /gateway-oss/{{page.kong_version}}/db-less-and-declarative-config#plugin-compatibility
[db-less]: /gateway-oss/{{page.kong_version}}/db-less-and-declarative-config
