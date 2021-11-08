---
name: Set Dynamic Upstream Host
publisher: Hawkeye
version: 1.0.0

desc: Constructs the upstream hostname dynamically based on incoming request parameters
description: |
  This plugin can be used to dynamically construct upstream hostname with port number based on the key identifier passed in the incoming request. If the same upstream API is deployed in different servers/data centres then this plugin can form the hostname of this upstream API dynamically to route it to particular server/data centre without any change in Kong route or service.
  This plugin extracts the key identifier from incoming request and following are the supported parameters -
* Header param
* Query param
* Path param
* Json or form-urlencoded request body

type: plugin
categories:
  - traffic-control

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
    enterprise_edition:
      compatible:
        - 2.4.x
        - 2.3.x
        - 2.2.x
        - 2.1.x
        - 1.5.x
        - 1.3-x

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
      value_in_examples: "nodenumber.org"
      datatype: string
      description: |
        Upstream host with the variable name which will be replaced by the plugin. 
        For eg: `nodenumber.org`
        Here `nodenumber` will be replaced with actual value coming in incoming request.
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
      value_in_examples: nodenumber
      datatype: string
      description: |
        Variable name which needs to be replaced from `config.upstream_host`.
        For eg: `config.upstream_host = nodenumber.org`
        `string_to_replace_from_host = nodenumber`
        Here `nodenumber` in upstream host will be replaced with actual value coming in incoming request.
    - name: header
      required: semi
      value_in_examples: target
      default:
      datatype: string
      description: |
        Header param name which will be used to form the upstream host. Only one header name needs to be passed here.
        For eg: `-H target : httpbin`. Here the value `httpbin` from the header `target` will be used to form the upstream host.
    - name: query_arg
      required: semi
      value_in_examples:
      default:
      datatype: string
      description: |
        Query param name which will be used to form the upstream host. Only one query param name needs to be passed here. 
        For eg: `/api?target=httpbin`. Here the value `httpbin` from the query `target` will be used to form the upstream host.
    - name: path_index
      required: semi
      value_in_examples:
      default:
      datatype: number
      description: |
        Path param index which will be used to form the upstream host.
        For eg: `/api/httpbin`
        For getting path param path_index here will be 2. Target will have `httpbin` in the hostname.
    - name: body_param
      required: semi
      value_in_examples:
      default:
      datatype: string
      description: |
        Body parameter name which will be used to form the upstream host.
        Only `application/json` and `application/x-www-form-urlencoded` content types are supported. For Json message the field name or Json path needs to be passed. 
        For eg: If Json message : `{"target": "httpbin"}`
        and `config.body_param=target` then `target` field in json will be used to form the upstream host. In case of duplicates the entire Json path needs to be provided. 
        For form-urlencoded if `--data-urlencode 'target=httpbin'` and `config.body_param=target`then `target` field in form body will be used to form the upstream host.
  extra: |
    Note : At any point of time only one parameter is supported and at least one is required.
---
