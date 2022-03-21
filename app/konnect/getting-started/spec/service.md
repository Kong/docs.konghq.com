---
title: Import an API Spec into Konnect
no_version: true
---

Use the Service Hub to manage and share your APIs. Bring an API spec and publish
it through the Service Hub to the Dev Portal.

The Dev Portal is an API catalog that lets you document your Konnect Services
and share them with your developers. Developers can use the Dev Portal to
locate, access, consume, and register applications against the Services.

This topic walks you through importing an API spec into a Konnect Service,
and adding a description.

## Prerequisites
* You have **Organization Admin** permissions in
{{site.konnect_saas}}. If you created this Konnect organization, your account
is part of the organization admin team by default.
* You have an OpenAPI spec in JSON or YAML format. If not, you can use the
[sample vitalsSpec.yaml](/konnect/vitalsSpec.yaml) for testing.

## Create a service

In this guide, you will be using the Service Hub to create a Konnect
Service, then create your first Service version to contain the spec.

1. From the left navigation menu, click **Services** to open Service Hub.

1. Click **Add New Service**.

1. Enter a **Service Name**. For this example, enter `example_service`.

    A Service name can be any string containing letters, numbers, or characters;
    for example, `service_name`, `Service Name`, or `Service-name`.

1. (Optional) Enter a **Description**.

    This description is used in Konnect and on the Dev Portal.

1. Click **Create**.

    A new Service is created and the page automatically redirects back to the
    **example_service** overview page.

    Now that you have a Service set up, you can start filling out details about your
    API.

## Upload a description

{% include_cached /md/konnect/dev-portal.md section='markdown' %}

## Create a Service version

Let's set up the first version of your API service. A Konnect Service can
contain many versions, but one spec is always linked to one version.

1. On your Service's overview page, scroll down to **Versions** and
 click **New Version**.

1. Enter a **Version Name**. For this example, enter `v.1`.

    A version name can be any string containing letters, numbers, or characters;
    for example, `1.0.0`, `v.1`, or `version#1`. A Service can have multiple
    versions.

1. Select a runtime group.

    Choose a [group](/konnect/configure/runtime-manager/runtime-groups) to
    limit this version to a specific group of runtime
    instances. This determines which entities and runtimes the Service version
    has access to, and who has access to this version.

    {:.note}
    > **Note:** Later on in this guide, you will have the chance to test out
    application registration. Applications can only be registered against
    Services in the default runtime group, so if you want to test out that
    feature, choose `default` in this step.

    Different versions of the same Service can run in different runtime groups.
    The version name is unique within a group:

    * If you create multiple versions in the **same group**, they must have unique names.
    * If you create multiple versions in **different groups**, the versions can have the same name.

1. Click **Create** to save.

The Service version is created in **Published** status by default. This means
that if you publish the Service to the Dev Portal, this version will be published
along with it.

If you don't want the version to be published yet, you can set the version to a
different [stage in its lifecycle](/link to version lifecycle doc).

## Upload an API spec

{% include_cached /md/konnect/dev-portal.md section='spec' %}

## Summary and next steps

In this topic, you:
* Created a service named `example_service`
* Uploaded a description for the service in `.md` format
* Created the first version of the service named `1` and chose a runtime group for it.
* Uploaded your API spec into Konnect

Next, [implement the Service](/konnect/getting-started/spec/implement) and prepare it for application registration.
