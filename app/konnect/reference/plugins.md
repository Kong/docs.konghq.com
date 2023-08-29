---
title: Plugin Ordering Reference
content_type: explanation
---

This document contains reference information about dynamic plugin ordering and plugin execution order in {{site.konnect_short_name}}. 

## Dynamic plugin ordering

By default, plugins execution order is static. You can override the static priority for any {{site.konnect_short_name}} plugin by using each plugin's
dynamic plugin ordering settings field. This determines plugin ordering during the `access` phase,
and lets you create _dynamic_ dependencies between plugins. 

To configure this setting in {{site.konnect_short_name}}, go to **Gateway Manager > Plugins**, and then select **Configure Dynamic Ordering** from the context menu next to the plugin you want to configure. From the plugin ordering settings, you can configure whether a plugin runs before or after another plugin.

## Plugin execution order

The order in which plugins are executed in {{site.konnect_short_name}} is determined by their
static priority. As the name suggests, this value is _static_ and can't be easily changed by the user. 

The following list includes all plugins bundled with a {{site.konnect_short_name}}
Enterprise subscription.

The current order of execution for the bundled plugins is:

{% include /md/plugin-priority.md edition='enterprise' %}