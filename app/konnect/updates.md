---
title: Konnect Cloud Updates
no_version: true
---

The updates contained in this topic apply to {{site.konnect_saas}},
an application that lets you manage configuration for multiple runtimes
from a single, cloud-based control plane, and provides a catalog of all deployed
services.

## Date TBA

**New site (domain? environment?) for Konnect**
: Konnect is now available at [cloud.konghq.com](https://cloud.konghq.com), which replaces the [konnect.konghq.com](https://konnect.konghq.com) domain.
`konnect.konghq.com` will no longer receive any updates, and will be deprecated in the near future.

: You can continue using your `konnect.konghq.com` account, or create a new one and [manually migrate configuration to the new account](/konnect/getting-started/import).
In the upcoming months, Kong will be migrating all accounts to the `cloud.konghq.com` environment.

: The minimum supported Kong Gateway version in this environment is 2.5.0.1.

**Runtime groups**
: Konnect now manages all runtime configuration through runtime groups, which provide the ability to have multiple control planes in one Konnect organization.
Each runtime group acts as a separate control plane and can manage runtime configurations independently of any other group.

: Learn more about [runtime groups](/konnect/runtime-manager/runtime-groups), then read up on how to manage them with the [Konnect UI](/konnect/runtime-manager/runtime-groups/manage) or with [decK](/konnect/runtime-manager/runtime-groups/declarative-config).

**Teams and roles**
: You can now manage Konnect authorization with [teams and roles](/konnect/org-management/teams-and-roles). You can use {{site.konnect_short_name}}'s [predefined teams](/konnect/org-management/teams-and-roles/teams-reference) for a standard set of roles, or [create custom teams](/konnect/org-management/teams-and-roles/manage) with any roles you choose. Invite users and add them to these teams to manage user access.

**Konnect UI/UX redesign**
: The Konnect UI now has reworked navigation, refreshed colors and styles, and a focus on consistent interactions throughout the application.

: Navigation redesign details:
  * Services is renamed to Service Hub
  * Runtimes is renamed to Runtime Manager
  * Shared Config is now part of Runtime Manager
  * Dev Portal settings have moved from the general settings page to the Dev Portal section
  * Refreshed iconography for the main menu

**Dev Portal SSO**

: You can now configure custom identity providers (IdPs) for the Dev Portal.
: See the [SSO documentation](/konnect/dev-portal/customization/#single-sign-on) for more information.

**Koko?**
: (What can we say about the changes to the CP?)

**Vitals metrics and dashboards**
: The Vitals overview dashboard now provides metrics for services cataloged by Service Hub within a selected time interval.
You can view a graph for each category by clicking **Traffic** or **Errors**, and switching between the two views. Each graph is filterable by timeframe.

: In the Service Hub, graphs for services and routes now show data up to the last 30 days.

**Vitals custom reports** <span class="badge alpha"></span>

: Through the Vitals menu, you can create custom reports to track API calls based on services, routes, or applications.

: See the [custom reports documentation](/konnect/vitals/generate-reports) for more information.

**Labels**
: You can now use labels for categorizing runtime groups.
Labels are key:value pairs, and are helpful for organizing, searching, and filtering subsets of Konnect entities.
: Learn about using labels in the [runtime group documentation](/konnect/runtime-manager/runtime-groups/manage).

**Tags for Konnect services**
: You can now connect Konnect services to Gateway services with the [`_KonnectService` tag](/deck/latest/guides/konnect/#konnect-service-tags).

**Service sharing**
: You can [share Konnect services](/konnect/servicehub/manage-services/#share-a-service) with users and teams through the Service Hub.

**Certificate changes for runtime instances**
: The validity period for runtime instance certificates has been extended from six months ten years.

: Additionally, Konnect doesn't require CA certificates for runtime instances anymore.

**Custom plugin requirements have changed**
: Some custom plugin limitations have changed or been removed.
See the latest requirements in the [plugin doc](/konnect/servicehub/plugins).

: Custom plugins can't be added directly through the {{site.konnect_saas}} application.
If you have a custom plugin you want to use in Konnect, contact [Kong Support](https://support.konghq.com/).

**Refactored documentation**
: The Konnect documentation has been refactored to match the new Konnect navigation, and generally reworked to provide a better experience for Konnect users.

**Known issues/limitations**
: The `cloud.konghq.com` environment has the following restrictions:
  * Dev Portal and application registration can only be used with the default runtime group.
  * The following plugins are not supported:
    * OAuth2 Authentication
    * OAuth2 Introspection
    * Apache OpenWhisk
    * Vault Auth
  * What else?

## March 2022

### 2021.03.07
**{{site.base_gateway}} 2.8.0.0 support**
: {{site.konnect_saas}} now supports {{site.base_gateway}} 2.8.0.0 runtimes.
You can keep using existing 2.7.x runtimes, or you can upgrade to
2.8.0.0 to take advantage of any new features, updates, and bug fixes.

: For all the changes and new features in {{site.base_gateway}} 2.8.x, see the
[changelog](/gateway/changelog/#2800).

: To use any new features in the release,
[start up a new 2.8.0.0 runtime](/konnect/runtime-manager/runtime-instances/upgrade).

## January 2022

### 2022.01.14
**Custom Domain for Dev Portal**
: You can now set a custom domain for your Dev Portal through the {{site.konnect_saas}} Admin UI.

: See the documentation: [Add a Custom Domain](/konnect/dev-portal/customization/).

**Headers are modifiable**
: You can now set a welcome message and primary header through the Admin UI for your Dev Portal.

## December 2021

### 2021.12.21
**{{site.base_gateway}} 2.7.0.0 support**
: {{site.konnect_saas}} now supports {{site.base_gateway}} 2.7.0.0 runtimes.
You can keep using existing 2.6.x runtimes, or you can upgrade to
2.7.0.0 to take advantage of any new features, updates, and bug fixes.

: For all the changes and new features in {{site.base_gateway}} 2.7.x, see the
[changelog](/gateway/changelog/#2700).

: To use any new features in the release,
[start up a new 2.7.0.0 runtime](/konnect/runtime-manager/runtime-instances/upgrade).

## November 2021

### 2021.11.30
**Single-sign on (SSO) with Okta**
: {{site.konnect_saas}} now supports single sign-on (SSO) access through
[Okta](https://developer.okta.com/docs/guides/) with
[OpenID Connect](https://developer.okta.com/docs/concepts/oauth-openid/#openid-connect).

: See the guide on [Setting up SSO with Okta](/konnect/org-management/okta-idp)
for more information.


### 2021.11.10
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
See the Dev Portal doc section on
[{{site.konnect_short_name}}-managed plugins](/konnect/dev-portal/applications/application-overview/#konnect-managed-plugins)
for more information.


## August 2021
### 2021.08.31
**{{site.base_gateway}} 2.5.0.1 support**
: {{site.konnect_saas}} now supports {{site.base_gateway}} 2.5.0.1.
runtimes. You can keep using existing 2.4.x runtimes, or you can upgrade to
2.5.0.1 to take advantage of any new features, updates, and bug fixes.
: This release includes [event hook support](/gateway/latest/admin-api/event-hooks/reference),
improvements to CP-DP communication, new configuration options in plugins, and more.
: For all the changes and new features in {{site.base_gateway}} 2.5.x, see the [changelog](/gateway/changelog).

## June 2021
### 2021.06.24
**Global plugin support**
: You can now configure global plugins through {{site.konnect_saas}}. Visit the
[Shared Config page](https://konnect.konghq.com/configuration/)
and select the **Plugin** menu option to get started.

### 2021.06.21
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


### 2021.06.15
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

### 2021.05.12
**Certificate expiration limit extended**
: The validity period for runtime certificates has been extended from 30 days to
six months.

: To take advantage of the new validity period, bring up new data planes through
the Runtime Manager. For existing instances, [generate new certificates](/konnect/runtime-manager/runtime-instances/renew-certificates).

### 2021.05.11

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

### 2021.05.07

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

### 2021.03.16
**Runtime setup improvement**
: Quick setup just got a little bit faster. When configuring a new runtime
through the Runtime Manager, HTTPie is no longer required for the
quick setup script.

## February 2021

### 2021.02.23

**{{site.base_gateway}} 2.3 support**
: {{site.konnect_saas}} now supports {{site.base_gateway}} 2.3
runtimes. There is no upgrade path for existing runtimes.
: To use {{site.base_gateway}} 2.3, [re-provision a new runtime](/konnect/runtime-manager/#kong-gateway).

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

### 2021.02.10

**Portal authentication**
: You can now [disable authentication on a Dev Portal](/konnect/dev-portal/access/),
which exposes the Dev Portal publicly to anyone with the link. No one needs to register
for Dev Portal access.
: New application registrations aren't available through a public-facing portal.

### 2021.02.01

{{site.konnect_product_name}} ({{site.konnect_short_name}}) is now generally available!

To get started with {{site.konnect_short_name}}, see the
[Quickstart Guide](/konnect/getting-started/configure-runtime/).

For more information about {{site.konnect_short_name}}, contact your Kong sales
representative.
