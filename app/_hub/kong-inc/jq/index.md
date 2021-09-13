---
name: Kong jq
publisher: Kong Inc.
versions: 0.1.x
beta: true

desc: Provides arbitrary jq transformations to a JSON object.
description: |
    Provides arbitrary jq transformations to a JSON object. The source of the object can either be the request or response body, and the transformed result can either replace the body or be used to set HTTP headers.

    Multiple filters can be specified in the configuration. You can use these filters to set request headers from values present in the request body, and then rewrite the response body with a separate jq program.

enterprise: true
type: plugin
categories:
 - transformations

kong_version_compatibility:
    enterprise_edition:
      compatible: 
        - 2.6.x

params:
  name: jq
  service_id: true
  route_id: true
  consumer_id: true
  yaml_examples: false
  k8s_examples: false
  konnect_examples: false
  protocols: ["http"]
  dbless_compatible:
  config:
    - name: request_jq_program
      required: semi
      datatype: string
      description: |
        The jq program to run on the request body. For example, `.[0] | { "X-Foo": .foo }`. 
        Either `request_jq_program` or `response_jq_plugin` must be included in configuration.
    - name: request_jq_options
      required: false
      datatype: record
      description: |
        Boolean option flags to modify the run behavior of the jq program run on the request body.
        - `compact_output`: Returns output in a compact form without additional spacing,
          and with each JSON object on a single line. Defaults to `true`. Set to `false` for "pretty" output.
        - `raw_output`: Outputs as raw strings, not JSON quoted. Default is `false`.
        - `join_output`: Similar to `raw_output` but does not output newline separators. Default is `false`.
        - `ascii_output`: jq usually outputs non-ASCII Unicode codepoints as UTF-8, even if the input specified
           them as escape sequences (like "\u03bc"). Using this option, you can force jq to produce pure ASCII
           output, replacing every non-ASCII character with the equivalent escape sequence. Default is `false`.
        - `sort_keys`: Outputs the fields of each object with the keys in sorted order. Default is `false`.

        For further explanations, see the [lua-resty-jq documentation](https://github.com/bungle/lua-resty-jq#filter).
    - name: request_if_media_type
      required: false
      datatype: array of strings
      default: ["application/json"]
      description: |
        A list of media type strings, which must be present in the `Content-Type` header for the request program to run.
    - name: response_jq_program
      required: semi
      datatype: string
      description: |
        The jq program to run on the response body. For example, `.[0] | { "X-Foo": .foo }`. 
        Either `request_jq_program` or `response_jq_plugin` must be included in configuration.
    - name: response_jq_options
      required: false
      datatype: record
      description: |
        Boolean option flags to modify the run behavior of the jq program run on the response body.
        - `compact_output`: Returns output in a compact form without additional spacing,
          and with each JSON object on a single line. Defaults to `true`. Set to `false` for "pretty" output.
        - `raw_output`: Outputs as raw strings, not JSON quoted. Default is `false`.
        - `join_output`: Similar to `raw_output` but does not output newline separators. Default is `false`.
        - `ascii_output`: jq usually outputs non-ASCII Unicode codepoints as UTF-8, even if the input specified
           them as escape sequences (like "\u03bc"). Using this option, you can force jq to produce pure ASCII
           output, replacing every non-ASCII character with the equivalent escape sequence. Default is `false`.
        - `sort_keys`: Outputs the fields of each object with the keys in sorted order. Default is `false`.

        For further explanations, see the [lua-resty-jq documentation](https://github.com/bungle/lua-resty-jq#filter).
    - name: response_if_media_type
      required: false
      datatype: array of strings
      default: ["application/json"]
      description: |
        A list of media type strings, which must be present in the `Content-Type` header for the response program to run.
    - name: response_if_status_code
      required: false
      datatype: array of integers
      default: [200]
      description: |
        A list of HTTP response status codes which must be present for the response program to run.
---


