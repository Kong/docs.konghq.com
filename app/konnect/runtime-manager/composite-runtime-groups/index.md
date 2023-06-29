---
title: Composite Runtime Groups
content_type: explanation
badge: enterprise
---

A composite runtime group is a read-only group that combines configuration from
its members, which are standard runtime groups. All of the standard runtime groups within a 
composite runtime group share the same cluster of runtime instances. 

![Standard runtime group](/assets/images/docs/konnect/konnect-standard-rg.svg)
> _**Figure 1:** In a standard runtime group setup, each team configures and manages their own runtime instances._
_For example, Team Blue configures Runtime Group Blue, which then uses a set of runtime instances that only run Blue configuration._


![Composite runtime group](/assets/images/docs/konnect/konnect-composite-rg.svg)
> _**Figure 2:** In a composite runtime group setup, each team still configures their own runtime groups, but the runtime instances are shared._
_For example, Team Blue configures Runtime Group Blue, which is then combined with the configuration from Team Green and Team Yellow._
_The runtime instances in the cluster use the combined configuration._

A composite runtime group can contain up to 256 runtime groups. 
Each standard group can have up to 5 parent composite runtime groups.

## Limitations

A composite runtime group composition will be applied even if the configurations of the standard runtime groups are not combined successfully. 
This means that even if there is some confict and the member groups weren't merged successfully, a composite runtime group still gets created.

Composite runtime groups are read-only (with some exceptions), so configuration modifications must be made via a member standard runtime group. 

The following are exceptions to the read-only rule:
* A runtime instance client certificate can be generated in the UI or uploaded to a composite runtime group.
* Runtime instances can be connected to a composite runtime group, however members of a composite runtime group cannot have any runtime instances connected to them.

Kong Ingress Controller runtime groups can't be part of a composite runtime group.

## Runtime instances 

A runtime instance (also known as a {{site.base_gateway}} data plane node) can only connect to a single runtime group. 
In a composite runtime group, the composite configuration from all child runtime groups is pushed to each runtime instance.

Each composite runtime group has its own unique control plane endpoint. 
A runtime instance that is connected to a composite runtime group has no knowledge of any other runtime groups.

The runtime instances of a composite runtime group are not visible to a member runtime group.

## Configuring core entities

There are some special cases and behaviors to note for core entities in a composite runtime group.

All entities in a composite runtime group must have unique names and IDs. 
For example, if two members of a composite runtime group both have a service named `example_service`, 
it will cause an [invariance](/konnect/runtime-manager/composite-runtime-groups/invariances/) which must be resolved to restore function.

A number of Kong entities can be associated with another Kong entity.
Based on the type of association, the behavior of these associated entities in a composite runtime group follows one of these patterns:
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

Entity-specific behavior exceptions:
* **Consumers**: A consumer of a standard runtime group becomes a consumer of the composite runtime group once the originating group becomes a member of the composite runtime group.
The authentication credentials of a consumer in a standard runtime group become valid credentials of the composite runtime group.
The ID of a consumer from one composite runtime group member can't be used in authorization for another composite runtime group member.

* **Consumer groups**: Only consumers from the same runtime group can be added to a consumer group.
Consumer groups names in the Rate Limiting Advanced plugin can reference group names from other composite runtime group members.

* **Global plugins**: A plugin that is globally scoped in the standard runtime group remains globally scoped in the composite runtime group. 
This plugin will affect the entire composite runtime group.
Multiple instances of the same global plugin can be combined into the composite runtime group. (for example, two instances of the Rate Limiting plugin).

* **Vaults**: The prefix of each Vault must be unique.
Once a Vault from a standard runtime group becomes part of a composite runtime group, it becomes available to the whole composite runtime group.
An entity field in a standard runtime group can successfully reference a secret in a Vault from another standard runtime group, now both part of the composite runtime group.

## More information
* [Set up and manage runtime groups](/konnect/runtime-manager/composite-runtime-groups/how-to/)
* [Migrate configuration into a composite runtime group](/konnect/runtime-manager/composite-runtime-groups/migrate/)
* [Invariances in runtime groups](/konnect/runtime-manager/composite-runtime-groups/invariances/)