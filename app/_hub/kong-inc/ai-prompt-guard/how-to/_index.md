---
nav_title: Using the AI Prompt Guard plugin
title: Using the AI Prompt Guard plugin
---

The AI Prompt Guard configuration takes two arrays of objects: one for "allow" patterns, and
one for "deny" patterns, for example in a financial processing/auditing model:

{:.note}
> This plugin currently supports the `llm/v1/chat` type request only.

## Usage

First, as in the [AI Proxy](/hub/kong-inc/ai-proxy/) documentation, create a service, route, and `ai-proxy` plugin
that will serve as your LLM access point.

Now create the `ai-prompt-decorator` plugin at global, service, or route level, using the examples that follow.

## Examples

### Card Numbers Adherence

For requests to pass through in this example, any of the "user" role messages in the prompt
must have all "card" fields adhering to this standard (starts with number 4, for 16 characters).

```yaml
allow_patterns:
  - '\"card\".*\"4[0-9]{12}(?:[0-9]{3})?\"'
```

{% navtabs %}

{% navtab Valid %}
```json
{
  "messages": [
    {
      "role": "system",
      "content": "Use the default card processing validation rules."
    },
    {
      "role": "user",
      "content": "Validate this card: {\"card\": \"4111111111111111\",\"cvv\": \"000\"}"
    }
  ]
}
```
{% endnavtab %}

{% navtab Invalid %}
```json
{
  "messages": [
    {
      "role": "system",
      "content": "Use the default card processing validation rules."
    },
    {
      "role": "user",
      "content": "Validate this card: {\"card\": \"5111111111111111\",\"cvv\": \"000\"}"
    }
  ]
}
```
{% endnavtab %}

{% endnavtabs %}
