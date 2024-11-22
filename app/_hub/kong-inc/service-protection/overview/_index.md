---
nav_title: Overview
title: Overview
---

You can rate limit services using the Service Protection plugin. 

If you want to apply global rate limits or apply rate limits to routes and consumers, see the following other rate limiting plugins:
* [Rate Limiting plugin](/hub/kong-inc/rate-limiting/): Rate limit services, consumers, and routes or apply global rate limits.
* [Rate Limiting Advanced plugin](/hub/kong-inc/rate-limiting-advanced/): Rate limit services, consumers, and routes or apply global rate limits. The Rate Limiting Advanced plugin extends the functionality of the Rate Limiting plugin by providing advanced tuning settings and the ability to apply multiple limits in sliding or fixed windows.
* [AI Rate Limiting Advanced plugin](/hub/kong-inc/ai-rate-limiting-advanced/): Apply rate limits to traffic from LLMs.

<details><summary>Does the Service Protection plugin replace the Rate Limiting or Rate Limiting Advanced plugins?</summary>

{% capture rl_plugins_replace %}
No. The Service Protection plugin only rate limits services. You can still use the Rate Limiting and Rate Limiting Advanced plugins to rate limit other entities, like consumers and routes. 
{% endcapture %}

{{ rl_plugins_replace | markdownify }}

</details>

<details><summary>Can I use the Service Protection plugin with other rate limiting plugins?</summary>

{% capture rl_plugins_compatibility %} 
Yes. You can rate limit a service with the Service Protection plugin and rate limit a route or a consumer with the other rate limiting plugins. We don't recommend rate limiting the same services with the Service Protection plugin and another rate limiting plugin.
{% endcapture %}

{{ rl_plugins_compatibility | markdownify }}

</details>

<details><summary>When would I use the Service Protection plugin with other rate limiting plugins?</summary>

{% capture rl_plugins_use_cases %}
You should use the Service Protection plugin to rate limit your services and use the other rate limiting plugins to limit other entities, like consumers or routes, or to apply global rate limits. 
{% endcapture %}

{{ rl_plugins_use_cases | markdownify }}

</details>

<details><summary>If I'm currently using a different rate limiting plugin to rate limit my services, should I migrate to the Service Protection plugin? And if so, how do I migrate?</summary>

{% capture rl_plugins_migrate %}
IDK 
{% endcapture %}

{{ rl_plugins_use_migrate | markdownify }}

</details>

## How it works

The following diagram shows how the Service Protection plugin rate limits services:

{% mermaid %}
sequenceDiagram
    actor Consumer
    participant Service Protection plugin
    participant Services
    Consumer->>Service Protection plugin: Sends a request
    Service Protection plugin->>Services: API
{% endmermaid %}

The Service Protection plugin uses the same [Rate Limiting Library](https://docs.konghq.com/gateway/latest/reference/rate-limiting/) as the other rate limiting plugins.

## More information

<!-- Bulleted list of links to more info about your plugin -->