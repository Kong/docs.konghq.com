---
title: Using the Dev Portal
no_search: true
no_version: true
beta: true
---

## Overview
The Dev Portal in Kong Konnect (Konnect) contains a collection of Service
Version specs and documentation objects.

* Markdown documentation: a description of your Service. Applies to the whole
Service package.
* Version spec: An OAS/Swagger document in YAML or JSON format. Applies to a
specific Service Version.

The purpose of the Portal is to allow registration and consumption of services
running through Kong to other teams, developers, partners, and so on.

You can access the Developer Portal for any published Service through the URL
found on the **Dev Portal** page. The format looks something like this:

```
<org-name>.portal.prod.khcp.kongcloud.io
```

## Add a Markdown File for a Service

You can provide descriptions of your Services with Markdown.

1. On the Services page, select a Service to open its overview.

2. In the Service Document section, click **Upload Document**.

3. From your file manager, select an `.md` file to upload. Click **Open**.

    Your file is published to the Portal.

## Replace a Markdown File for a Service

Upload a new document to replace an existing Service Document.

1. On the Services page, select a Service to open its overview.

2. In the Service Document section, click the **gear icon > Upload New**.

3. Click **Replace** to upload a replacement version of the file.

## Upload a Version Spec

Upload a OpenAPI spec to document your Service Version.

1. On the Services page, select a Service Version to view the Version overview
page.

2. In the Version Spec section, click **Upload Spec**.

3. Select a spec file to upload.

    For the purpose of this example, you can use
    [vitalsSpec.yaml](/konnect/vitalsSpec.yaml).

    >**Note**: Konnect accepts specs in YAML or JSON format. It is recommended to
    link documentation (OAS/Swagger spec) to your Service.


## Publish a Service to the Portal

1. Open the Services page and select a Service.

2. Click on the **Actions** dropdown and select **Publish to Portal**.

    This publishes all of the Service's Version specs to the Developer Portal.

3. In Konnect's left menu navigation, go to **Dev Portal**.

4. Click the **Portal URL** to access your Portal, or click the gear icon for
any published Service and select **View in portal**.

## Summary

In this topic, you:

* Uploaded Markdown documentation for a Service.
* Uploaded a YAML spec for a Service Version.
* Published the Service with both documents to the Developer Portal.
