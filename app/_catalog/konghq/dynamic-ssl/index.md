---
name: Dynamic SSL
nav:
  - label: Usage
    items:
      - label: Creating an SSL certificate
      - label: Propagation

desc: Add an SSL certificate for an underlying service
description: |
  Dynamically binds a specific SSL certificate to the `request_host` value of a service. In case you want to setup a global SSL certificate for **every API**, take a look at the [Kong SSL configuration options][configuration].

  <div class="alert alert-warning">
    <strong>Note:</strong> As of Kong 0.10.0, this plugin has been removed and the
    core is now directly responsible for dynamically serving SSL certificates.
    You can read about how to serve an API over SSL in the
    <a href="/latest/proxy#configuring-ssl-for-an-api">Proxy</a> and the
    <a href="/latest/admin-api">Admin API</a> references.
  </div>

type: plugin
categories:
  - security

params:
  name: ssl
  api_id: true
  service_id: true
  route_id: true
  consumer_id: true
  config:
    - name: cert
      required: true
      default:
      value_in_examples: "@/path/to/cert.pem"
      description: |
        Upload the data of the certificate to use. Note that is the the actual data of the key (not the path), so it should be sent in `multipart/form-data` upload request.
    - name: key
      required: true
      default:
      value_in_examples: "@/path/to/cert.key"
      description: |
        Upload the data of the certificate key to use. Note that is the the actual data of the key (not the path), so it should be sent in `multipart/form-data` upload request.
    - name: only_https
      required: false
      default: "`false`"
      value_in_examples: true
      description: |
        Specify if the service should only be available through an `https` protocol.
    - name: accept_http_if_already_terminated
      required: false
      default: "`false`"
      description: |
        If `config.only_https` is `true`, accepts HTTPs requests that have already been terminated by a proxy or load balancer and the `x-forwarded-proto: https` header has been added to the request. Only enable this option if the Kong server cannot be publicly accessed and the only entry-point is such proxy or load balancer.

---

## Creating an SSL certificate

When creating an SSL certificate to use with this plugin, make sure you create one that is compatible with nginx. There are different ways of getting an SSL certificate, below you can find some easy steps to create a self-signed certificate to use with this plugin:

```bash
# Let's create the private server key
openssl genrsa -des3 -out server.key 2048

# Now we create a certificate signing request
openssl req -new -key server.key -out server.csr -sha256

# Remove the passphrase
cp server.key server.key.org
openssl rsa -in server.key.org -out server.key

# Signing the SSL certificate
openssl x509 -req -in server.csr -signkey server.key -out server.crt -sha256
```

If you followed the steps above the certificate will be stored in a file named `server.crt`, while the key is at `server.key`.

----

## Propagation

When adding this plugin, the SSL certificate and its key will be uploaded and stored into the datastore, and they doesn't need to physically exist on the Kong servers.

For example, if you have two Kong servers called "Server_1" and "Server_2", this means that you can upload a certificate, let's say, on "Server_1" and it will be immediately available also on "Server_2" (and on any other server you decide to add to the cluster, as long as they point to the same datastore).

[api-object]: /latest/admin-api/#api-object
[configuration]: /latest/configuration#ssl_cert_path
