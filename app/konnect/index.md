---
title: Kong Konnect Cloud
subtitle: Kong's hosted control plane
no_version: true
---

{{site.konnect_short_name}} lets you manage multiple runtimes from a
single, cloud-based control plane, giving you an overview of all deployed
services. You can deploy the runtimes in different environments, data
centers, geographies, or zones without needing a local clustered database for
each runtime group.

## Konnect modules

### Runtime Manager

The [Runtime Manager](/konnect/runtime-manager) enables provisioning instances
of {{site.konnect_short_name}}’s supported runtimes. It lets you catalogue,
connect to, and monitor the status of all runtime groups and instances in one
place, as well as manage group configuration.

* Manage runtime groups
* Import Kong Gateway configuration into a runtime group
* Set up a runtime instance with Docker, Linux, or Kubernetes (Helm)

### Service Hub

The [Service Hub](/konnect/servicehub) enables the cataloging of all services into a single system of record. This catalog represents the single source of truth for your organization’s service inventory and their dependencies. By leveraging Service Hub, application developers can search, discover, and consume existing services to accelerate their time-to-market, while enabling a more consistent end-user experience across the organization’s applications.

* Manage services
* Manage plugins
* Publish documents from the Service Hub to the Dev Portal

### Dev Portal

[Dev Portal](/konnect/dev-portal) enables the formal publishing of API docs to an API catalogue through which developers (typically external to an application team) can discover and formally register to use the API.

* Customize your Dev Portal
* Publish a service to the Dev Portal
* Manage developer access
* Set up application registration
* Register an application to a service

### Monitoring and analytics in Konnect

Use [Konnect reports](/konnect/dev-portal) to capture service, route, and application usage and health monitoring data. You can enhance these monitoring and analytics capabilities with {{site.konnect_short_name}} plugins that enable monitoring metrics to be streamed to third-party analytics providers such as Datadog and Prometheus.

* Generate custom reports
* Export usage data from Service Hub

### Teams and roles

To help secure and govern your environment, {{site.konnect_short_name}} provides
the ability to manage authorization with [teams and roles](/konnect/org-management/teams-and-roles).
You can use {{site.konnect_short_name}}'s
predefined teams for a standard set of roles, or create custom teams with
any roles you choose. Invite users and add them to these teams to manage user
access.

* Assign users to a team
* Create custom teams

## Architecture

The {{site.konnect_product_name}} platform provides a cloud control plane (CP),
which manages all service configurations. It propagates those configurations to
all runtime nodes, which use in-memory storage. These nodes can be installed
anywhere, on-premise or in the cloud.

![Konnect Cloud](/assets/images/docs/konnect/konnect-intro.png)

> Figure 1: Diagram of Konnect modules.

Runtime instances, acting as data planes, listen for traffic on the proxy port 443
by default. The {{site.konnect_short_name}} data plane evaluates
incoming client API requests and routes them to the appropriate backend APIs.
While routing requests and providing responses, policies can be applied with
plugins as necessary.

For example, before routing a request, the client might be required to
authenticate. This delivers several benefits, including:

* The Service doesn’t need its own authentication logic since the data plane is
handling authentication.
* The Service only receives valid requests and therefore cycles are not wasted
processing invalid requests.
* All requests are logged for central visibility of traffic.

## License management

When you create a {{site.konnect_saas}} account, a license is
automatically provisioned to the organization. You do not need to manage this
license manually.

Any runtimes configured through the [Runtime Manager](/konnect/configure/runtime-manager)
also implicitly receive the same license from {{site.konnect_saas}}
control plane. You should never have to deal with a license
directly.

For any license questions, contact your sales representative.
