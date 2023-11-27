---
title: APIOps with decK 
content_type: explanation
---

API Lifecycle Automation (APIOps) is the process of applying 
automation frameworks to API best practices. decK enables APIOps by 
providing a tool with varied commands that can be coordinated to build 
API delivery automations.

decK commands break down into the following categories:

* Configuration generation
* Configuration transformation
* Gateway state management

This guide walks you through using the configuration 
generation and transformation commands to build an API automation delivery pipeline.

## Configuration generation

[OpenAPI](https://swagger.io/specification/) is the most commonly used standard 
for defining API behavior. OpenAPI Specifications (OAS) are useful
for many API development related tasks including generating documentation
and API client code. With decK, you can also generate {{site.base_gateway}}
configuration from OAS files.

Let's assume you have the following minimal OAS in a file named `oas.yaml`:

```yaml
openapi: 3.0.0
info:
  title: httpbin API
  description: Simple API for testing purposes
  version: 1.0.0
servers:
  - url: http://httpbin.org
paths:
  /request:
    get:
      summary: Get a simple response from the /request resource of the httpbin API
      responses:
        '200':
          description: Successful response
```

You can generate a {{site.base_gateway}} configuration with the following:

```sh
deck file openapi2kong \
  --spec oas.yaml \
  --output-file httpbin.yaml
```

Which produces a complete decK configuration file:

```yaml
_format_version: "3.0"
services:
- host: httpbin.org
  id: de7107e7-a39c-5574-9e8c-e66787ae50e7
  name: httpbin-api
  path: /
  plugins: []
  port: 80
  protocol: http
  routes:
  - id: 803b324e-98ed-5ec5-aecf-b4ce973036f4
    methods:
    - GET
    name: httpbin-api_request_get
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
> **Note**: The {{site.base_gateway}} [getting started guide](/gateway/latest/get-started/) 
can help you quickly run a gateway in Docker to follow along with these instructions.

You can synchronize this directly to the gateway using `deck sync`:

```sh
deck sync -s httpbin.yaml
```

Which creates the service and route:

```sh
creating service httpbin-api
creating route httpbin-api_request_get
Summary:
  Created: 2
  Updated: 0
  Deleted: 0
```

This is a very simple example. In reality, you will generally want to configure more sophisticated {{site.base_gateway}} capabilities 
for your API. Maybe you want to secure your API with an 
[authentication plugin](/hub/?category=security), 
or protect it with [traffic management](/hub/?category=traffic-control).
These API Gateway concepts are usually orthogonal to the OAS, and a clearer
separation of concerns is achieved if they are configured independently of the specification.

This can be accomplished with decK file _transformations_. 

## Configuration transformations

If you are building microservices or an API platform for multiple teams, you likely have 
multiple services and code repositories with their own decK configuration files. 
Using decK file transformation commands, you can organize your decK configuration files into partial segments 
of the full configuration and assemble them prior to synchronizing with {{site.base_gateway}}. 
This allows you to organize different aspects of the configuration in alignment with the rest of your
software development artifacts.

Continuing the example above, let's take a look at how commands can be pipelined to create API lifecycle automations.

Let's assume you have a second team that builds a different API, and
provides a {{site.base_gateway}} decK configuration segment for their service and route. Copy the 
following configuration into a file named `another-httpbin.yaml`:

```yaml
_format_version: "3.0"
services:
- host: httpbin.org
  id: 7cc31086-3837-4e7e-bbe9-271e51c1f614 
  name: another-httpbin-api
  path: /
  plugins: []
  port: 80
  protocol: http
  routes:
  - id: 08ac3482-843a-40f8-a277-a4e73baf19d9 
    methods:
    - GET
    name: another-httpbin-api_request_get
    paths:
    - ~/another-request$
    plugins: []
    regex_priority: 200
    strip_path: false
    tags: []
  tags: []
upstreams: []
```

You can use the decK `file merge` command to bring these two configurations into one:

```sh
deck file merge httpbin.yaml another-httpbin.yaml \
  --output-file merged-kong.yaml
``` 

You now have a file named `merged-kong.yaml`, which is a single decK file with both services and routes merged. This file is
also a complete deck file and could be synchronized to a gateway. Before doing that, let's take the example one step further.

Now assume you want to ensure that all services in your configuration communicate with the upstream endpoint 
via `https` only. You can use the deck `file patch` command to accomplish this:

```sh
deck file patch --state merged-kong.yaml \
  --selector "$.services[*]" \
  --value 'protocol: "https"' \
  --output-file kong.yaml
```

The final `kong.yaml` file is a full configuration you can synchronize to the gateway:

```sh
deck sync -s kong.yaml
```

Here is an example of putting the above together in a Unix-style pipeline:

```sh
deck file openapi2kong --spec oas.yaml --output-file httpbin.yaml && 
  deck file merge httpbin.yaml another-httpbin.yaml | 
  deck file patch --selector "$.services[*]" --value 'protocol: "https"' |
  deck sync -s -
```

Most commonly, you will use the commands from CI/CD tools built into your version control system
to bring full and partial {{site.base_gateway}} configurations together to create APIOps for your 
particular needs.

## More information

See the example file at [Kong/go-apiops](https://github.com/Kong/go-apiops/blob/main/docs/learnservice_oas.yaml)
for extensive annotations explaining the conversion process, as well as all supported custom 
annotations (`x-kong-...` directives).
