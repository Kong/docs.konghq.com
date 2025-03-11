---
title: Create Consumer Groups in Kong Manager
content_type: tutorial
badge: enterprise
---
With [consumer groups](/gateway/latest/key-concepts/consumer-groups/), you can scope plugins to specifically defined groups and a new plugin instance will be created for each individual consumer group, making configurations and customizations more flexible and convenient. 
For all plugins available on the consumer groups scope, see the [Plugin Scopes Reference](/hub/plugins/compatibility/#scopes).

## Create a consumer group in Kong Manager

The following creates a new consumer group:

1. In Kong Manager, go to a {{site.base_gateway}} workspace > **Consumers**.
2. Open the **Consumer Groups** tab.
3. Click **New Consumer Group**.
4. Enter a group name and select consumers to add to the group.
5. Click **Save**.

On the consumer group's overview page, you can now add any supported plugin. 
This plugin will apply to all consumers in the group.