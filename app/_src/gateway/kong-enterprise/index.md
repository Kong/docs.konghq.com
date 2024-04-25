---
title: Overview
badge: enterprise
content_type: explanation
---

{{site.ee_product_name}} is the scalable, secure, and flexible API management solution that extends {{site.base_gateway}}, the fastest, most adopted API gateway. 
It adds enterprise plugins, advanced security features, GUI's, and 24/7 support. 
It is the only solution that helps you accelerate your cloud journey by managing, securing, and monitoring connections between applications across hybrid and multi-cloud architectures, to help you scale faster and boost developer productivity.

## Enterprise Plugins

{{site.ee_product_name}} offers access to 400+ out-of-box enterprise and community plugins. 
It offers exclusive versions of OSS plugins like the [Rate Limiting Advanced plugin](/hub/kong-inc/rate-limiting-advanced/) with added functionality such as the use of consumer groups, and database specific strategy. It also provides Enterprise-exclusive functionality, such as authentication with 
[OpenID Connect](/hub/kong-inc/openid-connect/), which lets you standardize identity provider (IdP) integrations.

{{site.ee_product_name}} also natively supports gRPC and REST, WebSockets, and integrates with Apollo GraphQL server and Apache Kafka services. These plugins can be leveraged to provide advanced connectivity features and solutions to {{site.base_gateway}} such as:

