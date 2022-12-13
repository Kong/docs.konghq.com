---
title: MeshGateway
---

`MeshGateway` is a policy used to configure [{{site.mesh_product_name}}'s builtin gateway](/docs/{{ page.version }}/explore/gateway#builtin).
It is used in combination with [`MeshGatewayRoute`](/docs/{{ page.version }}/policies/mesh-gateway-route).

A builtin gateway `Dataplane` with no additional configuration does nothing.
It is simply an unconfigured unit of proxying capacity.
To make use of it, we need to place a `MeshGateway` resource on it.
The `MeshGateway` resource specifies what network ports the gateway should listen on and how network traffic should be accepted.
A builtin gateway Dataplane can have exactly one `MeshGateway` resource bound to it.
This binding uses standard {{site.mesh_product_name}} matching semantics.

The most important field in the `MeshGateway` resource is the listener field.
A `MeshGateway` can have any number of listeners, where each listener represents an endpoint that can accept network traffic.
To configure a listener, you need to specify the port number, the network protocol, and (optionally) the hostname to accept.
Each listener has its own set of {{site.mesh_product_name}} tags so that {{site.mesh_product_name}} policy configuration can be targeted to specific listeners.

{% tabs usage useUrlFragment=false %}
{% tab usage Universal %}
```yaml
type: MeshGateway
mesh: default
name: edge-gateway
selectors:
- match:
    kuma.io/service: edge-gateway
conf:
  listeners:
  - port: 8080
    protocol: HTTP
    hostname: foo.example.com
    tags:
      port: http/8080 
```
{% endtab %}
{% tab usage Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: MeshGateway
mesh: default
metadata:
  name: edge-gateway
spec:
  selectors:
    - match:
        kuma.io/service: edge-gateway
  conf:
    listeners:
    - port: 8080
      protocol: HTTP
      hostname: foo.example.com
      tags:
        port: http/8080 
```
{% endtab %}
{% endtabs %}

The selectors field matches Dataplane tags to determine which Dataplanes will be configured with this `MeshGateway`.
The listeners field is an array of listeners for the Gateway.
In this example, the Gateway will listen for HTTP protocol connections on TCP port 8080.
The `MeshGateway` doesn’t specify which IP addresses will be listened on; that is done in the Dataplane resource.
Since HTTP has a protocol-specific concept of hostname, this listener can specify a hostname that it is willing to accept requests for.

It is common to configure HTTP proxies to accept requests for more than one hostname.
The Gateway resource supports this by merging listeners that have a common port.
Whether merging listeners is allowed depends on the semantics of the protocol field.
It is allowed for the most common protocols, HTTP and HTTPS.

{% tabs selectors useUrlFragment=false %}
{% tab selectors Universal %}
```yaml
type: MeshGateway
mesh: default
name: edge-gateway
selectors:
- match:
    kuma.io/service: edge-gateway
conf:
  listeners:
  - port: 8080
    protocol: HTTP
    hostname: foo.example.com
    tags:
      vhost: foo.example.com
  - port: 8080
    protocol: HTTP
    hostname: bar.example.com
    tags:
      vhost: bar.example.com
```
{% endtab %}
{% tab selectors Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: MeshGateway
mesh: default
metadata:
  name: edge-gateway
spec:
  selectors:
    - match:
        kuma.io/service: edge-gateway
  conf:
    listeners:
    - port: 8080
      protocol: HTTP
      hostname: foo.example.com
      tags:
        vhost: foo.example.com
    - port: 8080
      protocol: HTTP
      hostname: bar.example.com
      tags:
        vhost: bar.example.com
```
{% endtab %}
{% endtabs %}

Above shows a `MeshGateway` resource with two HTTP listeners on the same port.
In this example, the gateway proxy will be configured to listen on port 8080, and accept HTTP requests both for hostnames.

Note that because each listener entry has its own {{site.mesh_product_name}} tags, policy can still be targeted to a specific listener.
{{site.mesh_product_name}} generates a set of tags for each listener by overlaying the tags from the listener onto the tags from the Dataplane to which the Gateway is matched.
This set of listener tags is what {{site.mesh_product_name}} will match policies against.


| `Dataplane` tags                            | Listener tags                                      | Final Tags                                          |
| ----------------------------------------- | -------------------------------------------------- | --------------------------------------------------- |
| kuma.io/service=edge-gateway              | vhost=foo.example.com                              | kuma.io/service=edge-gateway,vhost=foo.example.com  |
| kuma.io/service=edge-gateway              | kuma.io/service=example,domain=example.com         | kuma.io/service=example,domain=example.com          |
| kuma.io/service=edge,location=us          | version=2                                          | kuma.io/service=edit,location=us,version=2          |

The reference doc contains all options on [`MeshGateway`](/docs/{{ page.version }}/generated/resources/policy_meshgateway).

## TLS Termination

TLS sessions are terminated on a Gateway by specifying the "HTTPS" protocol, and providing a server certificate configuration.
Below, the gateway listens on port 8443 and terminates TLS sessions.

{% tabs tls-termination useUrlFragment=false %}
{% tab tls-termination Universal %}
```yaml
type: MeshGateway
mesh: default
name: edge-gateway
selectors:
- match:
    kuma.io/service: edge-gateway
conf:
  listeners:
  - port: 8443
    protocol: HTTPS
    hostname: foo.example.com
    tls:
      mode: TERMINATE  
      certificates:
        - secret: foo-example-com-certificate
    tags:
      name: foo.example.com
```
{% endtab %}
{% tab tls-termination Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: MeshGateway
mesh: default
metadata:
  name: edge-gateway
spec:
  selectors:
    - match:
    kuma.io/service: edge-gateway
  conf:
    listeners:
    - port: 8443
      protocol: HTTPS
      hostname: foo.example.com
      tls:
        mode: TERMINATE
        certificates:
          - secret: foo-example-com-certificate
      tags:
        name: foo.example.com
```
{% endtab %}
{% endtabs %}

The server certificate is provided through a {{site.mesh_product_name}} datasource reference, in this case naming a secret that must contain both the server certificate and the corresponding private key.

### Server Certificate Secrets

A TLS server certificate secret is a collection of PEM objects in a {{site.mesh_product_name}} datasource (which may be a file, a {{site.mesh_product_name}} secret, or inline data).

There must be at least a private key and the corresponding TLS server certificate.
The CA certificate chain may also be present, but if it is, the server certificate must be the first certificate in the secret.

{{site.mesh_product_name}} gateway supports serving both RSA and ECDSA server certificates.
To enable this support, generate two server certificate secrets and provide them both to the listener TLS configuration.
The `kumactl` tool supports generating simple, self-signed TLS server certificates. The script below shows how to do this.

{% tabs tls-secret useUrlFragment=false %}
{% tab tls-secret Kubernetes %}
```shell
kubectl apply -f <(
cat<<EOF
apiVersion: v1
kind: Secret
metadata:
  name: foo-example-com-certificate
  namespace: kuma-system
  labels:
    kuma.io/mesh: default
data:
  value: '$(kumactl generate tls-certificate --type=server --hostname=foo.example.com --key-file=- --cert-file=- | base64 -w0)'
type: system.kuma.io/secret
EOF
)
```
{% endtab %}
{% tab tls-secret Universal %}
```shell
kumactl apply -f <(
cat<<EOF
type: Secret
mesh: default
name: foo-example-com-certificate
data: $(kumactl generate tls-certificate --type=server --hostname=foo.example.com --key-file=- --cert-file=- | base64 -w0)
EOF
)
```
{% endtab %}
{% endtabs %}
