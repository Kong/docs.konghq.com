---
title: Dev Portal Service Documentation
content_type: how-to
---

A core function of the Dev Portal is publishing API product descriptions and API specs. Developers can use the Dev Portal to access, consume, and register new applications against your API product.

Through API Products, you can also publish any API product and its
documentation to the Dev Portal. Publishing API products to the Dev Portal is the only way to expose your service to developers. Once the API product is published and available to developers, they can apply for access by [registering](/konnect/dev-portal/dev-reg/) a developer account. You can also [manage](/konnect/dev-portal/access-and-approval/manage-devs/) access to the Dev Portal from the {{site.konnect_saas}} interface.

## API product descriptions

You can provide extended descriptions of your API products with a Markdown (`.md`) file. The contents of this file will be displayed as the introduction to your API in the Dev Portal. API product descriptions can be any markdown document that describes your service: 

* Release notes
* Support and SLA 
* Business context and use cases
* Deployment workflows

<p align="center">
  <img src="/assets/images/products/konnect/api-products/konnect_service_docs_description.png" />
</p>

All API product descriptions are managed from the **Documentation** section in the API Product overview. Once you've uploaded the markdown file, you have a preview of how it will render, the option to edit, and a view of the publication status. You can also create a hierarchy between the docs you upload that will be reflected in the way they're displayed in the Dev Portal.

## API specification

API specifications, or specs, can be uploaded and attached to a specific API product version within API products.
{{site.konnect_short_name}} accepts OpenAPI (Swagger) specs in YAML or JSON.

Once you've uploaded the spec, you can also preview the way the spec will render, including the methods available, endpoint descriptions, and example values. You'll also be able to filter by tag when in full-page view. 


