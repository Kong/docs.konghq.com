---
nav_title: Langchain
title: Set up AI Proxy with Langchain
minimum_version: 3.9.x
---

This guide walks you through setting up the AI Proxy plugin with [Langchain](https://www.langchain.com/).

{% include_cached /md/plugins-hub/ai-providers-prereqs.md snippet='intro' %}

## Kong AI Gateway

[Kong AI Gateway](https://konghq.com/products/kong-ai-gateway) delivers a suite of AI-specific plugins
on top of the API Gateway platform, enabling you to:

* Route a single consumer interface to multiple models, across many providers
* Load balance similar models based on cost, latency, and other metrics/algorithms
* Deliver a rich analytics and auditing suite for your deployments
* Enable semantic features to protect your users, your models, and your costs
* Provide no-code AI enhancements to your existing REST APIs
* Leverage Kong's existing ecosystem of authentication, monitoring, and traffic-control plugins

## Get Started

Kong AI Gateway exchanges inference requests in the OpenAI formats - thus you can easily and quickly
connect your existing LangChain OpenAI adaptor-based integrations directly through Kong with no code changes.

You can target hundreds of models across the [supported providers](https://docs.konghq.com/hub/kong-inc/ai-proxy/),
all from the same client-side codebase.

### Create LLM Configuration

Kong AI Gateway uses the same familiar service/route/plugin system as the API Gateway product,
with a declarative setup that launches a complete gateway system configured from a single
YAML file.

Create your gateway YAML file, using the [Kong AI-Proxy Plugin](https://docs.konghq.com/hub/kong-inc/ai-proxy/),
in this example for:

* the **OpenAI** backend and **GPT-4o** model
* the **Gemini** backend and **Google One-hosted Gemini** model

```yaml
_format_version: "3.0"

# A service can hold plugins and features for "all models" you configure
services:
  - name: ai
    url: https://localhost:32000  # this can be any hostname

    # A route can denote a single model, or can support multiple based on the request parameters
    routes:
      - name: openai-gpt4o
        paths:
          - "/gpt4o"
        plugins:
          - name: ai-proxy  # ai-proxy is the core AI Gateway enabling feature
            config:
              route_type: llm/v1/chat
              model:
                provider: openai
                name: gpt-4o
              auth:
                header_name: Authorization
                header_value: "Bearer <OPENAI_KEY_HERE>"  # replace with your OpenAI key
```

Output this file to `kong.yaml`

### Launch the Gateway

Launch the Kong open-source gateway, loading this configuration YAML, with one command:

```sh
$ docker run -it --rm --name kong-ai -p 8000:8000 \
    -v "$(pwd)/kong.yaml:/etc/kong/kong.yaml" \
    -e "KONG_DECLARATIVE_CONFIG=/etc/kong/kong.yaml" \
    -e "KONG_DATABASE=off" \
    kong:3.8
```

#### Test it

Check you are reaching GPT-4o on OpenAI correctly:

```sh
$ curl -H 'Content-Type: application/json' -d '{"messages":[{"role":"user","content":"What are you?"}]}' http://127.0.0.1:8000/gpt4o

{
  ...
  ...
        "content": "I am an AI language model developed by OpenAI, designed to assist with generating text-based responses and providing information on a wide range of topics. How can I assist you today?",
  ...
  ...
}
```

### Execute Your LangChain Code

Now you can (re-)configure your LangChain client code to point to Kong, and we should see
identical results!

First, load the LangChain SDK into your Python dependencies:

```sh
# WSL2, Linux, macOS-native:
pip3 install -U langchain-openai
```

```sh
# or macOS if installed via Homebrew:
python3 -m venv .venv
source .venv/bin/activate
pip install -U langchain-openai
```

Then create an `app.py` script:

```python
from langchain_openai import ChatOpenAI

kong_url = "http://127.0.0.1:8000"
kong_route = "gpt4o"

llm = ChatOpenAI(
    base_url=f'{kong_url}/{kong_route}',  # simply override the base URL from OpenAI, to Kong
    model="gpt-4o",
    api_key="NONE"  # set to NONE as we have not added any gateway-layer security yet
)

response = llm.invoke("What are you?")
print(f"$ ChainAnswer:> {response.content}")
```

and run it!

```sh
$ python3 ./app.py
```

#### Custom Tool Usage

Kong also supports custom tools, defined via any supported OpenAI-compatible SDK, including LangChain.

With the same `kong.yaml` configuration, you can execute a simple custom tool definition:

```python
from langchain_openai import ChatOpenAI
from langchain_core.tools import tool

kong_url = "http://127.0.0.1:8000"
kong_route = "gpt4o"

@tool
def multiply(first_int: int, second_int: int) -> int:
    """Multiply two integers together."""
    return first_int * second_int

llm = ChatOpenAI(
    base_url=f'{kong_url}/{kong_route}',
    api_key="department-1-api-key"
)

llm_with_tools = llm.bind_tools([multiply])

chain = llm_with_tools | (lambda x: x.tool_calls[0]["args"]) | multiply
response = chain.invoke("What's four times 23?")
print(f"$ ToolsAnswer:> {response}")
```

## Productionize the Gateway

### Secure your AI Model

We've just opened up our GPT-4o subscription to the localhost.

Now add a Kong-level API key to the `kong.yaml` configuration file, which secures your published AI route, and allows your to track usage across multiple
users, departments, paying-subscribers, or any other entity:

```yaml
_format_version: "3.0"

services:
  - name: ai
    url: https://localhost:32000

    routes:
      - name: openai-gpt4o
        paths:
          - "/gpt4o"
        plugins:
          - name: ai-proxy
            config:
              route_type: llm/v1/chat
              model:
                provider: openai
                name: gpt-4o
              auth:
                header_name: Authorization
                header_value: "Bearer <OPENAI_KEY_HERE>"  # replace with your OpenAI key again

          # Now we add a security plugin at the "individual model" scope
          - name: key-auth
            config:
              key_names:
                - Authorization

# and finally a consumer with **its own API key**
consumers:
  - username: department-1
    keyauth_credentials:
      - key: "Bearer department-1-api-key"
```

and adjust your Python code accordingly:

```python
...
...
llm = ChatOpenAI(
    base_url=f'{kong_url}/{kong_route}',
    model="gpt-4o",
    api_key="department-1-api-key"  # THIS TIME WE SET THE API KEY FOR THE CONSUMER, AS CREATED ABOVE
)
...
...
```

## Observability

There are two mechanisms for observability in Kong AI Gateway, depending on your deployment architecture:

* Self-hosted and Kong Community users can bring their favourite JSON-log dashboard software.
* Konnect Cloud users can use [Konnect Advanced Analytics](https://docs.konghq.com/konnect/analytics/) to automatically visualize every aspect of the AI Gateway operation.

### Self-Hosting AI Gateway Observability

You can use one (or more) of Kong's many [logging protocol plugins](https://docs.konghq.com/hub/?category=logging),
sending your AI Gateway metrics and logs (in JSON format) to your chosen dashboarding software.

You can choose to log metrics, input/output payloads, or both.

#### Sample ELK Stack

Use the [sample Elasticsearch/Logstash/Kibana stack](https://github.com/KongHQ-CX/kong-ai-gateway-observability) on GitHub 
to see the full range of observability tools available when running LangChain applications via Kong AI Gateway.

Boot it up in three steps:

1. Clone the repository: `git clone https://github.com/KongHQ-CX/kong-ai-gateway-observability && cd kong-ai-gateway-observability/`
2. Export your OpenAI API auth header (with API key) into the current shell environment: `export OPENAI_AUTH_HEADER="Bearer sk-proj-......"`
3. Start the stack: `docker compose up`

Now you can run the same LangChain code as in the previous step(s), visualizing exactly what's happening in Kibana, at:
http://localhost:5601/app/dashboards#/view/aa8e4cb0-9566-11ef-beb2-c361d8db17a8

**You can generate analytics over every AI request executed by LangChain/Kong:**

![Kong API Stats Example](/assets/images/guides/llm-libraries/kong-analytics.png)

**and even, if enabled, every request and response, as granular as 'who-is-executing-what-when':**

![Kong API Logs Example](/assets/images/guides/llm-libraries/kong-logs.png)

*This uses the [Kong HTTP-Log plugin](https://docs.konghq.com/hub/kong-inc/http-log/) 
to send all AI statistics and payloads to Logstash.*

## Prompt Tuning, Audit, and Cost Control Features

Now that you have your LangChain codebase calling one or many LLMs via Kong AI Gateway, you can 
snap-in as many features as required, by harnessing 
[Kong's growing array of AI plugins](https://docs.konghq.com/hub/?category=ai).
