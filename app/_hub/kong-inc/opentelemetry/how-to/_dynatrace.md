---
title: Set up Dynatrace with OpenTelemetry
nav_title: Using Dynatrace
minimum_version: 3.8.x
---

<span class="badge premiumpartner"></span>

{{site.base_gateway}} integrates with Dynatrace through Kong’s [OpenTelemetry](/hub/kong-inc/opentelemetry/), [Prometheus](/hub/kong-inc/prometheus/), and [logging](/hub/?category=logging) plugins.
This guide shows you how to set up Dynatrace with Kong's OpenTelemetry plugin.

{{site.base_gateway}}'s plugins send signals to the Dynatrace Collector which is responsible for updating the Dynatrace tenant with {{site.base_gateway}} traces, metrics, and logs.

This is a {{site.base_gateway}} integration and is fully supported by Kong through the existing plugins available in {{site.base_gateway}}.

{% include_cached /md/plugins-hub/dynatrace.md %}