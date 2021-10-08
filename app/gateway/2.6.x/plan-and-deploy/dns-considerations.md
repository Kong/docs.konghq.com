---
title: DNS Considerations for Kong Gateway
badge: enterprise
---

{{site.base_gateway}} provides web applications that must be able to interact with
other Kong services to function properly: Kong Manager must be able to
interact with the Admin API, and the Dev Portal must be able to interact with
the Portal API. These applications are subject to security restrictions
enforced by browsers, and Kong must send appropriate information to browsers in
order for them to function properly.

These security restrictions use the applications' DNS hostnames to evaluate
whether the applications' metadata satisfies the security constraints. As such,
you must design your DNS structure to meet the requirements.

## Quick guide

It is recommended you read through this document to understand why these
requirements exist and how they function. In brief, your environment must meet
one of the two criteria below:

* Kong Manager and the Admin API are served from the same hostname, typically
  by placing the Admin API under an otherwise unused path, such as `/_adminapi/`.
* Kong Manager and the Admin API are served from different hostnames with a
  shared suffix (e.g. `kong.example` for `api.admin.kong.example` and
  `manager.admin.kong.example`). Admin session configuration sets
  `cookie_domain` to the shared suffix.

The same applies to the Portal API and Dev Portal.

The first option simplifies configuration in `kong.conf`, but requires an HTTP
proxy in front of the applications (because it uses HTTP path-based routing).
The Kong proxy can be used for this. The second option requires more
configuration in kong.conf, but can be used without proxying the applications.

## CORS

### Understanding CORS

[Cross-Origin Resource Sharing, or CORS][mdn-cors], is a set of rules for web
applications that make requests across origins, i.e.  to URLs that do not share
the same scheme, hostname, and port as the page making the request. When making
a cross-origin request, browsers send an `Origin` request header, and servers
must respond with a matching `Access-Control-Allow-Origin` (ACAO) header. If
the two headers do not match, the browser will discard the response, and any
application components that require that response's data will not function
properly.

For example, the following request/response pairs have matching CORS headers,
and will succeed:

```
GET / HTTP/1.1
Host: example.com
Origin: http://example.net

HTTP/1.1 200 OK
Access-Control-Allow-Origin: http://example.net
```

```
GET / HTTP/1.1
Host: example.com
Origin: http://example.net

HTTP/1.1 200 OK
Access-Control-Allow-Origin: *
```

`*` indicates that any origin is allowed.

These requests do not have a matching pair of CORS headers, and will fail:

```
GET / HTTP/1.1
Host: example.com
Origin: http://example.net

HTTP/1.1 200 OK
Access-Control-Allow-Origin: http://badbadcors.example
```

```
GET / HTTP/1.1
Host: example.com
Origin: http://example.net

HTTP/1.1 200 OK
```

Missing CORS headers when CORS headers are expected results in failure.

### CORS in the context of Kong Gateway

Kong Manager and the Dev Portal operate by issuing requests to their respective
APIs using JavaScript. These requests may be cross-origin depending on your
environment.

Kong's services determine what CORS headers to send based on various location
hint settings in `kong.conf`. The Admin API obtains its ACAO header value from
`admin_gui_url` and the Portal API obtains its header value from the
information in the `portal_gui_protocol`, `portal_gui_host`, and
`portal_gui_use_subdomains` settings. You may optionally specify additional
Portal API origins using `portal_cors_origins`.

You can configure your environment such that these requests are not
cross-origin by accessing both the GUI and its associated API via the same
hostname, e.g. by accessing Kong Manager at `https://admin.kong.example/` and
the Admin API at `https://admin.kong.example/_api/`. This option requires
placing a proxy in front of both Kong Manager and the Admin API to handle
path-based routing; you can use Kong's proxy for this purpose. Note that the
GUIs must be served at the root of their domains; you cannot place the APIs at
the root and the GUI under a path.

### Troubleshooting

CORS errors are shown in the browser developer console (for example, see documentation for
[Firefox][firefox-dev-console] and [Chrome][chrome-dev-console]) with
explanations of the specific issue. ACAO/Origin mismatches are most common, but
other error conditions can appear as well.

For example, if you have mistyped your `admin_api_uri`, you will see something
like the following:

```
Access to XMLHttpRequest at 'https://admin.kong.example' from origin 'https://manager.kong.example' has been blocked by CORS policy: Response to preflight request doesn't pass access control check: The 'Access-Control-Allow-Origin' header has a value 'https://typo.kong.example' that is not equal to the supplied origin.
```

These errors are generally self-explanatory, but if the issue is not clear,
check the Network developer tool, find the requests for the path in the error,
and compare its `Origin` request header and `Access-Control-Allow-Origin`
response header (it may be missing entirely).

## Cookies

### Understanding cookies

[Cookies][mdn-cookies] are small pieces of data saved by browsers for use in
future requests. Servers include a [Set-Cookie header][mdn-set-cookie] in their
response headers to set cookies, and browsers include a [Cookie
header][mdn-cookie] when making subsequent requests.

Cookies are used for a variety of purposes and offer many settings to tailor
when a browser will include them to fit a particular use case. Of particular
interest are the following directives:

- Cookie scope, defined by the cookie's `Domain` and `Path` directives. Absent
  these, cookies are sent only to the hostname that created them: a cookie
  created by `example.com` will not be sent with a request to
  `www.example.com`. When `Domain` is specified, cookies are sent to that
  hostname and its subdomains, so a cookie from `example.com` with
  `Domain=example.com` *will* be sent with requests to `www.example.com`.
