---
title: decK
subtitle: Manage {{site.konnect_product_name}}, {{site.base_gateway}}, and {{site.kic_product_name}} configuration declaratively
content_type: explanation
---

decK is a command line tool that allows you to orchestrate and automate the entire API delivery process. It is a key part of API Lifecycle Automation (APIOps), including configuring {{ site.base_gateway }} from an existing OpenAPI specification.

decK operates on state files, which represent the intended configuration of {{ site.base_gateway }} in text format. You can configure any [{{ site.base_gateway }} entity](/deck/reference/entities/) (e.g. service, route, plugin) declaratively and apply that configuration to {{ site.base_gateway }} using decK.

## decK commands

The decK commands are structured into three main categories:

1. [**Configuration Generation**](/deck/file/generation/): This category focuses on the initial creation of decK state files from industry-standard API specification formats.

2. [**Configuration Transformation**](/deck/file/manipulation/): This set of commands provides the tools needed to refine and restructure decK configuration files. It allows for the segmentation of a full configuration into smaller, manageable parts and their subsequent reassembly.

3. [**Gateway State Management**](/deck/manage-gateway/): This category encompasses commands that facilitate the synchronization of the final decK file with the target platform, be it {{site.konnect_product_name}}, {{site.base_gateway}}, or {{site.kic_product_name}}.

Through these categories and their associated commands, decK offers a comprehensive suite of tools 
for configuration and management within the Kong platform.