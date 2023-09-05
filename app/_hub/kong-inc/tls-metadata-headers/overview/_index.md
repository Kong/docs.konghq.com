---
nav_title: Overview
---

The TLS Metadata Header plugin detects client certificates in requests, retrieves the TLS metadata, 
such as the URL-encoded client certificate, and proxies this metadata via HTTP headers.
This is useful when an upstream service performs some validation for the proxied TLS client certificate.

The plugin itself does not perform any validation on the client certificate.

Used in conjunction with any plugin which requests a client certificate, such as the 
[mTLS Authentication](/hub/kong-inc/mtls-auth/) or [TLS Handshake Modifier](/hub/kong-inc/tls-handshake-modifier/) plugins.
