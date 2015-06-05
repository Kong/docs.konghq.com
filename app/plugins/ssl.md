---
sitemap: true
id: page-plugin
title: Plugins - SSL Certificate
header_title: SSL Certificate
header_icon: /assets/images/icons/plugins/ssl.png
header_btn_text: Report Bug
header_btn_href: mailto:support@mashape.com?subject={{ page.header_title }} Plugin Bug
breadcrumbs:
  Plugins: /plugins
---

Bounds a specific SSL certificate to the `public_dns` value of a service. In case you want to setup a global SSL certificate for **every API**, take a look at the [Kong SSL configuration options](#). **Note**: this plugin requires Kong >= 0.3.0

---

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
$ curl -X POST http://kong:8001/apis/{api_id}/plugins \
    --form "name=ssl" \
    --form "value.cert=@/path/to/cert.pem" \
    --form "value.key=@/path/to/cert.key" \
    --form "value.only_ssl=true"
```

`api_id`: The API ID that this plugin configuration will target

form parameter                                           | description
 ---:                                               | ---
`name`                                              | Name of the plugin to use, in this case: `ssl`
`value.cert`                                        | Specify the path of the certificate file to upload.
`value.key`                                         | Specify the path of the certificate key file to upload
`value.only_https`<br>*optional*                    | Specify if the service should only be available through an `https` protocol. Defaults to `false`.

## Creating an SSL certificate

When creating an SSL certificate to use with this plugin, make sure you create one that is compatible with nginx. There are different ways of getting an SSL certificate, below you can find some easy steps to create a self-signed certificate to use with this plugin:

```bash
# Let's create the private server key
sudo openssl genrsa -des3 -out server.key 1024

# Now we create a certificate signing request
sudo openssl req -new -key server.key -out server.csr

# Remove the passphrase
sudo cp server.key server.key.org
sudo openssl rsa -in server.key.org -out server.key

# Signing the SSL certificate
sudo openssl x509 -req -in server.csr -signkey server.key -out server.crt
```

If you followed the steps above the certificate will be stored in a file named `server.crt`, while the key is at `server.key`.



[api-object]: /docs/{{site.data.kong_latest.version}}/admin-api/#api-object
[configuration]: /docs/{{site.data.kong_latest.version}}/configuration
