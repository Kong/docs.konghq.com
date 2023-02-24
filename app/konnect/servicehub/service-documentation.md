---
title: Dev Portal Service Documentation
---

A core function of the Dev Portal is publishing service descriptions and API specs. Developers can use the Dev Portal to access, consume, and register new applications against your services.

Through Service Hub, you can also publish any service in your catalog and its
documentation to the Dev Portal. Publishing services to the Dev Portal is the only way to expose your service to developers. Once the service is published and available to developers, they can apply for access by [registering](/konnect/dev-portal/dev-reg/) a developer account. You can also [manage](/konnect/dev-portal/access-and-approval/manage-devs/) access to the Dev Portal from the {{site.konnect_saas}} interface.

## Service descriptions

You can provide extended descriptions of your services with a Markdown (`.md`) file. The contents of this file will be displayed as the introduction to your API in the Dev Portal. All service descriptions are managed from the **Documentation Page** for a particular service. Service descriptions can be any markdown document that describes your service: 

* Release notes
* Support and SLA 
* Business context and use cases
* Deployment workflows

## API specification

API specifications, or specs, can be uploaded and attached to a specific version within your Dev Portal.
You can have different API specs that correspond to different service versions.
{{site.konnect_short_name}} accepts OpenAPI (Swagger) specs in YAML or JSON.

## Publishing

Publishing a service makes it available to developers in your organization. Unpublishing a service removes it from the Dev Portal. Removing a service from the Dev Portal is not permanent, and you can republish it at any time.

{:.note}
> **Note**: You can only publish services in your [geographic region](/konnect/regions) to the Dev Portal in your region. If you want to publish services to a Dev Portal in another region, switch to the new region in the top-right of {{site.konnect_product_name}}.

Publishing and unpublishing service documentation in {{site.konnect_product_name}} controls what document is displayed for a particular service.
Publishing is managed from a specific service's **Documentation Page**. 
