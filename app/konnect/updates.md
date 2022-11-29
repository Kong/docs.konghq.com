---
title: Kong Konnect Updates
---

<!-- vale off -->

The updates contained in this topic apply to {{site.konnect_saas}},
an application that lets you manage configuration for multiple runtimes
from a single, cloud-based control plane, and provides a catalog of all deployed
services. [Try it today!](https://cloud.konghq.com/quick-start)

## December 2022

**Secrets management using vaults**
: {{site.konnect_short_name}} now supports storing sensitive values in a vault
with any of the following backends:
* Environment variables
* AWS Secrets Manager
* HashiCorp Vault
* GCP Secret Manager

: See the [vaults documentation](/konnect/runtime-manager/vaults) to get started.

## November 2022

**Application registration support in any runtime group**
: {{site.konnect_short_name}} now officially supports [app registration to services in both default and non-default runtime groups](/konnect/dev-portal/applications/enable-app-reg/#support-for-any-runtime-group). Portal developers can register their applications to consume services proxied through gateway services in both default and non-default runtime groups.

:  Currently, this feature is only available for services being proxied through {{site.base_gateway}} 3.0.0.0 or later.

**Dev portal Dynamic Client Registration**

: As part of this release, we have improved the UI for DCR to provide a more polished experience for users.

**Certificate management functionality added to the {{site.konnect_saas}} runtime manager**
: {{site.konnect_short_name}} now allows customers to handle the complexity of creating, storing,
and organizing certificates needed for runtime instances connected to runtime groups in {{site.konnect_short_name}}.
This reduces operational complexity for customers while ensuring that security is not compromised.

**New Analytics predefined teams**
: {{site.konnect_short_name}} now allows you to add users to the Analytics Viewer and Analytics Admin teams. These teams allow you to give users access to only the Analytics section in {{site.konnect_short_name}}. With this release, individual users don't have to be Organization Admins anymore to access all the Analytics capabilities.

: {{site.konnect_short_name}} now includes the following predefined Analytics teams:
* Analytics Admin: Users can fully manage all Analytics content, which includes creating, editing, and deleting reports, as well as viewing the analytics summary.
* Analytics Viewer: Users can only view the analytics summary and report data.

: For more information, see [Teams Reference](/konnect/org-management/teams-and-roles/teams-reference/).

**Migration to cloud.konghq.com is completed**
: All active accounts have been migrated from `konnect.konghq.com`
to [cloud.konghq.com](https://cloud.konghq.com).
The deprecated environment at `konnect.konghq.com` is no longer available.

**Multiple runtime groups**
: All the runtime groups in {{site.konnect_short_name}}, including default and non-default runtime groups, are eligible for application registration.

**Editing the default runtime group**
: You can now edit the name of the default runtime group.
The group still retains its status as the default group, and can't be deleted.

**Konnect APIs for identity management**
: Konnect APIs for identity management are now available for external consumption. This set of APIs allow organizations to manage users, teams, team memberships, team mappings and role assignments. As a result, customers can leverage our APIs to build custom integrations with their identity provider or ERP systems to manage their users and user’s access to Konnect.
[IdP API documentation](https://developer.konghq.com/spec/5175b87f-bfae-40f6-898d-82d224387f9b/d0e13745-db5c-42d5-80ae-ef803104f5ce)

## October 2022

**Dynamic client registration <span class="badge beta"></span>**
: Dynamic client registration with Okta is now in public beta.
[Test it out yourself!](/konnect/dev-portal/applications/dynamic-client-registration/okta/)

**Latency reporting**
: The Analytics dashboard now includes a [latency tab](/konnect/analytics/summary-dashboard/), which lets you track
request latency for the P50, P95, and P99 percentiles.
P99 latency data also appears in runtime groups and on service overview pages in the Service Hub.

: This feature is available for runtime instances running {{site.base_gateway}} 3.0.0.0 or later.

## September 2022

**Analytics custom reports**
: [Analytics custom reports](/konnect/analytics/generate-reports/) are now generally available in {{site.konnect_saas}}. This release focuses on stability and minor usability improvements.

: Custom reporting provides more data insights by allowing you to view data details and export data into a CSV file.

**Runtime groups dashboard**
: In {{site.konnect_saas}}, you now have insights into your [runtime groups usage](/konnect/runtime-manager/runtime-groups/dashboard/) across all and individual runtime instances. These insights help platform owners to understand the health and performance of each runtime group, which often reflects individual business units in a more federated organization.

**Custom plugin instantiation**
: {{site.konnect_saas}} now allows you to discover, configure, and apply Kong approved custom plugins to your control planes directly through the plugin hub in Runtime Manager. You can do this by submitting your custom plugin schemas for approval through the CRE teams. This allows you to expand Kong's functionality in your environment by using custom plugins, while reducing the operational overhead of working with your CRE teams to discover, configure, and apply custom plugins.

**Launch runtimes directly in a cloud provider <span class="badge alpha"></span>**
: You can now create runtime instances in Azure and AWS directly through {{site.konnect_saas}}. This simplifies the operational process for creating the runtime instance in your private cloud for AWS and Azure.

**Support for multiple versions of runtime instances**
: {{site.konnect_saas}} now supports running multiple runtime instances versions at the same time with the same control plane configuration. This makes it easier for you to test and validate new runtime instance versions, such as patch, minor, and major upgrades.
This release includes a new user interface that provides information about which runtime instances are incompatible with the current gateway configuration and provides actionable insights into the corrective steps to fix the issue.

**Quick start for new {{site.konnect_saas}} org admins**
: {{site.konnect_saas}} now includes an optional quick start that automatically creates a runtime group, service package, and gateway service, applies the CORS plugin, and shows analytics for that service with the click of a button. You can use the quick start to become familiar with the different aspects of {{site.konnect_saas}} via text and call-outs to key documentation throughout the onboarding process.

**Organization Admin (Read Only) predefined team**
: A new predefined team has been introduced in {{site.konnect_saas}}. This team allows you to grant users read-only access to all features and functions in {{site.konnect_saas}}. As always, permissions are additive, so a user in the Organization Admin (Read Only) team may also have write access to various features if they are assigned additional permissions.

**Multi-runtime group app registration support <span class="badge alpha"></span>**
: You can now enable app registration to services in all runtime groups. This feature only supports versions in the non-default runtime group that use {{site.base_gateway}} 3.0.

: As part of this release, API key credentials are no longer stored in the Dev Portal. Portal developers will need to store their credentials immediately after creation.

**Dynamic client registration <span class="badge beta"></span>**
: {{site.konnect_saas}} Dev Portal supports integration with Okta for end-to-end client management. This feature is released as a private beta. This feature allows Dev Portal developers to automatically create applications in Okta and receive credentials to access services proxied through {{site.base_gateway}}.

**Service version lifecycle**
: You can identify the [lifecycle stage](/konnect/servicehub/service-versions/#manage-the-service-version-lifecycle) of your APIs and notify Dev Portal developers if a particular API will be deprecated soon.  

**{{site.base_gateway}} 3.0.0.0 support**
: {{site.konnect_saas}} now supports {{site.base_gateway}} 3.0.0.0 runtimes.
You can keep using existing 2.8.x runtimes, or you can upgrade to
3.0.0.0 to take advantage of any new features, updates, and bug fixes.

: With this major release, {{site.base_gateway}} introduces many new features, including:
* Five new plugins, including WebSocket validation support, TLS connection customization, and OpenTelemetry
* A new expression-based router
* Dynamic plugin ordering through declarative configuration
* Slim and UBI Docker images
and much more.

: **3.0.0.0 is a major release**. This means that it contains breaking changes and incompatibilities with 2.x versions.
Review the list of [breaking changes](/gateway/changelog/#breaking-changes-and-deprecations) before upgrading to 3.0.
: In particular, note the following:
* **Changes to regex route path format**: 3.0 has a new router. To make sure your existing routes work in 3.0, add a `~` to any regex routes. Learn more in the [route configuration guide](/gateway/latest/key-concepts/routes/expressions/).
* **Limitations** ({{site.konnect_short_name}} only): [Secrets management](/gateway/latest/kong-enterprise/secrets-management/) and [consumer groups](/gateway/latest/kong-enterprise/consumer-groups/) are not yet supported in {{site.konnect_saas}}.


: For all the changes and new features in {{site.base_gateway}} 3.0.0.0, see the
[changelog](/gateway/changelog/#3000).

: To use any new features in the release,
[start up a new 3.0.0.0 runtime](/konnect/runtime-manager/runtime-instances/upgrade/).

## August 2022

**Generic OIDC**

: {{site.konnect_short_name}} launches generic OIDC support to allow Single-Sign-On (SSO) for platform login. Customers now have the ability to configure a separate OIDC-compliant Identity Provider (IdP) for {{site.konnect_short_name}}. Generic OIDC is an Enterprise feature.

**Personal Access Tokens**

: {{site.konnect_short_name}} users can now generate personal access tokens (PATs). PATs are used as an alternative method of authentication for [decK](/deck/1.14.x/guides/konnect/) commands avoiding the need to use traditional username and passwords.

**AWS Marketplace Listing**

: {{site.konnect_short_name}} Enterprise can now be purchased through the [AWS Marketplace](https://aws.amazon.com/marketplace/pp/prodview-7zds3oxx3ntjy) or via private contract with your Amazon Web Services account team. This greatly simplifies the procurement process for existing AWS customers.

**DevPortal Custom Domain Progress Indicator**

: We've added an in interactive checklist when configuring a [custom domain](/konnect/dev-portal/customization/#custom-dev-portal-url) for your developer portal. There is now an indicator to help understand if your DNS changes have propogated, and when the SSL certificate has been generated by {{site.konnect_short_name}}.

**Download option to all reports**

: We have introduced an "Export" option to all reports inside the overview page in Vitals. Exporting a report downloads an unpivoted CSV to your local machine that can be used for offline analysis.

## July 2022

**New environment for {{site.konnect_short_name}}**
: {{site.konnect_short_name}} is now available at [cloud.konghq.com](https://cloud.konghq.com), which replaces the [konnect.konghq.com](https://konnect.konghq.com) environment. The environment at `konnect.konghq.com` will no longer receive any updates, and will be deprecated in the near future.

: Existing organizations will be automatically upgraded to the new {{site.konnect_short_name}} environment over the next 4-6 weeks. We will be contacting your organization administrator with more details on the upgrade process.

: You can continue using your `konnect.konghq.com` account and wait until we migrate it, or create a new account and [manually migrate configuration to the new account](/konnect/getting-started/import).

: The minimum supported {{site.base_gateway}} version for this environment is 2.5.0.1.

**Runtime groups**
: {{site.konnect_short_name}} now manages all runtime configuration through runtime groups, which provide the ability to securely isolate configuration for sets of runtime instances. Essentially, this gives you access to multiple SaaS-managed control planes in one {{site.konnect_short_name}} organization.

: Every organization starts with one `default` runtime group. Additional custom runtime groups are an enterprise-only feature.

: Learn more about [runtime groups](/konnect/runtime-manager/runtime-groups), then read up on how to manage them with the [{{site.konnect_short_name}} UI](/konnect/runtime-manager/runtime-groups/manage) or with [decK](/konnect/runtime-manager/runtime-groups/declarative-config).

: With runtime groups come a few other changes to runtime management for all organizations:
  * Certificate rotation and management:
    * When setting up runtime instances through the {{site.konnect_short_name}} UI, certificates are generated in the browser and pushed to the {{site.konnect_short_name}} API.
    * {{site.konnect_short_name}} no longer requires CA certificates for runtime instances.
    * The validity period for runtime instance certificates has been extended from six months to ten years.
  * Reworked Gateway configuration UI:
    * The Shared Config menu is now part of Runtime Manager. Manage your Gateway services, routes, plugins, upstreams, SNIs, and certificates through a runtime group, alongside all of the runtime instances in that group.
  * You can use [labels for categorizing runtime groups](/konnect/runtime-manager/runtime-groups/manage).
  Labels are key:value pairs, and are helpful for organizing, searching, and filtering subsets of {{site.konnect_short_name}} entities.

**Teams and roles**
: You can now manage {{site.konnect_short_name}} authorization with [teams and roles](/konnect/org-management/teams-and-roles).
Existing RBAC roles have been converted to [predefined teams](/konnect/org-management/teams-and-roles/teams-reference), which are available for all {{site.konnect_short_name}} organizations.

: To manage user access, invite users to {{site.konnect_short_name}} and add them to teams, or assign individual roles to a user.

: With a {{site.konnect_short_name}} Enterprise subscription, you can also [create custom teams](/konnect/org-management/teams-and-roles/manage) and assign per-entity permissions for each team.

**Declarative configuration management support with decK**
: As of [decK 1.12](https://github.com/Kong/deck/releases), standard decK commands such as `diff`, `sync`, and `dump` support {{site.konnect_short_name}} runtime groups.
: Learn how to use decK with {{site.konnect_short_name}}:
  * [Get started with decK and {{site.konnect_short_name}}](/deck/latest/guides/konnect)
  * [Import](/konnect/getting-started/import) {{site.base_gateway}} or `konnect.konghq.com` configuration into `cloud.konqhq.com`
  * [Manage runtime groups with decK](/konnect/runtime-manager/runtime-groups/declarative-config)

**Tags for {{site.konnect_short_name}} services**
: You can now connect {{site.konnect_short_name}} services to Gateway services with the [`_KonnectService` tag](/deck/latest/guides/konnect/#konnect-service-tags).

**{{site.konnect_short_name}} UI/UX redesign**
: The {{site.konnect_short_name}} UI now has reworked navigation, refreshed colors and styles, and a focus on consistent interactions throughout the application.

: Navigation redesign details:
  * Services is renamed to Service Hub
  * Runtimes is renamed to Runtime Manager
  * Shared Config is now part of Runtime Manager
  * Dev Portal settings have moved from the general settings page to the Dev Portal section
  * Refreshed iconography for the main menu

**Dev Portal default theme**
: The Dev Portal now comes with a new default theme: "Mint Rocket".

**Dev Portal SSO support with your own IdP**
: You can now configure custom identity providers (IdPs) for the Dev Portal.
: See the [SSO documentation](/konnect/dev-portal/customization/#single-sign-on) for more information.

**Simplified custom Dev Portal URL setup**
: SSL certificate generation for custom URLs is now handled by {{site.konnect_short_name}}.

: To set up a custom URL, see the [Dev Portal customization documentation](/konnect/dev-portal/customization) for more information.

**Vitals metrics and dashboards**
: The Vitals overview dashboard has been reworked for Plus and Enterprise tiers.
The dashboard now provides metrics for services cataloged by Service Hub within a selected time interval.
You can view a graph for each category by clicking **Traffic** or **Errors**, and switching between the two views. Each graph is filterable by time frame.

: In the Service Hub, graphs for services and routes now show data up to the last 30 days.

**Vitals custom reports** <span class="badge alpha"></span>

: Vitals custom reports are now available for Plus and Enterprise tiers.
Through the Vitals menu, you can create custom reports to track API requests for services, routes, and applications.

: See the [custom reports documentation](/konnect/analytics/generate-reports) for more information.

**Custom plugin requirements have changed**
: Some custom plugin limitations have changed or been removed.
See the latest requirements in the [plugin documentation](/konnect/servicehub/plugins).

: Custom plugins can't be added directly through the {{site.konnect_saas}} application.
If you have a custom plugin you want to use in {{site.konnect_short_name}}, contact [Kong Support](https://support.konghq.com/).

**Refactored documentation**
: The {{site.konnect_short_name}} documentation has been refactored to match the new {{site.konnect_short_name}} navigation, and generally reworked to provide a better experience for {{site.konnect_short_name}} users. Let us know what you think via [team-docs@konghq.com](mailto:team-docs@konghq.com)!

**Known issues/limitations**
: The `cloud.konghq.com` environment has the following restrictions:
  * Application registration through Dev Portal can only be used with the default runtime group. This restriction will be removed in a future update to {{site.konnect_short_name}}.
  * The following plugins are not supported:
    * OAuth2 Authentication
    * Apache OpenWhisk
    * Vault Auth
    * DeGraphQL
    * GraphQL Rate Limiting Advanced
    * Key Authentication Encrypted
  * decK does not support authenticating against Runtime Groups when single sign-on (SSO) is enabled.

## March 2022

**{{site.base_gateway}} 2.8.0.0 support**
: {{site.konnect_saas}} now supports {{site.base_gateway}} 2.8.0.0 runtimes.
You can keep using existing 2.7.x runtimes, or you can upgrade to
2.8.0.0 to take advantage of any new features, updates, and bug fixes.

: For all the changes and new features in {{site.base_gateway}} 2.8.x, see the
[changelog](/gateway/changelog/#2800).

: To use any new features in the release,
[start up a new 2.8.0.0 runtime](/konnect/runtime-manager/runtime-instances/upgrade).

## January 2022

**Custom Domain for Dev Portal**
: You can now set a custom domain for your Dev Portal through the {{site.konnect_saas}} Admin UI.

: See the documentation: [Add a Custom Domain](/konnect/dev-portal/customization/).

**Headers are modifiable**
: You can now set a welcome message and primary header through the Admin UI for your Dev Portal.

## December 2021

**{{site.base_gateway}} 2.7.0.0 support**
: {{site.konnect_saas}} now supports {{site.base_gateway}} 2.7.0.0 runtimes.
You can keep using existing 2.6.x runtimes, or you can upgrade to
2.7.0.0 to take advantage of any new features, updates, and bug fixes.

: For all the changes and new features in {{site.base_gateway}} 2.7.x, see the
[changelog](/gateway/changelog/#2700).

: To use any new features in the release,
[start up a new 2.7.0.0 runtime](/konnect/runtime-manager/runtime-instances/upgrade).

## November 2021

**Single-sign on (SSO) with Okta**
: {{site.konnect_saas}} now supports single sign-on (SSO) access through
[Okta](https://developer.okta.com/docs/guides/) with
[OpenID Connect](https://developer.okta.com/docs/concepts/oauth-openid/#openid-connect).

: See the guide on [Setting up SSO with Okta](/konnect/org-management/okta-idp)
for more information.

**{{site.base_gateway}} 2.6.0.0 support**
: {{site.konnect_saas}} now supports {{site.base_gateway}} 2.6.0.0
runtimes. You can keep using existing 2.5.x runtimes, or you can upgrade to
2.6.0.0 to take advantage of any new features, updates, and bug fixes.
: This release introduces the new [jq plugin](/hub/kong-inc/jq). It also
adds new features and improvements to a long list of plugins, including:
* [Kafka Log](/hub/kong-inc/kafka-log)
and [Kafka Upstream](/hub/kong-inc/kafka-upstream): Support for TLS, mTLS, and
SASL auth
* [Prometheus](/hub/kong-inc/prometheus): Introduces the
`data_plane_cluster_cert_expiry_timestamp` metric, letting you keep an eye on the
status of you data plane certificates
* [Request Termination](/hub/kong-inc/request-termination): Introduces the
new `trigger` configuration option, which tells the
plugin to activate only on specific headers or query parameters

: To use any new features in the release and gain access to the jq plugin,
[start up a new runtime](/konnect/runtime-manager/runtime-instances/upgrade).

: For all the changes and new features in {{site.base_gateway}} 2.6.x, see the
[changelog](/gateway/changelog/#2600).

**Tags for auth plugins created by application registration**
: When you enable application registration on a Service,
{{site.konnect_saas}} enables two plugins automatically: ACL, and one of Key
Authentication or OIDC. These plugins cannot be edited or deleted directly. To
help differentiate the {{site.konnect_short_name}}-managed plugins and avoid breaking your service,
{{site.konnect_short_name}} now adds two metadata tags for declarative configuration:
`konnect-managed-plugin` and `konnect-app-registration`.


## August 2021

**{{site.base_gateway}} 2.5.0.1 support**
: {{site.konnect_saas}} now supports {{site.base_gateway}} 2.5.0.1.
runtimes. You can keep using existing 2.4.x runtimes, or you can upgrade to
2.5.0.1 to take advantage of any new features, updates, and bug fixes.
: This release includes [event hook support](/gateway/latest/admin-api/event-hooks/reference),
improvements to CP-DP communication, new configuration options in plugins, and more.
: For all the changes and new features in {{site.base_gateway}} 2.5.x, see the [changelog](/gateway/changelog).

## June 2021

**Global plugin support**
: You can now configure global plugins through {{site.konnect_saas}}. Visit the
[Shared Config page](https://konnect.konghq.com/configuration/)
and select the **Plugin** menu option to get started.

**{{site.base_gateway}} 2.4.1.1 support**
: {{site.konnect_saas}} now supports {{site.base_gateway}} 2.4.1.1
runtimes. You can keep using existing 2.3.x runtimes, or you can upgrade to
2.4.1.1 to take advantage of any new features.
: The 2.4.1.1 release includes two new plugins: [OPA](/hub/kong-inc/opa) and
[Mocking](/hub/kong-inc/mocking). To use these plugins, and any other features
newly introduced in this release, [start up a new runtime](/konnect/runtime-manager/runtime-instances/upgrade).
: For all the changes and new features in {{site.base_gateway}} 2.4.x, see the [changelog](/gateway/changelog).

**More plugins available in {{site.konnect_saas}}**
: The following plugins are now available:

: * **Free tier**
    * [Serverless Functions](/hub/kong-inc/serverless-functions/)
    * [Datadog](/hub/kong-inc/datadog/)
    * [Zipkin](/hub/kong-inc/zipkin/)
    * [Request Size Limiting](/hub/kong-inc/request-size-limiting/)
    * [Request Transformer](/hub/kong-inc/request-transformer/)
* **Plus tier**
    * [Exit Transformer](/hub/kong-inc/exit-transformer)
* **Enterprise tier**
    * [Key Auth Encrypted](/hub/kong-inc/key-auth-enc/)
    * [Request Transformer Advanced](/hub/kong-inc/request-transformer-advanced/)
    * [Response Transformer Advanced](/hub/kong-inc/response-transformer-advanced/)

**Default strategy/policy for rate limiting plugins**
: The rate limiting plugins now default to `redis` as the rate limiting
strategy or policy. This setting allows cluster-wide rate limiting using a
Redis server. To store counters in-memory on each node, change this setting
to `local`.

: The `cluster` config strategy/policy is not supported in
{{site.konnect_saas}}, and does not appear as an option in the plugin
configuration anymore.

: To find the setting based on the rate limiting plugin, see:
* `config.policy`:
    * [Rate Limiting](/hub/kong-inc/rate-limiting)
    * [Response Rate Limiting](/hub/kong-inc/response-ratelimiting)
* `config.strategy`:
    * [GraphQL Rate Limiting Advanced](/hub/kong-inc/graphql-rate-limiting-advanced/)
    * [Rate Limiting Advanced ](/hub/kong-inc/rate-limiting-advanced)

**Sorting the runtime status table**
: You can now sort the runtime status table in
[Runtime Manager](https://konnect.konghq.com/runtime-manager) by the
**Last Seen** or **Sync Status** columns.

## May 2021

**Certificate expiration limit extended**
: The validity period for runtime certificates has been extended from 30 days to
six months.

: To take advantage of the new validity period, bring up new data planes through
the Runtime Manager. For existing instances, [generate new certificates](/konnect/runtime-manager/runtime-instances/renew-certificates).

**{{site.konnect_short_name}} Plus is launched!**
: {{site.konnect_short_name}} introduces a
[new plan tier system](https://konghq.com/pricing) for subscriptions.
* **{{site.konnect_product_name}} Free:** Basic features and plugins with a
cloud control plane.
* **{{site.konnect_product_name}} Plus:** A pay-as-you-go, credit card-based
option that provides a simple way for developers or operators on small teams to
quickly start using the services they need right now.
* **{{site.konnect_product_name}} Enterprise**: For organizations that want
to manage all services across their entire organization. {{site.konnect_short_name}}
Enterprise provides connectivity with enterprise-grade security, scalability,
and observability across any cloud, platform, and protocol to help teams build
powerful digital services and experiences.

: If you already have a {{site.konnect_short_name}} or {{site.ee_product_name}}
account and license, this license will roll over seamlessly into the new
{{site.konnect_short_name}} Enterprise tier.

**{{site.konnect_short_name}} Plus free trials**
: When you [sign up for a {{site.konnect_short_name}} account](/konnect/getting-started/access-account),
you are automatically enrolled into a 30-day {{site.konnect_short_name}}
Plus free trial. You don't need to provide a credit card or any info beyond
the account registration. At the end of the trial, you'll have the choice to
keep the account at the Plus tier or downgrade to Free.

**Billing and plan management**
: You can now [manage your plan subscription](/konnect/account-management/billing)
for Free and Plus plan tiers directly from the app. {{site.konnect_short_name}}
now includes a Stripe integration, and the process is fully self-serve: choose
your plan, add a card, make payments, all through the {{site.konnect_short_name}}
app and billing portal.

**Self-serve account registration**
: You can now sign up for a {{site.konnect_short_name}} account without an
access code. No more
reaching out to Kong support or sales for access &ndash; just go
to [https://konnect.konghq.com](https://konnect.konghq.com) and try it out!

**Runtime setup improvements**
: Runtime setup for Linux and Kubernetes environments has improved. When you
configure a new runtime, instead of one **Advanced** tab, the Runtime Manager
now has **Linux** and **Kubernetes** tabs. Choose the tab that fits your
environment and copy the configuration parameters directly.

: **Known issues with the Kubernetes tab:**
: * The `image` and `repository` parameters are in the wrong format and
point to a non-existent image. Substitute them with the following:

    ```yaml
    image:
      repository: kong/kong-gateway
      tag: "2.3.2.0-alpine"
    ```
* `cluster_telemetry_endpoint` is missing a space between
the parameter and the value. Add a space to fix the formatting:

    ```yaml
    cluster_telemetry_endpoint: <your-instance-name>.tp.konnect.konghq.com:443
    ```

## March 2021

**Runtime setup improvement**
: Quick setup just got a little bit faster. When configuring a new runtime
through the Runtime Manager, HTTPie is no longer required for the
quick setup script.

## February 2021

**{{site.base_gateway}} 2.3 support**
: {{site.konnect_saas}} now supports {{site.base_gateway}} 2.3
runtimes. There is no upgrade path for existing runtimes.
: To use {{site.base_gateway}} 2.3, [re-provision a new runtime](/konnect/runtime-manager/#runtime-instances).

**Advanced runtime configuration**
: You can now configure custom {{site.base_gateway}} data planes through the
Runtime Manager and run gateway instances outside of Docker. Use the
**Advanced** option when configuring a new runtime to get started.

: See the runtime configuration guides for more information:
* [{{site.base_gateway}} runtime on Docker](/konnect/runtime-manager/runtime-instances/gateway-runtime-docker/)
* [{{site.base_gateway}} runtime on Kubernetes](/konnect/runtime-manager/runtime-instances/gateway-runtime-kubernetes/)
* [{{site.base_gateway}} runtime without a container](/konnect/runtime-manager/runtime-instances/gateway-runtime-conf/)

**Logging plugins**
: The full set of {{site.base_gateway}}'s logging plugins is now available
through {{site.konnect_saas}}. This includes:
* [File Log](/hub/kong-inc/file-log)
* [HTTP Log](/hub/kong-inc/http-log)
* [Kafka Log](/hub/kong-inc/kafka-log)
* [Loggly](/hub/kong-inc/loggly)
* [StatsD](/hub/kong-inc/statsd)
* [StatsD Advanced](/hub/kong-inc/statsd-advanced)
* [Syslog](/hub/kong-inc/syslog)
* [TCP Log](/hub/kong-inc/tcp-log)
* [UDP Log](/hub/kong-inc/udp-log)

**Portal authentication**
: You can now [disable authentication on a Dev Portal](/konnect/dev-portal/access/),
which exposes the Dev Portal publicly to anyone with the link. No one needs to register
for Dev Portal access.
: New application registrations aren't available through a public-facing portal.

**{{site.konnect_product_name}} ({{site.konnect_short_name}}) is now generally available!**

: To get started with {{site.konnect_short_name}}, see the
[Quickstart Guide](/konnect/getting-started/configure-runtime/).

: For more information about {{site.konnect_short_name}}, contact your Kong sales
representative.
