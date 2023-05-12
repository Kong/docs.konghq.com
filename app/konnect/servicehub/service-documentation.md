---
title: Dev Portal Service Documentation
---

A core function of the Dev Portal is publishing service descriptions and API specs. Developers can use the Dev Portal to access, consume, and register new applications against your services.

Through Service Hub, you can also publish any service in your catalog and its
documentation to the Dev Portal. Publishing services to the Dev Portal is the only way to expose your service to developers. Once the service is published and available to developers, they can apply for access by [registering](/konnect/dev-portal/dev-reg/) a developer account. You can also [manage](/konnect/dev-portal/access-and-approval/manage-devs/) access to the Dev Portal from the {{site.konnect_saas}} interface.

## Service descriptions

You can provide extended descriptions of your services with a Markdown (`.md`) file. The contents of this file will be displayed as the introduction to your API in the Dev Portal. Service descriptions can be any markdown document that describes your service: 

* Release notes
* Support and SLA 
* Business context and use cases
* Deployment workflows

<p align="center">
  <img src="/assets/images/docs/konnect/konnect_service_docs_description.png" />
</p>

All service descriptions are managed from the **Documentation** section in the service overview. Once you've uploaded the markdown file, you have a preview of how it will render, the option to edit, and a view of the publication status. You can also create a hierarchy between the docs you upload that will be reflected in the way they're displayed in the Dev Portal.

## API specification

API specifications, or specs, can be uploaded and attached to a specific version within your Dev Portal.
You can have different API specs that correspond to different service versions.
{{site.konnect_short_name}} accepts OpenAPI (Swagger) specs in YAML or JSON.

<p align="center">
  <img src="/assets/images/docs/konnect/konnect_service_docs_spec.png" />
</p>

Once you've uploaded the spec, you can also preview the way the spec will render, including the methods available, endpoint descriptions, and example values. You'll also be able to filter by tag when in full-page view. 
