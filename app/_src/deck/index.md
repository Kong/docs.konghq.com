---
title: decK
subtitle: Manage {{site.konnect_product_name}}, {{site.base_gateway}} and {{site.kic_product_name}} configuration declaratively
content_type: explanation
---

## What is decK?

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

decK is compatible with {{site.ce_product_name}} >= 1.x and
{{site.ee_product_name}} >= 0.35.

## decK commands

The decK commands are structured into three main categories:

1. **Configuration Generation**: This category focuses on the initial creation of decK state files from industry-standard API specification formats. This category includes the following command: 
   - [deck file openapi2kong](/deck/{{page.release}}/reference/deck_file_openapi2kong/): Converts OpenAPI specification files into decK state files.

2. **Configuration Transformation**: This set of commands provides the tools needed to refine and restructure decK configuration files. It allows for the segmentation of a full configuration into smaller, manageable parts and their subsequent reassembly. This category includes commands such as:
   - [deck file add-plugins](/deck/{{page.release}}/reference/deck_file_add-plugins/): Incorporates plugins into decK objects.
   - [deck file add-tags](/deck/{{page.release}}/reference/deck_file_add-tags/): Attaches tags to decK objects for enhanced organization.
   - [deck file list-tags](/deck/{{page.release}}/reference/deck_file_list-tags/): Enumerates tags associated with decK objects.
   - [deck file remove-tags](/deck/{{page.release}}/reference/deck_file_remove-tags/): Eliminates tags from decK objects.
   - [deck file lint](/deck/{{page.release}}/reference/deck_file_lint/): Assesses a decK file against a set of linting rules, identifying any discrepancies.
   - [deck file patch](/deck/{{page.release}}/reference/deck_file_patch/): Applies modifications to a decK file without overhauling the entire configuration.
   - [deck file merge](/deck/{{page.release}}/reference/deck_file_merge/): Combines several partial decK files into a comprehensive one.
   - [deck file render](/deck/{{page.release}}/reference/deck_file_render/): Fuses multiple complete decK files, rendering a singular, unified configuration.
   - [deck file validate](/deck/{{page.release}}/reference/deck_file_validate/): Conducts an offline validation of the state file, pinpointing potential issues.
   - [deck file kong2kic](/deck/{{page.release}}/reference/deck_file_kong2kic/): Converts decK state files into Kong Ingress Controller manifests.

3. **Gateway State Management**: This category encompasses commands that facilitate
the synchronization of the final decK file with the target platform, be it Konnect, Kong Gateway, 
or Kong Ingress Controller. Key commands include:
   - [deck gateway ping](/deck/{{page.release}}/reference/deck_gateway_ping/): Confirms connectivity with Kong’s Admin API.
   - [deck gateway validate](/deck/{{page.release}}/reference/deck_gateway_validate/): Validates the state file against the Kong Admin API in an online setting.
   - [deck gateway dump](/deck/{{page.release}}/reference/deck_gateway_dump/): Extracts all entities from Kong and archives them in a local file.
   - [deck gateway diff](/deck/{{page.release}}/reference/deck_gateway_diff/): Executes a trial run of the `deck gateway sync` command to preview changes.
   - [deck gateway sync](/deck/{{page.release}}/reference/deck_gateway_sync/): Synchronizes the state file with Kong, ensuring alignment.
   - [deck gateway reset](/deck/{{page.release}}/reference/deck_gateway_reset/): Purges all entities from Kong, resetting its state.

Through these categories and their associated commands, decK offers a comprehensive suite of tools 
for configuration and management within the Kong platform.

## Use case

Let's explore how KongAir, an imaginary airline, leverages decK to streamline its API management processes. The KongAir API Community of Practice has established a set of governance rules to ensure uniformity and efficiency across all API teams:

- Every API team within KongAir, including those responsible for the Flights and Routes APIs, adopts OpenAPI specifications to define their API contracts.
- These teams maintain the flexibility to employ Kong's Transformation and Validation plugins to enhance their APIs. They manage these plugins' configurations through modular decK state files, promoting autonomy and customization.
- The KongAir API Community of Practice has also embraced a comprehensive set of API Design Guidelines to standardize API development. These guidelines are implemented and monitored through a linting file overseen by the dedicated API Platform Team, ensuring adherence to best practices.
- The API Platform Team assumes a pivotal role in configuring critical plugins related to Observability, Security, and Traffic Control within Kong, centralizing expertise and governance for these essential aspects.
- Furthermore, this team is tasked with the management of environment-specific variables, ensuring seamless deployment and operation across different stages of the development lifecycle.

The diagram below delineates KongAir's structured approach to deploying decK, steered by their established governance protocols:

