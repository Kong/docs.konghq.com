---
title: Getting Started with the Kong Developer Portal
---

## Enable the Dev Portal

1. Open the Kong configuration file in your editor of choice (`kong.conf`)
2. Find and change the `portal` configuration option to `on` and remove the `#` from the beginning of the line, it should now look like:
  - **`portal = on`**
        1. Enables the **Dev Portal File API** which can be accessed at: `:8001/files`
        2. Serves the **Dev Portal** **Loader** on port  `:8003`
        3. Enables the **Public Dev Portal API** on port  `:8004`
          - The **Public Dev Portal File API** can be accessed at `:8004/file`
3. Restart Kong (`kong restart`)

> Note: Not all deployments of Kong utilize a configuration file, if this describes you (or you are unsure) please reference the [Kong configuration docs](/{{page.kong_version}}/configuration/) in order to implement this step.
