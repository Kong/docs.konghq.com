---
title: AI Gateway
content-type: tutorial
book: get-started
chapter: 7
---

Kong AI Gateway is a powerful set of new features built on top of [{{site.base_gateway}}](/gateway/latest/), 
designed to help organizations effectively adopt AI capabilities quickly and securely.

With the rapid emergence of multiple AI providers (including OSS self hosted models), 
the AI technology landscape is fragmented and lacking in standards and controls. This 
significantly complicates how organizations use and govern AI services. {{site.base_gateway}}'s 
broad API management capabilities and plugin extensibility model make it well suited to 
provide AI specific API management and governance services.

While AI providers do not conform to a standard API specification, the AI Gateway provides a 
normalized API layer allowing clients to consume AI services in a provider agnostic manner. The
AI Gateway provides additional capabilities for governance and tuning through request/response 
transformations, prompt engineering, and AI usage observability.

The AI Gateway features are enabled through a set of modern and specialized plugins, 
designed around LLM API use cases. When deployed alongside existing [{{site.base_gateway}} plugins](/hub), 
{{site.base_gateway}} users can quickly assemble a sophisticated AI management platform 
without custom code or deploying new and unfamiliar tools.

{:.note}
> **Note:**
> As of {{site.base_gateway}} `3.6`, the AI Gateway plugins are release as BETA and should not be 
> deployed in production environments.

## Getting Started

The AI Gateway is built using {{site.base_gateway}}'s standard plugin model and the AI Plugins are bundled 
with {{site.base_gateway}} as of version `3.6`. This means you can deploy the AI Gateway
capabilities by following the documented configuration instructions for [each plugin](/hub/?category=ai). 

However, to help you get started quickly, we have provided a script that automates the task of 
deploying a {{site.base_gateway}} configured as an AI Gateway to a local Docker container, 
allowing you to evaluate the core AI provider capabilities before exploring the full suite of AI plugins.

The quickstart script supports deploying {{site.base_gateway}} on {{site.konnect_product_name}} or 
in traditional mode on Docker only.

{:.note}
> **Note:**
> Running this script prompts you for AI Provider API Keys which are used to configure authentication with
> hosted AI providers. These keys are passed to the {{site.base_gateway}} Docker container and are 
> not transmitted outside the host machine.

The script runs interactively and prompts you for information about the AI providers you wish to configure.

Download and run script shell in one step:

```sh
curl -Ls https://get.konghq.com/ai | bash
```

After the AI Gateway is deployed, the script will display information you can use to evaluate the 
AI provider proxy behavior. Additionally, the script will display information about deployment
files it generates which can be used to for more advanced AI Gateway configurations. 

## AI Gateway Capabilities 

The following describes the broad capabilities of the AI Gateway, more details can be found
in the AI Gateway plugins found in the {{site.base_gateway}} [Plugin Hub](/hub/?category=ai).

### AI Provider Proxy

The core of the AI Gateway is the ability to route AI Requests to various providers in a vendor agnostic
manner. This normalized API layer affords developers and the organization multiple benefits:

* Client applications are shielded from AI provider API specifics promoting code reuse and stability 
* The AI gateway gives the organization a central point of governance and observability over AI data and usage
* AI usage can be easily optimized as request routing can be dynamic based on various metrics: Cost, usage, response accuracy, etc...

The AI Gateway supports two types of LLM requests: 

* completion : A type of request where the AI system is asked to generate a textual output based on a single prompt. 
* chat : A type of request that is part of a conversational AI interface. In a `chat` request, the AI is expected to return
  a dialog response to user input. The AI system bases its response on the conversational history. 

The initial set of AI Providers supported by the core proxy behavior are:

* OpenAI 
* Cohere
* Azure
* Anthropic

In Addition to the above hosted AI Providers, self hosted models are supported as well. An example
tool that allows the running of local models is [Ollama](https://ollama.ai/).  The following local
models are initially supported:

* Mistral
* Llama2

{:.note}
> **Note:**
> By default local models are configured on the following endpoint `http://host.docker.internal:11434`
> which allows {{site.base_gateway}} running in Docker to connect to the host machine. 

This core AI Gateway feature is enabled with the [AI Proxy](hub/kong-inc/ai-proxy) plugin, which is
deployed by default in the getting started script referenced above. See the 
[configuration](hub/ai-proxy/configuration/) for details on modifying the proxy behavior.

### AI Usage Governance

With the growing adoption of AI technologies, organizations are exposed to a set of new risk vectors. In particular,
organizations are at risk of having sensitive data leaked to AI Providers, exposing them and 
their customers to data breaches and other security risks. 

#### Data Governance

AI Gateway provides the ability to govern outgoing AI prompts via the 
[AI Prompt Guard](/hub/kong-inc/ai-prompt-guard). This plugin allows the configuration of regular expressions
following an allow/deny list configuration. Denied prompts result in `4xx` HTTP code responses to clients preventing
the egress of offending requests.

#### Prompt Engineering

AI systems are built around prompts, and manipulating those prompts is important to successful adoption of the technologies.
Prompt engineering is the methodology of manipulating the linguistic inputs that guide the AI system. The AI Gateway 
supports a set of plugins that allow you to create a simplified and enhanced experience by setting default prompts or manipulating
prompts from clients as they pass through the gateway.

The [AI Prompt Template](/hub/kong-inc/ai-prompt-template) plugin enables administrators to provide pre-configured AI prompts to users. These prompts contain variable 
placeholders in the format `{{variable}}` which users fill to adapt the template to their specific needs. This functionality 
prohibits arbitrary prompt injection by sanitizing string inputs to ensure that JSON control characters are escaped. 

The [AI Prompt Decorator](/hub/kong-inc/ai-prompt-decorator) plugin injects an array of `llm/v1/chat` messages at the 
start or end of a caller’s chat history. This capability allows the caller to create more complex prompts and have more control 
over how a Large Language Model (LLM) is used when called via {{site.base_gateway}}.

These plugins must be used in combination with the AI Proxy plugin, allowing you to build specialized AI experiences for your users.

#### Request Transformations

TODO: Clean up this

AI Request Transformer: The AI Request Transformer plugin uses a configured LLM service to transform and introspect the 
consumer's request body before proxying the request upstream. It extends the function of the AI Proxy plugin and runs after all of the 
AI Prompt plugins, allowing it to introspect LLM requests against a different LLM. The transformed request is then sent to the backend service. 
It requires the AI Proxy to be first configured. Once the LLM service returns a response, this is set as the upstream's request body. 

AI Response Transformer: The AI Response Transformer plugin uses a configured LLM service to introspect and transform the 
HTTP(S) response from upstream before sending it back to the client. This plugin complements the AI Proxy plugin, facilitating 
introspection of LLM responses against a different LLM. Importantly, it adjusts response headers, response status codes, and the body of the 
response based on instructions from the LLM. The adjusted response is then sent back to the client. Similar to the AI Request Transformer, 
this plugin also requires the AI Proxy to be first configured. Link to AI Response Transformer


