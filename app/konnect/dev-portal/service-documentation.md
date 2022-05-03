---
title: Dev Portal Service Documentation
no_version: true
---

A core function of the Developer Portal is uploading Service descriptions and API specs. Developers can use the Spec and corresponding descriptions to access, consume, and register new applications against your Services. For a step by step tutorial on publishing a Service Description and an API Spec to the Developer Portal see our [Get Started: Set Up and Access Dev Portal](/konnect/getting-started/publish-service) guide.


## Service Descriptions

Service Descriptions Provide extended descriptions of your Services with Markdown. The
description applies to the whole Service, and appears on every version of that
Service in the Dev Portal. The contents of this markdown file will be displayed as the introduction to your API when this Service is published to the Dev Portal.

### Upload a Service Description

1. From the left navigation menu, open the **ServiceHub** page.

2. Select a Service to open its overview.

3. In the **Service Document** section, click **Upload Document**.

3. Select a `.md` file to upload.

### Update a Service Description

You can upload a new document to replace an existing Service Document

1. From the left navigation menu, open the {% konnect_icon servicehub %} **ServiceHub** page.

2. Select a Service to open its overview.

3. In the **Service Document** section:
    * To upload a new file, click the **file icon**, then
    **Replace**. Select a new `.md` file to upload.

### Delete a Service Description

You can delete an existing document from the Developer Portal. Deleting a Service Description will permanently remove it from the Developer Portal. 

1. From the left navigation menu, open the {% konnect_icon servicehub %}**ServiceHub** page.

2. Select a Service to open its overview.

3. In the **Service Document** section:
    * To delete the file, click the **gear icon**, then **Delete**.
    Click **Delete** again to confirm.

## API Specification

API Specifications are uploaded and attached to a specific Version within your Developer Portal. You can have different API Specifications that correspond to different versions. {{site.konnect_short_name}} accepts OpenAPI (Swagger) specs in YAML or JSON
format.

### Upload a Version Spec

1. From the left navigation menu, open the **ServiceHub** page.

2. Click a Service version to open the Service Overview.

3. From the left-hand navigation bar, click **Versions**.

4. Click a specific Version from the list.

5. In the **Version Spec** section, click **Upload Spec**.

6. Click **Upload Spec** to upload your Open API Specification file.

    The spec must be in YAML or JSON format. You
    can use [vitalsSpec.yaml](/konnect/vitalsSpec.yaml) as a sample spec to test this functionality.
    If the Service was previously published to the Dev Portal, the documentation
    for the Service gets automatically updated with your changes. If not,
    [publish](/konnect/dev-portal/publish) the Service.

### Update a Version Spec

1. From the left navigation menu, open the **ServiceHub** page.

2. Click a Service version to open the Service Overview.

1. From the left navigation menu, open the **ServiceHub** page.

2. Click a Service version to open the Service Overview.

3. From the left-hand navigation bar, click **Versions**.

4. Click a specific Version from the list.

5. In the **Version Spec** section:

    * To update the spec, click the spec to update it, then click **Replace**. Choose a new YAML or
    JSON spec to replace the existing one.
    
    The published documentation for the Service is automatically updated in the Developer Portal.

### Delete a Version Spec

1. From the left navigation menu, open the {% konnect_icon servicehub %} **ServiceHub**.

2. Click a Service version to open the Service Overview.

3. From the left-hand navigation bar, click **Versions**.

4. Click a specific Version from the list.

5. In the **Version Spec** section:

    * To delete the file, click the **gear icon**, then **Delete** > to remove the spec.

    Deleted files are permanently removed from the Developer Portal.

## Next Steps
After adding documentation for your Services,
[publish](/konnect/dev-portal/publish) them to the Dev Portal.