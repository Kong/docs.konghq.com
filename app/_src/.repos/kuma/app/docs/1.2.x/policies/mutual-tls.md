---
title: Mutual TLS
---

This policy enables automatic encrypted mTLS traffic for all the services in a [`Mesh`](/docs/{{ page.version }}/policies/mesh), as well as assigning an identity to every data plane proxy. Kuma supports different types of CA backends as well as automatic certificate rotation.

Kuma ships with the following CA (Certificate Authority) supported backends:

* [builtin](#usage-of-builtin-ca): it automatically auto-generates a CA root certificate and key, that are also being automatically stored as a [Secret](/docs/{{ page.version }}/security/secrets/).
* [provided](#usage-of-provided-ca): the CA root certificate and key are being provided by the user in the form of a [Secret](/docs/{{ page.version }}/documentation/secrets).

Once a CA backend has been specified, Kuma will then automatically generate a certificate for every data plane proxy in the [`Mesh`](/docs/{{ page.version }}/policies/mesh). The certificates that Kuma generates are SPIFFE compatible and are used for AuthN/Z use-cases in order to identify every workload in our system. 

{% tip %}
The certificates that Kuma generates have a SAN set to `spiffe://<mesh name>/<service name>`. When Kuma enforces policies that require an identity like [`TrafficPermission`](/docs/{{ page.version }}/traffic-permissions) it will extract the SAN from the client certificate and use it to match the service identity.
{% endtip %}

Remember that by default mTLS **is not** enabled and needs to be explicitly enabled as described below. Also remember that by default when mTLS is enabled all traffic is denied **unless** a [`TrafficPermission`](/docs/{{ page.version }}/traffic-permissions) policy is being configured to explicitly allow traffic across proxies.

{% tip %}
Always make sure that a [`TrafficPermission`](/docs/{{ page.version }}/traffic-permissions) resource is present before enabling mTLS in a Mesh in order to avoid unexpected traffic interruptions caused by a lack of authorization between proxies.
{% endtip %}

To enable mTLS we need to configure the `mtls` property in a [`Mesh`](/docs/{{ page.version }}/policies/mesh) resource. We can have as many `backends` as we want, but only one at a time can be enabled via the `enabledBackend` property. 

If `enabledBackend` is missing or empty, then mTLS will be disabled for the entire Mesh.

## Usage of "builtin" CA

This is the fastest and simplest way to enable mTLS in Kuma.

With a `builtin` CA backend type, Kuma will dynamically generate its own CA root certificate and key that it uses to automatically provision (and rotate) certificates for every replica of every service.

We can specify more than one `builtin` backend with different names, and each one of them will be automatically provisioned with a unique pair of certificate + key (they are not shared).

To enable a `builtin` mTLS for the entire Mesh we can apply the following configuration:

{% tabs usage useUrlFragment=false %}
{% tab usage Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  mtls:
    enabledBackend: ca-1
    backends:
      - name: ca-1
        type: builtin
        dpCert:
          rotation:
            expiration: 1d
        conf:
          caCert:
            RSAbits: 2048
            expiration: 10y
```

We will apply the configuration with `kubectl apply -f [..]`.
{% endtab %}

{% tab usage Universal %}
```yaml
type: Mesh
name: default
mtls:
  enabledBackend: ca-1
  backends:
    - name: ca-1
      type: builtin
      dpCert:
        rotation:
          expiration: 1d
      conf:
        caCert:
          RSAbits: 2048
          expiration: 10y
```

We will apply the configuration with `kumactl apply -f [..]` or via the [HTTP API](/docs/{{ page.version }}/documentation/http-api).
{% endtab %}
{% endtabs %}

A few considerations:

* The `dpCert` configuration determines how often Kuma should automatically rotate the certificates assigned to every data plane proxy.
* The `caCert` configuration determines a few properties that Kuma will use when auto-generating the CA root certificate.

### Storage of Secrets

When using a `builtin` backend Kuma automatically generates a root CA certificate and key that are being stored as a Kuma [Secret resource](/docs/{{ page.version }}/documentation/secrets) with the following name:

* `{mesh name}.ca-builtin-cert-{backend name}` for the certificate
* `{mesh name}.ca-builtin-key-{backend name}` for the key

On Kubernetes, Kuma secrets are being stored in the `kuma-system` namespace, while on Universal they are being stored in the underlying [backend](/docs/{{ page.version }}/documentation/backends) configured in `kuma-cp`.

We can retrieve the secrets via `kumactl` on both Universal and Kubernetes, or via `kubectl` on Kubernetes only:

{% tabs secrets-storage useUrlFragment=false %}
{% tab secrets-storage kumactl %}

The following command can be executed on any Kuma backend:

```sh
kumactl get secrets [-m MESH]
# MESH      NAME                           AGE
# default   default.ca-builtin-cert-ca-1   1m
# default   default.ca-builtin-key-ca-1    1m
```
{% endtab %}
{% tab secrets-storage kubectl %}

The following command can be executed only on Kubernetes:

```sh
kubectl get secrets \
    -n kuma-system \
    --field-selector='type=system.kuma.io/secret'
# NAME                             TYPE                                  DATA   AGE
# default.ca-builtin-cert-ca-1     system.kuma.io/secret                 1      1m
# default.ca-builtin-key-ca-1      system.kuma.io/secret                 1      1m
```
{% endtab %}
{% endtabs %}

## Usage of "provided" CA

If you choose to provide your own CA root certificate and key, you can use the `provided` backend. With this option, you must also manage the certificate lifecycle yourself.

Unlike the `builtin` backend, with `provided` you first upload the certificate and key as [Secret resources](/docs/{{ page.version }}/documentation/secrets), and then reference the Secrets in the mTLS configuration.

Kuma then provisions data plane proxy certificates for every replica of every service from the CA root certificate and key.

Sample configuration:

{% tabs sample-configuration useUrlFragment=false %}
{% tab sample-configuration Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  mtls:
    enabledBackend: ca-1
    backends:
      - name: ca-1
        type: provided
        dpCert:
          rotation:
            expiration: 1d
        conf:
          cert:
            secret: name-of-secret
          key:
            secret: name-of-secret
```

We will apply the configuration with `kubectl apply -f [..]`.
{% endtab %}

{% tab sample-configuration Universal %}
```yaml
type: Mesh
name: default
mtls:
  enabledBackend: ca-1
  backends:
    - name: ca-1
      type: provided
      dpCert:
        rotation:
          expiration: 1d
      conf:
        cert:
          secret: name-of-secret
        key:
          secret: name-of-secret
```

We will apply the configuration with `kumactl apply -f [..]` or via the [HTTP API](/docs/{{ page.version }}/documentation/http-api).
{% endtab %}
{% endtabs %}

A few considerations:

* The `dpCert` configuration determines how often Kuma should automatically rotate the certificates assigned to every data plane proxy.
* The Secrets must exist before referencing them in a `provided` backend.

### CA requirements

When using an arbitrary certificate and key for a `provided` backend, we must make sure that we comply with the following requirements:

1. It MUST be a self-signed Root CA certificate (Intermediate CA certificates are not allowed)
2. It MUST have basic constraint `CA` set to `true` (see [X509-SVID: 4.1. Basic Constraints](https://github.com/spiffe/spiffe/blob/master/standards/X509-SVID.md#41-basic-constraints))
3. It MUST have key usage extension `keyCertSign` set (see [X509-SVID: 4.3. Key Usage](https://github.com/spiffe/spiffe/blob/master/standards/X509-SVID.md#43-key-usage))
4. It MUST NOT have key usage extension 'digitalSignature' set (see [X509-SVID: Appendix A. X.509 Field Reference](https://github.com/spiffe/spiffe/blob/master/standards/X509-SVID.md#appendix-a-x509-field-reference))
5. It MUST NOT have key usage extension 'keyAgreement' set (see [X509-SVID: Appendix A. X.509 Field Reference](https://github.com/spiffe/spiffe/blob/master/standards/X509-SVID.md#appendix-a-x509-field-reference))
6. It MUST NOT have key usage extension 'keyEncipherment' set (see [X509-SVID: Appendix A. X.509 Field Reference](https://github.com/spiffe/spiffe/blob/master/standards/X509-SVID.md#appendix-a-x509-field-reference))

{% warning %}
Do not use the following example in production, instead generate valid and compliant certificates. This example is intended for usage in a development environment.
{% endwarning %}

Below we can find an example to generate a sample CA certificate + key:

{% tabs sample-certificate useUrlFragment=false %}
{% tab sample-certificate openssl %}

The following command will generate a CA root certificate and key that can be uploaded to Kuma as a Secret and then used in a `provided` mTLS backend:

```sh
SAMPLE_CA_CONFIG="
[req]
distinguished_name=dn
[ dn ]
[ ext ]
basicConstraints=CA:TRUE,pathlen:0
keyUsage=keyCertSign
"

openssl req -config <(echo "$SAMPLE_CA_CONFIG") -new -newkey rsa:2048 -nodes \
  -subj "/CN=Hello" -x509 -extensions ext -keyout key.pem -out crt.pem
```

The command will generate a certificate at `crt.pem` and the key at `key.pem`. We can generate the Kuma Secret resources by following the [Secret reference](/docs/{{ page.version }}/documentation/secrets).

{% endtab %}
{% endtabs %}

### Development Mode

In development mode we may want to provide the `cert` and `key` properties of the `provided` backend without necessarily having to create a Secret resource, but by using either a file or an inline value.

{% warning %}
Using the `file` and `inline` modes in production presents a security risk since it makes the values of our CA root certificate and key more easily accessible from a malicious actor. We highly recommend using `file` and `inline` only in development mode.
{% endwarning %}

Kuma offers an alternative way to specify the CA root certificate and key:

{% tabs root-certificate useUrlFragment=false %}
{% tab root-certificate Kubernetes %}

Please note the `file` and `inline` properties that are being used instead of `secret`:

```yaml
apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  mtls:
    enabledBackend: ca-1
    backends:
    - name: ca-1
      type: provided
      conf:
        cert:
          inline: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURHekNDQWdPZ0F3S... # cert in Base64
        key:
          file: /opt/cert.key
```

{% endtab %}

{% tab root-certificate Universal %}

Please note the `file` and `inline` properties that are being used instead of `secret`:

```yaml
type: Mesh
name: default
mtls:
  enabledBackend: ca-1
  backends:
  - name: ca-1
    type: provided
    conf:
      cert:
        inline: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSURHekNDQWdPZ0F3S... # cert in Base64
      key:
        file: /opt/cert.key
```
{% endtab %}
{% endtabs %}

## Certificate Rotation

Once a CA backend has been configured, Kuma will utilize the CA root certificate and key to automatically provision a certificate for every data plane proxy that it connects to `kuma-cp`.

Unlike the CA certificate, the data plane proxy certificates are not permanently stored anywhere but they only reside in memory. These certificates are designed to be short-lived and rotated often by Kuma.

By default, the expiration time of a data plane proxy certificate is `30` days. Kuma rotates these certificates automatically after 4/5 of the certificate validity time (ie: for the default `30` days expiration, that would be every `24` days).

You can update the duration of the data plane proxy certificates by updating the `dpCert` property on every available mTLS backend.

You can inspect the certificate rotation statistics by executing the following command (supported on both Kubernetes and Universal):

{% tabs certificate-rotation useUrlFragment=false %}
{% tab certificate-rotation kumactl %}

We can use the Kuma CLI:

```sh
kumactl inspect dataplanes
# MESH      NAME     TAGS          STATUS   LAST CONNECTED AGO   LAST UPDATED AGO   TOTAL UPDATES   TOTAL ERRORS   CERT REGENERATED AGO   CERT EXPIRATION       CERT REGENERATIONS
# default   web-01   service=web   Online   5s                   3s                 4               0              3s                     2020-05-11 16:01:34   2
```

Please note the `CERT REGENERATED AGO`, `CERT EXPIRATION`, `CERT REGENERATIONS` columns.

{% endtab %}
{% tab certificate-rotation HTTP API %}

We can use the Kuma HTTP API by retrieving the [Dataplane Insight](/docs/{{ page.version }}/documentation/http-api/#dataplane-overviews) resource and inspecting the `dataplaneInsight` object.

```json
...
dataplaneInsight": {
  ...
  "mTLS": {
    "certificateExpirationTime": "2020-05-14T20:15:23Z",
    "lastCertificateRegeneration": "2020-05-13T20:15:23.994549539Z",
    "certificateRegenerations": 1
  }
}
...
```

{% endtab %}
{% endtabs %}

A new data plane proxy certificate is automatically generated when:

* A data plane proxy is restarted.
* The control plane is restarted.
* The data plane proxy connects to a new control plane.
