---
title: Customize OpenTelemetry spans as a developer
nav_title: Customize OpenTelemetry spans as a developer
---

The OpenTelemetry plugin is built on top of the {{site.base_gateway}} tracing PDK.

It's possible to customize the spans and add your own spans through the universal tracing PDK.

## Create a custom span

The following is an example for adding a custom span using {{site.base_gateway}}'s serverless plugin:

1. Create a file named `custom-span.lua` with the following content:

    ```lua
      -- Modify the root span
      local root_span = kong.tracing.active_span()
      root_span:set_attribute("custom.attribute", "custom value")

      -- Create a custom span
      local span = kong.tracing.start_span("custom-span")

      -- Append attributes
      span:set_attribute("custom.attribute", "custom value")
      
      -- Close the span
      span:finish()
    ```

2. Apply the Lua code using the `post-function` plugin using a cURL file upload:

    ```bash
    curl -i -X POST http://localhost:8001/plugins \
      -F "name=post-function" \
      -F "config.access[1]=@custom-span.lua"

    HTTP/1.1 201 Created
    ...
    ```

## More information

* [Troubleshooting the OpenTelemetry plugin](/hub/kong-inc/opentelemetry/#troubleshooting)
* [How logging works in the OpenTelemetry plugin](/hub/kong-inc/opentelemetry/#logging)
* [How tracing works in the OpenTelemetry plugin](/hub/kong-inc/opentelemetry/#tracing)