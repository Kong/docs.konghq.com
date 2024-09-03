---
nav_title: Overview
---

The Header Cert Authentication plugin authenticates API calls using client certificates received in HTTP headers,
rather than through traditional TLS termination.
This is necessary in scenarios where TLS traffic is not terminated at {{site.base_gateway}}, but rather at an external CDN or load balancer,
and the client certificate is preserved in an HTTP header for further validation.

## How it works

This plugin addresses the inability of the {{site.base_gateway}} to authenticate API calls using client certificates received in HTTP headers, rather than through traditional TLS termination. 
This occurs in scenarios where TLS traffic is not terminated at the {{site.base_gateway}}, but rather at an external CDN or load balancer, and the client certificate is preserved in an HTTP header for further validation.

The Header Cert Authentication plugin is similar to the [mTLS Auth plugin](/hub/kong-inc/mtls-auth).
However, the mTLS plugin is only designed for traditional TLS termination, while the Header Cert Auth plugin also provides support for client certificates in headers. 

The Header Cert Auth plugin extracts the client certificate from the HTTP header and validates it against the configured CA list. 
If the certificate is valid, the plugin maps the certificate to a consumer based on the common name field.

The plugin validates the certificate provided against the configured CA list based on the
requested route or service:
* If the certificate is not trusted or has expired, the response is
  `HTTP 401 TLS certificate failed verification`.
* If consumer did not present a valid certificate (this includes requests not
  sent to the HTTPS port), then the response is `HTTP 401 No required TLS certificate was sent`.
  The exception is if the `config.anonymous` option is configured on the plugin, in which
  case the anonymous consumer is used and the request is allowed to proceed.

The plugin can be configured to only accept certificates from trusted IP addresses, as specified by the [`trusted_ips`](/gateway/{{page.release}}/reference/configuration/#trusted_ips) config option. This ensures that Kong can trust the header sent from the source and provides L4 level of security.

{:.important}
> **Important:** Incomplete or improper configuration of the Header Cert Authentication plugin can compromise the security of your API.
<br><br>
> For instance, enabling the option to bypass origin verification can allow malicious actors to inject fake certificates, as Kong will not be able to verify the authenticity of the header. This can downgrade the security level of the plugin, making your API vulnerable to attacks. Ensure you carefully evaluate and configure the plugin according to your specific use case and security requirements.

Additionally, the plugin has a [static priority](/konnect/reference/plugins/) configured so that it runs after all authentication plugins, allowing other auth plugins (e.g. basic-auth) to secure the source first. This ensures that the source is secured by multiple layers of authentication by providing L7 level of security.

### Client certificate request

The `send_ca_dn` option is not supported in this plugin. This is used in mutual TLS authentication, where the server sends the list of trusted CAs to the client, and the client then uses this list to select the appropriate certificate to present. In this case since the plugin does not do TLS handshakes and only parses the client certificate from the header, it is not applicable.

The same applies to SNI functionality. The plugin can verify the certificate without needing to know the specific hostname or domain being accessed. The plugin's authentication logic is decoupled from the TLS handshake and SNI, so it doesn't need to rely on SNI to function correctly (pretty much anything that deals with the actual TLS handshake is not needed for the plugin to work).

### Troubleshooting

When authentication fails, the client does not have access to any details that explain the failure. The security reason for this omission is to prevent malicious reconnaissance. Instead, the details are recorded inside Kong's error logs under the `[header-cert-auth]` filter.

### FAQ

**Q: Will the client need to encrypt the message with a private key and certificate when passing the certificate in the header?**

**A:** No, the client only needs to send the target's certificate encoded in a header. Kong will validate the certificate, but it requires a high level of trust that the WAF/LB is the only entrypoint to the Kong proxy. The Header Cert Auth plugin will provide an option to secure the source, but additional layers of security are always preferable. Network level security (so that Kong only accepts requests from WAF - IP allow/deny mechanisms) and application-level security (Basic Auth or Key Auth plugins to authenticate the source first) are examples of multiple layers of security that can be applied.

## Get started with the Header Cert Authentication plugin

* [Add certificate authorities](/hub/kong-inc/header-cert-auth/how-to/add-cert-authorities/):
    To use this plugin, you must add certificate authority (CA) certificates.
    Set them up before configuring the plugin.
* [Configuration reference](/hub/kong-inc/header-cert-auth/configuration/)
* [Basic configuration example](/hub/kong-inc/header-cert-auth/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/header-cert-auth/how-to/)
* [Create manual mappings between certificate and consumer objects](/hub/kong-inc/header-cert-auth/how-to/manual-mapping-cert-consumers/)
* [AWS ALB integration](/hub/kong-inc/header-cert-auth/how-to/aws-alb-integration/)
