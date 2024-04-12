---
title: Control Plane Groups
content_type: explanation
badge: enterprise
---

A control plane group is a read-only control plane that combines configuration from
its members, which are standard control planes. All of the standard control planes within a 
control plane group share the same cluster of data plane nodes. 

## Standard control planes vs groups

In a standard control plane setup, each team configures and manages their own data plane nodes.
For example, in the following diagram, Team Blue configures Control Plane Blue, which then uses a set of data plane nodes that only run Blue configuration; the same happens with Team Green.

<!--vale off-->
{% mermaid %}
flowchart LR
  A(fa:fa-users Team Blue )
  B(fa:fa-users Team Green)
  C(Control plane Blue
  #40;standard group#41;)
  D(Control plane Green
  #40;standard group#41;)
  E(fa:fa-layer-group Data plane nodes)
  F(fa:fa-layer-group Data plane nodes)


  A -- deck gateway sync --> C
  B -- deck gateway sync --> D
  subgraph id1 ["`**KONNECT ORG**`"]
  C
  D
  end
  C --Get config from 
  control plane Blue--> E
  D --Get config from 
  control plane Green--> F
  subgraph id2 [Data centers]
  E
  F
  end
  
  style A stroke:none,fill:#286FEB,color:#fff
  style B stroke:none,fill:#11A06B,color:#fff
  style C stroke:none,fill:#286FEB,color:#fff
  style D stroke:none,fill:#11A06B,color:#fff
  style E stroke:#286FEB
  style F stroke:#11A06B
  linkStyle 0,2 stroke:#286FEB
  linkStyle 1,3 stroke:#11A06B
  style id1 rx:10,ry:10,stroke:#a2afb7,stroke-dasharray:3
  style id2 rx:10,ry:10,stroke:#a2afb7,stroke-dasharray:3
{% endmermaid %}
<!--vale on-->

> _**Figure 1:** Standard control plane workflow_

In a control plane group setup, each team still administers their own control plane, but the data plane nodes are shared. 

The following diagram illustrates using a control plane group for a federated platform administrator model. In this example, Team Blue configures Control Plane Blue, which is then combined with the configuration from Team Green. In addition, the control plane group contains Control Plane Green, which is managed by a central platform team. The central team provides global plugin configuration, which is added to any configuration that teams Blue and Green provide.

The data plane nodes in the cluster use the combined configuration from all three groups.

<!--vale off-->
{% mermaid %}
flowchart LR
  A(fa:fa-users Team Blue)
  B(fa:fa-users Team Green)
  C(Control plane Blue
  #40;standard group#41;)
  D(Control plane Purple
    global config
    #40;standard group#41;)
  E(Control plane Green
   #40;standard group#41;)
  F(fa:fa-layer-group Data plane nodes)
  G(fa:fa-layer-group Data plane nodes)

  A -- deck gateway sync --> C
  B -- deck gateway sync --> E

  subgraph id1 ["`**KONNECT ORG**`"]
    subgraph id2 [<br>Control plane group Steel]
    C
    D
    E
    end
  end

  id2 -- Get config from 
  control plane group
  Steel--> F & G

  subgraph id3 [Data centers]
  F
  G
  end

  style A stroke:none,fill:#286FEB,color:#fff
  style B stroke:none,fill:#11A06B,color:#fff
  style C stroke:none,fill:#286FEB,color:#fff
  style D stroke:none,fill:#5F43E9,color:#fff
  style E stroke:none,fill:#11A06B,color:#fff
  style F stroke:#a2afb7
  style G stroke:#a2afb7
  linkStyle 0 stroke:#286FEB
  linkStyle 1 stroke:#11A06B
  style id1 rx:10,ry:10,stroke:#a2afb7,stroke-dasharray:3
  style id2 rx:10,ry:10,stroke:none,fill:#dae3f2
  style id3 rx:10,ry:10,stroke:#a2afb7,stroke-dasharray:3
{% endmermaid %}
<!--vale on-->

> _**Figure 2:** Control plane group workflow_

A control plane group can contain up to 256 control planes. 
You can add or remove up to 50 member control planes at a time.

Each standard control plane can be a member of no more than 5 control plane groups.

## Data plane nodes

In a control plane group, the combined configuration from all member control planes is pushed to each data plane node.

A data plane node can only connect to a single control plane in a cluster.
This means that in a control plane group, all data plane nodes must be managed from the control plane group itself. 
Members of a control plane group can't have their own data plane nodes. 

When adding a standard control plane to a group, make sure it has no connected data plane nodes.

The data plane nodes of a control plane group are not visible to a member control plane.

## Configuring core entities

There are some special cases and behaviors to note for core entities in a control plane group.

All entities in a control plane group must have unique names and IDs. 
For example, if two members of a control plane group both have a service named `example_service`, 
it will cause a [conflict](/konnect/gateway-manager/control-plane-groups/conflicts/) which must be resolved to restore function.

A number of Kong entities can be associated with another Kong entity.
Based on the type of association, the behavior of these associated entities in a control plane group follows one of these patterns:
* If the entity relationship is referenced by ID, associations remain constrained to the behavior of the individual control plane.
* If the entity relationship is referenced by a string, then associations across one or more member control planes are possible.

Entity | Associated Entity | Type of Association
-------|-------------------|--------------------
Service | Route | By ID
Upstream | Target | By ID
Certificate | SNI | By ID
Consumer | Credential | By ID
Consumer | Consumer group | By ID
Consumer | ACL group | By string
Consumer groups | Plugin | By string
Plugin (Non-Global) | Service, route, consumer | By ID
Global plugin | Control plane | By control plane
Key | Key set | By ID
Vault | Control plane| By control plane
deGraphQL route | Service | By ID
GraphQL Rate Limiting cost decoration | Service | By ID

The {{site.base_gateway}} resource associated with an entity must be part of the same standard control plane as the entity.

Entity-specific behavior exceptions:
* **Consumers**: A consumer of a standard control plane becomes a consumer of the control plane group once the originating 
control plane becomes a member of the control plane group.
The authentication credentials of a consumer in a standard control plane become valid credentials of the control plane group.
The ID of a consumer from one control plane group member can't be used in authorization for another control plane group member.

* **Consumer groups**: Only consumers from the same control plane can be added to a consumer group.
Consumer group names in the Rate Limiting Advanced plugin can reference group names from other control plane group members.

* **Vaults**: The prefix of each Vault must be unique.
Once a Vault from a standard control plane becomes part of a control plane group, it becomes available to the whole control plane group.
An entity field in a standard control plane can successfully reference a secret in a Vault from another standard control plane, now both part of the control plane group.

* **Global plugins**: A plugin that is globally scoped in the standard control plane remains globally scoped in the control plane group. 
This plugin will affect the entire control plane group.
For example, two instances of the Rate Limiting plugin cannot be installed in the control plane group.

{:.note}
> **Note:** If you want to limit which users can apply global plugins, add all global plugins into a single control plane, and then grant access to only your limited set of users. If any other member control planes add a global plugin to their configuration, a conflict will result and prevent the changed configuration from being applied.

## Limitations

A control plane group composition will be applied even if the configurations of the standard control planes are not combined successfully. 
This means that even if there is some conflict and the member control planes weren't merged successfully, a control plane group still gets created.

Control plane groups are read-only (with some exceptions), so configuration modifications must be made via a member control plane. 

The following are exceptions to the read-only rule:
* A data plane node client certificate can be generated in the UI or uploaded to a control plane group.
* Data plane nodes can be connected to a control plane group, however, members of a control plane group cannot have any data plane nodes connected to them.

{{site.kic_product_name}} control planes can't be part of a control plane group.

One control plane group cannot be a member of another control plane group. 


Conflict detection in a control plane group happens only after you have added a data plane node to the control plane group.
## More information
* [Set up and manage control planes](/konnect/gateway-manager/control-plane-groups/how-to/)
* [Migrate configuration into a control plane group](/konnect/gateway-manager/control-plane-groups/migrate/)
* [Conflicts in control planes](/konnect/gateway-manager/control-plane-groups/conflicts/)
* [Troubleshooting data planes](/konnect/gatway-manager/troubleshooting/)
