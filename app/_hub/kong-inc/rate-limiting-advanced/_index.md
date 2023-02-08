---
name: Rate Limiting Advanced
publisher: Kong Inc.
desc: Upgrades Kong Rate Limiting with more flexibility and higher performance
description: |
  The Rate Limiting Advanced plugin for Konnect Enterprise is a re-engineered version of the Kong Gateway (OSS) [Rate Limiting plugin](/hub/kong-inc/rate-limiting/).

  As compared to the standard Rate Limiting plugin, Rate Limiting Advanced provides:
  * Enhanced capabilities to tune the rate limiter, provided by the parameters `limit` and `window_size`. Learn more in [Multiple Limits and Window Sizes](#multi-limits-windows)
  * Support for Redis Sentinel, Redis cluster, and Redis SSL
  * Increased performance: Rate Limiting Advanced has better throughput performance with better accuracy. The plugin allows you to tune performance and accuracy via a configurable synchronization of counter data with the backend storage. This can be controlled by setting the desired value on the `sync_rate` parameter.
  * More limiting algorithms to choose from: These algorithms are more accurate and they enable configuration with more specificity. Learn more about our algorithms in [How to Design a Scalable Rate Limiting Algorithm](https://konghq.com/blog/how-to-design-a-scalable-rate-limiting-algorithm).
  * Consumer groups support: Apply different rate limiting configurations to select groups of consumers. Learn more in [Rate limiting for consumer groups](#rate-limiting-for-consumer-groups)
  * More control over which requests contribute to incrementing the rate limiting counters via the `disable_penalty` parameter
type: plugin
enterprise: true
categories:
  - traffic-control
kong_version_compatibility:
  community_edition:
    compatible: null
  enterprise_edition:
    compatible: true
---
