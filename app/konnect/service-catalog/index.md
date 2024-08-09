---
title: Service catalog
subtitle: Track every service across your architecture
content-type: explanation
---

{{site.konnect_saas}}'s Service Catalog offers a comprehensive catalog of all services running in your organization, both {{site.base_gateway}} services and external services. This catalog is the single source of truth for your organization’s service inventory and their dependencies.

Specifically, Service Catalog addresses the following problems:

* **Service Discovery:** By gaining visibility into all your services, and therefore a complete and accurate understanding of your infrastructure, you can proactively eliminate any 'API Dark Matter' – the unrecognized or undiscovered APIs that live within your organization’s fragmented ecosystems. You are then able to take steps to proactively mitigate vulnerabilities caused by unused or risky interfaces.
* **Service Ownership:** Service Catalog tackles the challenge of keeping track of service ownership within your organization. The catalog holds an up-to-date mapping between teams and services. This makes it clear who owns what, as new employees join and leave your company and as new services are spun up and shut down. 
* **360 Service Visibility:** Service Catalog collects the pieces of information that are most important to understanding the general health of a service, and presents this to you in a single pane of glass. Thus, you no longer have to navigate to different tabs across different applications (i.e. GitHub, Datadog, PagerDuty, etc.) to quickly grasp your service’s recent activity and status. In addition, Service Catalog allows you to quickly identify existing services within the company that you can reuse, thereby preventing duplicative effort and unnecessary toil. <!--what pieces specifically?-->
* **Service Governance and Policy Enforcement:** Enables governance in how services are created and maintained across your company to ensure security, compliance, and engineering best practices are adhered to.

<!--diagrams here-->

## Service Catalog terminology

| Term | Definition |
| ---- | ---------- |
| Service Catalog | The canonical system of record for your organization's services in {{site.konnect_short_name}}. This includes all the interactions between them and with external APIs. |
| Service | A service is the top-level entity in the Service Catalog. It's typically defined as an independent system delivering specific capabilities and owned by a singular team in your organization. |
| Add-On | Add-Ons are application integrations, either internal {{site.konnect_short_name}} applications or external applications, that you can enable or disable within Service Catalog. When enabled, an Add-On serves one of two purposes:<ul><li>Allows you to discover new Resources and subsequently create new services based on them. For example: creating a new {{site.konnect_short_name}} service called “Billing” from a GitHub Repository called “billing-repo-public”. In this case, the Add-On is GitHub and the Resource is the GitHub Repository called “billing-repo-public”.</li><li>Allows you to add helpful contextual information to a service that already exists in your catalog. For example: binding a {{site.base_gateway}} service called “trigger-payment” to a Service Catalog service. In this case, the Add-On is “Gateway Manager” and the Resource is the “trigger-payment” {{site.base_gateway}} service.</li> |
| Resource | A Resource represents an entity discovered from an Add-On that can be mapped to any number of services. For example: a {{site.base_gateway}} or GitHub service. |

## Use cases

The following table describes various use cases for Service Catalog:

| You want to... | Then use... |
| -------------- | ----------- |
| As a Platform Owner who works at a large enterprise company, I have difficulty keeping track of my organization's services when application teams constantly spin up new services and shut down old ones. Furthermore, my organization has new employees join and old employees leave at a rate I cannot keep up with. As a result, I don’t know which teams or individuals are responsible for which services anymore.Currently, I could choose to catalog our services in Excel, Confluence, or something similar. However, these alternatives often end up incomplete or out of sync if the application teams won’t help me maintain them. | Then use... |
| As a Service Owner, whenever I detect a problem with a service that I’m responsible for, I must now jump between different tabs across different applications to triage the issue. More concretely, I must now perform a series of tasks, which may include one or more of the following: Navigate to Datadog to view logs and traces. Go to Github to view whether there were any recent pull requests. Look at PagerDuty and verify who the on-call engineer is, so that I can speak to them. Check out Gateway Manager in Konnect to look at gateway health metrics. Browse Confluence to find the document that explains which services depend on my service, so that I can notify the corresponding owners that they may have been impacted. This is a time-consuming process which hinders my ability to be productive doing actual development work. | Then use... |
| As a Platform Owner who works at a company that operates in a federated model, when a new security or compliance requirement is introduced by my leadership team, I need a structured approach to track and enforce adoption across the entire organization. Currently, my biggest pain point is that each individual team has its own unique culture, timelines, and processes. This makes my task extremely cumbersome. To illustrate, here are a few examples of security or compliance mandates that my leadership team might want to enforce across the company: Require there to be an assigned Team Owner and PagerDuty on-call engineer to every service 24/7. Require that all services backed by a Kong Gateway have the mTLS Plugin enabled. Require that all services meet the company-defined DORA metric benchmarks. Require that all services using NodeJS upgrade to the latest version of the library. | Then use... |
| As a Platform Owner, I want to establish and codify best practices on how new services are created and deployed in my organization. Currently, although these best practices may exist, they aren’t always necessarily enforced. This inconsistency results in inefficiency, since teams across the company aren’t able to leverage each other as effectively whenever problems arise. In a similar vein, as a Service Owner who recently joined a new company, I want to quickly learn best practices on how new services are created and deployed. Currently, these best practices either aren’t documented or don’t exist at all. As a result, I must spend a lot of time talking to other engineers across the company to familiarize myself with our processes. This delays my ability to quickly ramp up and begin contributing. | Then use... |
| As a Service Owner, when I have a hunch that an engineering problem I’m currently working on may have already been solved by another employee in the past, I want to view a complete list of services across the company. This would allow me to easily verify whether there exists a solution whose code I can reuse or build upon, thus preventing duplicative effort. Currently, this canonical list of services does not exist, and so my workaround is to ping several colleagues on Slack or Teams to hunt for an answer. | Then use... |

## FAQs

How do services map to API products? What is the relationship there?

Is a service an API?

## More information
* link to related resources in API products and dev portal