{% if include.snippet == "intro" %}

For all providers, the Kong AI Proxy plugin attaches to **route** entities.

It can be installed into one route per operation, for example:

* OpenAI "Chat" route
* Cohere "Chat" route
* Cohere "Completions" route

Each of these AI-enabled routes must point to a "null" service. This service doesn't need to map to any real upstream URL,
it can point somewhere empty (for example, `http://localhost:32000`), because the AI Proxy plugin overwrites the upstream URL.
**This requirement will be removed in a later Kong revision.**
{% endif %}

{% if include.snippet == "service" %}

{% if include.provider %}
* {{include.provider}} account and subscription
{% endif %}
* You need a service to contain the route for the LLM provider. Create a service **first**:

```bash
curl -X POST http://localhost:8001/services \
  --data "name=ai-proxy" \
  --data "url=http://localhost:32000"
```
Remember that the upstream URL can point anywhere empty, as it won't be used by the plugin.
{% endif %}