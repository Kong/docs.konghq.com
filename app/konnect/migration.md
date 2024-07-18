---
title: Migrating from Kong Gateway On-Premises to Kong Konnect
---

The success of {{site.base_gateway}} can be attributed to its flexible deployment model, 
exceptional performance, broad extensibility, and Open Source and Enterprise licensing models.
This has resulted in a large deployment base over a variety of environments and topologies. 

As organizations grow and scale they need for more advanced capabilities while lowering 
operational complexity. Features such as strong [multi-tenancy](https://konghq.com/blog/enterprise/multi-tenancy), 
federated API management, advanced security integrations, and others. With {{site.konnect_product_name}}, 
users have access to a full featured API management platform which provides managed components and 
builds on the lessons learned from deep customer usage of {{site.base_gateway}} and API management best practices. 

This document will provide a guide for {{site.base_gateway}} users looking to migrate to {{site.konnect_product_name}}. 

## Migration Guide

The following will provide key details for completing a successful migration from {{site.base_gateway}} on-premises to 
{{site.konnect_product_name}}. This document focuses on migrating a [Hybrid](/gateway/latest/production/deployment-topologies/hybrid-mode/) 
or [Traditional](/gateway/latest/production/deployment-topologies/traditional/)
deployment to Konnect, for other deployment modes see the following:

* [{{site.kic_product_name}} (KIC)](/kubernetes-ingress-controller/latest/)
    
    If you run KIC on premises, migrating to Konnect is straightforward. 
    The [Kong Ingress Controller for Kubernetes Assocation](/konnect/gateway-manager/kic/)
    documentation provides details on linking your KIC deployment to a KIC based Control Plane
    in {{site.konnect_product_name}}.

* [DB-less mode](/gateway/latest/production/deployment-topologies/db-less-and-declarative-config/)

    If you're running a DB-less deployment and interested in migrating to Konnect, Kong recommends migrating to 
    Hybrid mode deployment to take advantage of the full capabilities of Kong Konnect. Please reach out to
    a Kong representative for assistance with this migration.

### Role Based Access Controls

Both {{site.base_gateway}} and {{site.konnect_product_name}} provide frameworks for controlling security and
data access. 

{{site.base_gateway}} provides a traditional Role Based Access Control (RBAC) system
to manage administrators and users of the API gateway system. {{site.konnect_product_name}} provides a robust 
multi-layer Identity and Access Management (IAM) system including organizations, teams and roles. 
Konnect also provides integrations with IdP providers via OIDC allowing you to map centrally managed teams to 
Konnect based roles.

{{site.base_gateway}}'s RBAC system does not map directly to the IAM system provided by {{site.konnect_product_name}}. 
Users migrating from {{site.base_gateway}} on-premises to {{site.konnect_product_name}} have typically 
chosen to use Konnect's IdP integrations and take advantage of their existing IdP solution and Konnect team 
based mappings instead migrating their {{site.base_gateway}} on-premises RBAC configuration directly.

The following are the general steps for setting up IAM in {{site.konnect_product_name}} for your migration:

* [Sign up](https://konghq.com/products/kong-konnect/register?utm_medium=referral&utm_source=docs) for 
  Konnect (if necessary), and use the [Org Switcher](/konnect/org-management/org-switcher/) 
  to create or select the Organization you are going to migrate your on-premises deployment to. 
* [Set up single sign-on (SSO) access to Konnect using an existing IdP provider](/konnect/org-management/oidc-idp/)
* [Create teams](/konnect/org-management/teams-and-roles/manage/) in Konnect or use 
  [predefined teams](/konnect/org-management/teams-and-roles/teams-reference/) to create your desired organizational structure.
* For any custom teams, [assign the appropriate roles](/konnect/org-management/teams-and-roles/manage/#edit-roles-for-a-team) 
  from the predefined list of available roles in Konnect.
* Use the Konnect IdP Team Mappings feature to 
  [map the Konnect teams to your IdP provider groups](/konnect/org-management/okta-idp/#map-konnect-teams-to-okta-groups).

### Workspaces -> Control Planes

{{site.base_gateway}} supports configuration isolation using
[Workspaces](/gateway/latest/kong-enterprise/workspaces/).
{{site.konnect_product_name}}'s model is more advanced and is solved 
using [Control Planes](/konnect/gateway-manager/#control-planes) which are managed, virtual, and lightweight
components used to isolate configuration. 

When migrating to {{site.konnect_product_name}}, you will create a Control Plane design that 
best fits your goals, which may or may not mirror the number of Workspaces you
use on-premises.

#### Control Plane Design

If you currently use a single Workspace in your on-premises installation,
you can simply create a matching Control Plane with the same name. Alternatively, 
you may choose to take the opportunity to re-organize your single Workspace configuration 
into multiple Control Planes if there is a clear separation of concerns in your gateway configuration.

If you're using multiple workspaces in your on-premises installation, the most straightforward
approach is to create a Control Plane for each workspace, but you may choose to reorganize your 
design during the migration.

#### Multi-tenancy

{{site.base_gateway}} Workspaces also provide a way to share runtime infrastructure across isolated configurations.
With {{site.konnect_product_name}}, this is achieved using 
[Control Plane Groups](/konnect/gateway-manager/control-plane-groups/). Control Planes can be added
and removed from Control Plane Groups and setup to mirror your existing mutli-tenant Workspace configuration. 
Once you have Control Plane Groups setup, you can connect data plane instances to the group creating
a share data plane infrastructure among the constituent Control Planes.

#### Control Plane Management 

Managing Control Planes and Control Plane Groups in {{site.konnect_product_name}} can be 
achieved by using the [Konnect UI](/konnect/gateway-manager/), the
[Konnect Control Planes API](/konnect/api/control-planes/latest/), or the 
[{{site.konnect_product_name}} Terraform Provider](https://registry.terraform.io/providers/Kong/konnect/latest).

#### Example Workspace Migration

The following provides an example set of steps for migrating a small multi-Workspace setup to 
{{site.konnect_product_name}}.

{:.note}
> **Note**: Instructions on this page are not step-by-step guides. They are meant to be illustrative of the general steps 
you can perform to migrate Workspaces. The examples use [decK](/deck/latest/) and some well known command line tools for 
querying APIs and manipulating text output. See the [jq](https://jqlang.github.io/jq/) and [yq](https://github.com/mikefarah/yq) 
tool pages for more information.

We can start by querying the [Admin API](/gateway/latest/admin-api/) of our on-premises installation to get 
a list of workspaces for a particular {{site.base_gateway}} installation:

```sh
curl -s localhost:8001/workspaces | jq -r '.data.[].name'
```

And we'll receive a response with a name for each Workspace:

```text
default
inventory
sales
```

Our example on-premises installation has three total workspaces: The `default` workspace, `inventory`, and `sales`. 

{:.note}
> **Note**: {{site.base_gateway}} provides a `default` Workspace, and similarly {{site.konnect_product_name}} provides a 
`default` Control Plane. Neither of these can be deleted, so migrating the `default` Workspace to the `default` Control Plane 
is a logical choice.

Create a new Control Plane for each non-default Workspace:

```txt
curl -s -H "Authorization: Bearer ${KONNECT_PAT}" \
  --request POST \
  --url https://us.api.konghq.com/v2/control-planes \
  --header 'Content-Type: application/json' \
  --header 'accept: application/json' \
  --data '{"name":"inventory","description":"CP for the Inventory team.","cluster_type":"CLUSTER_TYPE_CONTROL_PLANE"}'
```

```txt
curl -s -H "Authorization: Bearer ${KONNECT_PAT}" \
  --request POST \
  --url https://us.api.konghq.com/v2/control-planes \
  --header 'Content-Type: application/json' \
  --header 'accept: application/json' \
  --data '{"name":"sales","description":"CP for the Sales team.","cluster_type":"CLUSTER_TYPE_CONTROL_PLANE"}'
```

Login into the Konnect UI and validate the new Control Planes.

### Plugins

Konnect supports the majority of plugins available to {{site.base_gateway}}, however,
{{site.base_gateway}} is ran in Hybrid Mode which limits support for plugins that require direct access
to a database. 

{:.note}
> **Note**: Konnect also provides Dedicated Cloud Gateways which 
further limit plugins that require specialized software agents running on the dataplane hosts. 

In order to migrate plugins from on-premises to Konnect you should review 
[Konnect Compatibility page](/konnect/compatibility/) for your usage of unsupported
plugins. Additionally, review if certain configuration values are unsupported which will require additional
changes to your configuration.

### Custom Plugins

{{site.konnect_product_name}} supports custom plugins with similar restrictions to pre-built plugins. Given 
that {{site.base_gateway}} runs in a Hybrid deployment mode, custom plugins may not access a database directly
and can not provide a custom Admin API endpoint. See the Konnect documentation for more details
on [Custom Plugin support](/konnect/gateway-manager/plugins/#custom-plugins) requirements.

Migrating custom plugins to Konnect requires uploading and associating your custom plugin's `schema.lua` file to 
the desired Control Plane. This can be done using the 
[Konnect UI](/konnect/gateway-manager/plugins/add-custom-plugin/) or the 
[Konnect Control Planes Config API](/konnect/api/control-plane-configuration/latest/#/Custom%20Plugin%20Schemas/list-plugin-schemas).

Just like in on-premises deployments, the custom plugin code must be distributed to the data plane instances.

{:.note}
> **Note**: Konnect's Dedicated Cloud Gateways can support custom plugins
but currently require a manual deployment process involving {{site.base_gateway}}'s support personal. Contact your Kong representative
for more information.

### {{site.base_gateway}} Configuration

Typically the {{site.base_gateway}} configuration is migrated to {{site.konnect_product_name}} 
using [decK](/deck/latest/guides/konnect/), the declarative management tool for {{site.base_gateway}}
configurations.

The general process for migrating the configuration involves "dumping" your existing on-premises configuration
to a local file, modifying the configuration slightly to remove any workspace specific metadata,
and then synchronizing the configuration to your desired Control Plane in {{site.konnect_product_name}}.

Continuing the example from earlier, use `deck` to dump the configuration of each Workspace to a local file:

```sh
deck gateway dump --workspace default --output-file default.yaml
deck gateway dump --workspace inventory --output-file inventory.yaml
deck gateway dump --workspace sales --output-file sales.yaml
```

When using `deck` to dump the configuration, the output file will include the Workspace name in the configuration.
To remove the `_workspace` key from the configuration, you can use the `yq` tool to remove the key:

```sh
yq -i 'del(._workspace)' default.yaml
yq -i 'del(._workspace)' inventory.yaml
yq -i 'del(._workspace)' sales.yaml 
```

Synchronize the configuration to the Control Planes using decK configured with the 
proper Control Plane name and the Konnect access token:

```sh
deck gateway sync --konnect-token "${KONNECT_PAT}" --konnect-control-plane-name default default.yaml
deck gateway sync --konnect-token "${KONNECT_PAT}" --konnect-control-plane-name inventory inventory.yaml
deck gateway sync --konnect-token "${KONNECT_PAT}" --konnect-control-plane-name sales sales.yaml
```

In addition to the above process of using decK for the migration, {{site.konneect_product_name}} provides
other tools that could be used for migrating your configuration. Each tool will require a different process,
reference their documentation for more information.

* [Konnect Control Planes Config API](/konnect/api/control-plane-configuration/latest/)
* [{{site.konnect_product_name}} Terraform Provider](/konnect/reference/terraform/)

### Data planes

The recommended approach for migrating your data plane instances to {{site.konnect_product_name}} is to
create new data plane instances connected to your Control Plane, validate their configuration and connectivity,
and then decommission the on-premises data plane instances.

The {{site.konnect_product_name}} documentation provides details on 
[{{site.base_gateway}} installation options](/konnect/gateway-manager/data-plane-nodes/). The easiest
way to deploy new data planes is using the Konnect Gateway Manager, which provides integrated 
launchers for popular operating systems and compute platforms. 

### APIOps

Konnect users will find that there are additional options for managing the API deployment lifecycle on
compared to {{site.base_gateway}} on-premises. 

If you're using [deck](/deck/latest) to manage your {{site.base_gateway}} configuration, you can continue to use
the tool to managing your {{site.konnect_product_name}} configuration. The decK CLI 
[supports Konnect Control Plane configuration](/deck/latest/guides/konnect/)
by providing additional flags that configure the tool to connect to a particular Control Plane using access tokens.

Additionally, {{site.konnect_product_name}} provides a Terraform provider for managing a full Konnect deployment 
including Control Planes, Control Plane Groups, data plane configuration and more. The 
[{{site.konnect_product_name}} Terraform Provider](/konnect/reference/terraform/) can be used independently
or in conjunction with decK to manage your API deployment lifecycle.

The [{{site.kgo_product_name}}](/gateway-operator/latest/) is also available for teams 
that desire to use standardized Kubernetes APIs to manage their Konnect deployments.

## Next steps

If you are interested in assistance with migrating from {{site.base_gateway}} on-premises to 
{{site.konnect_product_name}}, please contact a Kong field representative.

