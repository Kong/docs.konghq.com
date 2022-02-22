---
title: Alternate OpenAPI Renderer
badge: enterprise
---

Through Kong Manager [Editor](/gateway/latest/developer-portal/using-the-editor), customize how your API specs render in your Dev Portal.

To do this, add some custom code and update your config, as follows:

1. In Kong Manager Editor, navigate to Themes > base > layout > system > `spec.renderer.html`.

2. In `spec.renderer.html`, replace all of the current content with the content in this [spec-renderer.html](/gateway/latest/spec-renderer.html) file. Doing so adds the option for [Stoplight](https://meta.stoplight.io/docs/platform/ZG9jOjIwNjk2MQ-welcome-to-the-stoplight-docs) and [Redoc](https://github.com/Redocly/redoc) layouts.

3. In `theme.conf.yaml`, add the parameter `spec_renderer_type` and the value `stoplight` or `redoc`. For example:

    ```yaml
    spec_renderer_type: "stoplight"
    ```

4. Refresh your Dev Portal to see that the change has taken effect.
