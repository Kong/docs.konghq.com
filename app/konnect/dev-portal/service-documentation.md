---
title: Dev Portal Service Documentation
no_version: true
---

A core function of the Dev Portal is publishing Service descriptions and API specs. Developers can use the spec and corresponding descriptions to access, consume, and register new applications against your Services. For a step by step tutorial on publishing a Service description and an API spec to the Dev Portal, see our [Get Started: Set Up and Access Dev Portal](/konnect/getting-started/publish-service) guide.


## Service descriptions

You can provide extended descriptions of your Services with a Markdown (`.md`) file. The contents of this file will be displayed as the introduction to your API in the Dev Portal. 
### Upload a Service description

1. From the left navigation menu, open the {% konnect_icon servicehub %} **Service Hub** page.

2. Select a Service to open its overview.

3. In the **Service Document** section, click **Upload Document**.

3. Select a `.md` file to upload.

### Update a Service description

You can upload a new document to replace an existing Service document.

1. From the left navigation menu, open the {% konnect_icon servicehub %} **Service Hub** page.

2. Select a Service to open its overview.

3. In the **Service Document** section, click the **file icon**, then **Replace**. Select a new `.md` file to upload.

### Delete a Service description

You can delete an existing document from the Dev Portal. Deleting a Service description will permanently remove it from the Dev Portal. 

1. From the left navigation menu, open the {% konnect_icon servicehub %} **Service Hub** page.

2. Select a Service to open its overview.

3. In the **Service Document** section, click the {% konnect_icon cogwheel %} icon, then **Delete**. Click **Delete** again to confirm.

## API specification

API specifications, or specs, can be uploaded and attached to a specific Version within your Dev Portal. You can have different API specs that correspond to different versions. {{site.konnect_short_name}} accepts OpenAPI (Swagger) specs in YAML or JSON.

### Upload a Version Spec

1. From the left navigation menu, open the {% konnect_icon servicehub %} **Service Hub** page.

2. Click a Service to open the Service Overview.

3. From the left navigation bar, click **Versions**.

4. Click a specific Version from the list.

5. In the **Version Spec** section, click **Upload Spec**.

6. Click **Upload Spec** to upload your Open API Specification file.

    The spec must be in YAML or JSON format. You
    can use [vitalsSpec.yaml](/konnect/vitalsSpec.yaml) as a sample spec to test this functionality.
    If the Service was previously published to the Dev Portal, the documentation
    for the Service gets automatically updated with your changes. If not,
    [publish](/konnect/dev-portal/publish) the Service.

### Update a Version Spec

1. From the left navigation menu, open the {% konnect_icon servicehub %} **Service Hub** page.

2. Click a Service to open the Service Overview.

3. From the left navigation bar, click **Versions**.

4. Click a specific Version from the list.

5. In the **Version Spec** section, click the spec, then click **Replace**. Choose a new spec to replace the existing one. The published documentation for the Service is automatically updated in the Dev Portal.

### Delete a Version Spec

1. From the left navigation menu, open the {% konnect_icon servicehub %} **Service Hub**.

2. Click a Service to open the Service Overview.

3. From the left navigation bar, click **Versions**.

4. Click a specific Version from the list.

5. In the **Version Spec** section, click the {% konnect_icon cogwheel %} icon, then **Delete** to remove the sepc. 

    Deleted files are permanently removed from the Dev Portal.

## Next Steps
After adding documentation for your Services,
[publish](/konnect/dev-portal/publish) them to the Dev Portal.