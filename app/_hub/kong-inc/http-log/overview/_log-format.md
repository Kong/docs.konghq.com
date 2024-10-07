---
nav_title: Log format
title: Log format
---

{% if_version lte:3.2.x %}
{:.note}
> **Note:** If the `queue_size` argument > 1, a request is logged as an array of JSON objects.
{% endif_version %}
{% if_version gte:3.3.x %}
{:.note}
> **Note:** If the `max_batch_size` argument > 1, a request is logged as an array of JSON objects.
{% endif_version %}

## Log format

{% include /md/plugins-hub/log-format.md %}

### JSON object descriptions

{% include /md/plugins-hub/json-object-log.md %}