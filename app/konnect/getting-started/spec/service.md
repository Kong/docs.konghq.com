---
title: Import an API Spec into Konnect
no_version: true
---

Use the ServiceHub to manage and share your APIs. Bring an API spec and publish
it through the ServiceHub to the Dev Portal.

The Dev Portal is an API catalog that lets you document your Konnect Services
and share them with your developers. Developers can use the Dev Portal to
locate, access, consume, and register applications against the Services.

This topic walks you through importing an API spec into a Konnect Service,
and adding a description.

## Prerequisites
* You have the **Organization Admin** or **Service Admin** role in
{{site.konnect_saas}}. If you created this Konnect organization, your account
is part of the organization admin team by default.
* You have an OpenAPI spec in JSON or YAML format. If not, you can use the
[sample vitalsSpec.yaml](/konnect/vitalsSpec.yaml) for testing.

## Create a service

{% include_cached /md/konnect/create-service.md %}

## Upload a description

Now that you have a Service set up, you can start filling out details about your
API.

{% include_cached /md/konnect/dev-portal-description.md %}

## Create a Service version

{% include_cached /md/konnect/service-version.md %}

## Upload an API spec

{% include_cached /md/konnect/dev-portal-spec.md %}

## Summary and next steps

In this topic, you:
* Created a service named `example_service`
* Uploaded a description for the service in `.md` format
* Created the first version of the service named `1` and chose a runtime group for it.
* Uploaded your API spec into Konnect

Next, [implement the Service](/konnect/getting-started/spec/implement) and prepare it for application registration.
