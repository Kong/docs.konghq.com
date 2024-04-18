---
nav_title: Overview
---

This plugin lets you add mutual TLS authentication based on a client-supplied or a server-supplied certificate, 
and on the configured trusted certificate authority (CA) list.

The mTLS plugin automatically maps certificates to consumers based on the common name field.

## How does the mTLS plugin work?

To authenticate a consumer with mTLS, it must provide a valid certificate and
complete a mutual TLS handshake with {{site.base_gateway}}.

The plugin validates the certificate provided against the configured CA list based on the
requested route or service:
* If the certificate is not trusted or has expired, the response is
  `HTTP 401 TLS certificate failed verification`.
* If consumer did not present a valid certificate (this includes requests not
  sent to the HTTPS port), then the response is `HTTP 401 No required TLS certificate was sent`.
  The exception is if the `config.anonymous` option is configured on the plugin, in which
  case the anonymous consumer is used and the request is allowed to proceed.

### Client certificate request

Client certificates are requested in the `ssl_certificate_by_lua` phase where {{site.base_gateway}} does not
have access to `route` and `workspace` information. Due to this information gap, {{site.base_gateway}} asks for
the client certificate by default on every handshake if the `mtls-auth` plugin is configured on any route or service.
In most cases, the failure of the client to present a client certificate is not going to affect subsequent
proxying if that route or service does not have the `mtls-auth` plugin applied. The exception is where
the client is a desktop browser, which prompts the end user to choose the client cert to send and
lead to user experience issues rather than proxy behavior problems. 

To improve this situation, {{site.base_gateway}} builds an in-memory map of SNIs from the configured {{site.base_gateway}} routes that should present a client certificate. 
To limit client certificate requests during handshake while ensuring the client
certificate is requested when needed, the in-memory map is dependent on the routes in
{{site.base_gateway}} having the SNIs attribute set.
If any routes don't have SNIs set, {{site.base_gateway}} must request
the client certificate during every TLS handshake:

- **Plugin is applied globally**: mTLS auth is applied on every request irrespective of workspace
- **Plugin is applied at the service level**: If one or more of the routes *do not* have SNIs set, mTLS auth is applied on every request irrespective of workspace. 
- **Plugin is applied at the route level**: If one or more of the routes *do not* have SNIs set, applied on every request irrespective of workspace.
- **Plugin is applied at the route level and all routes have SNIs set**: mTLS is applied on specific requests only.

SNIs must be set for all routes that mutual TLS authentication uses.

{% if_plugin_version gte:3.1.x %}
### Sending the CA DNs during TLS handshake

By default, {{site.base_gateway}} doesn't send the CA DN list during the TLS handshake. 
More specifically, the `certificate_authorities` field in the CertificateRequest message is empty.

In some cases, the client may need this `certificate_authorities` to guide
certificate selection. Setting `config.send_ca_dn` to `true` adds the
CA certificates configured in the `config.ca_certificate` to the lists of
the corresponding SNIs.

As mentioned in [Client certificate request](#client-certificate-request),
due to the phase gap, {{site.base_gateway}} doesn't know the route information in the
`ssl_certificate_by_lua` phase, which is decided in the later `access` phase.
Therefore {{site.base_gateway}} builds an in-memory map of SNIs. 
The CA DN list will eventually be associated with the SNIs. 
If multiple `mtls-auth` plugins with different `config.ca_certificate` are 
associated to the same SNI, their CA DNs are merged. 
For example:

- When the plugin is enabled in the **global** workspace scope, the CA DNs
  are associated with a special SNI, `\*`.
- When the plugin is applied at the **service** level, the CA DNs are
  associated with every SNI of every route to this service. 
  If a route has no SNIs set, then the CA DNs are associated with a special SNI, `\*`.
- When the plugin is applied at the **route** level, the CA DNs are
  associated with every SNI configured on this route. 
  If the route has no SNIs set, then the CA DNs are associated with a special SNI, `\*`.

During the mTLS handshake, if the client sends a SNI in the ClientHello message and
the SNI is found in the in-memory map of SNIs, then the corresponding CA DN list is sent in CertificateRequest message.

If the client doesn't send SNIs in the ClientHello message or the SNI sent is
unknown to {{site.base_gateway}}, then the CA DN list associated with `\*` is sent only when the client certificate is requested.
{% endif_plugin_version %}


### Troubleshooting

When authentication fails, the client does not have access to any details that explain the
failure. The security reason for this omission is to prevent malicious reconnaissance.
Instead, the details are recorded inside Kong's error logs under the `[mtls-auth]`
filter.

## Get started with the mTLS Authentication plugin

* [Add certificate authorities](/hub/kong-inc/mtls-auth/how-to/add-cert-authorities/): 
To use this plugin, you must add certificate authority (CA) certificates. 
Set them up before configuring the plugin.
* [Configuration reference](/hub/kong-inc/mtls-auth/configuration/)
* [Basic configuration example](/hub/kong-inc/mtls-auth/how-to/basic-example/)
* [Create manual mappings between certificate and consumer objects](/hub/kong-inc/mtls-auth/how-to/manual-mapping-cert-consumers/)
