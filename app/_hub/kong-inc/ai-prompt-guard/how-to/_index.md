---
nav_title: Using the AI Prompt Guard plugin
title: Using the AI Prompt Guard plugin
---

The AI Prompt Guard configuration takes two arrays of objects: one for `allow` patterns, and
one for `deny` patterns.

## Prerequisites

First, as in the [AI Proxy](/hub/kong-inc/ai-proxy/) documentation, create a service, route, and `ai-proxy` plugin
that will serve as your LLM access point.

You can now create the `ai-prompt-decorator` plugin at global, service, or route level, using the following examples.

## Examples

The following examples show allow and deny patterns used in a financial processing auditing model.

### Card numbers adherence ("Allow Only")

For requests to pass through in this example, any of the `user` role messages in the prompt
must have all `card` fields adhering to this standard (starts with integer 4, then 3 integers,
and finally 12 asterisks).

This plugin would prevent accidental processing (and/or subsequent model training) where full
card numbers are sent in.

```yaml
allow_patterns:
  - '.*\"card\".*\"4[0-9]{3}\*{12}\"'
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
      "content": "Validate this card: {\"card\": \"4111************\", \"cvv\": \"000\"}"
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
      "content": "Validate this card: {\"card\": \"4111111111111111\",\"cvv\": \"000\"}"
    }
  ]
}
```
{% endnavtab %}

{% endnavtabs %}

### Card numbers adherence ("Deny Only")

For requests to pass through in this example, an inverse of the above, any of the `user` role messages
in the prompt **must not** be a card number field that starts with `5`. 

```yaml
deny_patterns:
  - '\"card\".*\"5[0-9]{12}(?:[0-9]{3})?\"'
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

### Valid products ("Allow AND Deny rules")

{:.note}
> This example uses an `ai-proxy` plugin that has been configured for the `llm/v1/completions` route type.
> It expects only one JSON field: a `prompt` string.

For requests to pass through in this example, the message(s) from the callers to our audit LLM request:
* **Must** contain at least one of the product names in the allow list
* **Must not** contain any of the product names in the deny list

```yaml
allow_patterns:
  - ".*(P|p)ears.*"
  - ".*(P|p)eaches.*"
deny_patterns:
  - ".*(A|a)pples.*"
  - ".*(O|o)ranges.*"
```

{% navtabs %}

{% navtab Valid %}
```json
{
  "prompt": "Get me prices for: Pears"
}
```
{% endnavtab %}

{% navtab Neutral (Rejected) %}
```json
{
  "prompt": "Get me prices for: Strawberries"
}
```
{% endnavtab %}

{% navtab Invalid %}
```json
{
  "prompt": "Get me prices for: Oranges"
}
```
{% endnavtab %}

{% endnavtabs %}
