---
title: Dev Portal Service Documentation
no_version: true
---

A core function of the Dev Portal is publishing service descriptions and API specs. Developers can use the Dev Portal to access, consume, and register new applications against your services.

Through Service Hub, you can also publish any service in your catalog and its
documentation to the Dev Portal. Publishing services to the Dev Portal is the only way to expose your service to developers. 
Once the service is published and available to developers, they can apply for access by [registering](/konnect/dev-portal/dev-reg/) a developer account. You can also [manage](/konnect/dev-portal/access-and-approval/manage-devs/) access to the Dev Portal from the {{site.konnect_saas}} interface.

## Service descriptions

You can provide extended descriptions of your services with a Markdown (`.md`) file. The contents of this file will be displayed as the introduction to your API in the Dev Portal. All service descriptions are managed from the **Documentation Page** for a particular service. Service descriptions can be any markdown document that describes your service: 

* Release notes
* Support and SLA 
* Business context and use cases
* Deployment workflows


### Upload a service description

From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service, select **Documentation**, then follow these steps:

1. Click **Add Page**

1. Select a `.md` file to upload.

1. Optional: Set a custom **Page name**, **URL slug**, or choose a parent document.

### Update a service description

You can upload a new document to replace an existing service document.

From the **Documentation Page**, select a service document, then follow these steps:

1. Click the context menu icon for a service document and select **Edit**. 

1. Upload a new `.md` file, or update information about the service document. 

1. Optional: publish or unpublish the service document.


### Delete a service description

You can delete an existing document from the Dev Portal. Deleting a service description permanently removes it from the Dev Portal and the Service Hub.

From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service, then follow these steps:

* From the **Documentation Page**, click the context menu icon, then click **Delete**.

## API specification

API specifications, or specs, can be uploaded and attached to a specific version within your Dev Portal.
You can have different API specs that correspond to different service versions.
{{site.konnect_short_name}} accepts OpenAPI (Swagger) specs in YAML or JSON. 

### Upload a version spec

From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service version, then follow these steps:

1. In the **Version Spec** section, click **Upload Spec**.

1. Click **Upload Spec** again to upload your OpenAPI specification file.

    The spec must be in YAML or JSON format. You
    can use [vitalsSpec.yaml](/konnect/vitalsSpec.yaml) as a sample spec to test this functionality.
    If the service was previously published to the Dev Portal, the documentation
    for the service gets automatically updated with your changes.

### Update a version spec

From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service version. Upload a new spec:

* In the **Version Spec** section, click the spec, then click **Replace**.
Choose a new spec to replace the existing one.

The published documentation for the service is automatically updated in the Dev Portal.

### Delete a version spec

From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service version.
Delete the spec:

* In the **Version Spec** section, click the {% konnect_icon cogwheel %} icon, then **Delete** to remove the spec.

Deleted files are permanently removed from the Dev Portal.

## Publishing

### Publish a service {#publish}

Publish a service and its API specs to the Dev Portal. Publishing a service makes it available to developers in your organization. Unpublishing a service removes it from the Dev Portal. Removing a service from the Dev Portal is not permanent, and you can republish it at any time.

{:.note}
> **Note**: You can only publish services in your [geographic region](/konnect/regions) to the Dev Portal in your region. If you want to publish services to a Dev Portal in another region, switch to the new region in the top-right of {{site.konnect_product_name}}.

From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service. 
Then, use the **Service actions** drop-down menu to select **Publish to portal** or **Unpublish from portal**.


### Publishing Service Documentation

Publishing and unpublishing service documentation in {{site.konnect_product_name}} controls what document is displayed for a particular service.
Publishing is managed from a specific service's **Documentation Page**. 

1. From the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service, and click the **Documentation** page. 

1. From the **Documentation** page, click the context menu for a specific service document, select **edit**, and toggle the **published page** button to the desired state.
