---
name: Set Dynamic Upstream Host
publisher: Flash
version: 1.0.0

desc: Constructs the upstream hostname dynamically based on the incoming request parameters
description: |
  This plugin can be used to dynamically construct upstream hostname and port number based on the key identifier passed in the incoming request. If the same upstream api is deployed in different servers or data centers, then this plugin can form the hostname for the upstream api dynamically to route it to particular server or data center without making any change in Kong route or service.
  This plugin extracts the key identifier from the incoming request and following are the supported parameters -
  * Header param
  * Query param
  * Path param
  * Body param
  
  
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
        For eg: `config.upstream_host` is set to `example.org`
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
        String which needs to be replaced from `config.upstream_host` parameter.
        For eg: If `config.upstream_host` is set to `example.org` and 
        `config.string_to_replace_from_host` is set to `example` then
        `example` string in the upstream host will be replaced with the key identifier value coming in the incoming request dynamically.
    - name: header
      required: semi
      value_in_examples: target
      default:
      datatype: string
      description: |
        Header param name which will be used to form the upstream host. Only one header name is supported.
        For eg: `-H target : httpbin`. Here the value `httpbin` from the header `target` will be used to form the upstream host. 
        Final upstream hostname formed here is `httpbin.org` and Kong will make a call to this host.
    - name: query_arg
      required: semi
      value_in_examples:
      default:
      datatype: string
      description: |
        Query param name which will be used to form the upstream host. Only one query param name is supported. 
        For eg: `/api?target=httpbin`. Here the value `httpbin` from the query param `target` will be used to form the upstream host.
        Final upstream hostname formed here is `httpbin.org` and Kong will make a call to this host.
    - name: path_index
      required: semi
      value_in_examples:
      default:
      datatype: number
      description: |
        Path param index which will be used to form the upstream host.
        For eg: `/api/httpbin`. Path index is required to get the path param value and here in this example path_index value is 2. 
        Based on the path index, `httpbin` string will be extracted from the uri.
        Final upstream hostname formed here is `httpbin.org` and Kong will make a call to this host.
    - name: body_param
      required: semi
      value_in_examples:
      default:
      datatype: string
      description: |
        Request body parameter name which will be used to form the upstream host.
        Only `application/json` and `application/x-www-form-urlencoded` content types are supported. For Json message, the field name or Json path needs to be passed. 
        For eg: If Json message is `{"target": "httpbin"}`
        and `config.body_param=target` then `httpbin` value from the `target` field in the json will be used to form the upstream host. 
        In case of duplicates (target field in json) the entire Json path needs to be provided. 
        For form-urlencoded payload if `--data-urlencode 'target=httpbin'` and `config.body_param=target` then `httpbin` value from the `target` field in the form body will be used to construct the upstream host.
  extra: |
    Note : Only one of `header`, `query_arg`, `path_index` or `body_param` can be provided at one time, and at least one is required.
---
