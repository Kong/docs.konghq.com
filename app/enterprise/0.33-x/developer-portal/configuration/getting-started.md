---
title: Getting Started with the Kong Developer Portal
book: portal
chapter: 3
---

## Enable the Dev Portal

1. Open the Kong configuration file in your editor of choice (`kong.conf`)
2. Find and change the `portal` configuration option to `on` Don't forget to remove the `#` from the beginning of the line, it should now look like: `portal = on`.
   - Enables the **Dev Portal Files endpoint** on Admin API which can be accessed at: `:8001/files`
   - Enables the **Public Dev Portal Files API** which can be accessed at `:8004/files`
   - Serves the **Dev Portal Loader** on port `:8003`
3. Restart Kong (`kong restart`)

> Note: Not all deployments of Kong utilize a configuration file, if this describes you (or you are unsure) please reference the [Kong configuration docs](https://getkong.org/0.13.x/configuration/) in order to implement this step.

## Visit the Example Dev Portal

Now that you have enabled the Dev Portal in Kong, you can visit the Example Dev Portal:

- Navigate your browser to `http://127.0.0.1:8003`

You should now see the Default Dev Portal Homepage, and be able to navigate through the example pages.

## Next Steps

### Adding Authentication

To add Authentication, head on over to [Authenticating the Dev Portal](/enterprise/{{page.kong_version}}/developer-portal/configuration/authentication).

### Customizing

To begin customizing your Dev Portal, jump to [Customizing the Kong Developer Portal](/enterprise/{{page.kong_version}}/developer-portal/customization).

Next: [Authentication &rsaquo;]({{page.book.next}})
