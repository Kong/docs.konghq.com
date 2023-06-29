---
title: Composite Runtime Groups
content_type: explanation
badge: enterprise
---

A composite runtime group is a read-only group that combines configuration from
its members, which are standard runtime groups. All of the standard runtime groups within a 
composite runtime group share the same cluster of runtime instances. 

![Standard runtime group](/assets/images/docs/konnect/konnect-standard-rg.svg)
> _**Figure 1:** In a standard runtime group setup, each team configures and manages their own runtime instances. For example, Team Blue configures Runtime Group Blue, which then uses a set of runtime instances that only run Blue configuration._


![Composite runtime group](/assets/images/docs/konnect/konnect-composite-rg.svg)
> _**Figure 2:** In a composite runtime group setup, each team still configures their own runtime groups, but the runtime instances are shared. For example, Team Blue configures Runtime Group Blue, which is then combined with the configuration from Team Green and Team Yellow. The runtime instances in the cluster use the combined configuration._

A composite runtime group can contain up to 256 runtime groups. 
Each standard group can have up to 5 parent composite runtime groups.

## Limitations

A composite runtime group composition will be applied even if the configurations of the standard runtime groups are not combined successfully. This means that if due to some conflict the config of standard runtime groups cannot be merged successfully, a composite runtime group will still be created.
A composite runtime group is a read-only runtime group (exceptions listed below), so configuration modifications must be made via a member standard runtime group. 

A runtime instance client certificate can be generated in the UI or uploaded to a composite runtime group
Runtime instances can be connected to a composite runtime group, however members of a composite runtime group cannot have any runtime instances connected to them.

Kong Ingress Controller runtime groups can't be part of a composite runtime group.

## Runtime instances 

A runtime instance (also known as a {{site.nbase_gateway}} data plane node) can only connect to a single runtime group. In a composite runtime group, the composite configuration from all child runtime groups is pushed to each runtime instance.

Each composite runtime group has its own unique control plane endpoint. A runtime instance that is connected to a composite runtime group has no knowledge of any other runtime groups.

The runtime instances of a composite runtime group are not visible to a member runtime group.

## Configuring core entities

Here are the behaviors and special cases for each of the core entities when used as part of a composite runtime group.

A number of Kong entities can be associated with another Kong entity. The table below displays the type of association. Based on the type of association, the behavior of these associated entities when merged into a composite runtime group can be inferred by the following:
* If the entity relationship is referenced by ID, associations remain constrained to the behavior of the individual runtime group.
* If the entity relationship is referenced by a string, then associations across one or more member runtime groups are possible.

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
Global plugin | Runtime Group | By Runtime group
Key | Key set | By ID
Vault | Runtime group | By Runtime group
deGraphQL route | Service | By ID
GraphQL Rate Limiting cost decoration | Service | By ID

The {{site.base_gateway}} resource associated with an entity must be part of the same standard runtime group as the entity.

Entities in a composite runtime group must have unique names and IDs. For example, if two members of a composite runtime group both have a service named `example_service`, it will cause an invariance which must be resolved to restore function.

Entity-specific behavior exceptions:
* **Consumers**: A consumer of a standard runtime group will become a consumer of the composite runtime group once the standard runtime group becomes a member of the composite runtime group.
The authentication credentials of a consumer in a standard runtime group become valid credentials of the composite runtime group.
The id of a consumer from one composite runtime group member cannot be used in authorization in another composite runtime group member.
* **Consumer groups**: Only consumers from the same runtime group can be added to a consumer group.
Consumer groups names in the Adv Rate Limiting plugin can reference group names from other composite runtime group members.
* **Global plugins**: A plugin that is globally scoped in the standard runtime group will remain globally scoped in the composite runtime group. 
This plugin will affect the entire composite runtime group.
Multiple instances of the same global plugin can be combined into the composite runtime group. (eg: two instances of the ratelimit plugin)
* **Vaults**: The prefix of each Vault must be unique.
Once a Vault from a standard runtime group becomes part of a composite runtime group, it becomes available to the whole composite runtime group.
An entity field in a standard runtime group can successfully reference a secret in a Vault from another standard runtime group, now both part of the composite runtime group

### Invariances in runtime groups

You may see one of the following error messages in your runtime group:

Composite runtime group:

```
Invariances have been detected between these runtime groups: 
<group name>
<group name>
```

![Composite runtime group invariances](/assets/images/docs/konnect/konnect-invariances-composite.png)

![Standard runtime group invariances](/assets/images/docs/konnect/konnect-invariances-members.png)


Standard runtime group:
```
This runtime group is causing an invariance with the parent composite runtime group.
```

![Specific runtime group invariance example](/assets/images/docs/konnect/konnect-invariances-child.png)


This means that there is a conflict between members of a runtime group. It may be one of the following issues:

Invariance | Description | Action
-----------|-------------|--------
Duplicate names across composite runtime group members | Entity names within a standard runtime group must be unique. However, it is possible to create entities with the same name in different standard runtime groups. When those groups are added as members of the same composite group, the composite group ends up having entities with duplicate names. The duplicate entities behave as regular entities in the data plane. | Resolve the conflict by removing one of the instances.
Shared credentials across composite runtime group members | Consumer credentials in one composite runtime group member can be used to authenticate to everything registered in the group. This notification lets you know that credentials are being shared. | If you don't want to share credentials across the members, identify and remove those credentials.
ACL group names across composite runtime group members | ACL groups names can be referenced across composite runtime group members for authorization. The notification lets you know that ACL group names are shared. | If you don't want to share ACL groups across the members, identify and remove duplicates.
Consumer groups across composite runtime group members | Consumer group names in the Rate Limiting Advanced plugin can reference group names from other composite runtime group members. The notification lets you know that consumer group names are shared. | If you don't want to share consumer groups across the members, identify and remove duplicates.
Multiple instances of the same global plugin | A global plugin can only be applied once in an standard runtime group. However, multiple instances of the same global plugin can be combined into the composite runtime group. | Resolve the conflict by removing one of the instances.
decK dump with duplicate names found | `deck dump` will break with duplicate names across composite runtime group entities. | Resolve the conflict by removing one of the instances.
Reference by name vs reference by ID | If the entity relationship requires reference by id, then cross-RG relationships don't work. If the entity relationship is defined by a special string, then cross-RG relationships do work as long as you know the special string. | Resolve the conflict by removing one of the instances.