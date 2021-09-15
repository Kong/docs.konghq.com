---
title: Kong Enterprise 2.1.x Release Notes
---

These release notes provide a high-level overview of Kong Enterprise 2.1.x, which includes the 2.1.0.0 (beta) release. For detailed information about 2.1.x, 2.1.0.0 (beta), and any subsequent 2.1.x patch releases, see the [Changelog](https://docs.konghq.com/enterprise/changelog/).

## New Features

### Hybrid Mode

Kong Enterprise now supports a new deployment method called Hybrid mode, also known as Control Plane / Data Plane Separation (CP/DP).

In this mode, Kong nodes in a cluster are split into two roles: Control Plane (CP), which centrally manages Kong Enterprise cluster configuration, and Data Plane (DP), which serves traffic for the proxy. Each DP node is connected to one of the CP nodes. Instead of accessing the database contents directly as in the traditional deployment method, the DP nodes maintain connection with CP nodes, and receive the latest configuration. All nodes in a cluster are configured with generated certificates, ensuring each Data Plane node is calling back to securely pair with the Control Plane.

You can manage Kong Enterprise add-ons including Kong Manager, Developer Portal, Vitals, Immunity, and Brain from a single Control Plane that spans multiple clusters across different data centers and platforms. This means that you can distribute Kong Enterprise instances in Data Plane mode over any of Kong’s supported environments, while still connecting back to the Control Plane.

Here’s a sample configuration with one central Control Plane and three Data Plane nodes, as well as Kong Manager and Developer Portal enabled on the Control Plane:

![Hybrid mode](/assets/images/docs/ee/deployment/deployment-hybrid-2.png)

For more information, check out the following links:
* [Hybrid Mode Overview](/enterprise/{{page.kong_version}}/deployment/hybrid-mode/)
* [Deploying Kong Enterprise in Hybrid Mode](/enterprise/{{page.kong_version}}/deployment/hybrid-mode-setup)

### Developer Portal Application Registration with External IDP Support

Authentication is decoupled from the Application Registration plugin, and support is added for third-party OAuth providers. Developers now have the flexibility to choose from either Kong or a third-party identity provider (IdP) as the system of record for application credentials. With third-party OAuth support, developers can centralize application credential management with the supported IdP of their choice.

For more information, see:
* [Application Registration](/enterprise/{{page.kong_version}}/developer-portal/administration/application-registration/)
* [Application Registration Plugin](/hub/kong-inc/application-registration/)

### Developer Portal Markdown Support

The Developer Portal now supports GitHub Markdown as an alternative to Developer Portal templates. To use the feature, create a markdown file and call the new markdown layout module. You can use the default CSS or customize it for more control over the Dev Portal skin.

For more information, see the [Developer Portal Markdown](/enterprise/{{page.kong_version}}/developer-portal/theme-customization/markdown-extended/) topic.

### Go Language Support for Custom Plugins

The Go Plugin Development Kit for Kong Enterprise allows users to tap into the Go ecosystem with custom plugins. The Kong Go PDK directly parallels the existing Kong PDK for Lua plugins.

For more information, see the [Go PDK](/enterprise/{{page.kong_version}}/go/) topic.

### Kong Vitals Reports

A new interface in Kong Manager lets you view usage dashboards and generate reports, with easier access to all metrics collected by Kong Vitals over a greater period of time. Use the reports feature to browse, filter, and view your metrics in a time-series generated report, and export the report as a comma-separated values (CSV) file.

For more information, see the [Vitals Overview](/enterprise/{{page.kong_version}}/vitals/overview/) and [Vitals Reports](/enterprise/{{page.kong_version}}/vitals/vitals-reports/) topics.

### Kong for Kubernetes Enterprise (K4K8s) Image Changes

For the {{site.ee_product_name}}, Kong for Kubernetes Enterprise (K4K8s) now uses the `kong-enterprise-edition` image, which works as a drop-in replacement for the `kong-enterprise-k8s` image used in earlier versions.

For more information, including instructions for switching images, see [Kong for Kubernetes Deployment Options](/enterprise/{{page.kong_version}}/deployment/kubernetes-deployment-options).

## Known Issues and Workarounds

* LDAP Authentication and LDAP Authentication Advanced plugins: When using only RBAC Token authorization, Service Directory Mapping to Kong Roles does not take effect. If you need to use CLI access with your Service Directory mapping, use the same authentication mechanism that Kong Manager uses to secure browser sessions, as defined in this workaround: [Using Service Directory Mapping on the CLI](/enterprise/2.1.x/kong-manager/authentication/ldap/#using-service-directory-mapping-on-the-cli).

* The [Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced) plugin does not support the `cluster` strategy in hybrid mode. The `redis` strategy must be used instead.

* Setting your Kong password (`Kong_Password`) using a value containing four ticks (for example, `KONG_PASSWORD="a''a'a'a'a"`) causes a Postgres syntax error on bootstrap. To work around this issue, do not use special characters in your password.

### Breaking Changes

* When performing upgrade and migration to 2.1.x, custom entities and plugins have breaking changes. See [https://docs.konghq.com/enterprise/2.1.x/deployment/upgrades/custom-changes/](https://docs.konghq.com/enterprise/2.1.x/deployment/upgrades/custom-changes/).

  * `run_on` is removed from plugins, as it has not been used for a long time but compatibility was kept in 1.x. Any plugin with `run_on` will now break because the schema no longer contains that entry. If testing custom plugins against this beta release, update the plugin's schema.lua file and remove the `run_on` field.

  * The Correlation ID (`correlation-id`) plugin has a higher priority than in CE. This is an incompatible change with CE in case `correlation-id` is configured against a Consumer.

  * The ability to share an entity between Workspaces is no longer supported. The new method requires a copy of the entity to be created in the other Workspaces.

  * The [legacy portal mode](/enterprise/2.1.x/developer-portal/legacy-migration/) is no longer supported.

## Deprecated Features

Kong Brain is deprecated and not available for use in Kong Enterprise version 2.1.4.0 and later.

## Changelog

For a complete list of features, fixes, and changes, see the Kong Enterprise [Changelog](/enterprise/changelog/) for versions 2.1.x and 2.1.0.0 (beta).
