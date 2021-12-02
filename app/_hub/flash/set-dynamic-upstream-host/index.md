---
name: Set Dynamic Upstream Host
publisher: Flash
version: 1.0.0

desc: Constructs the upstream hostname dynamically based on the incoming request parameters
description: |
  This plugin can dynamically construct the upstream hostname and 
  port number based on the key identifier passed in the incoming request. If the same 
  upstream API is deployed in different servers or data centers, then this plugin can 
  form the hostname for the upstream API dynamically to route it to a particular 
  server or data center without making any changes in Kong Route or Service 
  configuration.
  
  
support_url: https://github.com/anup-krai/kong-plugin-set-dynamic-target-host/issues
source_url: https://github.com/anup-krai/kong-plugin-set-dynamic-target-host
license_type: Apache-2.0 

type: plugin
categories:
  - traffic-control

kong_version_compatibility:
    community_edition:
      compatible:
        - 2.5.x
        - 2.4.x

params:
  name: set-target-host
  service_id: true
  route_id: false
  consumer_id: false
  protocols: ["http", "https"]
  dbless_compatible: true
    
  config:
    - name: upstream_host
      required: true
      default:
      value_in_examples: "example.org"
      datatype: string
      description: |
        Upstream host with the variable string which has to be replaced by the plugin.
        
        For example, `config.upstream_host` can be set to `example.org`.
    - name: upstream_port
      required: false
      default: "443"
      value_in_examples:
      datatype: string
      description: |
        Upstream server port number. Default value is `443` if not provided in plugin configuration.
    - name: string_to_replace_from_host
      required: true
      default:
      value_in_examples: example
      datatype: string
      description: |
        String to replace from the `config.upstream_host` parameter.
        
        For example, if `config.upstream_host` is set to `example.org` and 
        `config.string_to_replace_from_host` is set to `example`, then the
        `example` string in the upstream host is replaced with the key identifier 
        value from the incoming request dynamically.
    - name: header
      required: semi
      value_in_examples: target
      default:
      datatype: string
      description: |
        Header parameter name used to form the upstream host. Only one header name is supported.
        
        For example, `header` is set to `target`, and the incoming request 
        includes the header `-H target : httpbin`. The value `httpbin` 
        from the header `target` is used to form the upstream host. 
        The final upstream hostname formed is `httpbin.org`, and 
        Kong makes a call to this host.
    - name: query_arg
      required: semi
      value_in_examples:
      default:
      datatype: string
      description: |
        Query parameter name used to form the upstream host. Only one query parameter name is supported. 

        For example, `query` is set to `target` and the incoming request includes the 
        query `/api?target=httpbin`. The value `httpbin` from the query param `target` 
        is used to form the upstream host.
        The final upstream hostname formed is `httpbin.org`, and 
        Kong makes a call to this host.
    - name: path_index
      required: semi
      value_in_examples:
      default:
      datatype: number
      description: |
        Path parameter index used to form the upstream host.
        For example, `path_index` is set to `2`, and the incoming request uses the 
        path `/api/httpbin`. Based on the path index, the second string, `httpbin`, is
        extracted from the URI.
        The final upstream hostname formed is `httpbin.org`, and Kong makes a call to 
        this host.
    - name: body_param
      required: semi
      value_in_examples:
      default:
      datatype: string
      description: |
        Request body parameter name used to form the upstream host.
        Only `application/json` and `application/x-www-form-urlencoded` content types are 
        supported. For a JSON message, the field name or JSON Path must be passed. 

        For example, if the JSON message is `{"target": "httpbin"}`
        and `config.body_param` is set to `target`,  the `httpbin` value from the 
        `target` field in the JSON message is used to form the upstream host. 
       
         In case of duplicates (target field in JSON), the entire JSON Path needs to 
         be provided. 
        For example, if a  form-urlencoded payload contains 
        `--data-urlencode 'target=httpbin'` and `config.body_param` is set to 
        `target`, the `httpbin` value from the `target` field in the form body is used 
        to construct the upstream host.
  extra: |
    **Note**: Only one of `header`, `query_arg`, `path_index`, or `body_param` can be provided at one time, and at least one is required.
---
