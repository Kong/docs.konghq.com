---
nav_title: Overview
---

The AI Rate Limiting Advanced plugin provides rate limiting for the providers used by any AI plugins. The
AI Rate Limiting plugin extends the
[Rate Limiting Advanced](/hub/kong-inc/rate-limiting-advanced/) plugin.

This plugin uses the token data returned by the LLM provider to calculate the costs of queries.
The same HTTP request can vary greatly in cost depending on the calculation of the 
LLM providers.

A common pattern to protect your AI API is to analyze and
assign costs to incoming queries, then rate limit the consumer's
cost for a given time window and providers.

You can also create a generic prompt rate limit using the [request prompt provider](#request-prompt-function).

{:.note}
> **Notes:**
  * PostgreSQL 9.5+ is required when using the `cluster` strategy with `postgres` as the backing Kong cluster datastore.
  * The `dictionary_name` directive was added to prevent the usage of the `kong` shared dictionary, which could lead to `no memory` errors.
    * Known limitation: The cost for `AI proxy` is only reflected during the next request.
    * Example: A request is made and `AI proxy` plugin returns a token cost of `100` for the `OpenAI` provider:
      - The request is made to the OpenAI provider and the response is returned to the user
      -  If the rate limit is reached, the next request will be blocked
    * Known limitation: The disable penalty only works for the `requestPrompt` provider.

## Choosing a rate limiting plugin

Kong provides multiple rate limiting plugins. Choose one to fit your use case:

{% include /md/plugins-hub/rl-table.md %}

## Headers sent to the client

When this plugin is enabled, Kong sends some additional headers back to the client
indicating the allowed limits, how many requests are available, and how long it will take
until the quota is restored.

For example:

```plaintext
X-AI-RateLimit-Reset: 47
X-AI-RateLimit-Retry-After: 47
```

The plugin also sends headers indicating the limits in the time frame and the number
of remaining minutes for each provider:

```plaintext
X-AI-RateLimit-Limit-30-azure: 1000
X-AI-RateLimit-Remaining-30-azure: 950
```

If more than one limit is being set, the plugin returns a combination of more time limits:

```plaintext
X-AI-RateLimit-Limit-30-azure: 1000
X-AI-RateLimit-Remaining-30-azure: 950
X-AI-RateLimit-Limit-40-cohere: 2000
X-AI-RateLimit-Remaining-40-cohere: 1150
```

If any of the limits configured have been reached, the plugin returns an `HTTP/1.1 429` status
code to the client with the following JSON body:

```plaintext
{ "message": "API rate limit exceeded for provider azure, cohere" }
```

For each provider, it also indicates how long it will take until the quota will be restored:

```plaintext
X-AI-RateLimit-Retry-After-30-azure: 1500
X-AI-RateLimit-Reset-30-azure: 1500
```

If using the request prompt provider, the plugin will send the query cost:

```plaintext
X-AI-RateLimit-Query-Cost: 100
```

The `Retry-After` headers will be present on `429` errors to indicate how long the service is
expected to be unavailable to the client. When using `window_type=sliding` and `RateLimit-Reset`, `Retry-After`
may increase due to the rate calculation for the sliding window.

{:.important}

> **Important**:
> * You can optionally hide the cost, limit, and remaining headers with the `hide_client_headers` option.
> * The headers `RateLimit-Limit`, `RateLimit-Remaining`, and `RateLimit-Reset` are based on the Internet-Draft [RateLimit Header Fields for HTTP](https://datatracker.ietf.org/doc/draft-ietf-httpapi-ratelimit-headers) and may change in the future to respect specification updates.


### Token count strategies

The plugin supports three strategies to calculate the token:

| Strategy    | Description |
| --------- | ---- |
| `total_tokens`   | Represents the total number of tokens, including both the prompt and the generated completion, in the LLM's input sequence. |
| `prompt_tokens` | Represents the tokens provided by the user as input to the LLM, typically defining the context or task. |
| `completion_tokens`   | Represents the tokens generated by the LLM in response to the prompt, representing the completed output or continuation of the task. |

{% if_version gte: 3.8.x %}
| `cost`   | Represents the financial or computational cost incurred based on the tokens used by the LLM during the request. Using this strategy can help you limit API usage based on the actual costs of processing the request, ensuring that expensive requests (in terms of token usage) are managed more carefully. This cost is calculated by taking the sum of multiplying the number of prompt tokens by the cost per prompt token (input cost) and by multiplying the number of completion tokens by the cost per completion token (output cost): `cost = prompt_tokens * input_cost + completion_tokens * output_cost`. The `input_cost` and `output_cost` fields must be defined in the AI Rate Limiting Advanced plugin for this to work. |

{:.important}
> **Important**: If using the `cost` strategy, please make sure to fill the `input_cost` and `output_cost` fields in the ai plugins.
{% endif_version %}

#### Request Prompt Function {#request-prompt-function}

You can decide to use a custom function to count the tokens for a requests. When using the request prompt provider, it will call the function to get the token count at the request level and implement a limit.


## Get started with the AI Rate Limiting Advanced plugin

* [Configuration reference](/hub/kong-inc/ai-rate-limiting-advanced/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-rate-limiting-advanced/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/ai-rate-limiting-advanced/how-to/)

### All AI Gateway plugins

{% include_cached /md/ai-plugins-links.md release=page.release %}
