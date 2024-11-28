---
title: TLS Verification of Upstream Services
type: how-to
purpose: |
  How to configure Kong to verify TLS certificates when connecting to upstream services
---

From version 3.4.0 {{ site.kic_product_name }} allows you to configure {{ site.base_gateway }} to run the TLS
verification of upstream services. If you have an upstream service that handles TLS, you can configure {{
site.base_gateway }} to verify the certificate it presents by attaching a CA certificate to a service. This guide
shows how to make this happen using the `BackendTLSPolicy` (when using Gateway API) or Kubernetes Service annotations
(when using Ingress API).

{% include /md/kic/prerequisites.md release=page.release disable_gateway_api=false%}

## Set up an upstream service with TLS

Before we configure {{ site.kic_product_name }} to verify the certificate of the upstream service, we need to set up an
upstream service that handles TLS. We can use the `kong/goecho` service as an example. It is a simple echo server that
can be configured to serve HTTPS on an arbitrary port using a TLS certificate and key pair.

### Create a certificate chain

To showcase all the possible configurations, we will create a certificate chain with a root CA, an intermediate CA, and
a leaf server certificate. We will use `openssl` to generate the certificates.

```shell
# Create a directory to store the certificates
mkdir certs
cd certs

# Generate Root CA
openssl req -new -newkey rsa:2048 -nodes -keyout root.key -subj "/CN=root" -x509 -days 365 -out root.crt

# Generate Intermediate CA
openssl req -new -newkey rsa:2048 -nodes -keyout inter.key -subj "/CN=inter" -out inter.csr
openssl x509 -req -in inter.csr -CA root.crt -CAkey root.key -CAcreateserial -days 365 -out inter.crt -extfile <(echo "basicConstraints=CA:TRUE")

# Generate Leaf Certificate
openssl req -new -newkey rsa:2048 -nodes -keyout leaf.key -subj "/CN=kong.example" -out leaf.csr
openssl x509 -req -in leaf.csr -CA inter.crt -CAkey inter.key -CAcreateserial -days 365 -out leaf.crt -extfile <(printf "subjectAltName=DNS:kong.example")

# Create a certificate chain
cat leaf.crt inter.crt > chain.crt

# Cleanup intermediate files
rm -f *.csr *.srl
cd ..
```

Running this script will generate the following files in `certs` directory:

- `root.key` and `root.crt`: Root CA key and certificate
- `inter.key`, `inter.crt`: Intermediate CA key and certificate
- `leaf.key`, `leaf.crt`: Server key and certificate (valid for `kong.example` SAN)
- `chain.crt`: Server certificate chain

### Deploy the goecho service

We will deploy the `kong/goecho` service with the generated certificates. We will use the `leaf.key` and
`chain.crt` files to configure the service to serve HTTPS.

First, deploy the standard `kong/goecho` service (no HTTPS support).

```bash
kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/echo-service.yaml
```

The results should look like this.

```text
service/echo created
deployment.apps/echo created
```

Now, let's configure it to serve HTTPS. Let's create a secret with the server key and the certificate chain (including
the intermediate certificate and the leaf certificate).

```bash
kubectl create secret tls goecho-tls --key ./certs/leaf.key --cert ./certs/chain.crt
```

Next, patch the `echo` deployment to use the secret and serve HTTPS using it.

```bash
kubectl patch deployment echo -p '{
  "spec": {
    "template": {
      "spec": {
        "containers": [
          {
            "name": "echo",
            "ports": [
              {
                "containerPort": 443
              }
            ],
            "env": [
              {
                "name": "HTTPS_PORT",
                "value": "443"
              },
              {
                "name": "TLS_CERT_FILE",
                "value": "/etc/tls/tls.crt"
              },
              {
                "name": "TLS_KEY_FILE",
                "value": "/etc/tls/tls.key"
              }
            ],
            "volumeMounts": [
              {
                "mountPath": "/etc/tls",
                "name": "tls"
              }
            ]
          }
        ],
        "volumes": [
          {
            "name": "tls",
            "secret": {
              "secretName": "goecho-tls"
            }
          }
        ]
      }
    }
  }
}'
```

Also, patch the service to use HTTPS by adding the `konghq.com/protocol: https` annotation and the `spec.ports`
entry.

```shell
kubectl patch service echo -p '{
  "metadata": {
    "annotations": {
      "konghq.com/protocol": "https"
    }
  },
  "spec": {
    "ports": [
      {
        "name": "https",
        "port": 443,
        "targetPort": 443
      }
    ]
  }
}'
```

The results should look like this:

```text
deployment.apps/echo patched
service/echo patched
```

## Expose the goecho service

Now that the `kong/goecho` service is serving HTTPS, we need to expose it.

{% include /md/kic/http-test-routing-resource.md service=echo port=443 %}

Verify connectivity by issuing an HTTP request to proxy. The service serves HTTPS but {{ site.base_gateway }} initiates
the connection and proxies it as HTTP in this case, thus the request should be made over HTTP. The `Host` header is
required to match the hostname of the service.

```shell
curl -H Host:kong.example $PROXY_IP/echo
```

You should see a response similar to this:

```text
Welcome, you are connected to node orbstack.
Running on Pod echo-bd94b7dcc-qxs2b.
In namespace default.
With IP address 192.168.194.9.
Through HTTPS connection.
```

That means the service is up and running and {{ site.base_gateway }} connects to it successfully over HTTPS, _without
verification_.

## Configure {{ site.base_gateway }} to verify the upstream TLS certificate

### Enable TLS verification

To configure {{ site.base_gateway }} to verify the certificate of the upstream service, we need to annotate the
service accordingly.

