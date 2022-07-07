---
title: Kong Konnect Cloud
subtitle: The SaaS API Platform
no_version: true
---

{{site.konnect_short_name}} is an API lifecycle 
management platform designed from the ground up for the cloud native era 
and delivered as a service. This platform lets you build modern applications 
better, faster, and more securely. The management plane is hosted 
in the cloud by Kong, while the runtime engine, {{site.base_gateway}} — Kong's 
lightweight, fast, and flexible API gateway  — is managed by you within your 
preferred network environment. 

{{site.konnect_short_name}} helps simplify multi-cloud API management by:

* Offering a single management plane to deploy and manage your APIs and microservices in any environment: cloud, on-premises, Kubernetes, and virtual machines. 
 
* Instantly applying authentication, API security, and traffic control policies consistently across all your services using powerful enterprise and community plugins.

* Providing a real-time, centralized view of all your services. Monitor golden signals such as error rate and latency for each service and route to gain deep insights into your API products.


{:.note}
> This documentation is for the {{site.konnect_short_name}} environment at
[cloud.konghq.com](https://cloud.konghq.com). For the old
[konnect.konghq.com](https://konnect.konghq.com) environment, see the
[legacy {{site.konnect_short_name}} documentation](/konnect/legacy).

## {{site.konnect_short_name}} modules

### Service Hub

[Service Hub](/konnect/servicehub) makes internal APIs discoverable, 
consumable, and reusable for internal development teams. Catalog
all your services through the Service Hub to create a single source of 
truth for your organization’s service inventory. By leveraging Service Hub, 
your application developers 
can search, discover, and consume existing services to accelerate their 
time-to-market, while enabling a more consistent end-user experience
across the organization’s applications.

[Start cataloging services with Service Hub &rarr;](/konnect/servicehub)

### Runtime Manager

[Runtime Manager](/konnect/runtime-manager) empowers your teams to securely
collaborate and manage their own set of runtimes and services without 
the risk of impacting other teams and projects. Runtime Manager instantly
provisions hosted {{site.base_gateway}} control planes and supports securely
attaching {{site.base_gateway}} data planes from your cloud or hybrid environments.

Through the Runtime Manager, increase the security of your APIs with out-of-the-box enterprise and community plugins, including OpenID Connect, Open Policy Agent, Mutual TLS, and more.

[Learn more about the Runtime Manager &rarr;](/konnect/runtime-manager)

[Check out {{site.konnect_short_name}}-compatible plugins &rarr;](/hub)

### Dev Portal

Streamline developer onboarding with the [Dev Portal](/konnect/dev-portal), which offers a self-service developer experience
to discover, register, and consume published services from your Service Hub catalog.
This customizable experience can be used to match your own unique branding and
highlights the documentation and interactive API specifications of your services.
Enable application registration to automatically secure your APIs with a
 variety of authorization providers.

[Learn more about the Dev Portal &rarr;](/konnect/dev-portal)

### Monitoring and analytics in {{site.konnect_short_name}}

Use [Vitals](/konnect/vitals) to gain deep insights
into service, route, and application usage and health monitoring data. Keep your finger
on the pulse of the health of your API products with custom reports and contextual dashboards.
In addition, you can enhance the native monitoring and analytics capabilities with
Gateway plugins that enable streaming monitoring metrics to
third-party analytics providers, such as Datadog and Prometheus.

[Learn more about monitoring and analytics &rarr;](/konnect/vitals)

### Teams and roles

To help secure and govern your environment, {{site.konnect_short_name}} provides
the ability to manage authorization with [teams and roles](/konnect/org-management/teams-and-roles).
You can use {{site.konnect_short_name}}'s predefined teams for a standard set of roles,
or create custom teams with any roles you choose. Invite users and add them to these teams to manage user
access. You can also map groups from your existing identity provider into {{site.konnect_short_name}} teams.

[Learn more about team and user administration &rarr;](/konnect/org-management/teams-and-roles)
