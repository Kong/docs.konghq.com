---
title: Dev Portal Service Documentation
no_version: true
---

A core function of the Dev Portal is publishing service descriptions and API specs. Developers can use the spec and corresponding descriptions to access, consume, and register new applications against your services.

Through Service Hub, you can also publish any service in your catalog and its
documentation to the Dev Portal. Publishing services to the Dev Portal is the only way to expose your service to developers. Once the service is published and available to developers, they can apply for access by [registering](/konnect/dev-portal/dev-reg/) a developer account. You can also [manage](/konnect/dev-portal/access-and-approval/manage-devs/) access to the Dev Portal from the {{site.konnect_saas}} interface.

## Service descriptions

You can provide extended descriptions of your services with a Markdown (`.md`) file. The contents of this file will be displayed as the introduction to your API in the Dev Portal.

### Upload a service description

1. In the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service from the list.

1. In the **Service Document** section, click **Upload Document**.

1. Select a `.md` file to upload.

### Update a service description

You can upload a new document to replace an existing service document.

1. In the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service from the list.

1. In the **Service Document** section, click the {% konnect_icon markdown %} **file icon**, then **Replace**.

1. Select a new `.md` file to upload.

### Delete a service description

You can delete an existing document from the Dev Portal. Deleting a service description permanently removes it from the Dev Portal and the Service Hub.

1. In the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service from the list.

1. In the **Service Document** section, click the {% konnect_icon cogwheel %} icon, then **Delete**.

1. Confirm to permanently delete the service description file.

## API specification

API specifications, or specs, can be uploaded and attached to a specific version within your Dev Portal.
You can have different API specs that correspond to different versions.
{{site.konnect_short_name}} accepts OpenAPI (Swagger) specs in YAML or JSON.

### Upload a version spec

1. In the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service version.

1. In the **Version Spec** section, click **Upload Spec**.

1. Click **Upload Spec** to upload your OpenAPI specification file.

    The spec must be in YAML or JSON format. You
    can use [vitalsSpec.yaml](/konnect/vitalsSpec.yaml) as a sample spec to test this functionality.
    If the service was previously published to the Dev Portal, the documentation
    for the service gets automatically updated with your changes. If not,
    [publish](/konnect/servicehub/service-documentation/#publishing) the service.

### Update a version spec

1. In the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service version.

1. In the **Version Spec** section, click the spec, then click **Replace**.
Choose a new spec to replace the existing one.
The published documentation for the service is automatically updated in the Dev Portal.

### Delete a version spec

1. In the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service version.

1. In the **Version Spec** section, click the {% konnect_icon cogwheel %} icon, then **Delete** to remove the spec.

    Deleted files are permanently removed from the Dev Portal.

## Publishing

### Publish a service {#publish}

Publish a service and its API specs to the Dev Portal. Publishing a service makes it available to developers in your organization.

1. In the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service from the list.

1. Click the **Service actions** drop-down menu and select **Publish to portal**.

### Unpublish a service {#unpublish}

Unpublish a service to remove it from the Dev Portal. Unpublishing is not permanent, and you can republish again at any time.

1. In the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service from the list.

1. Click the **Service actions** drop-down menu and select **Unpublish from portal**.
