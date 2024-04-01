---
title: Product Documentation
content_type: how-to
---

A core function of the Dev Portal is publishing API product descriptions, documentation, and API specs. Developers can use the Dev Portal to access, consume, and register new applications against your API product.

## API Product Documentation

You can provide extended descriptions of your API products with a Markdown (`.md`) file. The contents of this file will be displayed as the introduction to your API in the Dev Portal. API product descriptions can be any markdown document that describes your service such as: 

* Release notes
* Support and SLA 
* Business context and use cases
* Deployment workflows

<p align="center">
  <img src="/assets/images/products/konnect/api-products/konnect_service_docs_description.png" />
</p>


Manage all API product descriptions from the Documentation section in the API Product overview. After uploading your markdown file, you'll be able to preview its rendering, edit it directly using the {{site.konnect_saas}} Markdown Renderer, and check its publication status. Additionally, you can organize your documents into a hierarchy, which will influence the order they are displayed to your users from within the Dev Portal.

### Interactive markdown renderer

The integrated markdown editor allows you to edit your documentation directly within {{site.konnect_saas}}. It supports:

* Code syntax highlighting for Bash, JSON, Go, and JavaScript
* Rendering UML diagrams and flowcharts via Mermaid and PlantUML
* Emojis

You can insert Mermaid and PlantUML diagrams by using a language-specific identifier immediately following the triple backtick (```) notation that initiates the code block:

* ```mermaid
* ```plantuml


## API specifications

API specifications, or specs, can be uploaded and attached to a specific API product version within API products.
{{site.konnect_short_name}} accepts OpenAPI (Swagger) specs in YAML or JSON.

Once you've uploaded the spec, you can also preview the way the spec will render, including the methods available, endpoint descriptions, and example values. You'll also be able to filter by tag when in full-page view. 


