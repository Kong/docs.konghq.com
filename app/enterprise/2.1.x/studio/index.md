---
title: Kong Studio
toc: false
---
Kong Studio is a bundle for Kong Enterprise based on Insomnia Designer,
which enables spec-first development for all REST and GraphQL services.

![Kong Studio Architecture](/assets/images/docs/studio/studio-insomnia-architecture.png)
> &#42;included in Enterprise license, but installed separately

Benefits for organizations:
* Accelerate design and test workflows via automated testing
* Direct Git sync
* Inspect all response types

Benefits for teams:
* Increase development velocity
* Reduce deployment risk
* Increase collaboration

## Feature comparison

| Feature | Insomnia Core | Insomnia Designer | Kong Studio (Plugin Bundle)|
|---------|---------------|-------------------|----------------------------|
| Make requests, inspect responses | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| Design and manage OpenAPI specs | <i class="fa fa-times"></i> | <i class="fa fa-check"></i> | <i class="fa fa-check"></i> |
| {{site.ee_product_name}} plugin support | <i class="fa fa-times"></i> |  <i class="fa fa-times"></i> | <i class="fa fa-check"></i> |
| Support from Kong | <i class="fa fa-times"></i> | <i class="fa fa-times"></i> | <i class="fa fa-check"></i> |

Insomnia Designer is referred to as Kong Studio when it is configured through the
[Kong Studio bundle](https://insomnia.rest/plugins/insomnia-plugin-kong-bundle).
Kong Studio extends Insomnia Designer by allowing users to generate configuration
for Kong Enterprise and sync API designs directly to the Kong Developer Portal.

The following documentation series will guide you through downloading and installing
Kong Studio, debugging and editing spec files, and syncing to your
Kong Developer Portal and git repositories.

<div class="docs-grid">

  <div class="docs-grid-block">
    <h3>
        <a href="/enterprise/{{page.kong_version}}/studio/download-install">Download & Install</a>
    </h3>
    <p></p>
    <a href="/enterprise/{{page.kong_version}}/studio/download-install">
        Download and install the Kong Studio Bundle &rarr;
    </a>
  </div>

  <div class="docs-grid-block">
    <h3>
        <a href="https://support.insomnia.rest/article/94-introduction">Insomnia Designer Documentation</a>
    </h3>
    <p></p>
    <a href="https://support.insomnia.rest/article/94-introduction">
        Insomnia Designer Documentation &rarr;
    </a>
  </div>

  <div class="docs-grid-block">
    <h3>
        <a href="/enterprise/{{page.kong_version}}/studio/deploy-to-dev-portal">Deploy to the Dev Portal</a>
    </h3>
    <p></p>
    <a href="/enterprise/{{page.kong_version}}/studio/deploy-to-dev-portal">
        Connect to Kong Enterprise and deploy specs to the Kong Developer Portal &rarr;
    </a>
  </div>

  <div class="docs-grid-block">
    <h3>
        <a href="/enterprise/{{page.kong_version}}/studio/dec-conf-studio">Generate Configuration</a>
    </h3>
    <p></p>
    <a href="/enterprise/{{page.kong_version}}/studio/dec-conf-studio">
        Generate Kong Declarative and Kong for Kubernetes configuration from your OpenAPI spec &rarr;
    </a>
  </div>

</div>
