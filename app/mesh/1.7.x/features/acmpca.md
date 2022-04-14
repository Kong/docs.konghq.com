---
title: Kong Mesh - ACM Private CA Policy
---

## Amazon Certificate Manager Private CA Backend

The default [mTLS policy in Kuma](https://kuma.io/docs/latest/policies/mutual-tls/)
supports the following backends:

* `builtin`: {{site.mesh_product_name}} automatically generates the Certificate
Authority (CA) root certificate and key that will be used to generate the data
plane certificates.
* `provided`: the CA root certificate and key can be provided by the user.

{{site.mesh_product_name}} adds:

* [`vault`](/mesh/{{page.kong_version}}/features/vault): {{site.mesh_product_name}} generates data plane certificates
using a CA root certificate and key stored in a HashiCorp Vault
server.

* `acmpca`: {{site.mesh_product_name}} generates data plane certificates
using Amazon Certificate Manager Private CA.

## ACM Private CA mode

In `acmpca` mTLS mode, {{site.mesh_product_name}} communicates with the Amazon Certificate Manager,
which generates the data plane proxy certificates automatically.
{{site.mesh_product_name}} does not retrieve any CA private keys,
which means that the private key of the CA is secured by Amazon ACM and not exposed to third parties.

In `acmpca` mode, you point {{site.mesh_product_name}} to the
ACM resource and optionally provide an authentication method. {{site.mesh_product_name}}
will use the default AWS credential chain to authenticate.

When {{site.mesh_product_name}} is running in `acmpca` mode, the backend communicates with AWS ACM
and ensures data plane certificates are issued and rotated for each proxy.

### Configure ACM Private CA

The `acmpca` mTLS backend requires a configured ACM Private CA resource to be accessible.

The following steps show how to configure ACM Private CA for {{site.mesh_product_name}} with
 a mesh named `default`. For your environment, replace `default` with the appropriate mesh name.

{{site.mesh_product_name}} works with a Root CA or an Intermediate CA.

See [ACM Private CA documentation](https://aws.amazon.com/certificate-manager/private-certificate-authority/) to learn how to create an ACM Private CA in AWS.

Once created, you will need the ARN of the Private CA and the Root Certificate Chain to configure
{{site.mesh_product_name}}.

### Configure Mesh

#### Authentication and AWS Client Configuration
`kuma-cp` communicates directly with ACM Private CA. `kuma-cp` will use the default ordering
of AWS credential chain to authenticate. It will search for credentials in environment
variables, configuration files and EC2 / IRSA roles. In addition to credentials, AWS configuration
may be specified in standard environment variables, such as AWS_REGION.

AWS credentials may also be supplied as secrets stored by {{site.mesh_product_name}}.

#### ACMPCA mTLS Configuration

AWS credentials and CA Certificate may be supplied inline, as a path to a file on the
same host as `kuma-cp`, or contained in a `secret`. Inline specification of credentials should
be used for testing purposes only.
When using a `secret`, it should be a mesh-scoped 
secret (see [the Kuma Secrets documentation](https://kuma.io/docs/latest/security/secrets/) for details 
on mesh-scoped secrets versus global secrets). On Kubernetes, this mesh-scoped secret should be stored 
in the system namespace (`kong-mesh-system` by default) and should be configured as `type: system.kuma.io/secret`.

Here's an example of a configuration with a `acmpca`-backed CA:

{% navtabs %}
{% navtab Kubernetes %}

```yaml
apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  mtls:
    enabledBackend: acmpca-1
    backends:
      - name: acmpca-1
        type: acmpca
        dpCert:
          rotation:
            expiration: 1d
        conf:
          arn: "arn:aws:acm-pca:region:account:certificate-authority/12345678-1234-1234-1234-123456789012" # AWS ARN of the Private CA
          commonName: {% raw %}'{{ tag "kuma.io/service" }}.mesh'{% endraw %} # optional. If set, then commonName is added to the certificate. You can use "tag" directive to pick a tag which will be base for commonName. If unset, a Subject Alternative Name may be duplicated as Common Name.
          caCert:             # caCert is used to verify the TLS certificate presented by ACM.
            secret: sec-1     # one of file, secret or inline.
          auth: # Optional AWS authentication keys. If unset, default credential chain locations are searched.
            awsCredentials:
              accessKey:
                secret: sec-2  # one of file, secret or inline.
              accessKeySecret:
                file: /tmp/accesss_key.txt # one of file, secret or inline.
```

Apply the configuration with `kubectl apply -f [..]`.

{% endnavtab %}
{% navtab Universal %}

```yaml
type: Mesh
name: default
mtls:
  enabledBackend: acmpca-1
  backends:
  - name: acmpca-1
    type: acmpca
    dpCert:
      rotation:
        expiration: 24h
    conf:
      arn: "arn:aws:acm-pca:region:account:certificate-authority/12345678-1234-1234-1234-123456789012" # AWS ARN of the Private CA
      commonName: {% raw %}'{{ tag "kuma.io/service" }}.mesh'{% endraw %} # optional. If set, then commonName is added to the certificate. You can use "tag" directive to pick a tag which will be base for commonName. If unset, a Subject Alternative Name may be duplicated as Common Name.
      caCert:              # caCert is used to verify the TLS certificate presented by ACM.
        secret: sec-1      # one of file, secret or inline.
      auth:  # Optional AWS authentication keys. If unset, default credential chain locations are searched.
        awsCredentials:
          accessKey:
            secret: sec-2  # one of file, secret or inline.
          accessKeySecret:
            file: /tmp/accesss_key.txt # one of file, secret or inline.
```

Apply the configuration with `kumactl apply -f [..]`, or with the [HTTP API](https://kuma.io/docs/latest/reference/http-api).

{% endnavtab %}
{% endnavtabs %}

## Multizone and ACM Private CA

In a multizone environment, the global control plane provides the `Mesh` to the zone control planes. However, you must make sure that each zone control plane can communicate with ACM Private CA. This is because certificates for data plane proxies are requested from ACM Private CA by the zone control plane, not the global control plane.

You must also make sure the global control plane can communicate with ACM Private CA. When a new `acmpca` backend is configured, {{site.mesh_product_name}} validates the connection by issuing a test certificate. In a multizone environment, validation is performed on the global control plane.
