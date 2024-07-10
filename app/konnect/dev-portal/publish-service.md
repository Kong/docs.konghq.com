---
title: Add and publish API product documentation
---

The Dev Portal is an API catalog that lets you document and publish your {{site.konnect_short_name}} API products
and share them with your developers. Developers can use the Dev Portal to
locate, access, consume, and register applications to the products. 

This guide walks you through associating API specs and product documentation with your API products, and viewing any published content, and Dev Portal specific customization options.

Published API products become immediately available to users who have access to the Dev Portal. When an API product is published, the API spec and any product documentation becomes discoverable. We use the term discoverable here because the Dev Portal can create a unified API experience where a developer can navigate through the different APIs that are available, read documentation, test endpoints within the Dev Portal, and register to create applications for specific APIs. 


### Add Product Documentation

You can provide extended descriptions of your {{site.konnect_short_name}} API products with a Markdown (`.md`) file.
The contents of this file will be displayed as the introduction to your API in the Dev Portal.

1. Write a description for your API in Markdown (`.md`).

    If you don't have a file you can use for testing, copy the following text
    into a blank `.md` file:

    ```md
    Here's a description with some **formatting**.

    Here's a bulleted list:
    * One
    * Two
    * Three

    You can [add relative links](/) and [absolute links](https://cloud.konghq.com).

    Try adding a codeblock for code snippets:

        This is a test

    ```

1. In the {% konnect_icon api-product %} [**API Products**](https://cloud.konghq.com/api-products), select a service.

1. Select **Documentation**, upload your documentation, add a **Page name**, and an optional **URL slug**. 
1. Click **Save**.


### Add an API Spec {#add-api-spec}

Every version can have one OpenAPI spec associated with it, in JSON or YAML format.

If you have a spec, use it in the following steps. Otherwise, you can
use the [sample Analytics spec](/konnect/vitalsSpec.yaml) for testing.


1. From the {% konnect_icon api-product %} [**API Products**](https://cloud.konghq.com/api-products) dashboard, select **Product Version** then click the product version you want to upload the spec for. 

1. In the **API Spec** tab, click **Upload**.

1. Select a spec file to upload.

    The spec must be in YAML or JSON format. To test this functionality, you
    can use [vitalsSpec.yaml](/konnect/vitalsSpec.yaml) as a sample spec.

This OpenAPI spec will be shown under the version name when this service is
published to the Dev Portal.

## Publish an API product and API product version to a Dev Portal

To publish an API, you must publish both the API product and API product version to the Dev Portal.

1. In {% konnect_icon dev-portal %} [**Dev Portal**](https://cloud.konghq.com/portal), select the Dev Portal you want to publish the API for.
1. Click [**API Products**](https://cloud.konghq.com/api-products/).
1. Select the API product you want to publish. On the API product overview page, click **Add** and select **Publish to Dev Portals** in the menu.
1. Click **Publish** to publish your API product to a specific Dev Portal.  
1. In {% konnect_icon api-product %} [**API Products**](https://cloud.konghq.com/api-products), select the API product you added to the Dev Portal. 
1. Click **Product Versions** in the sidebar.
1. Click the product version you created previously and want to publish to your Dev Portals. From the **Actions** menu or the **Dev Portals** tab, click **Publish to Dev Portals** and select the Dev Portals you want to publish the product version to.

The API product and product versions should now display in the Dev Portals you selected.

## View the published content on Dev Portal

In this section, you can take one of two paths: keep the Dev Portal private
and require a login, or switch it to public, making it visible to anyone with
a link.

If you choose to make the Dev Portal public, application registration
will not be available.

{:.note}
> **Note:** The Dev Portal is a separate site that requires its own credentials.
You can't use your {{site.konnect_short_name}} credentials to log in here.

{% navtabs %}
{% navtab Private Dev Portal %}

1. Access the Dev Portal in one of the following ways:
    * Open {% konnect_icon dev-portal %} [**Dev Portal**](https://cloud.konghq.com/portal) from the left side menu.
      From there, click the **Portal URL**.
    * Directly visit the default Dev Portal URL:

    ```
    https://{ORG_NAME}.portal.cloud.konghq.com/
    ```

1. Click **Sign Up** and fill out the form to create a developer account.

    Remember, the Dev Portal does not share credentials with your {{site.konnect_short_name}}
    account.

1. As an admin, return to {{site.konnect_short_name}} and approve the account:

    1. From the left side menu, click {% konnect_icon dev-portal %} **Dev Portal**.
    Then click **Access Requests** to open the Access Requests page, which displays all pending developer request.

    2. In the row for developer request you want to approve, click the icon and choose
       **Approve** from the context menu.

       The status is updated from **Pending** to **Approved**. The developer
       transfers from the pending Requests page Developers tab to the Developers page.

1. Check your email for a confirmation link. Click the link, then log
into the Dev Portal.

1. Open any API product you have published to check it out.

{% endnavtab %}
{% navtab Public Dev Portal %}

1. Open {% konnect_icon dev-portal %} [**Dev Portal**](https://cloud.konghq.com/portal) from the left side menu,
then click **Settings**.

1. In the **Public Portal** pane, toggle the switch to **Enabled**.

1. Click **Save**.

1. Access the Dev Portal in one of the following ways:
    * From the left navigation menu again, go to **Dev Portal**.
    From there, click the **Portal URL**.
    * Directly visit the default Dev Portal URL:

    ```
    https://{ORG_NAME}.portal.cloud.konghq.com/
    ```

1. Open any API Product you have published to check it out.

{% endnavtab %}
{% endnavtabs %}

## Summary

In this topic, you added documentation for your API product and logged into the Dev Portal to check out the API product documentation live.

## More information

* [API product documentation](/konnect/api-products/service-documentation/): This doc explains how to upload, edit, and publish product documentation using the **API Products** dashboard and publish API product to the Dev Portal to be consumed by your users.
* [Manage Konnect API product versions](/konnect/api-products/): This explains how to manage the API product version for your services, including the status of the API product version. API product versions can have a status of "Published", "Deprecated", or "Unpublished".
* [Register an application to the API product](/konnect/dev-portal/applications/dev-apps/).
* [Customize Dev Portal](/konnect/dev-portal/customization/)
