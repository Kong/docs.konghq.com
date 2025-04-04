---
title: Strengthen Security in Kong Manager
badge: enterprise
---


## Content Security Policy

A Content Security Policy (CSP) helps prevent or minimize the risk of certain types of security threats. It consists of a series of instructions from a website to a browser, which instruct the browser to place restrictions on the things that the code comprising the site is allowed to do.

Kong Manager provides the optional configuration parameter [`admin_gui_csp_header`] that allows you to enable the Content Security Policy header. The Content Security Policy header is turned off by default.

When `admin_gui_csp_header` is enabled, Kong Manager will enforce a default Content Security Policy composed of the following directives:

```
default-src 'self';
connect-src <...see below...>;
img-src 'self' data:;
script-src 'self' 'wasm-unsafe-eval';
script-src-elem 'self';
style-src 'self' 'unsafe-inline';
```

If `admin_gui_api_url` is not specified, the `connect-src` directive will depend on the requesting host and port. For example:
  * If the request URL is `http://localhost:9112`, the `connect-src` directive will be `http://localhost:9112
  * If the request URL is `https://localhost:9112`, the `connect-src` directive will be `https://localhost:9112`.

If `admin_gui_api_url` is specified, the `connect_src` directive will depend on the presence of the `http` or `https` prefix:
* If `admin_gui_api_url` starts with `http://` or `https://`, the `connect-src` directive will be the value of `admin_gui_api_url`. 
*  If `admin_gui_api_url` doesn't start with `http://` or `https://`, the `connect-src` directive will be the value of `admin_gui_api_url` prefixed with `http://` when being accessed over HTTP, and `https://` when being accessed over HTTPS.

### Customize the Content Security Policy header

Sometimes, the default Content Security Policy may not fit your needs. You can customize the Content Security Policy by setting the [`admin_gui_csp_header_value`] parameter in your Kong configuration. For example:

```
admin_gui_csp_header_value = default-src 'self'; connect-src 'self' https://my-admin-api.tld;
```

{:.warning}
> **Note:** An invalid Content Security Policy may break the functionality of Kong Manager or even expose it to security risks. Make sure to test the Content Security Policy before using it in production.

## See also

* [Content Security Policy (CSP) - HTTP \| MDN](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP)

[`admin_gui_api_url`]: /gateway/{{page.release}}/reference/configuration/#admin_gui_api_url
[`admin_gui_csp_header`]: /gateway/{{page.release}}/reference/configuration/#admin_gui_csp_header
[`admin_gui_csp_header_value`]: /gateway/{{page.release}}/reference/configuration/#admin_gui_csp_header_value

