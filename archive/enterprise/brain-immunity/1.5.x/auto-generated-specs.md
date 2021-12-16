---
title: Auto-Generated Specs
---

## Introduction
Writing API documentation and keeping them up to date is often the easiest, most important task that either doesn't happen or doesn't happen enough. Having great API specifications is especially difficult for organizations with legacy APIs that were never documented to begin with.

Being able to use seen traffic to auto-generate OpenAPI/Swagger specifications is a crucial first step towards having and maintaining accurate API docs.


### Prerequisites
* Kong Enterprise installed and configured
* Kong Collector Plugin installed and configured
* Kong Collector App installed and configured
* Dev Portal enabled for all workspaces that need auto-generated specifications


For more information, see the [Kong Brain and Kong Immunity Installation and Configuration](/enterprise/{{page.kong_version}}/brain-immunity/install-configure) topic.


### Setup

Once you have the Collector plugin and infrastructure up and running with Dev Portal enabled, Kong Brain does not require additional configuration as it is automatically enabled. Once data is flowing through the Collector system, Brain starts generating and uploading OpenAPI/Swagger specifications to the Kong Dev Portal and populating the Service Map in Kong Manager.


#### Retrieve OpenAPI/Swagger specifications from the Collector backend

The generated OpenAPI/Swagger specifications can also be retrieved via the Collector App endpoint at `http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/swagger`.

The `/swagger` endpoint returns an OpenAPI/Swagger file, generated based on traffic matching the submitted filter parameters: `host`, `route_id`, `service_id`, and `workspace_name`.

In the specification, the fields `title`, `version`, and `description` are filled with the submitted URL parameters.

Use the parameter `openapi_version` to specify which version of the OpenAPI specification to use - possible values are `2` (default) and `3`.

```bash
http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/swagger?openapi_version=<2|3>&host=<request_host>&route_id=<route_id>&service_id=<service_id>&workspace_name=<workspace_name>&title=<title>&version=<version>&description=<description>
```
