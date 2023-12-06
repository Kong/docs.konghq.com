---
title: Add Documentation
---

The Dev Portal is an API catalog that lets you document your {{site.konnect_short_name}} API products
and share them with your developers. Developers can use the Dev Portal to
locate, access, consume, and register applications against the products.

This guide walks you through associating API specs and product documentation with your API products, and viewing any published content, and Dev Portal specific customization options.


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


1. From the {% konnect_icon api-product %} [**API Products**](https://cloud.konghq.com/api-products) dashboard, select **Product Version** then **Upload**. 

1. Find the **Version Spec** section and click **Upload Spec**.

1. Select a spec file to upload.

    The spec must be in YAML or JSON format. To test this functionality, you
    can use [vitalsSpec.yaml](/konnect/vitalsSpec.yaml) as a sample spec.

This OpenAPI spec will be shown under the version name when this service is
published to the Dev Portal.


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

1. Open the API product you published to check it out.

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
1. To view an API Product's documentation alongside its dynamic API reference (based on the API specification), navigate to {% konnect_icon api-product %} [**API Products**](https://cloud.konghq.com/api-products) and publish your API product along with its API version.
    * In the API Products section, select your API Product. Then, click **Actions** and select **Publish to portal**.
    * From the left-side navigation panel, select **Product Version** and click on the version you created previously. On the version's homepage, change the **Status** to **Published**.

1. Open the service you published to check it out.

{% endnavtab %}
{% endnavtabs %}


## Customize your Dev Portal

You can customize the Dev Portal to make it your own.
Let's change up a couple of things:

1. Return to {{site.konnect_short_name}}. From the left side menu, open {% konnect_icon dev-portal %}
**Dev Portal**, then [**Appearance**](https://cloud.konghq.com/portal/portal-appearance).

1. Try out a couple of customization options - whatever you like.

    * Choose a preset theme and adjust it to your needs
    * Set some home page text
    * Upload header, logo, or favicon images
    * Play around with the colours and fonts of your site

    You could also [add a custom domain](/konnect/dev-portal/customization/),
    if you have one you want to use.

1. Click **Save** to apply the changes.

1. Switch back to the Dev Portal to see your changes live.

## Summary and next steps

In this topic, you:
* Logged into the Dev Portal to check out the API product documentation live
* Customized the Dev Portal

Next, [register an application against the API product](/konnect/getting-started/app-registration/).
