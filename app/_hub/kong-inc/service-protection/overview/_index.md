---
nav_title: Overview
title: Overview
---

Set absolute maximum rate limits for services using the Service Protection plugin. 
You can use this plugin together with other rate limiting plugins to apply granular rate limits based on different entities.

If you want to apply global rate limits or apply rate limits to routes and consumers, see the following other rate limiting plugins:

{% include /md/plugins-hub/rl-table.md %}

The Service Protection plugin uses the same [Rate Limiting Library](/gateway/latest/reference/rate-limiting/) as the other rate limiting plugins.

## FAQs

<details><summary>Does the Service Protection plugin replace the Rate Limiting or Rate Limiting Advanced plugins?</summary>

{% capture rl_plugins_replace %}
No. The Service Protection plugin only rate limits services. You can still use the Rate Limiting and Rate Limiting Advanced 
plugins to rate limit other entities, like consumers and routes. 
{% endcapture %}

{{ rl_plugins_replace | markdownify }}

</details>

<details><summary>Can I use the Service Protection plugin with other rate limiting plugins?</summary>

{% capture rl_plugins_compatibility %} 
Yes. You can rate limit a service with the Service Protection plugin and rate limit a route or a consumer with the other rate limiting plugins. 
However, we **do not** recommend rate limiting the same service with multiple plugins.
{% endcapture %}

{{ rl_plugins_compatibility | markdownify }}

</details>

<details><summary>When would I use the Service Protection plugin with other rate limiting plugins?</summary>

{% capture rl_plugins_use_cases %}
You should use the Service Protection plugin to rate limit your services and use the other rate limiting plugins to limit other entities, 
like consumers or routes, or to apply global rate limits. 
{% endcapture %}

{{ rl_plugins_use_cases | markdownify }}

</details>

## Get started with the Service Protection plugin

* [Configuration reference](/hub/kong-inc/service-protection/configuration/)
* [Basic configuration example](/hub/kong-inc/service-protection/how-to/basic-example/)