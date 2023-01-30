---
name: CORS
publisher: Kong Inc.
desc: Allow developers to make requests from the browser
description: |
  Easily add __cross-origin resource sharing *(CORS)*__ to a Service and a Route
  by enabling this plugin.
type: plugin
categories:
  - security
kong_version_compatibility:
  community_edition:
    compatible: true
  enterprise_edition:
    compatible: true
---

## Known issues

Below is a list of known issues or limitations for this plugin.

### CORS Limitations

If the client is a browser, there is a known issue with this plugin caused by a
limitation of the [CORS specification](https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS) that prevents specifying a custom
`Host` header in a preflight `OPTIONS` request.

Because of this limitation, this plugin only works for Routes that have been
configured with a `paths` setting. The CORS plugin does not work for Routes that
are being resolved using a custom DNS (the `hosts` property).

To learn how to configure `paths` for a Route, read the [Proxy
Reference](/gateway/latest/reference/proxy).
