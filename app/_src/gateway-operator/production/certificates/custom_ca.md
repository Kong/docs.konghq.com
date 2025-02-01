---
title: Custom CA Certificates
---

{{ site.kgo_product_name }} uses a CA certificate to sign the certificates used by the `ControlPlane` and `DataPlane` components (for example, for securing Kong's Admin API).
This CA certificate is retrieved from a Kubernetes Secret as configured via `--cluster-ca-secret` and `--cluster-ca-secret-namespace` flags.

By default, the operator uses a self-signed CA certificate generated during the startup process.
However, you can provide your own CA certificate to the operator by creating a Kubernetes `Secret` with the CA certificate.

## Create a Kubernetes Secret

To provide your own CA certificate to the operator, you need to create a Kubernetes `Secret` containing the CA certificate and key.

This `Secret` has to contain the following fields:

- `tls.crt`: The CA certificate
- `tls.key`: The private key of the CA certificate

{% if_version gte: 1.5.x %}
### Configure the private key algorithm

You can specify the private key algorithm used to sign the certificates with the `--cluster-ca-key-type` flag.

It currently supports the following values:

- `ecdsa`
- `rsa`

When this flag is set to `rsa`, you can also set the `--cluster-ca-key-size` flag to specify the size of the RSA key.

{% endif_version %}

### Supported private key algorithms

Operator supports the following private key algorithms, which can be used to sign the certificates:

- ECDSA: When this algorithm is used, Operator will use the [`ECDSAWithSHA256`][gopkg_ecdsa_sha256]
  signature algorithm to sign the certificates.
{% if_version gte: 1.5.x %}
- RSA: When this algorithm is used, Operator will use the [`SHA256WithRSA`][gopkg_rsa_sha256] signature algorithm to sign the certificates.
{% endif_version %}

[gopkg_ecdsa_sha256]: https://pkg.go.dev/crypto/x509#ECDSAWithSHA256
[gopkg_rsa_sha256]: https://pkg.go.dev/crypto/x509#SHA256WithRSA
