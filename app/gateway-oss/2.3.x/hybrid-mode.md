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

In this mode Kong nodes in a cluster are separated into two roles: Control Plane (CP), where configuration is managed and the Admin API is served from,
and Data Plane (DP), which serves traffic for the proxy. Each DP node is connected to one of the CP nodes. Instead of accessing the
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
`cluster_listen` *Optional* | List of addresses and ports on which the Control Plane will listen for incoming Data Plane connections. Defaults to `0.0.0.0:8005`. Note this port is always protected with Mutual TLS (mTLS) encryption. Ignored on Data Plane nodes.
`cluster_control_plane` *Required* | Address and port that the Data Plane nodes use to connect to the Control Plane. Must point to the port configured using the `cluster_listen` property on the Control Plane node. Ignored on Control Plane nodes.
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

Starting the Control Plane is fairly simple. Aside from the database configuration
which is the same as today, we need to specify the "role" of the node to "control\_plane".
This will cause Kong to listen on `0.0.0.0:8005` by default for Data Plane
connections. The `8005` port on the Control Plane will need to be
accessible by all the Data Plane it controls through any firewalls you may have
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

Note that Control Plane still needs a database (Postgres or Cassandra) to store the
"source of truth" configurations, although the database never needs to be access by
Data Plane nodes. You may run more than a single Control Plane nodes to provide load balancing
and redundancy as long as they points to the same backend database.

## PKI mode

Starting in Kong 2.1, the Hybrid cluster can use certificates signed by a central certificate authority (CA).
This mode can be activated by setting `cluster_mtls` to `"pki"` in `kong.conf`. The default value is `"shared"`.

In PKI mode, the Control Plane and Data Plane don't need to use the same `cluster_cert` and `cluster_cert_key`.
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

Set the following configuration parameters in `kong.conf` on the Control Plane:

```
cluster_mtls = pki
cluster_ca_cert = /path/to/ca-cert.crt
cluster_cert = control-plane.crt
cluster_cert_key = control-plane.key
```

`cluster_ca_cert` specifies the root CA certificate for `cluster_cert` and `cluster_cert_key`. This
certificate must be the root CA certificate and not any of an intermediate CA.
Kong allows at most `3` levels of intermediate CAs to be used between the root CA and the cluster certificate.

Set the following configuration parameters in `kong.conf` on the Data Plane:

```
cluster_mtls = pki
cluster_server_name = control-plane.kong.yourcorp.tld
cluster_cert = data-plane.crt
cluster_cert_key = data-plane.crt
```

`cluster_server_name` specifies the SNI (Server Name Indication extension) to use for Data Plane
connections to the Control Plane through TLS. When not set, Data Plane will use `kong_clustering` as the SNI.


## Starting Data Plane Nodes

Now we have a Control Plane running, it is not much useful if no Data Plane nodes are
talking to it and serving traffic (remember Control Plane nodes can not be used
for proxying). To start the Data Plane, all we need to do is to specify the "role"
to "data\_plane", give it the address and port of where the Control Plane can be reached
and the node automatically connects and syncs itself up with the current configuration.

Similar to the CP config above, `cluster_cert` and `cluster_cert_key` configuration need to
point to the same files as the CP has. In addition the `cluster.crt` file need to be listed
as trusted by OpenResty through the `lua_ssl_trusted_certificate` configuration. If you
have already specified a different `lua_ssl_trusted_certificate`, then adding the content
of `cluster.crt` into that file will achieve the same result.

**Note:** In this release of the Hybrid Mode, the Data Plane receives updates from the Control
Plane via a format that is similar to the Declarative Config, therefore the `database`
property has to be set to `off` for Kong to start up properly.

```
KONG_ROLE=data_plane KONG_CLUSTER_CONTROL_PLANE=control-plane.example.com:8005 KONG_CLUSTER_CERT=cluster.crt KONG_CLUSTER_CERT_KEY=cluster.key KONG_LUA_SSL_TRUSTED_CERTIFICATE=cluster.crt KONG_DATABASE=off kong start
```

Or in `kong.conf`:

```
role = data_plane
cluster_control_plane = control-plane.example.com:8005
database = off
cluster_cert = cluster.crt
cluster_cert_key = cluster.key
lua_ssl_trusted_certificate = cluster.crt
```

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
Control Plane, or when was it last updated. This can be achieved by using the
Control Plane's new Cluster Status API:

```
# on Control Plane node
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
the name of the node and last time it synced with the Control Plane, as
well as config version currently running on them.

## Managing the cluster using Control Plane nodes

Once the nodes are setup, use the Admin API on the Control Plane as usual,
those changes will be synced and updated on the Data Plane nodes
automatically within seconds.

## Version and compatibility checks

Starting with Kong Gateway 2.3.0, Control Plane nodes can perform version 
compatibility checks to determine if connected Data Planes can be
synced safely. If the compatibility checks fail, the Control Plane stops
pushing out new config to the incompatible Data Planes to avoid breaking them.

The following conditions must be met for new configs being pushed to the Data
Plane:
1. The Kong Gateway version must be on the same major and minor release for both 
Control Plane and Data Planes, and only the patch version can vary.
For example, sync between Kong 2.2.0 and Kong 2.3.0 will fail, but sync between Kong 
2.3.0 and Kong 2.3.2 should succeed. 
2. The set of plugins enabled on the Control Plane and Data Plane must be
the same.
3. For enabled plugins, the plugin version number must be the same on both the 
Control Plane and Data Planes. This check is more strict than the Kong Gateway 
version check, as the plugin versions must match exactly, down to the patch level.  
For example, if `foo-plugin` has version 0.1.2 on the Control Plane and 0.1.1 on a 
Data Plane, sync will not happen.

If a config can not be pushed to a Data Plane due to failure of the
compatibility checks, the Control Plane will contain `warn` level lines in the
`error.log` similar to the following:
```
unable to send updated configuration to DP node with hostname: localhost.localdomain ip: 127.0.0.1 reason: version mismatches, CP version: 2.2 DP version: 2.1
unable to send updated configuration to DP node with hostname: localhost.localdomain ip: 127.0.0.1 reason: CP and DP does not have same set of plugins installed or their versions might differ
```

In addition, the `/clustering/data-planes` Admin API endpoint will return
the version of the Data Plane node and the latest config hash the node is
using. These will help detect version incompatibilities from the
Control Plane side.

## Fault tolerance

A valid question you may ask is: What would happen if Control Plane nodes are down,
will the Data Plane keep functioning? The answer is yes. Data plane caches
the latest configuration it received from the Control Plane on the local disk.
In case Control Plane stops working, Data Plane will keep serving requests using
cached configurations. It does so while constantly trying to reestablish communication
with the Control Plane.

This means that the Data Plane nodes can be restarted while the Control Plane
is down, and still proxy traffic normally.

## Limitations

### Plugins compatibility

This version of Hybrid Mode uses declarative config as the config sync format which
means it has the same limitations as declarative config as of today. Please refer
to the [Plugin Compatibility section][plugin-compat]
of declarative config documentation for more information.

---

[plugin-compat]: /{{page.kong_version}}/db-less-and-declarative-config#plugin-compatibility
[db-less]: /{{page.kong_version}}/db-less-and-declarative-config