- The `Secure` directive, which determines whether a cookie can be sent over an
  unencrypted (HTTP rather than HTTPS) connection. A cookie with `Secure`
  cannot be sent over HTTP, and must be set using HTTPS.
- The `SameSite` directive, which controls when a cookie can be sent with
  cross-origin requests. Note that cookies have a different notion of
  cross-origin than CORS and check against the domain suffix: while
  `example.com` sending a request to `api.example.com` is cross-origin for the
  purposes of CORS, a cookie with `Domain=example.com` is considered same-site
  for requests to `api.example.com`. `SameSite=Strict` cookies are only sent
  with same-site requests, `Lax` are sent when navigating to a link from
  another site, and `None` are sent with all cross-origin requests.

### Cookies in the context of Kong Gateway

After you log in to Kong Manager or the Dev Portal, Kong stores session
information in a cookie to recognize your browser during future requests. These
cookies are created using the [session plugin][session-plugin] (via
`admin_gui_session_conf`) or [OpenID Connect plugin][oidc-plugin].
Configuration is more or less the same between each--the OpenID Connect plugin
contains an embedded version of the session plugin, so while cookie handling
code is the same, it is configured directly in the OpenID Connect plugin
settings (`admin_gui_auth_conf`).

- `cookie_name` does not affect where the cookie is used, but should be set to
  a unique value to avoid collisions: some configurations may use the same
  `cookie_domain` for both admin and Portal cookies, and using the same name
  for both would then cause their cookies to collide and overwrite one another.
- `cookie_domain` should match the common hostname suffix shared by the GUI and
  its API. For example, if you use `api.admin.kong.example` and
  `manager.admin.kong.example` for the Admin API and Kong Manager,
  `cookie_domain` should be `admin.kong.example`.
- `cookie_samesite` should typically be left at its default, `strict`. `none`
  is not necessary if you have your DNS records and `cookie_domain` set
  following the examples in this document. `off` is only needed if the GUI and
  API are on entirely separate hostnames, e.g. `admin.kong.example` for the API
  and `manager.example.com` for Kong Manager. This configuration is not
  recommended because `off` opens a vector for cross-site request forgery
  attacks. It may be needed in some development or testing environments, but
  should not be used in production.
- `cookie_secure` controls whether cookies can be sent over unsecured
  (plaintext HTTP) requests. By default, it is set to `true`, which does not
  permit sending the cookie over unsecured connections. This setting should
  also remain on the default, but may be disabled in some development or
  testing environments where HTTPS is not used.

OpenID Connect uses the same settings, but prefixed with `session_`, e.g.
`session_cookie_name` rather than `cookie_name`.

Dev Portal configuration does not differ significantly from Kong Manager
configuration, but is configured per workspace under the Portal > Settings
section of Kong Manager, in the "Session Config (JSON)" field.

As with CORS, the above is not necessary if both the GUI and API use the same
hostname, with both behind a proxy and the API under a specific path on the
hostname.

### Troubleshooting

Issues with session cookies broadly fall into cases where the cookie is not
sent and cases where the cookie is not set. The network (for example, see documentation for
[Firefox][firefox-dev-network] or [Chrome][chrome-dev-network]) and
application/storage (see documentation for [Firefox][firefox-dev-storage] or
[Chrome][chrome-dev-application]) developer tools can assist with investigating
these.

In the network tool, selecting individual requests will show their request and
response headers. Successful authentication requests should see a `Set-Cookie`
response header including a cookie whose name matches `cookie_name` setting,
and subsequent requests should include the same cookie in the `Cookie` request
header.

If `Set-Cookie` is not present, it may be being stripped by some intermediate
proxy, or may indicate that the authentication handler encountered an error.
There should typically be other evidence in the response status and body in the
event of an error, and possible additional information in Kong's error logs.

If the cookie is set but not sent, it may have been deleted or may not match
requests that need it. The application/storage tool will show current cookies
and their parameters. Review these to see if your requests do not meet the
criteria to send the cookie (e.g. the cookie domain is not a suffix for a
request that requires the cookie, or is not present) and adjust your session
configuration accordingly.

If cookies are *not* present in application/storage, but were previously set
with `Set-Cookie`, they may have since been deleted, or may have expired.
Review the `Set-Cookie` information to see when the cookie was set to expire
and subsequent requests to determine if any other response has issued a
`Set-Cookie` that deleted it (by setting expiration to a date in the past).

This troubleshooting information may not immediately indicate the cause of the issue, but can
help Kong Support pinpoint the cause. Please provide it in tickets if possible.

[chrome-dev-application]: https://developers.google.com/web/tools/chrome-devtools#application
[chrome-dev-console]: https://developers.google.com/web/tools/chrome-devtools/console/log
[chrome-dev-network]: https://developers.google.com/web/tools/chrome-devtools#network
[firefox-dev-console]: https://developer.mozilla.org/en-US/docs/Tools/Web_Console/Opening_the_Web_Console
[firefox-dev-network]: https://developer.mozilla.org/en-US/docs/Tools/Network_Monitor
[firefox-dev-storage]: https://developer.mozilla.org/en-US/docs/Tools/Storage_Inspector
[mdn-cookie]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Cookie
[mdn-cookies]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies
[mdn-set-cookie]: https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Set-Cookie
[mdn-cors]: https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS
[oidc-plugin]: https://docs.konghq.com/hub/kong-inc/openid-connect/
[session-plugin]: https://docs.konghq.com/hub/kong-inc/session/
