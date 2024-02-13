
For all providers, the Kong AI Proxy plugin attaches to **route** entities.

It can be installed into one route per operation, for example:

* OpenAI "Chat" route
* Cohere "Chat" route
* Cohere "Completions" route

Each of these AI-enabled routes must point to a "null" service. This service doesn't need to map to any real upstream URL,
it can point somewhere empty (for example on `http://localhost:32000`), because the AI Proxy plugin will overwrite the upstream URL.
**This requirement will be removed in a later Kong revision.**


You should create this service **first** like in this example:

```bash
curl -X POST http://localhost:8001/services \
    --data "name=ai-proxy" \
    --data "url=http://localhost:32000"
```
