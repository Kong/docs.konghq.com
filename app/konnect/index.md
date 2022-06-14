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

{:.note}
> This documentation is for the {{site.konnect_short_name}} environment at
[cloud.konghq.com](https://cloud.konghq.com). For the old
[konnect.konghq.com](https://konnect.konghq.com) environment, see the
[legacy {{site.konnect_short_name}} documentation](/konnect/legacy).

## {{site.konnect_short_name}} modules

### Service Hub

The [Service Hub](/konnect/servicehub) enables the cataloging of all services
into a single system of record. This catalog represents the single source of
truth for your organization’s service inventory and their dependencies. By
leveraging Service Hub, application developers can search, discover, and consume
existing services to accelerate their time-to-market, while enabling a more
consistent end-user experience across the organization’s applications.

[Start cataloging services with Service Hub &rarr;](/konnect/servicehub)

### Runtime Manager

The [Runtime Manager](/konnect/runtime-manager) enables provisioning instances
of {{site.konnect_short_name}}’s supported runtimes. It lets you catalogue,
connect to, and monitor the status of all runtime groups and instances in one
place, as well as manage group configuration.

[Learn more about the Runtime Manager &rarr;](/konnect/runtime-manager)

### Dev Portal

[Dev Portal](/konnect/dev-portal) enables the formal publishing of API docs to
an API catalog through which developers (typically external to an application team)
can discover and formally register to use the API.

[Learn more about the Dev Portal &rarr;](/konnect/dev-portal)

### Monitoring and analytics in {{site.konnect_short_name}}

Use [{{site.konnect_short_name}} reports](/konnect/vitals) to capture service, route, and
application usage and health monitoring data. You can enhance these monitoring
and analytics capabilities with {{site.konnect_short_name}} plugins that enable
monitoring metrics to be streamed to third-party analytics providers such as
Datadog and Prometheus.

[Learn more about monitoring and analytics &rarr;](/konnect/vitals)

### Teams and roles

To help secure and govern your environment, {{site.konnect_short_name}} provides
the ability to manage authorization with [teams and roles](/konnect/org-management/teams-and-roles).
You can use {{site.konnect_short_name}}'s
predefined teams for a standard set of roles, or create custom teams with
any roles you choose. Invite users and add them to these teams to manage user
access.

[Learn more about team and user administration &rarr;](/konnect/org-management/teams-and-roles)
