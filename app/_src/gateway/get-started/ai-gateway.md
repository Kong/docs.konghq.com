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
on Docker only.

{:.note}
> **Note:**
> Running this script prompts you for AI Provider API Keys which are used to configure authentication with
> hosted AI providers. These keys are passed to the {{site.base_gateway}} Docker container and are 
> not transmitted outside the host machine.

Download and run script shell in one step:

```sh
curl -Ls https://get.konghq.com/ai | bash
```
This script prompts you for information about the AI providers you wish to configure and proceeds to 
run a {{site.base_gateway}} container and configure the AI plugins appropriately. The script is interactive 
allowing you to selectively configure the AI providers. 

After the AI Gateway is deployed, the script will display information you can use to evaluate the 
AI provider routing behavior. Additionally, the script will display information about deployment
files it generates which can be used to further deploy more advanced configurations. 

## AI Gateway Capabilities 

The following describes the broad capabilities of the AI Gateway, more details can be found
in the AI Gateway plugins found in the {{site.base_gateway}} [Plugin Hub](/hub).

### AI Provider Proxy

The core of the AI Gateway is the ability to route AI Requests to various providers in a vendor agnostic
manner. This normalized API layer affords developers and the organization multiple benefits:

* Client applications are shielded from AI provider API specifics promoting code reuse and stability 
* The AI gateway gives the organization a central point of governance and observability over AI data and usage
* AI usage can be easily optimized as request routing can be dynamic based on various metrics: Cost, usage, response accuracy, etc...

The AI Gateway supports two types of LLM requests: 

* completion : TODO what is a completion?
* chat : TODO what is a chat? 

The initial set of AI Providers supported by the core proxy behavior are:

* OpenAI 
* Cohere
* Azure
* Anthropic

In Addition to the above hosted AI Providers, self hosted models are supported as well.

* Mistral
* Llama2

{:.note}
> **Note:**
> By default local models are configured on the following endpoint `http://host.docker.internal:11434`
> which allows {{site.base_gateway}} to connect to the host machine. 

This core AI Gateway feature is enabled with the [AI Proxy](hub/ai-proxy) plugin, which is
deployed by default in the getting started script referenced above. See the 
[configuration](hub/ai-proxy/configuration/) for details on modifying the proxy behavior.

### AI Data Governance

Organizations are exposed to a new risk vector as their employees adopt AI usage. In particular
organizations are at risk of having sensitive data leaked to AI Providers, exposing 
their customers to data breaches and other security risks.

TODO

### AI Usage Governance

TODO

-   Description of AI Request Transformer
    Link to AI Request Transformer

-   Description of AI Response Transformer
    Link ti AI REsponse transformer

### Prompt Engineering


-   Description of AI Prompt Template
    Link to AI Prompt template

-   Description of AI Prompt Decorator
    Link to AI Prompt Decorator

-   Description of AI Prompt Guard
    Link to AK Prompt Guard

