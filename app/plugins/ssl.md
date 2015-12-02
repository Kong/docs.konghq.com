---
id: page-plugin
title: Plugins - SSL Certificate
header_title: SSL Certificate
header_icon: /assets/images/icons/plugins/ssl.png
breadcrumbs:
  Plugins: /plugins
nav:
  - label: Getting Started
    items:
      - label: Installation
      - label: Configuration
  - label: Usage
    items:
      - label: Creating an SSL certificate
      - label: Propagation
---

<div class="alert alert-warning">
  <strong>Note:</strong> This plugin requires Kong >= 0.3.0
</div>

Binds a specific SSL certificate to the `request_host` value of a service. In case you want to setup a global SSL certificate for **every API**, take a look at the [Kong SSL configuration options][configuration].

----

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file:

```yaml
plugins_available:
  - ssl
```

Every node in your Kong cluster should have the same `plugins_available` property value.

## Configuration

Configuring the plugin is as simple as a single API call, you can configure and enable it for your [API][api-object] by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/apis/{api}/plugins \
    --form "name=ssl" \
    --form "config.cert=@/path/to/cert.pem" \
    --form "config.key=@/path/to/cert.key" \
    --form "config.only_https=true"
```

`api`: The `id` or `name` of the API that this plugin configuration will target

form parameter                    | description
---:                              | ---
`name`                            | Name of the plugin to use, in this case: `ssl`
`config.cert`                      | Specify the path of the certificate file to upload.
`config.key`                       | Specify the path of the certificate key file to upload
`config.only_https`<br>*optional*  | Specify if the service should only be available through an `https` protocol. Defaults to `false`.
`config.accept_http_if_already_terminated`<br>*optional* | If `config.only_https` is `true`, accepts HTTPs requests that have already been terminated by a proxy or load balancer and the `x-forwarded-proto: https` header has been added to the request. Only enable this option if the Kong server cannot be publicly accessed and the only entry-point is such proxy or load balancer. Defaults to `false`.

## Creating an SSL certificate

When creating an SSL certificate to use with this plugin, make sure you create one that is compatible with nginx. There are different ways of getting an SSL certificate, below you can find some easy steps to create a self-signed certificate to use with this plugin:

```bash
# Let's create the private server key
openssl genrsa -des3 -out server.key 1024

# Now we create a certificate signing request
openssl req -new -key server.key -out server.csr

# Remove the passphrase
cp server.key server.key.org
openssl rsa -in server.key.org -out server.key

# Signing the SSL certificate
openssl x509 -req -in server.csr -signkey server.key -out server.crt
```

If you followed the steps above the certificate will be stored in a file named `server.crt`, while the key is at `server.key`.

## Propagation

When adding this plugin, the SSL certificate and its key will be uploaded and stored into the datastore, and they doesn't need to physically exist on the Kong servers. 

For example, if you have two Kong servers called "Server_1" and "Server_2", this means that you can upload a certificate, let's say, on "Server_1" and it will be immediately available also on "Server_2" (and on any other server you decide to add to the cluster, as long as they point to the same datastore).

[api-object]: /docs/latest/admin-api/#api-object
[configuration]: /docs/latest/configuration#ssl_cert_path
