---
title: Kubernetes cert-manager CA Policy
---

## cert-manager CA Backend

The default [mTLS policy in {{site.mesh_product_name}}][mtls-policy]
supports the following backends:

* `builtin`: {{site.mesh_product_name}} automatically generates the Certificate
Authority (CA) root certificate and key that will be used to generate the data
plane certificates.
* `provided`: the CA root certificate and key can be provided by the user.

{{site.mesh_product_name}} adds:

* [`vault`](/mesh/{{page.release}}/features/vault/): {{site.mesh_product_name}} generates data plane certificates
using a CA root certificate and key stored in a HashiCorp Vault
server.
* [`acmpca`](/mesh/{{page.release}}/features/acmpca/): {{site.mesh_product_name}} generates data plane certificates
using Amazon Certificate Manager Private CA.
* `certmanager`: {{site.mesh_product_name}} generates data plane certificates
using Kubernetes [cert-manager](https://cert-manager.io) certificate controller.

## Kubernetes cert-manager CA mode

In `certmanager` mTLS mode, {{site.mesh_product_name}} communicates with a locally installed cert-manager `Issuer`,
which generates the data plane proxy certificates automatically.
{{site.mesh_product_name}} does not retrieve any CA private keys,
which means that the private key of the CA is secured by cert-manager itself,
or an upstream CA,
and not exposed to third parties.

In `certmanager` mode, you provide {{site.mesh_product_name}} with a cert-manager `Issuer`
or `ClusterIssuer` reference. {{site.mesh_product_name}} will communicate with cert-manager
via Kubernetes resources which reference the `Issuer` or `ClusterIssuer`.

When {{site.mesh_product_name}} is running in `certmanager` mode, the backend communicates with cert-manager
and ensures data plane certificates are issued and rotated for each proxy.

`certmanager` is only available for {{site.mesh_product_name}} in the Kubernetes environment.

### Configure Kubernetes cert-manager CA

The `certmanager` mTLS backend requires a cert-manager `Issuer` or `ClusterIssuer` to be accessible
from the {{site.mesh_product_name}} system namespace.
A `ClusterIssuer` is accessible from the entire Kubernetes `cluster`.
An `Issuer` is only accessible from within its own namespace,
and must reside in the {{site.mesh_product_name}} system namespace
o be available to {{site.mesh_product_name}}.
The {{site.mesh_product_name}} system namespace is `kong-mesh-system` by default.

If the cert-manager is configured outside of the {{site.mesh_product_name}} system namespace,
and `ClusterIssuer` is not used,
this may require cert-manager configuration and secrets to be "reflected" into the `Issuer`
in the {{site.mesh_product_name}} system namespace. See [cert-manager documentation](https://cert-manager.io/docs/faq/sync-secrets/) for details.

The following steps show how to configure cert-manager for {{site.mesh_product_name}} with
a mesh named `default`. For your environment, replace `default` with the appropriate mesh name.

See [cert-manager.io](https://cert-manager.io) to learn how to
install and configure cert-manager.

Once created, you will need the `IssuerRef` information of the `Issuer` or `ClusterIssuer`
to configure {{site.mesh_product_name}}

### Configure Mesh

Here's an example of mTLS configuration with `certmanager` backend
which references an `Issuer` named `my-ca-issuer`:

```yaml
apiVersion: kuma.io/v1alpha1
kind: Mesh
metadata:
  name: default
spec:
  mtls:
    enabledBackend: certmanager-1
    backends:
    - name: certmanager-1
      type: certmanager
      dpCert:
        rotation:
          expiration: 24h
      conf:
        issuerRef:
          name: my-ca-issuer
          kind: Issuer
          group: cert-manager.io
```

In `issuerRef`, only `name` is strictly required.
`group` and `kind` will default to cert-manager default values. See `issuerRef` in [cert-manager API](https://cert-manager.io/docs/reference/api-docs/#cert-manager.io/v1.CertificateRequestSpec) for details.

Apply the configuration with `kubectl apply -f [..]`.

## multi-zone and Kubernetes cert-manager

In a multi-zone environment, the global control plane provides the `Mesh` to the zone control planes. However, you must make sure that each zone control plane can communicate with cert-manager using the same configuration.
This is because certificates for data plane proxies are requested from cert-manager by the zone control plane, not the global control plane.

This implies that each Kubernetes cluster in multi-zone must include an `Issuer` or `ClusterIssuer`
resource with the `issuerRef`  specified in the `Mesh` `certmanager` backend specification.
Also, because the backend is `Mesh` scoped configuration and `certmanager` backend is limited to the Kubernetes environment,
Universal and Kubernetes cannot be used together in a multi-zone environment which includes a `certmanager` mTLS backend.

{% if_version lte:2.3.x %}
You must also ensure the global control plan can access cert-manager.
When a new `certmanager`backend is configured, {{site.mesh_product_name}} validates the connection by issuing a test certificate.
In a multi-zone environment, validation is performed on the global control plane.
{% endif_version %}

<!-- links -->
{% if_version gte:2.0.x %}
[mtls-policy]: /mesh/{{page.release}}/policies/mutual-tls/
{% endif_version %}

{% if_version lte:1.9.x %}
[mtls-policy]: https://kuma.io/docs/1.8.x/policies/mutual-tls/
{% endif_version %}
