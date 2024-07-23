---
title: Migrating from Self-Managed Kong Gateway to Konnect
---

As a {{site.base_gateway}} user, you can directly migrate to {{site.konnect_short_name}}, as {{site.konnect_short_name}} uses {{site.base_gateway}} in its foundation. 

{{site.base_gateway}} deployments come in a wide variety of environments and topologies.
{{site.konnect_short_name}} runs in a topology very similar to hybrid mode, so migration from a self-managed Gateway hybrid deployment is the most straightforward. For this reason, this guide focuses on migrating a [hybrid](/gateway/latest/production/deployment-topologies/hybrid-mode/) 
or [traditional](/gateway/latest/production/deployment-topologies/traditional/)
deployment to {{site.konnect_short_name}}.

## Why migrate to {{site.konnect_short_name}}?

As organizations grow and scale, they gain the need for more advanced capabilities while lowering 
operational complexity. This includes features such as strong [multi-tenancy](https://konghq.com/blog/enterprise/multi-tenancy), 
federated API management, advanced security integrations, and others. With {{site.konnect_short_name}}, 
you gain access to a full featured API management platform which provides managed components and 
builds on the lessons learned from deep customer usage of {{site.base_gateway}} and API management best practices. 

At its core, migration to {{site.konnect_short_name}} is mostly a straightforward export and migration of proxy configuration. Depending on your environment, you may also need to move over:
* Dev Portal files, developer accounts, and applications
* Application registrations
* Convert RBAC roles and permissions into {{site.konnect_short_name}} teams
* Certificates
* Custom plugins


## Migration guide

This guide provides key details for completing a successful migration from a self-managed {{site.base_gateway}} to
{{site.konnect_short_name}}. It focuses on migrating a [hybrid](/gateway/latest/production/deployment-topologies/hybrid-mode/) 
or [traditional](/gateway/latest/production/deployment-topologies/traditional/) deployment to {{site.konnect_short_name}}.

<!--vale off-->
{% mermaid %}
flowchart TD
A{Which deployment 
topology are you 
starting with?}
B(Traditional)
C(Hybrid)
D(KIC)
E(DB-less)

A-->B & C & D & E

B & C --> F["Migrate to Konnect
(use this guide)"]
E --> H["Migrate to hybrid mode
(reach out to support for help)"] --> F
D --> G[<a href="/konnect/gateway-manager/kic/">Link your KIC deployment to a
KIC-based control plane</a>]
{% endmermaid %}
<!--vale on-->

> **Figure 1**: For traditional and hybrid deployments, you can migrate directly to {{site.konnect_short_name}} by following this guide. For DB-less deployments, migrate to hybrid first, then follow this guide. For KIC deployments, migrate to a KIC-based control plane.
### Role Based Access Controls (RBAC)

Both {{site.base_gateway}} and {{site.konnect_product_name}} provide frameworks for controlling security and
data access. 

{{site.base_gateway}} provides a traditional Role Based Access Control (RBAC) system
to manage administrators and users of the API gateway system. {{site.konnect_product_name}} provides a robust 
multi-layer Identity and Access Management (IAM) system including organizations, teams, and roles. 
{{site.konnect_product_name}} also provides integrations with IdP providers via OIDC, allowing you to map centrally managed teams to 
{{site.konnect_product_name}}-based roles.

{{site.base_gateway}}'s RBAC system does not map directly to the IAM system provided by {{site.konnect_product_name}}. 
When migrating from a self-managed {{site.base_gateway}} to {{site.konnect_short_name}}, 
we recommend using {{site.konnect_short_name}}'s IdP integrations. 
You can take advantage of your existing IdP solution and {{site.konnect_short_name}}'s 
team-based mappings instead of migrating your self-managed {{site.base_gateway}} 
RBAC configuration directly.

The following are the general steps for setting up IAM in {{site.konnect_product_name}} for your migration:

1. [Sign up](https://konghq.com/products/kong-konnect/register?utm_medium=referral&utm_source=docs) for 
  {{site.konnect_short_name}} (if necessary), and use the [Org Switcher](/konnect/org-management/org-switcher/) 
  to create or select the organization you are going to migrate your self-managed deployment to. 
2. [Set up single sign-on (SSO) access to {{site.konnect_short_name}} using an existing IdP provider](/konnect/org-management/oidc-idp/)
3. [Create teams](/konnect/org-management/teams-and-roles/manage/) in {{site.konnect_short_name}} or use 
  [predefined teams](/konnect/org-management/teams-and-roles/teams-reference/) to create your desired organizational structure.
4. For any custom teams, [assign the appropriate roles](/konnect/org-management/teams-and-roles/manage/#edit-roles-for-a-team) 
  from the predefined list of available roles in {{site.konnect_short_name}}.
5. Use the {{site.konnect_short_name}} IdP Team Mappings feature to 
  [map the{ {site.konnect_short_name}} teams to your IdP provider groups](/konnect/org-management/okta-idp/#map-konnect-teams-to-okta-groups).

### Migrating from workspaces to control planes

{{site.base_gateway}} supports configuration isolation using
[workspaces](/gateway/latest/kong-enterprise/workspaces/).
{{site.konnect_product_name}}'s model is more advanced and uses
[control planes](/konnect/gateway-manager/#control-planes) which are managed, virtual, and lightweight
components used to isolate configuration. 

When migrating to {{site.konnect_product_name}}, you will create a control plane design that 
best fits your goals, which may or may not mirror the number of workspaces you
use in your self-managed deployment.

#### Control plane design

If you currently use a single workspace in your self-managed installation,
you can simply create a matching control plane with the same name. Alternatively, 
you can choose to take the opportunity to re-organize your single workspace configuration 
into multiple control planes if there is a clear separation of concerns in your gateway configuration.

If you're using multiple workspaces in your self-managed installation, the most straightforward
approach is to create a control plane for each workspace, but you may choose to reorganize your 
design during the migration.

#### Multi-tenancy

{{site.base_gateway}} workspaces provide a way to share runtime infrastructure across isolated configurations.
With {{site.konnect_product_name}}, this is achieved using 
[control plane groups](/konnect/gateway-manager/control-plane-groups/). Control planes can be added to
and removed from control plane groups, and you can set them up to mirror your existing multi-tenant workspace configuration. 

With control plane groups set up, you can connect data plane instances to each group, creating
a shared data plane infrastructure among the constituent control planes.

#### Control plane management 

You can manage control planes and control plane groups in {{site.konnect_product_name}} by using the [Konnect UI](/konnect/gateway-manager/), the
[Konnect Control Planes API](/konnect/api/control-planes/latest/), or the 
[{{site.konnect_product_name}} Terraform Provider](https://registry.terraform.io/providers/Kong/konnect/latest).

#### Example workspace migration

The following provides an example set of steps for migrating a small multi-workspace setup to 
{{site.konnect_product_name}}.

{:.note}
> **Note**: Instructions on this page are not step-by-step guides. They are meant to illustrate the general steps 
you can perform to migrate workspaces. The examples use [decK](/deck/latest/) and some well known command-line tools for 
querying APIs and manipulating text output. See the [jq](https://jqlang.github.io/jq/) and [yq](https://github.com/mikefarah/yq) 
tool pages for more information.

Query the [Admin API](/gateway/latest/admin-api/) of your self-managed installation to get 
a list of workspaces for a particular {{site.base_gateway}} deployment:

```sh
curl -s localhost:8001/workspaces | jq -r '.data.[].name'
```

You will receive a response with a name for each workspace:

```text
default
inventory
sales
```

In this example, the self-managed installation has three total workspaces: the `default` workspace, `inventory`, and `sales`. 

{:.note}
> **Note**: {{site.base_gateway}} provides a `default` workspace, and similarly {{site.konnect_product_name}} provides a 
`default` control plane. Neither of these can be deleted, so migrating the `default` workspace to the `default` control plane 
is a logical choice.

Create a new control plane for each non-default workspace:

```sh
curl -s -H "Authorization: Bearer ${KONNECT_PAT}" \
  --request POST \
  --url https://us.api.konghq.com/v2/control-planes \
  --header 'Content-Type: application/json' \
  --header 'accept: application/json' \
  --data '{"name":"inventory","description":"CP for the Inventory team.","cluster_type":"CLUSTER_TYPE_CONTROL_PLANE"}'
```

```sh
curl -s -H "Authorization: Bearer ${KONNECT_PAT}" \
  --request POST \
  --url https://us.api.konghq.com/v2/control-planes \
  --header 'Content-Type: application/json' \
  --header 'accept: application/json' \
  --data '{"name":"sales","description":"CP for the Sales team.","cluster_type":"CLUSTER_TYPE_CONTROL_PLANE"}'
```

Login into the Konnect UI and validate the new Control Planes.

### Plugin migration

{{site.konnect_short_name}} supports the majority of plugins available to {{site.base_gateway}}. Since {{site.konnect_short_name}} runs in hybrid mode, this limits support for plugins that require direct access
to a database. 

{:.note}
> **Note**: {{site.konnect_short_name}} also provides Dedicated Cloud Gateways, which 
further limit plugins that require specialized software agents running on the data plane hosts. 

To migrate plugins from a self-managed deployment to {{site.konnect_short_name}}, review 
[Konnect Compatibility page](/konnect/compatibility/) to check for supported and unsupported plugins.
Also review any plugin configuration values, as certain values are unsupported in {{site.konnect_short_name}} and may require additional
changes to your configuration.

### Custom plugins

{{site.konnect_short_name}} supports custom plugins with similar restrictions to pre-built plugins. Since {{site.konnect_short_name}} runs in a hybrid deployment mode, custom plugins can't access a database directly
and can't provide custom Admin API endpoints. See the {{site.konnect_short_name}} documentation for more details
on [custom plugin support](/konnect/gateway-manager/plugins/#custom-plugins) requirements.

Migrating custom plugins to {{site.konnect_short_name}} requires uploading and associating your custom plugin's `schema.lua` file to 
the desired control plane. This can be done using the 
[Konnect UI](/konnect/gateway-manager/plugins/add-custom-plugin/) or the 
[Konnect Control Planes Config API](/konnect/api/control-plane-configuration/latest/#/Custom%20Plugin%20Schemas/list-plugin-schemas).

Just like in self-managed deployments, the custom plugin code must be distributed to the data plane instances.

{:.note}
> **Note**: {{site.konnect_short_name}}'s Dedicated Cloud Gateways can support custom plugins
but currently require a manual deployment process involving {{site.base_gateway}}'s support team. 
Contact your Kong representative for more information.

### {{site.base_gateway}} configuration

We recommend migrating {{site.base_gateway}} configuration to {{site.konnect_product_name}} 
using [decK](/deck/latest/guides/konnect/), the declarative management tool for {{site.base_gateway}}
configurations.

The general process for migrating the configuration involves "dumping" your existing  self-managed configuration
to a local file, modifying the configuration slightly to remove any workspace-specific metadata,
and then synchronizing the configuration to your desired control plane in {{site.konnect_short_name}}.

Continuing the example from earlier, use `deck` to dump the configuration of each workspace to a local file:

```sh
deck gateway dump --workspace default --output-file default.yaml
deck gateway dump --workspace inventory --output-file inventory.yaml
deck gateway dump --workspace sales --output-file sales.yaml
```

When using `deck` to dump the configuration, the output file will include the workspace name in the configuration.
To remove the `_workspace` key from the configuration, you can use the `yq` tool:

```sh
yq -i 'del(._workspace)' default.yaml
yq -i 'del(._workspace)' inventory.yaml
yq -i 'del(._workspace)' sales.yaml 
```

Synchronize the configuration to the control planes using decK configured with the 
proper control plane name and the {{site.konnect_short_name}} access token:

```sh
deck gateway sync --konnect-token "${KONNECT_PAT}" --konnect-control-plane-name default default.yaml
deck gateway sync --konnect-token "${KONNECT_PAT}" --konnect-control-plane-name inventory inventory.yaml
deck gateway sync --konnect-token "${KONNECT_PAT}" --konnect-control-plane-name sales sales.yaml
```

In addition to decK, {{site.konnect_short_name}} provides
other tools that could be used for migrating your configuration. Each tool requires a different process. See their documentation for more information:

* [Konnect Control Planes Config API](/konnect/api/control-plane-configuration/latest/)
* [{{site.konnect_product_name}} Terraform Provider](/konnect/reference/terraform/)

### Data planes

The recommended approach for migrating your data plane instances to {{site.konnect_product_name}} is to
create new data plane instances connected to your control plane, validate their configuration and connectivity,
and then decommission the self-managed data plane instances.

The {{site.konnect_product_name}} documentation provides details on 
[{{site.base_gateway}} installation options](/konnect/gateway-manager/data-plane-nodes/). The easiest
way to deploy new data planes is using the {{site.konnect_short_name}} Gateway Manager, which provides integrated 
launchers for popular operating systems and compute platforms. 

### APIOps

In {{site.konnect_short_name}}, there are additional options for managing the API deployment lifecycle, as compared to {{site.base_gateway}}.

* **decK**: If you're using [deck](/deck/latest) to manage your {{site.base_gateway}} configuration, you can continue to use
the tool to managing your {{site.konnect_product_name}} configuration. The decK CLI 
[supports {{site.konnect_short_name}} control plane configuration](/deck/latest/guides/konnect/)
by providing additional flags that configure the tool to connect to a particular control plane using access tokens.

* **Terraform**: Kong provides a Terraform provider for managing a full {{site.konnect_short_name}} deployment, 
including control planes, control plane groups, data plane configuration, and more. The 
[{{site.konnect_short_name}} Terraform Provider](/konnect/reference/terraform/) can be used independently
or in conjunction with decK to manage your API deployment lifecycle.

* **{{site.kgo_product_name}}**:  The [{{site.kgo_product_name}} (KGO)](/gateway-operator/latest/) is available for teams 
that want to use standardized Kubernetes APIs to manage their {{site.konnect_short_name}} deployments.

## Next steps

If you are interested in assistance with migrating from a self-managed {{site.base_gateway}} to 
{{site.konnect_short_name}}, contact a Kong field representative.

### Additional migration information

<div class="docs-grid-install max-4" >

  <a href="/konnect/api-products/service-documentation/" class="docs-grid-install-block no-description" style="min-height:150px">
    <img class="install-icon no-image-expand" src="/assets/images/icons/brand-icons/icn-upload.svg" alt="">
    <div class="install-text">Migrate API specs and markdown service descriptions</div>
  </a>

  <a href="/konnect/dev-portal/dev-reg/" class="docs-grid-install-block no-description" style="min-height:150px">
    <img class="install-icon no-image-expand" src="/assets/images/icons/brand-icons/icn-customers.svg" alt="">
    <div class="install-text">Create Dev Portal accounts for developers</div>
  </a>

  <a href="/konnect/gateway-manager/plugins/#custom-plugins" class="docs-grid-install-block no-description" style="min-height:150px">
    <img class="install-icon no-image-expand" src="/assets/images/icons/brand-icons/icn-extensibility.svg" alt="">
    <div class="install-text">Prepare custom plugins for migration</div>
  </a>

  <a href="/konnect/org-management/teams-and-roles/" class="docs-grid-install-block no-description" style="min-height:150px">
    <img class="install-icon no-image-expand" src="/assets/images/icons/brand-icons/icn-teams.svg" alt="">
    <div class="install-text">Review and set up teams and roles</div>
  </a>

</div>

### Other {{site.konnect_short_name}} use cases

<div class="docs-grid-install max-3">

  <a href="/hub/kong-inc/key-auth/how-to/basic-example/?tab=konnect-api" class="docs-grid-install-block no-description" style="min-height:150px">
    <img class="install-icon no-image-expand" src="/assets/images/icons/brand-icons/icn-key-auth.png" alt="" style="max-height:50px">
    <div class="install-text">Protect my APIs with key authentication</div>
  </a>

  <a href="/hub/kong-inc/rate-limiting/?tab=konnect-api" class="docs-grid-install-block no-description" style="min-height:150px">
    <img class="install-icon no-image-expand" src="/assets/images/icons/brand-icons/icn-rl.png" alt="" style="max-height:50px">
    <div class="install-text">Rate limit my APIs</div>
  </a>

  <a href="/konnect/dev-portal/applications/enable-app-reg/" class="docs-grid-install-block no-description" style="min-height:150px">
    <img class="install-icon no-image-expand" src="/assets/images/icons/brand-icons/icn-operation.svg" alt="">
    <div class="install-text">Make my APIs available to customers</div>
  </a>

</div>


