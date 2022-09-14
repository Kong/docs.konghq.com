---
title: Publish and Consume Services
no_version: true
---

The Dev Portal is an API catalog that lets you document your {{site.konnect_short_name}} services
and share them with your developers. Developers can use the Dev Portal to
locate, access, consume, and register applications against the services.

This guide walks you through setting up a sample API spec and description for
the {{site.konnect_short_name}} service and publishing the service to the Dev
Portal. You'll also have a chance to check out the Dev Portal live, and test
out some customization options.

## Prerequisites

You have [configured a {{site.konnect_short_name}} service](/konnect/getting-started/configure-service) with at least one version.

## Upload a description

You can provide extended descriptions of your {{site.konnect_short_name}} services with a Markdown (`.md`) file.
The contents of this file will be displayed as the introduction to your API in the Dev Portal.

{{site.konnect_short_name}} supports
[GitHub-Flavored Markdown](https://github.github.com/gfm/) (GFM) for API
descriptions.

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

1. In the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), open a service.
Find the **Service Document** section on your service's overview page and click **Upload Document**.

1. Locate the `.md` file and click **Open**.

## Upload an API spec

API specifications, or specs, can be uploaded and attached to a specific service version within your Dev Portal.
Every version can have one OpenAPI spec associated with it, in JSON or YAML format.

If you brought your own spec, use it in the following steps. Otherwise, you can
use the [sample Vitals spec](/konnect/vitalsSpec.yaml) for testing.

1. In the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), open a service, then pick a version.

1. Find the **Version Spec** section and click **Upload Spec**.

1. Select a spec file to upload.

    The spec must be in YAML or JSON format. To test this functionality, you
    can use [vitalsSpec.yaml](/konnect/vitalsSpec.yaml) as a sample spec.

This OpenAPI spec will be shown under the version name when this service is
published to the Dev Portal.

## Publish a service

1. In the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), return to your service's overview page.

1. In the top right corner, click on the **Service actions** dropdown and select
**Publish to Portal**.

    By default, this publishes all of the service's version specs to a private
    Dev Portal site.

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

1. Open the service you published to check it out.

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
* Uploaded documentation to describe your service
* Published the service to the Dev Portal
* Logged into the Dev Portal to check out the service documentation live
* Customized the Dev Portal

Next, [register an application against the service](/konnect/getting-started/app-registration).
