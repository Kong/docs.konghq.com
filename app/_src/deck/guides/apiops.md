---
title: APIOps with decK 
content_type: explanation
---

## APIOps with decK

API Lifecycle Automation (APIOps) is the process of applying 
automation frameworks to API best practices. decK enables APIOps by 
providing a tool with varied commands that can be coordinated to build 
API delivery automations.

decK commands break down into the following categories:

* Configuration generation
* Configuration transformation
* Gateway state management

This document will provide a guide on using the configuration 
generation and transformation commands to build an API automation delivery pipeline.

## Configuration Generation

[OpenAPI](https://swagger.io/specification/) is the de facto standard 
for defining API behavior. OpenAPI Specifications (OAS) are very useful
for many API development related tasks including generating documentation
and API client code. With decK, you can also generate {{site.base_gateway}}
configuration from OAS files.

Let's assume you have the following minimal OAS in a file named `oas.yaml`:

```yaml
openapi: 3.0.0
info:
  title: Mockbin API
  description: Simple API for testing purposes
  version: 1.0.0
servers:
  - url: http://mockbin.org
paths:
  /request:
    get:
      summary: Get a simple response from the /request resource of the mockbin API
      responses:
        '200':
          description: Successful response
```

You can generate a {{site.base_gateway}} configuration with the following:

```sh
deck file openapi2kong --spec oas.yaml --output-file mockbin.yaml
```

Which produces a complete decK configuration file:

```yaml
_format_version: "3.0"
services:
- host: mockbin.org
  id: de7107e7-a39c-5574-9e8c-e66787ae50e7
  name: mockbin-api
  path: /
  plugins: []
  port: 80
  protocol: http
  routes:
  - id: 803b324e-98ed-5ec5-aecf-b4ce973036f4
    methods:
    - GET
    name: mockbin-api_request_get
    paths:
    - ~/request$
    plugins: []
    regex_priority: 200
    strip_path: false
    tags: []
  tags: []
upstreams: []
```

{:.note}
> **Note**: The {{site.base_gateway}} [getting started guide](/gateway/{{page.kong_version}}/get-started/) 
can help you quickly run a gateway in Docker to follow along with these instructions.

You can syncronize this directly to the gateway using `deck sync`. 

```sh
deck sync -s mockbin.yaml
```

However, you will generally want to configure more sophisticated {{site.base_gateway}} capabilities 
for your API. Maybe you want to secure your API with an 
[authentication plugin](https://docs.konghq.com/hub/?category=security), 
or protect it with [traffic management](https://docs.konghq.com/hub/?category=traffic-control).
These API Gateway concepts are usually orthogonal to the OAS, and a clearer
separation of concerns is achieved if they are configured independently of the specification.

This can be accomplished with decK file _transformations_. 

## Configuration Transformations

If you are building microservices or an API platform for multiple teams, you will likely have 
multiple services and code repositories which may have their own decK configuration files. 
Using decK file transformation commands, you can organize your decK configuration files into partial segments 
of the full configuration and assemble them prior to syncronizing with {{site.base_gateway}}. 
This allows you to organize different aspects of the configuration in alignment with the rest of your
software development artifacts.

Continuing the example above, let's assume you have second team that builds a different API, and
provides a {{site.base_gateway}} decK configuration segment for their service and route:

```yaml
_format_version: "3.0"
services:
- host: mockbin.org
  id: de7107e7-a39c-5574-9e8c-e66787ae50e7
  name: another-mockbin-api
  path: /
  plugins: []
  port: 80
  protocol: http
  routes:
  - id: 803b324e-98ed-5ec5-aecf-b4ce973036f4
    methods:
    - GET
    name: another-mockbin-api_request_get
    paths:
    - ~/another-request$
    plugins: []
    regex_priority: 200
    strip_path: false
    tags: []
  tags: []
upstreams: []
```

We can use the decK `file merge` command to bring these two configurations into one. Assume the previous 
configuration is in a file named `another-mockbin.yaml`. 

```sh
deck file merge mockbin.yaml another-mockbin.yaml --output-file merged-kong.yaml
``` 

The `merged-kong.yaml` is now a single decK file with both services and routes merged. This file is
also a complete deck file and could be syncronized to a gateway. Before we do, let's take the example one step further.

Now assume you want to ensure that all services in your configuration communicate with the upstream endpoint 
via `https` only. We can use the deck `file patch` command to accomplish this.

```sh
deck file patch --state merged-kong.yaml \
  --selector "$.services[*]" \
  --value 'protocol: "https"' \
  --output-file kong.yaml
```

The final `kong.yaml` file is a full configuration we can syncronize to the gateway:

```sh
deck sync -s kong.yaml
```

These examples are trivial, but they intend to only show how commands can be pipelined to create
API lifecycle automations. Using common CI/CD tools built into your version control system, you'll be able to bring
full and partial {{site.base_gateway}} configurations together from multiple repositories, and create 
sophisticated automations.

