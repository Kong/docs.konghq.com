---
name: CORS
publisher: Kong Inc.
version: 1.0.0

desc: Allow developers to make requests from the browser
description: |
  Easily add __Cross-origin resource sharing *(CORS)*__ to a Service, a Route by enabling this plugin.

  <div class="alert alert-warning">
    <strong>Note:</strong> The functionality of this plugin as bundled
    with versions of Kong prior to 0.10.3 differs from what is documented herein.
    Refer to the
    <a href="https://github.com/Kong/kong/blob/master/CHANGELOG.md">CHANGELOG</a>
    for details.
  </div>

type: plugin
categories:
  - security

kong_version_compatibility:
    community_edition:
      compatible:
        - 1.0.x
        - 0.14.x
        - 0.13.x
        - 0.12.x
        - 0.11.x
        - 0.10.x
        - 0.9.x
        - 0.8.x
        - 0.7.x
        - 0.6.x
        - 0.5.x
        - 0.4.x
        - 0.3.x
        - 0.2.x
    enterprise_edition:
      compatible:
        - 0.34-x
        - 0.33-x
        - 0.32-x
        - 0.31-x

params:
  name: cors
  service_id: true
  route_id: true
  consumer_id: false
  config:
    - name: origins
      required: false
      default:
      value_in_examples: http://mockbin.com
      description: |
        A comma-separated list of allowed domains for the `Access-Control-Allow-Origin` header. If you wish to allow all origins, add `*` as a single value to this configuration field. The accepted values can either be flat strings or PCRE regexes. **NOTE**: Prior to Kong 0.10.x, this parameter was `config.origin` (note the change in trailing `s`), and only accepted a single value, or the `*` special value.
    - name: methods
      required: false
      default: "`GET, HEAD, PUT, PATCH, POST`"
      value_in_examples: GET, POST
      description:
        Value for the `Access-Control-Allow-Methods` header, expects a comma delimited string (e.g. `GET,POST`).
    - name: headers
      required: false
      default: "Value of the `Access-Control-Request-Headers` request header"
      value_in_examples: Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Auth-Token
      description: |
        Value for the `Access-Control-Allow-Headers` header, expects a comma delimited string (e.g. `Origin, Authorization`).
    - name: exposed_headers
      required: false
      default:
      value_in_examples: X-Auth-Token
      description: |
        Value for the `Access-Control-Expose-Headers` header, expects a comma delimited string (e.g. `Origin, Authorization`). If not specified, no custom headers are exposed.
    - name: credentials
      required: false
      default: "`false`"
      value_in_examples: true
      description: |
        Flag to determine whether the `Access-Control-Allow-Credentials` header should be sent with `true` as the value.
    - name: max_age
      required: false
      default:
      value_in_examples: 3600
      description: |
        Indicated how long the results of the preflight request can be cached, in `seconds`.
    - name: preflight_continue
      required: false
      default: "`false`"
      description: A boolean value that instructs the plugin to proxy the `OPTIONS` preflight request to the upstream service.

---

## Known issues

Below is a list of known issues or limitations for this plugin.

### CORS Limitations

If the client is a browser, there is a known issue with this plugin caused by a
limitation of the CORS specification that doesn't allow to specify a custom
`Host` header in a preflight `OPTIONS` request.

Because of this limitation, this plugin will only work for Routes that have been
configured with a `paths` setting, and it will not work for Routes that
are being resolved using a custom DNS (the `hosts` property).

To learn how to configure `paths` for a Route, please read the [Proxy
Reference][proxy-reference].

[configuration]: /latest/configuration
[proxy-reference]: /0.12.x/proxy#request-uri
