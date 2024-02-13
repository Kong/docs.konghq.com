---
nav_title: Llama2
title: Set up AI Proxy with Llama2
---

Set up the AI Proxy plugin to use the Llama2 LLM.

{:.important}
> Llama2 is a self-hosted model. As such, it requires setting the model option `upstream_url`, pointing to the absolute
> HTTP(S) endpoint for this model implementation.

There are a number of hosting/format options for running this LLM. Popular options include:

* [HuggingFace](https://huggingface.co/docs/transformers/model_doc/llama2)
* [OLLAMA](https://ollama.com/)
* [llama.cpp](https://github.com/ggerganov/llama.cpp)
* [Hosting the GGUF model yourself, with an e.g. Python Web Server](https://huggingface.co/meta-llama/Llama-2-7b-chat-hf)

## Upstream formats

The "upstream" request and response formats are different between various implementations of Llama2, and/or its accompanying web-server.

For this provider, the following should be used for the `config.model.options.llama2_format` parameter:

| Llama2 Hosting   | llama2_format Config Value | Auth Header?            |
|------------------|----------------------------|-------------------------|
| HuggingFace      | `raw`                      | `Authorization`         |
| OLLAMA           | `ollama`                   | Not required by default |
| llama.cpp        | `raw`                      | Not required by default |
| Self-Hosted GGUF | `openai`                   | Not required by default |

### Raw format

The `raw` format option emits the full Llama2 prompt format, under the JSON field `inputs`:

```json
{
  "inputs": "<s>[INST] <<SYS>>You are a mathematician. \n <</SYS>> \n\n What is 1 + 1? [/INST]"
}
```

It expects the response to be in the `responses` JSON field. If using `llama.cpp`, it should
also be set to `RAW`mode.

### Ollama format

The `ollama` format option adheres to the "chat" and "chat-completion" request formats,
[as defined in its API documentation](https://github.com/ollama/ollama/blob/main/docs/api.md).

### OpenAI format

The `openai` format option follows the same upstream formats as the equivalent OpenAI route_type operation.

## Using the plugin with Llama2

### Prerequisites

{% include_cached /md/plugins-hub/ai-providers-prereqs.md %}

Now you can create a **route** and accompanying **AI Proxy plugin** for your AI provider.

### Provider configuration

After installing and starting your Llama2 instance:

```yaml
name: llama2-chat
paths:
  - "~/llama2-chat$"
methods:
  - POST
plugins:
  - name: ai-proxy
    config:
      route_type: "llm/v1/chat"
      model:
        provider: "llama2"
        name: "llama2"
        llama2_format: "ollama"
        upstream_url: "http://llama2-server.local:11434/v1/chat"
```

### Plugin installation

Create the resources:

```bash
curl -X POST http://localhost:8001/services/ai-proxy/routes \
    --data "name=llama2-chat" \
    --data "paths[]=~/llama2-chat$"
```

```bash
curl -X POST http://localhost:8001/routes/llama2-chat/plugins \
    --data "name=ai-proxy" \
    --data "config.route_type=llm/v1/chat" \
    --data "config.model.provider=llama2" \
    --data "config.model.name=llama2" \
    --data "config.model.options.llama2_format=ollama" \
    --data "config.model.options.upstream_url=http://ollama-server.local:11434/v1/chat" \ 
```

### Test

Finally, make an `llm/v1/chat` type request to your new endpoint:

```bash
curl -X POST http://localhost:8000/llama2-chat \
  -H 'Content-Type: application/json' \
  --data-raw '{ "messages": [ { "role": "system", "content": "You are a mathematician" }, { "role": "user", "content": "What is 1+1?"} ] }'
```