---
name: CORS
publisher: Kong Inc.
version: 1.0.0

desc: Allow developers to make requests from the browser
description: |
  Easily add __cross-origin resource sharing *(CORS)*__ to a Service and a Route
  by enabling this plugin.

type: plugin
categories:
  - security

kong_version_compatibility:
    community_edition:
      compatible:
        - 2.4.x
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 2.0.x
        - 1.5.x      
        - 1.4.x
        - 1.3.x
        - 1.2.x
        - 1.1.x
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
        - 2.4.x
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 1.5.x
        - 1.3-x
        - 0.36-x


params:
  name: cors
  service_id: true
  route_id: true
  consumer_id: false
  protocols: ["http", "https"]
  dbless_compatible: yes
  config:
    - name: origins
      required: false
      default:
      value_in_examples: ["http://mockbin.com"]
      datatype: array of string elements
      description: |
        List of allowed domains for the `Access-Control-Allow-Origin` header. If you want to allow all origins, add `*` as a single value to this configuration field. The accepted values can either be flat strings or PCRE regexes.
    - name: methods
      required: false
      default: "`GET, HEAD, PUT, PATCH, POST, DELETE, OPTIONS, TRACE, CONNECT`"
      value_in_examples: [ "GET", "POST" ]
      datatype: array of string elements
      description:
        Value for the `Access-Control-Allow-Methods` header. Available
        options include `GET`, `HEAD`, `PUT`, `PATCH`, `POST`, `DELETE`, `OPTIONS`, `TRACE`, `CONNECT`.
        By default, all options are allowed.
    - name: headers
      required: false
      default: "Value of the `Access-Control-Request-Headers` request header"
      value_in_examples: [ "Accept", "Accept-Version", "Content-Length", "Content-MD5", "Content-Type", "Date", "X-Auth-Token" ]
      datatype: array of string elements
      description: |
        Value for the `Access-Control-Allow-Headers` header.
    - name: exposed_headers
      required: false
      default:
      value_in_examples: ["X-Auth-Token"]
      datatype: array of string elements
      description: |
        Value for the `Access-Control-Expose-Headers` header. If not specified, no custom headers are exposed.
    - name: credentials
      required: true
      default: "`false`"
      value_in_examples: true
      datatype: boolean
      description: |
        Flag to determine whether the `Access-Control-Allow-Credentials` header should be sent with `true` as the value.
    - name: max_age
      required: false
      default:
      value_in_examples: 3600
      datatype: number
      description: |
        Indicates how long the results of the preflight request can be cached, in `seconds`.
    - name: preflight_continue
      required: true
      default: "`false`"
      datatype: boolean
      description: A boolean value that instructs the plugin to proxy the `OPTIONS` preflight request to the Upstream service.

---

## Known issues

Below is a list of known issues or limitations for this plugin.

### CORS Limitations

If the client is a browser, there is a known issue with this plugin caused by a
limitation of the CORS specification that doesn't allow to specify a custom
`Host` header in a preflight `OPTIONS` request.

Because of this limitation, this plugin only works for Routes that have been
configured with a `paths` setting. The CORS plugin does not work for Routes that
are being resolved using a custom DNS (the `hosts` property).

To learn how to configure `paths` for a Route, read the [Proxy
Reference](/gateway/latest/reference/proxy).
