---
title: Set Up and Access Dev Portal
no_version: true
---

The Dev Portal is an API catalog that lets you document your Konnect Services
and share them with your developers. Developers can use the Dev Portal to
locate, access, consume, and register applications against the Services.

This guide walks you through setting up a sample API spec and description for
the {{site.konnect_short_name}} service and publishing the service to the Dev
Portal. You'll also have a chance to check out the Dev Portal live, and test
out some customization options.

## Upload a description

{% include_cached /md/konnect/dev-portal-description.md %}

## Upload an API spec

{% include_cached /md/konnect/dev-portal-spec.md %}

## Publish a Service

1. Return to the overview page for the `example_service`.

1. In the top right corner, click on the **Actions** dropdown and select
**Publish to Portal**.

    By default, this publishes all of the Service's version specs to a private
    Dev Portal site.


## View the published content on Dev Portal

{% include_cached /md/konnect/dev-portal-access.md %}

## Customize your Dev Portal

You can customize the Dev Portal to make it your own.
Let's change up a couple of things:

1. Return to Konnect. From the left side menu, open **Dev Portal**, then **Appearance**.

1. Try out a couple of customization options - whatever you like.

    * Choose a preset theme and adjust it to your needs
    * Set some home page text
    * Upload header, logo, or favicon images
    * Play around with the colours and fonts of your site

    You could also [add a custom domain](/konnect/dev-portal/customization/custom-domain/),
    if you have one you want to use.

1. Click **Save** to apply the changes.

1. Switch back to the Dev Portal to see your changes live.

## Summary and next steps

In this topic, you:
* Uploaded documentation to describe your Service
* Published the Service to the Dev Portal
* Logged into the Portal to check out the Service documentation live
* Customized the Dev Portal

For next steps, check out some of the other things you can do in
{{site.konnect_saas}}:
* Enable plugins on a [Service](/konnect/configure/servicehub/enable-service-plugin/) or a
[Route](/konnect/configure/servicehub/enable-route-plugin/)
* Set up [application registration](/konnect/dev-portal/applications/enable-app-reg/)
* [Manage your teams and roles](/konnect/org-management/teams-and-roles/)
