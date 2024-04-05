---
title: AI Gateway
content-type: tutorial
book: get-started
chapter: 7
---

Kong AI Gateway is a powerful set of features built on top of [{{site.base_gateway}}](/gateway/latest/), 
designed to help developers and organizations effectively adopt AI capabilities quickly and securely.

Quick links:
* [Get started](#getting-started) in one minute with our guide
* [Watch video tutorials](https://konghq.com/products/kong-ai-gateway#videos) in the AI Gateway product page
* [View the AI plugins](/hub/?category=ai) in the Kong Plugin Hub

With the rapid emergence of multiple AI LLM providers (including open source and self-hosted models), 
the AI technology landscape is fragmented and lacking in standards and controls. This 
significantly complicates how developers and organizations use and govern AI services. {{site.base_gateway}}'s 
broad API management capabilities and plugin extensibility model make it well suited to 
provide AI-specific API management and governance services.

While AI providers don't conform to a standard API specification, the AI Gateway provides a 
normalized API layer allowing clients to consume multiple AI services from the same client code base. 
The AI Gateway provides additional capabilities for credential management, AI usage observability, 
governance, and tuning through prompt engineering. Developers can use no-code AI Plugins to enrich
existing API traffic, easily enhancing their existing application functionality.

You can enable the AI Gateway features through a set of modern and specialized plugins, 
using the same model you use for any other {{site.base_gateway}} plugin. 
When deployed alongside existing [{{site.base_gateway}} plugins](/hub/?category=ai), 
{{site.base_gateway}} users can quickly assemble a sophisticated AI management platform 
without custom code or deploying new and unfamiliar tools.

![AI Gateway](/assets/images/products/gateway/getting-started-guide/ai-gateway.png)

## Getting started

The AI Gateway is built using {{site.base_gateway}}'s standard plugin model. The AI plugins are bundled 
with {{site.base_gateway}} as of version 3.6.x. This means you can deploy the AI Gateway
capabilities by following the documented configuration instructions for [each plugin](/hub/?category=ai). 

To help you get started quickly, we have provided a script that automates the task of 
deploying a {{site.base_gateway}} configured as an AI Gateway to a Docker container, 
allowing you to evaluate the core AI provider capabilities before exploring the full suite of AI plugins.

The quickstart script supports deploying {{site.base_gateway}} on {{site.konnect_product_name}} or 
in traditional mode on Docker only.

{:.note}
> **Note:**
> Running this script prompts you for AI Provider API Keys which are used to configure authentication with
> hosted AI providers. These keys are only passed to the {{site.base_gateway}} Docker container and are 
> not otherwise transmitted outside the host machine.

1. Run AI Gateway with the interactive `ai` quickstart script:

    ```sh
    curl -Ls https://get.konghq.com/ai | bash
    ```

2. Configure the deployment to target {{site.konnect_product_name}} or Docker only and configure your
   desired AI Provider API keys:

    ```sh
    ...
    Do you want to deploy on Kong Konnect (y/n) y
    ...
    Provide a key for each provider you want to enable and press Enter.
    Not providing a key and pressing Enter will skip configuring that provider.

    → Enter API Key for OpenAI    :
    ...
    ```

3. Once the AI Gateway is deployed, you will see information displayed to help you evaluate the AI proxy 
plugin behavior. For example, the script will output a sample command helping you route a chat request
to OpenAI:

    ```sh
    =======================================================
     ⚒️                                 Routing LLM Requests
    =======================================================
    
    Your AI Gateway is ready. You can now route AI requests
    to the configured AI providers. For example to route a
    chat request to OpenAI you can use the following
    curl command:
    
    curl -s -X POST localhost:8000/openai/chat \
     -H "Content-Type: application/json" -d '{
       "messages": [{
       "role": "user",
       "content": "What is Kong Gateway?"
     }] }'
    ```

4. Finally, the script will display information about deployment
files it generates, which can be used for future AI Gateway configurations. 

    ```sh
    =======================================================
     ⚒️                What is next with the Kong AI Gateway
    =======================================================
    
    This script demonstrated the installation and usage
    of only one of the many AI plugins that Kong Gateway
    provides (the 'ai-proxy' plugin).
    
    See the output directory to reference the files
    used during the installation process and modify for
    your production deployment.
    ℹ /tmp/kong/ai-gateway
    ```

{:.note}
> **Note:**
> By default, local models are configured on the endpoint `http://host.docker.internal:11434`,
> which allows {{site.base_gateway}} running in Docker to connect to the host machine. 

## AI Gateway Capabilities 

The following describes the broad capabilities of the AI Gateway. More details can be found
in the AI Gateway plugins found in the Kong [Plugin Hub](/hub/?category=ai).

### AI Provider Proxy

The core of the AI Gateway is the ability to route AI requests to various providers exposed via 
a provider-agnostic API. This normalized API layer affords developers and organizations multiple benefits:

* Client applications are shielded from AI provider API specifics, promoting code reusability
* Centralized AI provider credential management
* The AI Gateway gives the developers and organizations a central point of governance and observability over AI data and usage
* Request routing can be dynamic, allowing AI usage to be optimized based on various metrics: cost, usage, response accuracy, and so on.
* AI services can be used by other {{site.base_gateway}} plugins to augment non-AI API traffic 

This core AI Gateway feature is enabled with the [AI Proxy](/hub/kong-inc/ai-proxy/) plugin, which is
deployed by default in the getting started script referenced above. 

The AI Proxy supports two types of LLM requests: 

* _Completion_: A type of request where the AI system is asked to generate a textual output based on a single prompt.
  Completions are configured using the configuration key `route_type` and a value of `llm/v1/completions`.
* _Chat_: A type of request that is part of a conversational AI interface. In a `chat` request, the AI is expected to return
  a dialog response to user input and the AI system bases its response on the conversational history. Chats are
  configured using the configuration key `route_type` and a value of `llm/v1/chat`.

The core proxy behavior supports the following hosted AI providers:

* [OpenAI](https://openai.com/product)
* [Cohere](https://docs.cohere.com/reference/about)
* [Azure](https://learn.microsoft.com/en-us/azure/ai-services/openai/reference)
* [Anthropic](https://www.anthropic.com/)

In addition to the hosted AI providers, self hosted models are supported as well. An example
tool that allows the running of local models is [Ollama](https://ollama.ai/). The following local
models are supported:

* [Mistral](https://mistral.ai/)
* [Llama2](https://llama.meta.com/)

See the [AI Proxy plugin configuration](/hub/kong-inc/ai-proxy/configuration/) for details on modifying the proxy behavior.

### AI usage governance

With the growing adoption of AI technologies, developers and their organizations are exposed to a set of new risk vectors. 
In particular, the risk of having sensitive data leaked to AI Providers, exposing organizations and their customers to 
data breaches and other security risks. 

Kong's AI Gateway provides additional plugins to aid the developers in controlling AI data and usage. These 
plugins are used in combination with the AI Proxy plugin, allowing you to build secure and specialized AI 
experiences for your users.

#### Data governance

AI Gateway provides the ability to govern outgoing AI prompts via the 
[AI Prompt Guard](/hub/kong-inc/ai-prompt-guard). This plugin allows the configuration of regular expressions
following an allow/deny list configuration. Denied prompts result in `4xx` HTTP code responses to clients preventing
the egress of offending requests.

#### Prompt engineering

AI systems are built around prompts, and manipulating those prompts is important for successful adoption of the technologies.
Prompt engineering is the methodology of manipulating the linguistic inputs that guide the AI system. The AI Gateway 
supports a set of plugins that allow you to create a simplified and enhanced experience by setting default prompts or manipulating
prompts from clients as they pass through the gateway.

* The [AI Prompt Template](/hub/kong-inc/ai-prompt-template) plugin enables administrators to provide pre-configured AI prompts to users. These prompts contain variable 
placeholders in the format `{% raw %}{{variable}}{% endraw %}` which users fill to adapt the template to their specific needs. This functionality 
prohibits arbitrary prompt injection by sanitizing string inputs to ensure that JSON control characters are escaped. 

* The [AI Prompt Decorator](/hub/kong-inc/ai-prompt-decorator) plugin injects an array of `llm/v1/chat` messages at the 
start or end of a caller’s chat history. This capability allows the caller to create more complex prompts and have more control 
over how a Large Language Model (LLM) is used when called via {{site.base_gateway}}.

#### Request transformations

Kong's AI Gateway also allows you to use AI technology to augment other API traffic. One example may be routing API responses 
through an AI language translation prompt before returning it to the client. Kong's AI Gateway provides two plugins that can be 
used in conjunction with other upstream API services to weave AI capabilities into API request processing. These plugins
can be configured independently of the AI Proxy plugin.

* The [AI Request Transformer](/hub/kong-inc/ai-request-transformer) plugin uses a configured LLM service to transform and introspect the 
consumer's request body before proxying the request upstream. It extends the function of the AI Proxy plugin and runs after all of the 
AI Prompt plugins, allowing it to introspect LLM requests against a different LLM. The transformed request is then sent to the backend service. 
Once the LLM service returns a response, this is set as the upstream's request body. 

* The [AI Response Transformer](/hub/kong-inc/ai-response-transformer) plugin uses a configured LLM service to introspect and transform the 
HTTP(S) response from upstream before sending it back to the client. This plugin complements the AI Proxy plugin, facilitating 
introspection of LLM responses against a different LLM. Importantly, it adjusts response headers, response status codes, and the body of the 
response based on instructions from the LLM. The adjusted response is then sent back to the client. 

