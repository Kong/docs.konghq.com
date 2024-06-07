---
title: Kong AI Gateway
content-type: explanation
---

Kong AI Gateway is a powerful set of features built on top of [{{site.base_gateway}}](/gateway/latest/), 
designed to help developers and organizations effectively adopt AI capabilities quickly and securely.

## How to get started 

<div class="docs-grid-install docs-grid-install__bottom max-3">
  <a href="/gateway/{{page.release}}/get-started/ai-gateway/" class="docs-grid-install-block docs-grid-install-block__bottom">
    <img class="install-icon no-image-expand small" src="/assets/images/icons/documentation/icn-flag.svg" alt="">
    <div class="install-block-column">
      <div class="install-text">Get started</div>
      <div class="install-description">Get started in one minute with our guide</div>
    </div>
  </a>

  <a href="https://konghq.com/products/kong-ai-gateway#videos" class="docs-grid-install-block docs-grid-install-block__bottom no-link-icon">
    <img class="install-icon no-image-expand small" src="/assets/images/icons/documentation/icn-learning.svg" alt="">
    <div class="install-block-column">
      <div class="install-text">Videos</div>
      <div class="install-description">Watch video tutorials</div>
    </div>
  </a>

<a href="/hub/?category=ai" class="docs-grid-install-block docs-grid-install-block__bottom">
    <img class="install-icon no-image-expand small" src="/assets/images/icons/documentation/icn-api-plugins-color.svg" alt="">
    <div class="install-block-column">
      <div class="install-text">AI Plugins</div>
      <div class="install-description">Check out the AI plugins on the Kong Plugin Hub</div>
    </div>
  </a>
</div>

## What is the Kong AI Gateway?

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

## AI Gateway capabilities 

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

{% if_version gte:3.7.x %}
#### Rate limiting
{:.badge .enterprise}

Kong's AI Gateway also allows you to manage traffic to your LLM API. Kong's AI Gateway provides the AI Rate Limiting Advanced
plugin, which can be used to implement rate limiting on your AI requests traffic.

* The [AI Rate Limiting Advanced](/hub/kong-inc/ai-rate-limiting-advanced) plugin introspects LLM responses to calculate token cost and 
enable rate limits for the LLM backend service. When the LLM service returns a response, this is used as a cost to calculate the rate limit. 
More info on the analytics format can be found in [AI Analytics](/gateway/{{ page.release }}/production/logging/ai-analytics).

#### Content safety and moderation
{:.badge .enterprise}

Kong's AI Gateway provides mechanisms for moderating content.

* The [Azure Content Safety plugin](/hub/kong-inc/ai-azure-content-safety/) allows administrators to enforce 
introspection with the [Azure Content Safety](https://azure.microsoft.com/en-us/products/ai-services/ai-content-safety) service 
for all requests handled by the AI Proxy plugin.
The plugin enables configurable thresholds for the different moderation categories 
and you can specify an array set of pre-configured blocklist IDs from your Azure Content Safety instance.

{% endif_version %}

{% if_version gte:3.7.x %}
### AI observability

Kong's AI Gateway enables comprehensive observability of your AI services through logging and metrics. These features provide insights into AI usage, performance, and costs, helping you optimize and govern AI operations effectively.

#### Logging
{:.badge .enterprise}

Kong's AI Gateway provides standardized logging formats for AI plugins, allowing you to track and analyze AI usage consistently across various providers. 

More info on AI logging can be found in [AI Analytics](/gateway/{{ page.release }}/production/logging/ai-analytics).
{% endif_version %}

{% if_version gte:3.8.x %}
#### Metrics and Prometheus
{:.badge .enterprise}

Kong's AI Gateway allows you to expose and visualize AI metrics through Prometheus and Grafana. These metrics include
the number of AI requests, the cost associated with AI services, and the token usage per provider and model.

The metrics can be scraped by a Prometheus server and visualized using a Grafana dashboard. This setup provides
a real-time view of AI operations, helping you monitor performance and costs effectively.

More info on AI Metrics can be found in [AI Metrics](/gateway/{{ page.release }}/production/monitoring/ai-metrics).

{% endif_version %}