---
title: Publish a Service to the Dev Portal
no_search: true
no_version: true
---

Publish Services to the Dev Portal to expose them to your application
developers.

Through ServiceHub, you can publish any Service in your catalog and its
documentation to the Dev Portal using the default URL.

Setting up custom Dev Portal URLs is not currently supported through
{{site.konnect_short_name}} SaaS. If needed,
contact [Kong Support](https://support.konghq.com/), and we will manually set up
a custom Dev Portal URL for your {{site.konnect_short_name}} SaaS account.

## Publish a Service

1. From the left navigation menu, open the **Services** page and select a
Service.

2. Click on the **Actions** dropdown and select **Publish to Portal**.

    This publishes all of the Service's version specs to the Dev Portal.

3. Access the Dev Portal in any of the following ways:
    * Click the gear icon for any published Service and select **View in portal**.
    * From the left navigation menu again, go to **Dev Portal**.
    From there, click the **Portal URL**.
    * Directly visit the default Dev Portal URL:

    ```
    https://<org-name>.portal.konnect.konghq.com/
    ```

## Unpublish a Service

1. In the left navigation menu, open the **Services** page and select a Service.

2. Click on the **Actions** dropdown and select **Unpublish from Portal**.
