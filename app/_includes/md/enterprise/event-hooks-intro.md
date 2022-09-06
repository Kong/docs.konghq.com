<!-- Event hooks introduction is used in both the reference.md and examples.md files.  -->

Event hooks are outbound calls from {{site.base_gateway}}. With event hooks, the {{site.base_gateway}} can
communicate with target services or resources, letting the target know that an event was
triggered. When an event is triggered in Kong, it calls a URL with information about that
event. Event hooks add a layer of configuration for subscribing to worker events using the
admin interface. Worker events are integrated into {{site.base_gateway}} to communicate within the gateway context.
For example, when an entity is created, the {{site.base_gateway}} fires an event with information about the entity. Parts
of the {{site.base_gateway}} codebase can subscribe to these events, then process the events using callbacks.

In {{site.base_gateway}}, these callbacks can be defined using one of the following "handlers":

- **webhook:** Makes a JSON POST request to a provided URL with the event data as a payload.
  Useful for building a middle tier integration (your own webhook that receives Kong hooks).
  Specific headers can be configured for the request.

- **webhook-custom:** Fully configurable request. Useful for building a direct integration
  with a service (for example, a Slack webhook). Because it's fully configurable, it's
  more complex to configure. It supports templating on a configurable body, a configurable
  form payload, and headers.

- **log:** This handler, which requires no configuration, logs the event and the
  content of the payload into the {{site.base_gateway}} logs. If using hybrid mode, the `crud` and
  `dao:crud` sources will log on the control plane logs and the `balancer` and
  `rate-limiting-advanced` sources will log on the data plane logs.

- **lambda:** This handler runs specified Lua code after an event is triggered.
