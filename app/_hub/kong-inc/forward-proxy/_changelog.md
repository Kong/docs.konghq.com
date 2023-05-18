## Changelog

**{{site.base_gateway}} 3.1.x**

- **Forward Proxy**: `x_headers` field added. This field indicates how the plugin handles the headers
  `X-Real-IP`, `X-Forwarded-For`, `X-Forwarded-Proto`, `X-Forwarded-Host`, and `X-Forwarded-Port`.

  The field is set to `append` by default, but can be set to one of the following options:
  - `append`: Append information from this hop to the headers.
  - `transparent`: Leave headers unchanged, as if not using a proxy.
  - `delete`: Remove all headers including those that should be added for this hop, as if you are the originating client.

  Note that all options respect the trusted IP setting, and will ignore last hop headers if they are not from clients with trusted IPs.

**{{site.base_gateway}} 2.8.x**

* Added `http_proxy_host`, `http_proxy_port`, `https_proxy_host`, and
`https_proxy_port` configuration parameters for mTLS support.

    {:.important}
    > These parameters replace the `proxy_port` and `proxy_host` fields, which
    are now **deprecated** and planned to be removed in a future release.

* The `auth_password` and `auth_username` configuration fields are now marked as
referenceable, which means they can be securely stored as
[secrets](/gateway/latest/plan-and-deploy/security/secrets-management/getting-started)
in a vault. References must follow a [specific format](/gateway/latest/kong-enterprise/security/secrets-management/reference-format).

**{{site.base_gateway}} 2.7.x**

* Added `auth_username` and `auth_password` parameters for proxy authentication.