* [OpenID Connect (OIDC)](/hub/kong-inc/openid-connect/)
* [Event gateways with Kafka](/hub/kong-inc/kafka-upstream/)
* [GraphQL](/hub/kong-inc/graphql-proxy-cache-advanced/)
* [Mocking](/hub/kong-inc/mocking/)
* [Advanced data transformation](/hub/kong-inc/jq/)
* [OPA Policy driven traffic management](/hub/kong-inc/opa/)
{% if_version lte:3.3.x -%}
* [API product tiers](/gateway/{{page.release}}/admin-api/consumer-groups/reference/)
{% endif_version -%}
{% if_version gte:3.4.x -%}
* [API product tiers](/gateway/api/admin-ee/latest/#/consumer_groups/get-consumer_groups)
{% endif_version %}
[Get started with plugins &rarr;](/hub/)

{% if_version lte:3.4.x %}
## Dev Portal

The Dev Portal provides a single source of truth for all developers to locate, access and consume APIs, similar to a traditional API catalog. 
Dev Portal streamlines developer onboarding by offering a self-service developer experience to discover, register, and consume published services from {{site.base_gateway}}.
This customizable experience can be used to match your own unique branding and highlights the documentation and interactive API specifications of your services.
In addition, you can secure your APIs with a variety of authorization providers by enabling application registration.

[Learn more about Dev Portal &rarr;](/gateway/{{page.release}}/kong-enterprise/dev-portal/)

## Monitoring and analytics

The Vitals platform provides deep insights into services, routes, and application usage data. You can view the health of your API products with custom reports and contextual dashboards, and you can enhance the native monitoring and analytics capabilities with {{site.base_gateway}} plugins that enable streaming monitoring metrics to third-party analytics providers, such as [Datadog](/hub/kong-inc/datadog/) and [Prometheus](/hub/kong-inc/prometheus/).

[Start monitoring with Vitals &rarr;](/gateway/{{page.release}}/kong-enterprise/analytics/)

{% endif_version %}
## Role-based access control (RBAC)

{{site.ee_product_name}} lets you configure users, roles, and permissions with built-in role-based access control (RBAC). With RBAC, you can streamline developer onboarding, and create apply fine-grained security and traffic policies using the [Admin API](/gateway/api/admin-ee/latest/), or [Kong Manager](/gateway/{{page.release}}/kong-manager/auth/rbac/).

[Manage teams with RBAC &rarr;](/gateway/{{page.release}}/kong-manager/auth/rbac)

## Secrets management
{{site.ee_product_name}} offers out of the box secrets management with the following backends: 

* [Amazon Web Services (AWS)](/gateway/{{page.release}}/kong-enterprise/secrets-management/backends/aws-sm/)
{% if_version gte:3.5.x -%}
* [Microsoft Azure](/gateway/{{page.release}}/kong-enterprise/secrets-management/backends/azure-key-vaults/)
{% endif_version -%}
* [Google Cloud Platform (GCP)](/gateway/{{page.release}}/kong-enterprise/secrets-management/backends/gcp-sm/)
* [Hashicorp Vault](/gateway/{{page.release}}/kong-enterprise/secrets-management/backends/hashicorp-vault/)

To configure secrets management, {{site.base_gateway}} consumes your key for the backend provider, authenticates with the backend provider, and uses the backend to centrally manage and store application secrets, sensitive data, passwords, keys, certifications, tokens, and other items.

[Secure your application secrets &rarr;](/gateway/{{page.release}}/kong-enterprise/secrets-management/)


## Keyring and data encryption

Keyring and data encryption functionality provides transparent, symmetric encryption of sensitive data fields at rest. When enabled, {{site.base_gateway}} encrypts and decrypts data immediately before writing, or immediately after reading, from the database. Responses generated by the Admin API that contain sensitive fields continue to show data as plaintext, and {{site.base_gateway}} runtime elements (such as plugins) that require access to sensitive fields do so transparently, without requiring additional configuration.

{{site.base_gateway}} allows you to store sensitive data fields, such as consumer secrets, in an encrypted format within the database.
This provides encryption-at-rest security controls in a {{site.base_gateway}} cluster.

[Set up keyring and data encryption &rarr;](/gateway/{{page.release}}/kong-enterprise/db-encryption/)

## Audit logging

{{site.base_gateway}} provides granular logging of the Admin API. You can keep detailed track of changes made to the
cluster configuration throughout its lifetime, for compliance efforts and for
providing valuable data points during forensic investigations. Generated audit
log trails are [workspace](/gateway/api/admin-ee/latest/#/Workspaces) and [RBAC](/gateway/api/admin-ee/latest/)-aware,
providing {{site.base_gateway}} operators a deep and wide look into changes happening within
the cluster.

[Get started with audit logging &rarr;](/gateway/{{page.release}}/kong-enterprise/audit-log/)

## FIPS support

{{site.ee_product_name}} features a self-managed FIPS 140-2 gateway package, making it ideal for highly regulated industries with strict compliance and security considerations. 
Compliance with this standard is typically required for working with U.S. federal government agencies and their contractors.

[Learn more about FIPS support &rarr;](/gateway/{{page.release}}/kong-enterprise/fips-support/)

## Workspaces

Workspaces provide a way to segment or group {{site.base_gateway}} entities. Entities in a workspace are isolated from those in other workspaces.
{{site.ce_product_name}} is limited to one workspace. With {{site.ee_product_name}}, you can leverage multiple workspaces to allow developers to easily transition between projects, and to separate services and routes belonging to different upstreams. 

[Learn more about workspaces &rarr;](/gateway/{{page.release}}/kong-manager/workspaces/)

## Dynamic plugin ordering

Dynamic plugin ordering allows you to override the priority for any {{site.base_gateway}} plugin using each plugin's `ordering` field. 
This determines plugin ordering during the `access` phase
and lets you create _dynamic_ dependencies between plugins.

[Get started with dynamic plugin ordering &rarr;](/gateway/{{page.release}}/kong-enterprise/plugin-ordering/)
## Event hooks

Event hooks are outbound calls from {{site.base_gateway}}. With event hooks, the {{site.base_gateway}} can communicate with target services or resources, letting the target know that an event was triggered. When an event is triggered in the {{site.base_gateway}}, it calls a URL with information about that event. Event hooks add a layer of configuration for subscribing to worker events using the admin interface. 

In {{site.base_gateway}}, these callbacks can be defined using one of the following handlers:

* webhook
* webhook-custom
* log
* lambda

You can configure event hooks through the Admin API.

[Learn more about event hooks &rarr;](/gateway/api/admin-ee/latest/#/Event-hooks/)

## Consumer groups

Consumer groups enable the organization and categorization of consumers (users or applications) within an API ecosystem. 
By grouping consumers together, you eliminate the need to manage them individually, providing a scalable, 
efficient approach to managing configurations.

For example, you could use consumer groups to define rate limiting tiers and
apply them to subsets of consumers, instead of managing each consumer
individually.

{% if_version lte:3.3.x %}
* [Set up consumer groups &rarr;](/hub/kong-inc/rate-limiting-advanced/how-to/)
* [Consumer groups API reference &rarr;](/gateway/{{page.release}}/admin-api/consumer-groups/reference/)
{% endif_version %}
{% if_version gte:3.4.x %}
* [Consumer groups API documentation &rarr;](/gateway/api/admin-ee/latest/#/consumer_groups/get-consumer_groups)
* [Plugins with consumer groups support &rarr;](/hub/plugins/compatibility/#scopes)
{% endif_version %}

{% if_version gte:3.2.x %}
## Provisioning new data planes in the event of a control plane outage

Starting in version 3.2, {{site.base_gateway}} can be configured to support configuring new data planes in the event of a control plane outage. For more information, read the [How to Manage New Data Planes during Control Plane Outages](/gateway/latest/kong-enterprise/cp-outage-handling/) documentation, or the [Control Plane Outage Management FAQ](/gateway/latest/kong-enterprise/cp-outage-handling-faq/).

{% endif_version %}

{% if_version gte:3.5.x %}

## Docker container image signing

Starting with {{site.ee_product_name}} 3.5.0.2, Docker container images are signed, and can be verified using `cosign` with signatures published to a Docker Hub repository. Read the [Verify signatures for Signed Kong Images](/gateway/{{ page.release }}/kong-enterprise/signed-images/) documentation to learn more.
{% endif_version %}

{% if_version gte:3.6.x %}

## Docker container image build provenance

Kong produces build provenance for docker container images, which can be verified using `cosign` / `slsa-verifier` with attestations published to a Docker Hub repository. Read the [Verify Build Provenance for Signed Kong Images](/gateway/{{ page.release }}/kong-enterprise/provenance-verification/) documentation to learn more.

{% endif_version %}

## More information

See [Plugin Compatibility](/hub/plugins/compatibility/) for more information about Enterprise-only plugins.
