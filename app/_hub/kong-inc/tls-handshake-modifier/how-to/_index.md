## Client certificate request

Client certificates are requested in the `ssl_certificate_by_lua` phase where {{site.base_gateway}} does not
have access to `route` and `workspace` information. Due to this information gap, {{site.base_gateway}} asks for
the client certificate on every handshake if the `tls-handshake-modifier` plugin is configured on any route or service.

In most cases, the failure of the client to present a client certificate doesn't affect subsequent
proxying if that route or service does not have the `tls-handshake-modifier` plugin applied. The exception is where
the client is a desktop browser, which prompts the end user to choose the client cert to send and
leads to user experience issues rather than proxy behavior problems.

To improve this situation, Kong builds an in-memory map of SNIs from the configured {{site.base_gateway}} routes that should present a client
certificate. To limit client certificate requests during a handshake while ensuring the client
certificate is requested when needed, the in-memory map is dependent on all the routes in
{{site.base_gateway}} having the SNIs attribute set. When no routes have SNIs set, {{site.base_gateway}} must request
the client certificate during every TLS handshake:

- On every request irrespective of workspace when the plugin is enabled in global workspace scope.
- On every request irrespective of workspace when the plugin is applied at the service level
  and one or more of the routes *do not* have SNIs set.
- On every request irrespective of workspace when the plugin is applied at the route level
  and one or more routes *do not* have SNIs set.
- On specific requests only when the plugin is applied at the route level and all routes have SNIs set.

The result is all routes must have SNIs if you want to restrict the handshake request
for client certificates to specific requests.
