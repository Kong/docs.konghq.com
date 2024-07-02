---
title: Migrating from Kong Gateway On-Premises to Kong Konnect
---

The success of {{site.base_gateway}} can be attributed to its flexible deployment model, 
exceptional performance, broad extensibility, and Open Source and Enterprise licensing models.
This has resulted in a large deployment base over a variety of environments and topologies. 

As organizations grow and scale, they find a need for more advanced capabilities, 
such as strong multi-tenancy, federated API management, advanced security integrations, 
and more. With {{site.konnect_product_name}}, users have access to a full featured 
API management platform that builds on the lessons learned from deep customer 
usage of {{site.base_gateway}} and API management best practices.

This document will provide a guide for {{site.base_gateway}} users (Open Source or Enterprise) 
looking to migrate to {{site.konnect_product_name}}. The document reviews the design differences
between {{site.base_gateway}} on-premises vs {{site.konnect_product_name}} and provides a guide 
for planning and executing a successful migration.

## {{site.base_gateway}} - On-Premises vs. {{site.konnect_product_name}}

{{site.base_gateway}} on-premises requires users to deploy and manage various components
themselves. Depending on the chosen 
[deployment mode](/gateway/{{site.release}}/production/deployment-topologies/), a successful 
installation of {{site.base_gateway}} may require a database and one or more
gateway components. 

Alternatively, {{site.konnect_product_name}} provides fully hosted components, reducing the 
operational burden for users while providing access to a modern full API management platform.

In this section, we will break down the design differences between on-premises and 
{{site.konnect_product_name}} deployments, giving users a base understanding before planning 
a migration.

### Runtime Component Management

When deploying {{site.base_gateway}} on-premisies, users choose between 
traditional, hybrid, and db-less deployment topologies. Depending on the 
chosen topology and scale requirements, gateway components are deployed in 
various configurations and node counts.

When running {{site.base_gateway}} on Konnect, the gateway is deployed in a hybrid 
topology, meaning the Control Plane (CP) and Data Planes (DP) are separated. 

With {{site.konnect_product_name}}, users can deploy lightweight virtual CPs that can
be provisioned instantly and are fully managed by Kong.

On-premises deployments require users to self-manage Data Planes (DPs).

With Konnnect, users can choose to self-manage DPs or delegate DP
operations to Kong with fully managed Cloud Dataplanes.

### Multi-tenancy

{{site.base_gateway}} supports Workspaces. Workspaces allow for semi-isolated configurations
and adminstration via {{site.base_gateway}} RBAC capabilities. DPs share runtime processing
of Workspaces increasing operational efficiency.

{{site.konnect_product_name}} approaches multi-tenancy differently from on-premises. Konnect 
provides [Control Plane Groups](https://docs.konghq.com/konnect/gateway-manager/control-plane-groups/)
which allows for runtime multi-tenancy to support resource sharing DP deployments. 
CP Groups aggregate multiple CPs into a single configuration at runtime. 
The CPGs detect runtime conflicts and allow administrators to resolve them pre-deployment.

### Identity and Access Management 

With {{site.base_gateway}} on-prem, users have the option to manage gateway local administrators, 
users, and roles. As your organization scales, maintaining this additional set of credentials
can be challening. 

{{site.konnect_product_name}} provides a modern authentication and authorization model 
designed to scale with your organization. Konnect supports a strong integration with Identity Providers (IdP)
allowing for an easy mapping of IdP groups to Konnect teams.

Additionally, {{site.konnnect_product_name}} users can define a hierarchy of 
[organizations, teams, and roles](/konnect/org-management/auth/) that maps to their 
organization's structure. 

### Developer Portals

* Kong deprecated support for on-premises Kong Gateway developer portal support
* Konnect supports a more modern developer portal experience including support for multiple portals,
  API Products, and multi-portal support.
* Information on migrating portals is provided in the migration section below.


## Migration Planning and Execution

The following sections will provide various things to consider when migrating from 
{{site.base_gateway}} on-prem to {{site.konnect_product_name}}.

### API Delivery (APIOps)

Organizations migrating to {{site.konnect_product_name}} that do not already have a mature
API autmoation delivery process, have an opportunity to adopt best practices in API delivery.
Konnect supports multiple API driven and declarative approaches to managing the full API delivery lifecycle.

The migration process should involve the modification of your existing API delivery pipelines. In the event
that you do not currently have an APIOps delivery automation, adopting these practices during the migration
will greatly improve the overall API delivery process.

Multiple tools are available to assist in automating your API delivery:

* Kong Konnect APIs
* Kong Terraform Provider
* Kong decK 

### RBAC -> Orgs/Teams

Users migrating to Konnect are typically looking to leverage the new Orgs/Teams/Roles model 
instead of trying to model after any existing Admin/user setup in on-premises {{site.base_gateway}}.

* Generally migrating users have decided to utilize Idp integrations over migrating 
    local users and admins to fully utilize the new Konnect RBAC security model
* Konnect IdP mappings
    Konnect uses the group in the token and the mapping table to assign a team

### Configuration Migration

When migrating a configuration from {{site.base_gateway}} to {{site.konnect_product_name}} 
consider the following.

Do you have workspaces?
Yes -> Migrate each Workspace to a CP
    * 1 WS to 1 CP strategy
    * others?
No  -> Migrate the entire configuration to a single CP
    * When only using the default workspace, migrate to a single CP or look for ways to isolate 
      current configurations if desired

### Setup Audit Log

create your webhook to receive audit logs

### Deployment mode specifics

Depending on your current deployment mode, you may

#### Traditional Mode

* Create new Konnect CPs for every independent Kong Gateway installation
* You'll redeploy new DPs connecting to the Konnect CPs and decomissino the previous DPs
* Post migration and validation you will decomission the database

#### Hybrid Mode

* You'll need to migrate to the Konnect CPs
* You can re-configure the existing DPs to connect to Konnect or provision new ones and decomission the previous

#### Db-less Mode

* If you're using Db-less {{site.base_gateway}}, you are likely laready running with Kong Ingress Controller. 
* If using KIC, you can configure a read-only connection to Konnect to leverage API Management capabilities 
while retaining the existing KIC setup

#### Plugins

* Konnect supports a subset of all available plugins
* Custom plugins with DB access are not supported
* Konnect removes the runtime stateful datastore, simplifying runtime operation, but may affect some plugin capabilities
* OAuth2 for example requires a stateful datastore to persist tokens
    * Konnect provides IDP integrations OIDC which is a superior solution for operation identity managmeent over OAuth2
* List of compatible plugins ?
* List of incompatible plugins ?
    * alternatives?

### Runtime Multi-tenancy

CP Groups provide a way to share resources across multiple CPs. This is useful for 
resource optimization


### Developer Portals

Integrating wiki doc: https://konghq.atlassian.net/l/cp/Uk64sQ8j

## Layering in API Management Platform Capabilities

In addition to a fully or partially hosted {{site.base_gateway}} deployment, {{site.konnect_product_name}}
provides a full API management platform that includes additional capabilities unavailable on-premises.  API Products,
Service Catalogs, API Analytics, logging and monitoring and more... 

Post migration, these capabilities can be layered on as needed.

#### API Products

#### Service Catalog

#### Analytics

## Cloud Runtimes

Konnect provides a full managed runtime environment on top of the virtual CPs and API management features.
Allowing an organization to move to a fully managed API management platform.

Things to consider for cloud gateways...

* abc
* def
* ghi

## Migration next steps

If  you are interested in assistence with migrating from Kong Gateway to 
{{site.konnect_product_name}} , please contact a Kong field representative.

