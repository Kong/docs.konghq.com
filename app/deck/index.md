---
title: decK
subtitle: Manage {{site.konnect_product_name}}, {{site.base_gateway}}, and {{site.kic_product_name}} configuration declaratively
content_type: explanation
---

decK is a command line tool that lets you orchestrate and automate the entire API delivery process. It is a key part of API Lifecycle Automation (APIOps), including configuring {{ site.base_gateway }} from an existing OpenAPI specification.

decK operates on state files, which represent the intended configuration of {{ site.base_gateway }} in text format. You can configure any core [{{ site.base_gateway }} entity](/deck/reference/entities/) (for example, service, route, plugin) declaratively and apply that configuration to {{ site.base_gateway }} using decK.

## decK commands

decK offers a comprehensive suite of tools for configuring and managing the Kong platform through sets of commands. 
The decK commands are structured into three main categories:

* [**Configuration Generation**](/deck/file/): This category focuses on the initial creation of decK state files from industry-standard API specification formats.

* [**Configuration Transformation**](/deck/file/manipulation/): This set of commands provides the tools needed to refine and restructure decK configuration files. It allows for the segmentation of a full configuration into smaller, manageable parts and their subsequent reassembly.

* [**Gateway State Management**](/deck/gateway/): This category includes commands that facilitate the synchronization of the final decK file with the target platform, which can be {{site.konnect_product_name}}, {{site.base_gateway}}, or {{site.kic_product_name}}.
