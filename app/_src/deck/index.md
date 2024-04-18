---
title: decK
subtitle: Manage {{site.konnect_product_name}}, {{site.base_gateway}}, and {{site.kic_product_name}} configuration declaratively
content_type: explanation
---

## Quick links

<div class="docs-grid-install max-4">

  <a href="/deck/{{page.release}}/installation/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-deployment-color.svg" alt="">
    <div class="install-text">Install decK</div>
  </a>
  {% if_version gte:1.24.x %}
  <a href="/deck/{{page.release}}/guides/apiops/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/konnect/icn-cogwheel-nav.svg" alt="">
    <div class="install-text">APIOps with decK</div>
  </a>
  {% endif_version %}
  <a href="/deck/{{page.release}}/reference/deck/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-admin-api-color.svg" alt="">
    <div class="install-text">CLI Reference</div>
  </a>

</div>

## Introducing decK

decK is a command line tool that facilitates API Lifecycle Automation (APIOps) 
by offering a comprehensive toolkit of commands 
designed to orchestrate and automate the entire process of API delivery. 
APIOps involves leveraging automation frameworks to streamline and enforce 
best practices throughout the API lifecycle. 
This enables developers and operations teams to manage APIs 
from development through deployment, ensuring consistency, reliability, 
and speed in API integrations.

decK operates on state files. decK state files describe the configuration of Kong API Gateway. 
State files encapsulate the complete configuration of Kong in a declarative format, 
including services, routes, plugins, consumers, and other entities that define how requests
are processed and routed through Kong.

{% if_version gte:1.35.x %}
Check out our [KongAir use case](/deck/latest/use-case/) to learn how decK can be used to
streamline API management processes for an airline.
{% endif_version %}

decK is compatible with {{site.ce_product_name}} >= 1.x and
{{site.ee_product_name}} >= 0.35.

{% if_version gte:1.35.x %}
## decK commands

The decK commands are structured into three main categories:

1. **Configuration Generation**: This category focuses on the initial creation of decK state files from industry-standard API specification formats. This category includes the following command: 
   - [deck file openapi2kong](/deck/{{page.release}}/reference/deck_file_openapi2kong/): Converts OpenAPI specification files into decK state files.

2. **Configuration Transformation**: This set of commands provides the tools needed to refine and restructure decK configuration files. It allows for the segmentation of a full configuration into smaller, manageable parts and their subsequent reassembly. This category includes the following commands:
   - [deck file add-plugins](/deck/{{page.release}}/reference/deck_file_add-plugins/): Incorporates plugins into decK objects.
   - [deck file add-tags](/deck/{{page.release}}/reference/deck_file_add-tags/): Attaches tags to decK objects for enhanced organization.
   - [deck file list-tags](/deck/{{page.release}}/reference/deck_file_list-tags/): Enumerates tags associated with decK objects.
   - [deck file remove-tags](/deck/{{page.release}}/reference/deck_file_remove-tags/): Eliminates tags from decK objects.
   - [deck file lint](/deck/{{page.release}}/reference/deck_file_lint/): Assesses a decK file against a set of linting rules, identifying any discrepancies.
   - [deck file patch](/deck/{{page.release}}/reference/deck_file_patch/): Applies modifications to a decK file without overhauling the entire configuration.
   - [deck file merge](/deck/{{page.release}}/reference/deck_file_merge/): Combines several partial decK files into a comprehensive one.
   - [deck file namespace](/deck/{{page.release}}/reference/deck_file_namespace): Apply a namespace to routes in a decK file by prefixing the path.
   - [deck file render](/deck/{{page.release}}/reference/deck_file_render/): Fuses multiple complete decK files, rendering a singular, unified configuration.
   - [deck file validate](/deck/{{page.release}}/reference/deck_file_validate/): Conducts an offline validation of the state file, pinpointing potential issues.
   - [deck file kong2kic](/deck/{{page.release}}/reference/deck_file_kong2kic/): Converts decK state files into {{site.kic_product_name}} manifests.

3. **Gateway State Management**: This category encompasses commands that facilitate
the synchronization of the final decK file with the target platform, be it {{site.konnect_product_name}}, {{site.base_gateway}}, 
or {{site.kic_product_name}}. This category includes:
   - [deck gateway ping](/deck/{{page.release}}/reference/deck_gateway_ping/): Confirms connectivity with Kong’s Admin API.
   - [deck gateway validate](/deck/{{page.release}}/reference/deck_gateway_validate/): Validates the state file against the Kong Admin API in an online setting.
   - [deck gateway dump](/deck/{{page.release}}/reference/deck_gateway_dump/): Extracts all entities from Kong and archives them in a local file.
   - [deck gateway diff](/deck/{{page.release}}/reference/deck_gateway_diff/): Executes a trial run of the `deck gateway sync` command to preview changes.
   - [deck gateway sync](/deck/{{page.release}}/reference/deck_gateway_sync/): Synchronizes the state file with Kong, ensuring alignment.
   - [deck gateway reset](/deck/{{page.release}}/reference/deck_gateway_reset/): Purges all entities from Kong, resetting its state.

Through these categories and their associated commands, decK offers a comprehensive suite of tools 
for configuration and management within the Kong platform.

{% endif_version %}

## Looking for help or need to report an issue?

### Find help

One of the design goals of decK is to deliver a good developer experience.
To find help, use the following resources:
- The `--help` flag gives you the necessary help in the terminal itself and should
  solve most of your problems.
- If you still need help, [open a Github issue](https://github.com/kong/deck/issues/new) to ask your
  question.
- decK has very wide adoption by Kong's community and you can seek help
  from the larger community at [Kong Nation](https://discuss.konghq.com).

### Report a bug

If you believe you have run into a bug with decK, [open a Github issue](https://github.com/kong/deck/issues/new).

If you think you've found a security issue with decK, read the
[Security](#security) section.

### Security

decK does not offer to secure your Kong deployment but only configures it.
It encourages you to protect your Kong Admin API implementation with authentication but
doesn't offer such a service itself.

decK's state file can contain sensitive data such as private keys of
certificates, credentials, etc. It is up to the user to manage
and store the state file in a secure fashion.

If you believe that you have found a security vulnerability in decK,
submit a detailed report, along with reproducible steps
to [security@konghq.com](mailto:security@konghq.com).

## Licensing

decK is licensed with Apache License Version 2.0.
Read the [LICENSE](https://github.com/kong/deck/blob/main/LICENSE) file for more details.

## More resources

* [**decK FAQs**](/deck/{{page.release}}/faqs)
{% if_version gte:1.35.x -%}
* **Use case:** [Streamlining KongAir APIs](/deck/{{page.release}}/use-case/), based on the 
[KongAir demo app](https://github.com/Kong/KongAir)
{% endif_version -%}
* **References:** The command line `--help` flag on the main command or a subcommand (like `diff`,
`sync`, `reset`, and so on) shows the help text along with supported flags for those
commands. You can also see the references for all [commands available with decK](/deck/{{page.release}}/reference/deck)
in the decK documentation.
* **Video:** Kong Summit [motivation behind decK](https://www.youtube.com/watch?v=fzpNC5vWE3g). 
  Harry Bagdi gave a talk on the motivation behind decK
  and demonstrated a few key features of decK at Kong Summit 2019.
* **Changelog**: See the [CHANGELOG](https://github.com/kong/deck/blob/main/CHANGELOG.md) file in the Kong/deck repository.