1. The Flights API team initiates the process by converting their OpenAPI Specification into a decK state file using the `deck file openapi2kong` command.
2. Next, they enhance the state file by integrating Transformation Plugins (such as Request Transformer Advanced and Correlation ID) and Validation plugins (like OAS Validation) using the `deck file add-plugins` command.
3. To track the configuration's creation time, they apply relevant tags using `deck file add-tags`.
4. The state file undergoes a quality check against a predefined linting ruleset with `deck file lint`, ensuring adherence to best practices.
5. Environment-specific adjustments, including upstream API URLs, are made using the `deck file patch` command.
6. The Platform Team then merges global plugins for Observability, Authentication, Authorization, and Traffic Control into the main state file with `deck file merge`.
7. At this stage, a comprehensive state file for the Flights API is ready. This file is combined with the Routes API's state file using `deck file render`, creating a unified configuration.
8. The final state file is subjected to an offline validation through `deck file validate`.

   For deployments:
   - To {{site.konnect_product_name}} or {{site.base_gateway}} deployments, the process involves:
     1. Ensuring connectivity with the Admin API via `deck gateway ping`.
     2. Performing an online validation with `deck gateway validate`.
     3. Backing up the current Kong state with `deck gateway dump`.
     4. Previewing changes with `deck gateway diff`.
     5. Applying the new configuration with `deck gateway sync`.
   - For {{site.kic_product_name}} deployments, the sequence is:
     1. Transforming the decK state file into Kubernetes manifests using `deck file kong2kic`.
     2. Deploying the configuration with `kubectl apply`.

{% mermaid %}
        flowchart TB
    subgraph KongAir Flights API Team
        oas_flights[[Open API Specificiation]]
        trans_plugins_flights[[Transformation Plugins]]
        validation_plugins_flights[[Validation Plugins]]
    end
    subgraph KongAir API Platform Team
        obs_plugins_platform[[Observability Plugins]]
        auth_plugins_platform[[AuthN/AuthZ Plugins]]
        traffic_plugins_platform[[Traffic Control Plugins]]
        linting_platform[[Linting rules]]
        env_vars[[Environment Variables]]
    end
    subgraph KongAir Routes API Team
        routes_api[[Routes API Kong Conf]]
    end
    oas_flights_o2k([deck file openapi2kong])
    deck_flights_plugins([deck file add-plugins])
    oas_flights --> oas_flights_o2k
    oas_flights_o2k --> flights_kong_config[[Flights API Kong Conf]]
    flights_kong_config --> deck_flights_plugins
    trans_plugins_flights --> deck_flights_plugins
    validation_plugins_flights --> deck_flights_plugins
    deck_flights_plugins --> flights_plugins[[Flights API Kong Conf]]
    flights_plugins --> deck_flights_tags([deck file add-tags])
    deck_flights_tags --> flights_plugins_tags[[Flights API Kong Conf]]
    flights_plugins_tags --> deck_flights_lint([deck file lint])
    linting_platform --> deck_flights_lint
    deck_flights_lint --> flights_linted[[Flights API Kong Conf]]
    flights_linted --> deck_flights_patch([deck file patch])
    env_vars --> deck_flights_patch
    deck_flights_patch --> flights_patched[[Flights API Kong Conf]]
    flights_patched --> deck_flights_merge([deck file merge])
    obs_plugins_platform --> deck_flights_merge
    auth_plugins_platform --> deck_flights_merge
    traffic_plugins_platform --> deck_flights_merge
    deck_flights_merge --> flights_merged[[Flights API Kong Conf]]
    flights_merged --> deck_flights_render([deck file render])
    routes_api --> deck_flights_render
    deck_flights_render --> kongair_complete[[KongAir APIs Kong Conf]]
    kongair_complete --> deck_complete_validate([deck file validate])
    deck_complete_validate --> kongair_valid[[KongAir APIs Kong Conf]]
    kongair_valid --> target_platform
    target_platform{Target<br/>Platform}
    target_platform -->|Kong Admin API| deck_ping([deck gateway ping])
    deck_ping --> deck_validate([deck gateway validate])
    deck_validate --> deck_dump([deck gateway dump])
    deck_dump --> deck_diff([deck gateway diff])
    deck_diff --> deck_sync([deck gateway sync])
    target_platform -->|Kubernetes API| deck_kic([deck file kong2kic])
    deck_kic --> k8s_manifests[[KongAir APIs K8s Manifests]]
    k8s_manifests --> kubectl([kubectl apply])
{% endmermaid %}

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
* **References:** The command line `--help` flag on the main command or a subcommand (like `diff`,
`sync`, `reset`, and so on) shows the help text along with supported flags for those
commands. You can also see the references for all [commands available with decK](/deck/{{page.release}}/reference/deck)
in the decK documentation.
* **Video:** Kong Summit [motivation behind decK](https://www.youtube.com/watch?v=fzpNC5vWE3g). 
  Harry Bagdi gave a talk on the motivation behind decK
  and demonstrated a few key features of decK at Kong Summit 2019.
* **Changelog**: See the [CHANGELOG](https://github.com/kong/deck/blob/main/CHANGELOG.md) file in the Kong/deck repository.
