---
title: Policies
---

{% tip %}
**Need help?** Installing and using {{site.mesh_product_name}} should be as easy as possible. [Contact and chat](/community) with the community in real-time if you get stuck or need clarifications. We are here to help.
{% endtip %}

Here you can find the list of Policies that {{site.mesh_product_name}} supports.

Going forward from version 2.0, {{site.mesh_product_name}} is transitioning from [source/destination policies](../general-notes-about-kuma-policies) to [`targetRef` policies](../targetref). 

The following table shows the equivalence between source/destination and `targetRef` policies:

| source/destination policy                    | `targetRef` policy                |
|----------------------------------------------|-----------------------------------|
| [CircuitBreaker](../circuit-breaker)         | N/A                               |
| [FaultInjection](../fault-injection)         | N/A                               |
| [HealthCheck](../health-check)               | N/A                               |
| [RateLimit](../rate-limit)                   | N/A                               |
| [Retry](../retry)                            | N/A                               |
| [Timeout](../timeout)                        | N/A                               |
| [TrafficLog](../traffic-log)                 | [MeshAccessLog](../meshaccesslog) |
| [TrafficMetrics](../traffic-metrics)         | N/A                               |
| [TrafficPermissions](../traffic-permissions) | MeshTrafficPermission             |
| [TrafficRoute](../traffic-route)             | N/A                               |
| [TrafficTrace](../traffic-trace)             | [MeshTrace](../meshtrace)         |

{% warning %}
`targetRef` policies are still beta and it is therefore not supported to mix source/destination and targetRef policies together.
{% endwarning %}
