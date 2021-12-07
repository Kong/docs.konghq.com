---
title: Auto-Generated Specs
---

## Introduction
Writing API documentation and keeping them up to date is often the easiest, most important task that either doesn't happen or doesn't happen enough.  Having great API specs is especially difficult for organizations with legacy APIs that were never documented to begin with.

Being able to use seen traffic to auto-generated Swagger and Open API specs is a crucial first step towards having and maintaining accurate API docs.


### Prerequisites
* Kong Enterprise installed and configured
* Kong Collector Plugin installed and configured
* Kong Collector App installed and configured
* Dev Portal enabled for all workspaces that need auto-generated specifications


For more information, see the [Kong Brain and Kong Immunity Installation and Configuration Guide](/enterprise/{{page.kong_version}}/brain-immunity/install-configure).


### Setup

Once you have the Collector plugin and infrastructure up and running with Dev Portal enabled, Kong Brain does not require additional configuration as it is automatically enabled. Once data is flowing through the Collector system, Brain starts generating swagger files and service-maps as displayed on the Dev Portal.


#### Retrieve Open-Spec Files from Collector Backend

Open-spec files can also be retrieved via the Collector App endpoint on **<COLLECTOR_APP_ENDPOINT>/swagger**.  The **/swagger** endpoint returns a swagger file, generated considering traffic that match the submitted filter parameters: `host`, `route_id`, `service_id` and `workspace_name`. Also, it fills the fields `title`, `version` and `description` within the swagger file with the respective submitted parameters.

```
http://<COLLECTOR_APP_ENDPOINT>/swagger?host=<request_host>&openapi_version=<2|3>&route_id=<route_id>&service_id=<service_id>&workspace_name=<workspace_name>?title=
```
