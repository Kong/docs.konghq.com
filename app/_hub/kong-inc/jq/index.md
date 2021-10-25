---
name: jq
publisher: Kong Inc.
versions: 0.0.1

desc: Transform JSON objects included in API requests or responses using jq programs.
description: |
  The jq plugin enables arbitrary jq transformations on JSON objects included in API requests or responses.

  The configuration accepts two sets of options: one for the request and another for the response.
  For both the request and response, a jq program string can be included, along with some jq option flags
  and a list of media types. 
  
  One of the configured media types must be included in the `Content-Type` header of
  the request or response for the jq program to run. The default media type in the `Content-Type`
  header is `application/json`. 
  
  In the response context, you can also specify a list of status
  codes, one of which must match the response status code. 
  The default response status code is `200`.

  {:.note}
  > **Note:** In the response context the entire body must be buffered to be processed. This requirement also
  implies that the `Content-Length` header will be dropped if present, and the body transferred with chunked encoding.

  See jq's documentation on [Basic filters](https://stedolan.github.io/jq/manual/#Basicfilters) for more information on writing programs with jq.

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
  protocols: ["http","https"]
  dbless_compatible:
  examples: false
  config:
    - name: request_jq_program
      required: semi
      datatype: string
      description: |
        The jq program to run on the request body. For example, `.[0] | { "X-Foo": .foo }`. 
        Either `request_jq_program` or `response_jq_plugin` **must** be included in the configuration.
    - name: request_jq_program_options
      required: false
      datatype: record
      description: |
        Boolean option flags to modify the run behavior of the jq program run on the request body.
        - `compact_output`: Returns output in a compact form without additional spacing,
          and with each JSON object on a single line. Defaults to `true`. Set to `false` for "pretty" output.
        - `raw_output`: Outputs as raw strings, not JSON quoted. Default is `false`.
        - `join_output`: Similar to `raw_output` but does not output newline separators. Default is `false`.
        - `ascii_output`: jq usually outputs non-ASCII Unicode codepoints as UTF-8, even if the input specified
           them as escape sequences (like `\u03bc`). Using this option, you can force jq to produce pure ASCII
           output, replacing every non-ASCII character with the equivalent escape sequence. Default is `false`.
        - `sort_keys`: Outputs the fields of each object with the keys in sorted order. Default is `false`.
    - name: request_if_media_type
      required: false
      datatype: array of strings
      default: ["application/json"]
      description: |
        A list of media type strings. The media type included in the `Content-Type` request header **must**
        match one of the media types on this list for the program to run.
    - name: response_jq_program
      required: semi
      datatype: string
      description: |
        The jq program to run on the response body. For example, `.[0] | { "X-Foo": .foo }`. 
        Either `request_jq_program` or `response_jq_plugin` **must** be included in configuration.
    - name: response_jq_program_options
      required: false
      datatype: record
      description: |
        Boolean option flags to modify the run behavior of the jq program run on the response body.
        - `compact_output`: Returns output in a compact form without additional spacing,
          and with each JSON object on a single line. Defaults to `true`. Set to `false` for "pretty" output.
        - `raw_output`: Outputs as raw strings, not JSON quoted. Default is `false`.
        - `join_output`: Similar to `raw_output` but does not output newline separators. Default is `false`.
        - `ascii_output`: jq usually outputs non-ASCII Unicode codepoints as UTF-8, even if the input specified
           them as escape sequences (like `\u03bc`). Using this option, you can force jq to produce pure ASCII
           output, replacing every non-ASCII character with the equivalent escape sequence. Default is `false`.
        - `sort_keys`: Outputs the fields of each object with the keys in sorted order. Default is `false`.
    - name: response_if_media_type
      required: false
      datatype: array of strings
      default: ["application/json"]
      description: |
        A list of media type strings. The media type included in the `Content-Type` response header **must**
        match one of the media types on this list for the program to run.
    - name: response_if_status_code
      required: false
      datatype: array of integers
      default: [200]
      description: |
        A list of HTTP response status codes. The response status code **must**
        match one of the response status codes on this list for the program to run.

---