```shell
kubectl annotate service echo konghq.com/tls-verify=true
```

The results should look like this.

```text
service/echo annotated
```

Now, when you issue the same request as before, you should see an error similar to this.

```shell
curl -H Host:kong.example $PROXY_IP/echo
```

```text
{
  "message":"An invalid response was received from the upstream server",
  "request_id":"e2b3182856c96c23d61e880d0a28012f"
}
```

If you inspect {{ site.base_gateway }}'s container logs, you should see an error indicating an issue with TLS handshake.

```shell
 kubectl logs -n kong deploy/kong-gateway | grep "GET /echo"
```

```text
2024/11/28 18:04:05 [error] 1280#0: *20004 upstream SSL certificate verify error: (20:unable to get local issuer certificate) while SSL handshaking to upstream, client: 192.168.194.1, server: kong, request: "GET /echo HTTP/1.1", upstream: "https://192.168.194.9:443/", host: "kong.example", request_id: "e2b3182856c96c23d61e880d0a28012f"
192.168.194.1 - - [28/Nov/2024:18:04:05 +0000] "GET /echo HTTP/1.1" 502 126 "-" "curl/8.7.1" kong_request_id: "e2b3182856c96c23d61e880d0a28012f"
```

{{ site.base_gateway }} is now verifying the certificate of the upstream service and rejecting the connection because
the certificate is not trusted.

### Add the root CA certificate to {{ site.base_gateway }}

That can be fixed by adding the root CA certificate to the {{ site.base_gateway }}'s CA certificates and associating
it with the service.

First, create a secret with the root CA certificate.

{% include /md/kic/ca-certificates-note.md %}

```shell
echo '
apiVersion: v1
kind: Secret
metadata:
  name: root-ca
  labels:
    konghq.com/ca-cert: "true" # This label is required for the CA certificate to be recognized by Kong
  annotations:
    kubernetes.io/ingress.class: kong
data:
  cert: '$(base64 -w0 ./certs/root.crt)'
  # An arbitrary ID for the certificate 
  id: '$(printf "bf6e0f14-78cd-45ad-9325-87ec7ef7b890" | base64 -w0)'
' | kubectl apply -f -
```

The results should look like this.

```text
secret/root-ca created
```

Now, associate the root CA certificate with the service passing its name to `konghq.com/ca-certificates` annotation.

{:.note}
> The `konghq.com/ca-certificates` annotation is a comma-separated list of CA certificate names. You can add multiple
> CA certificates to the list.

```shell
kubectl annotate service echo konghq.com/ca-certificates='root-ca'
```

The results should look like this.

```text
service/echo annotated
```

Now, when you issue the same request as before, you should see a successful response.

```shell
curl -H Host:kong.example $PROXY_IP/echo
```

```text
Welcome, you are connected to node orbstack.
Running on Pod echo-bd94b7dcc-gdnhl.
In namespace default.
With IP address 192.168.194.18.
Through HTTPS connection.
```

{{ site.base_gateway }} is now verifying the certificate of the upstream service and accepting the connection because
the certificate is trusted.

### Configure verification depth

By default, {{ site.base_gateway }} verifies the certificate chain up to the root CA certificate with no depth limit.
You can configure the verification depth by annotating the service with the `konghq.com/tls-verify-depth` annotation.

For example, to limit the verification depth to 1 (i.e., only verify one intermediate certificate), you can annotate the
service like this:

```shell
kubectl annotate service echo konghq.com/tls-verify-depth=1
```

The results should look like this.

```text
service/echo annotated
```

Now, when you issue the same request as before, you should still see a successful response.

```shell
curl -H Host:kong.example $PROXY_IP/echo
```

```text
Welcome, you are connected to node orbstack.
Running on Pod echo-bd94b7dcc-gdnhl.
In namespace default.
With IP address
Through HTTPS connection.
```

You can also set the verification depth to 0 to not allow any intermediate certificates.

```shell
kubectl annotate --overwrite service echo konghq.com/tls-verify-depth=0
```

The results should look like this.

```text
service/echo annotated
```

Now, when you issue the same request as before, you should see an error similar to this.

```shell
curl -H Host:kong.example $PROXY_IP/echo
```

```text
{
  "message":"An invalid response was received from the upstream server",
  "request_id":"e2b3182856c96c23d61e880d0a28012f"
}
```

You can inspect {{ site.base_gateway }}'s container logs to see the error.

```shell
kubectl logs -n kong deploy/kong-gateway | grep "GET /echo"
```

```text
2024/11/29 11:41:46 [error] 1280#0: *45531 upstream SSL certificate verify error: (22:certificate chain too long) while SSL handshaking to upstream, client: 192.168.194.1, server: kong, request: "GET /echo HTTP/1.1", upstream: "https://192.168.194.19:443/", host: "kong.example", request_id: "678281372fb8907ed06d517cf515de78"
192.168.194.1 - - [29/Nov/2024:11:41:46 +0000] "GET /echo HTTP/1.1" 502 126 "-" "curl/8.7.1" kong_request_id: "678281372fb8907ed06d517cf515de78"
```

{{ site.base_gateway }} is now rejecting the connection because the certificate chain is too long. Changing the
verification depth to 1 should allow the connection to succeed again.

```shell
kubectl annotate --overwrite service echo konghq.com/tls-verify-depth=1
```

The results should look like this.

```text
service/echo annotated
```

Now, when you issue the same request as before, you should see a successful response.

```shell
curl -H Host:kong.example $PROXY_IP/echo
```

```text
Welcome, you are connected to node orbstack.
Running on Pod echo-bd94b7dcc-9lvmf.
In namespace default.
With IP address 192.168.194.19.
Through HTTPS connection.
```
