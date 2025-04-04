---
nav_title: Overview
---

{{site.base_gateway}} integrates with Dynatrace through Kong’s [OpenTelemetry](/hub/kong-inc/opentelemetry/), [Prometheus](/hub/kong-inc/prometheus/),and [logging](/hub/?category=logging) plugins. 
{{site.base_gateway}}'s plugins send signals to the Dynatrace Collector which is responsible for updating the Dynatrace tenant with {{site.base_gateway}} traces, metrics, and logs.

This is a {{site.base_gateway}} integration and is fully supported by Kong through the existing plugins available in {{site.base_gateway}}.

{% include_cached /md/plugins-hub/dynatrace.md %}