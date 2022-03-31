---
title: Dev Portal Service Documentation
no_version: true
---

Upload documentation for your Services through ServiceHub to display it
on the Dev Portal.

You can upload Service descriptions and version specs. At a minimum, we
recommend uploading an API spec for each Service version.

After adding documentation for your Services,
[publish](/konnect/dev-portal/publish) them to the Dev Portal.

## Service Descriptions

Provide extended descriptions of your Services with Markdown. The
description applies to the whole Service, and appears on every version of that
Service in the Dev Portal.

### Add a Markdown File for a Service

1. From the left navigation menu, open the **Services** page.

2. Select a Service to open its overview.

3. In the **Service Document** section, click **Upload Document**.

3. Select an `.md` file to upload. Click **Open**.

### Update or Delete a Markdown File for a Service

Upload a new document to replace an existing Service document.

1. From the Services page, select a Service to open its overview.

2. In the **Service Document** section:
    * To upload a new file, click the **file icon**, then
    **Replace**. Select a new `.md` file to upload.
    * To delete the file, click the **gear icon**, then **Delete**.
    Click **Delete** again to confirm.

## Version Specs

Upload a spec to document a Service version.

{{site.konnect_short_name}} accepts OpenAPI (Swagger) specs in YAML or JSON
format.

### Upload a Version Spec

1. From the left navigation menu, open the **Services** page.

2. Open a Service version.

3. In the **Version Spec** section, click **Upload Spec**.

4. Select a spec file to upload.

    The spec must be in YAML or JSON format. To test this functionality, you
    can use [vitalsSpec.yaml](/konnect/vitalsSpec.yaml) as a sample spec.

    If the Service was previously published to the Dev Portal, the documentation
    for the Service gets automatically updated with your changes. If not,
    [publish](/konnect/dev-portal/publish) the Service.

### Update or Delete a Version Spec

1. From the left navigation menu, open the **Services** page.

2. Open a Service version.

3. In the **Version Spec** section:

    * Click the spec to update it, then click **Replace**. Choose a new YAML or
    JSON spec to replace the existing one.

    * Or, click the **gear icon > Delete**  to remove the spec.

    The published documentation for the Service gets automatically updated with
    your changes.
