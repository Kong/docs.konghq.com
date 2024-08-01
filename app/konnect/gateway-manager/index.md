---
title: About Gateway Manager
---

The [Gateway Manager](https://cloud.konghq.com/gateway-manager)
is a {{site.konnect_saas}} functionality module
that lets you catalog, connect to, and monitor the status of all control planes (CP)
and data plane nodes (DPs) in one place, as well as manage control plane configuration.

The Gateway Manager overview page displays a list of
control planes currently owned by the organization. From here, you can add or
delete control planes, or go into each individual control plane to manage 
data plane nodes and their global configuration.

![gateway manager dashboard](/assets/images/products/konnect/gateway-manager/konnect-control-plane-dashboard.png)
> _**Figure 1:** Example Gateway Manager dashboard with several control planes, including the_
_default control plane, a KIC control plane, and control planes for development and production._

With {{site.konnect_short_name}} hosting the control plane, a data plane node
doesn't need a database to store configuration data. Instead, configuration
is stored in-memory on each node, and you can easily update all data plane nodes
in a control plane with a few clicks. This model applies whether the nodes are managed on-premise, in cloud-hosted environments, or through our fully managed SaaS offering with [Dedicated Cloud Gateways](/konnect/gateway-manager/dedicated-cloud-gateways).

The Gateway Manager, and the {{site.konnect_saas}} application as
a whole, does not have access or visibility into the data flowing through your
data plane nodes, and it does not store any data except the state and connection details
for each node.

## Control planes

{{site.konnect_short_name}} manages data plane configuration via control planes. 

Control planes come in three types:

* [**{{site.base_gateway}} control plane**](#kong-gateway-control-planes): 
    A collection of {{site.base_gateway}} data plane nodes sharing the same 
    configuration and behavior space. Each control plane
    manages configurations independently.

* [**Control plane group**](#control-plane-groups): 
    A type of control plane that manages central data plane nodes for multiple control planes.
    It collects configuration from its member control planes and applies the 
    aggregate config to a group of nodes. 
    
    This means that teams within a group share a cluster of {{site.base_gateway}} data 
    plane nodes, where each team has its own segregated configuration.

* [**{{site.kic_product_name}}**](/konnect/gateway-manager/kic/)
    Monitor the configuration of Kubernetes-based {{site.base_gateway}} data plane nodes.

You can find a list of all control planes in your organization
on the [Gateway Manager overview](https://cloud.konghq.com/gateway-manager/).

Access to each control plane is configurable on a team-by-team basis using
entity-specific permissions. For more information, see [Administer teams](/konnect/org-management/teams-and-roles/).

### {{site.base_gateway}} control planes

Every region in every organization starts with one default control plane.
This control plane can't be deleted, and its status as the default can't be changed.

With {{site.konnect_short_name}} you can configure additional {{site.base_gateway}}
control planes, each of which will have isolated configuration.
Use multiple control planes in one {{site.konnect_short_name}} organization to
manage data plane nodes and their configuration in any groupings you want.

Some common use cases for using multiple control planes include:

* **Environment separation:** Split environments based on their purpose, such as
development, staging, and production.
* **Region separation:** Assign each control plane to a region or group of
regions. Spin up data plane nodes in those regions for each control plane.
* **Team separation:** Dedicate each control plane to a different team and share
resources based on team purpose.
* **Resource hosting and management separation**: Run a hybrid control plane with 
self-hosted data plane nodes, and a separate Dedicated Cloud Gateway control 
plane with Kong-managed nodes.

<!--vale off-->
{% mermaid %}
flowchart TD
A(Hybrid control plane)
B(Fully-managed \n control plane)
C(<img src="/assets/images/logos/KogoBlue.svg" style="max-height:20px" class="no-image-expand"/> Self-managed \n data plane nodes \n #40;locally-hosted#41;)
D(<img src="/assets/images/logos/KogoBlue.svg" style="max-height:20px" class="no-image-expand"/> Self-managed \n data plane nodes \n #40;hosted by you in cloud provider#41;)
E(<img src="/assets/images/logos/KogoBlue.svg" style="max-height:20px" class="no-image-expand"/> Fully-managed \n data plane nodes \n #40;hosted by Kong#41;)

subgraph id1 [Konnect]
A
B
end

A --proxy configuration---> C & D
B --proxy configuration---> E

style id1 stroke-dasharray:3,rx:10,ry:10
style A stroke:none,fill:#0E44A2,color:#fff
style B stroke:none,fill:#0E44A2,color:#fff

{% endmermaid %}
<!--vale on-->

> _**Figure 2:** Example control plane group configuration for two control planes: a hybrid control plane and a fully-managed Dedicated Cloud Gateway control plane._
><br><br>
> _The hybrid control plane consists of a Kong-managed CP and self-managed DP nodes, while the Dedicated Cloud Gateway control plane consists of fully-managed CP and DP nodes. {{site.konnect_short_name}} is the SaaS-managed global management plane that manages all of the control planes, while the control planes manage configuration for data plane nodes._

#### Control plane configuration

For each control plane, you can spin up data plane nodes and configure
the following {{site.base_gateway}} entities:
* Gateway services
* Routes
* Consumers
* Consumer Groups
* Plugins
* Upstreams
* Certificates
* SNIs
* Vaults
* Keys

When there are multiple control planes, any entity configuration only
applies to the control plane that it was created in. Consumers and
their authentication mechanisms don't carry over to other control planes.

[{{site.base_gateway}} configuration in {{site.konnect_short_name}} &rarr;](/konnect/gateway-manager/configuration/)

### Control plane groups

A control plane group is a read-only control plane that combines configuration from
its members, which are standard {{site.base_gateway}} control planes. All of the members of a 
control plane group share the same cluster of data plane nodes.

The benefits of a control plane group include:
* **Shared infrastructure, individual config**: Users or organizations can share infrastructure, 
while teams still have their own standard control planes to manage individual configuration.
* **Modular clusters**: Combine standard control planes in different ways to create unique configurations
for different purposes.
* **Workspaces in the cloud**: Control plane groups function similarly to {{site.base_gateway}} workspaces, with the added benefit of a cloud control plane.

Learn more about control plane groups:
* [Intro to control plane groups](/konnect/gateway-manager/control-plane-groups/)
* [Set up and manage control plane groups](/konnect/gateway-manager/control-plane-groups/how-to/)
* [Migrate configuration into a control plane group](/konnect/gateway-manager/control-plane-groups/migrate/)
* [Conflicts in control plane groups](/konnect/gateway-manager/control-plane-groups/conflicts/)

### Control plane dashboard

For each control plane, you can view traffic, error rate, and {{site.base_gateway}} service analytics for its data plane nodes. 
This allows you to see how much of a control plane is used. You can also select the time frame of analytics that you want to display.

### Deleting a control plane

{:.warning}
> **Warning:** Deleting a control plane is irreversible. Make sure that you are
certain that you want to delete the control plane, and that all entities and data plane
nodes in the control plane the have been accounted for.

To delete a control plane, you can use the Gateway Manager or the 
{{site.konnect_short_name}} 
[Control Plane API](/konnect/api/control-planes/latest/).

When a control plane is deleted, all associated entities are also deleted.
This includes all entities configured in the Gateway Manager for this control plane.
As a best practice, [back up](/konnect/gateway-manager/backup-restore/) a 
control plane's configuration before deleting it to avoid losing necessary configuration.

Data plane nodes that are still active when the control plane is deleted will not be
terminated, but they will be orphaned. They will continue processing traffic
using the last configuration they received until they are either connected to
a new control plane or manually shut down.

You cannot delete the default control plane.

## Data plane nodes

A data plane node is a single {{site.base_gateway}} instance. 
Data plane nodes service traffic for the control plane. 

You can deploy your data plane nodes in the following ways:
* **Fully-managed**: Dedicated Cloud Gateways data plane nodes are completely managed by Kong in the cloud provider of your choice. You maintain control over the size and location of the gateway infrastructure, while Kong oversees the management of each instance and the entire cluster for you. You can use the Dedicated Cloud Gateways wizard in Gateway Manager to provision a {{site.base_gateway}} data plane node in a cloud provider.
* **Self-managed**: The data plane nodes are hosted either on your own systems or in  an external cloud provider. You can use the script in Gateway Manager to provision a {{site.base_gateway}} data plane node in a Docker container running Linux, on MacOS, or on Windows. 

The following table can help you decide which data plane node strategy to use based on your use case:

| Use case | Data plane node strategy |Solution |
| ------- | ----------- | ----------- |
| Reducing latency is important to your organization.  | [Dedicated Cloud Gateways](/konnect/gateway-manager/dedicated-cloud-gateways/) | Supports multiple regions on AWS and Azure: <br><br>- AWS regions: Sydney, Tokyo, Singapore, Frankfurt, Ireland, London, Ohio, Oregon. <br>- Azure regions: Frankfurt, Ireland, UK South, Virginia, Washington |
| Your organization operates in an industry with strict data protection and privacy requirements. |  [Dedicated Cloud Gateways](/konnect/gateway-manager/dedicated-cloud-gateways/) | Using the private gateway option, Kong provisions a private network load balancer and only exposes the IP address in the UI. |
| Your organization needs high availability with zero downtime when upgrading data plane nodes. | [Dedicated Cloud Gateways](/konnect/gateway-manager/dedicated-cloud-gateways/) | There's no downtime when upgrading your data plane nodes. Additionally, you can pre-warm your cluster by specifying the number of requests per second so that the first requests don’t have to wait for the infrastructure to scale up. |
| You have infrastructure in multiple clouds. | [Dedicated Cloud Gateways](/konnect/gateway-manager/dedicated-cloud-gateways/) | Dedicated Cloud Gateways allows you to run a multi-cloud solution that allows you to standardize API operations across the board to reduce complexity and increase agility. |
| You use a cloud provider (other than AWS) for hosting, or don't want to host in the cloud because of organizational policy. | [Self-managed](/konnect/gateway-manager/data-plane-nodes/) | You can self-manage your data plane nodes in AWS, Azure, and Google Cloud. Or, you can deploy self-managed data plane nodes in macOS, Windows, Linux (Docker), or Kubernetes. |

See the [data plane node installation options](/konnect/gateway-manager/data-plane-nodes/) for more information.

## Plugins

You can extend {{site.konnect_short_name}} by using plugins. Kong provides a set of standard Lua plugins that get bundled with {{site.konnect_short_name}}. The set of plugins you have access to depends on your installation.

Custom plugins can also be developed by the Kong Community and are supported and maintained by the plugin creators. If they are published on the Kong Plugin Hub, they are called Community or Third-Party plugins.

See the [{{site.konnect_short_name}} plugin ordering documentation](/konnect/reference/plugins/) for more information.
