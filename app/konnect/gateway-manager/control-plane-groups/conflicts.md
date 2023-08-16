---
title: Conflicts in runtime groups
content_type: reference
badge: enterprise
---

A conflict is a potential issue in composite configuration. 
For example, there might be a name conflict between services, or the existance of consumer credentials, 
which become available to all members of a composite group.

Once you have at least one runtime instance connected to your composite runtime group, 
you may see one of the following error messages:

Composite runtime group:

```
Conflicts have been detected between these runtime groups: 
<group name>
<group name>
```

![Composite runtime group invariances](/assets/images/docs/konnect/konnect-invariances-composite.png)

![Standard runtime group invariances](/assets/images/docs/konnect/konnect-invariances-members.png)


Standard runtime group:
```
This runtime group is causing a conflict with the parent composite runtime group.
```

![Specific runtime group invariance example](/assets/images/docs/konnect/konnect-invariances-child.png)

You can follow the link from the notification to **View** the conflicts in each group, 
then **View** again to open the resource that's causing the issue.

These issues must be resolved to continue using composite configuration. 
The control plane won't send any config updates to its data planes until conflicts are resolved.

See the following table for a breakdown of potential issues, their causes, and recommended solutions:

Conflict | Description | Action
-----------|-------------|--------
Duplicate names across composite runtime group members | Entity names within a standard runtime group must be unique. However, it's possible to create entities with the same name in different standard runtime groups. When those groups are added as members of the same composite group, the composite group ends up having entities with duplicate names. The duplicate entities behave as regular entities in the data plane. | Resolve the conflict by removing or renaming one of the instances.
Shared credentials across composite runtime group members | Consumer credentials in one composite runtime group member can be used to authenticate to everything registered in the group.| If you don't want to share credentials across the members, identify and remove those credentials.
ACL group names across composite runtime group members | ACL groups names can be referenced across composite runtime group members for authorization. | If you don't want to share ACL groups across the members, identify and remove duplicates.
Consumer groups across composite runtime group members | Consumer group names in the Rate Limiting Advanced plugin can reference group names from other composite runtime group members.| If you don't want to share consumer groups across the members, identify and remove duplicates.
decK dump with duplicate names found | `deck dump` will break with duplicate names across composite runtime group entities. | Resolve the conflict by removing or renaming one of the instances.
Reference by name vs reference by ID | If the entity relationship requires [reference by ID](/konnect/runtime-manager/composite-runtime-groups/#configuring-core-entities), then relationships across runtime groups don't work. If the entity relationship is defined by a special string, relationships across runtime groups do work as long as you know the string. | Resolve the conflict by removing one of the instances.
Multiple instances of the same global plugin | A global plugin can only be applied once in an standard runtime group. However, multiple instances of the same global plugin can be combined into the composite runtime group. | Resolve the conflict by removing one of the instances, or setting different instance names for the plugins.

{:.note}
> **Note:** If you want to limit which users can apply global plugins, add all global plugins into a single runtime group, and then grant access to only your limited set of users. If any other member runtime groups add a global plugin to their configuration, a conflict will result and prevent the changed configuration from being applied.
