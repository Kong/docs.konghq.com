---
title: Alternate OpenAPI Renderer
badge: enterprise
---

Through Kong Manager, use the Dev Portal [Editor](/gateway/{{page.kong_version}}/developer-portal/using-the-editor) to customize how your API specs render in your Dev Portal.

To do this, add some custom code and update your config, as follows:

1. In Kong Manager, navigate to the Dev Portal Editor from the left sidebar.

1. Navigate to **Themes** > **base** > **layout** > **system** > **`spec.renderer.html`**.

1. In `spec.renderer.html`, replace all of the current content with the content from this [spec-renderer.html](/code-snippets/spec-renderer.html) file. Doing so adds options for [Stoplight](https://meta.stoplight.io/docs/platform/ZG9jOjIwNjk2MQ-welcome-to-the-stoplight-docs) and [Redoc](https://github.com/Redocly/redoc) layouts.

1. In `theme.conf.yaml`, add the parameter `spec_render_type` and the value `stoplight` or `redoc`. For example:

    ```yaml
    spec_render_type: "stoplight"
    ```

1. Refresh your Dev Portal to see that the change has taken effect.
