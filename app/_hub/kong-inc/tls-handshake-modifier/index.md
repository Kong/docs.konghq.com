---
name: TLS Handshake Modifier
publisher: Kong Inc.
version: 0.1.x

desc: Requests a client to present it's client certificate
description: |
  The plugin only requests, but does not require the client certificate. No validation 
  of the client certificate is performed. If a client certificate exists, 
  the plugin makes this available for other plugins for this request to utilise.  
  
  This plugin is used in conjunction with the TLS Metadata Headers plugin.

enterprise: true
plus: true
type: plugin
categories:
  - security
kong_version_compatibility:
  enterprise_edition:
    compatible:
      - 2.8.x
params:
  name: tls-handshake-modifier
  service_id: true
  consumer_id: false
  route_id: true
  protocols:
    - https
    - grpcs
    - tls
  dbless_compatible: 'yes'
  examples: false
  config:
    - name: tls_client_certificate
      required: false
      default: '`REQUEST`'
      datatype: string
      description: |
        Indicates the TLS Handshake preference. Currently, the only option is `REQUEST`, that is
        requesr the client certificate.
---

### Client Certificate request
Client certificates are requested in the `ssl_certificate_by_lua` phase where Kong does not
have access to `route` and `workspace` information. Due to this information gap, Kong will ask for
the client certificate on every handshake if the `tls-handshake-modifier` plugin is configured on any Route or Service.
In most cases, the failure of the client to present a client certificate is not going to affect subsequent
proxying if that Route or Service does not have the `tls-handshake-modifier` plugin applied. The exception is where
the client is a desktop browser, which will prompt the end user to choose the client cert to send and
lead to user experience issues rather than proxy behavior problems. To improve this situation,
Kong builds an in-memory map of SNIs from the configured Kong Routes that should present a client
certificate. To limit client certificate requests during handshake while ensuring the client
certificate is requested when needed, the in-memory map is dependent on all the Routes in
Kong having the SNIs attribute set. When any routes do not have SNIs set, Kong must request
the client certificate during every TLS handshake:

- On every request irrespective of Workspace when the plugin is enabled in global Workspace scope.
- On every request irrespective of Workspace when the plugin is applied at the Service level
  and one or more of the Routes *do not* have SNIs set.
- On every request irrespective of Workspace when the plugin is applied at the Route level
  and one or more Routes *do not* have SNIs set.
- On specific requests only when the plugin is applied at the Route level and all Routes have SNIs set.

The result is all Routes must have SNIs if you want to restrict the handshake request
for client certificates to specific requests.

## Configuration

### Enable the plugin on a service

Configure this plugin on a [service](/gateway/latest/admin-api/#service-object):

```bash
curl -X POST http://<admin-hostname>:8001/services/<service>/plugins \
  --data "name=tls-handshake-modifier"
```

The `<service>` is the id or name of the service that this plugin configuration will target.

### Enable the plugin on a route

Configure this plugin on a [route](/gateway/latest/admin-api/#route-object):

```bash
$ curl -X POST http://<admin-hostname>:8001/routes/<route>/plugins \
   --data "name=tls-handshake-modifier"
   ```

The `<route>` is the id or name of the route that this plugin configuration will target.

### Enable the plugin globally

A plugin that is not associated to any service, route, or consumer is considered global, and
will run on every request. Read the [Plugin Reference](/gateway/latest/admin-api/#add-plugin) and the
[Plugin Precedence](/gateway/latest/admin-api/#precedence) sections for more information.

Configure this plugin globally using the default HTTP Header names:

```bash
curl -X POST http://<admin-hostname>:8001/plugins/ \
    --data "name=tls-handshake-modifier"
```
