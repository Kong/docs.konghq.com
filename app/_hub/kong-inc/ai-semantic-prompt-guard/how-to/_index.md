---
nav_title: Using the AI Semantic Prompt Guard plugin
title: Using the AI Semantic Prompt Guard plugin
---

The AI Semantic Prompt Guard configuration takes two arrays of objects: one for `allow` prompts, and
one for `deny` prompts, which it uses to determine which prompts are permitted or blocked.

## Prerequisites

- Create a service and a route
- Start a [Redis](https://redis.io/docs/latest/) instance in your environment

You can now create the AI Semantic Prompt Guard plugin at the global, service, or route level, using the following examples.

## Examples

The following examples show how to configure allow and deny prompts, and the expected behavior when making requests.

### Allow only

For example, to allow only message related to the topic Kong, configure the `allow_prompt` like this:

```yaml
allow_prompts:
- "Anything about Kong"
```

{% navtabs %}

{% navtab Valid %}
```json
{
  "messages": [
    {
      "role": "system",
      "content": "You are an IT specialist."
    },
    {
      "role": "user",
      "content": "What does Kong do?"
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
      "content": "You are an IT specialist."
    },
    {
      "role": "user",
      "content": "What is GitHub?"
    }
  ]
}
```
{% endnavtab %}

{% endnavtabs %}

### Deny only

To deny any questions related to Microsoft, you can configure the following prompt:

```yaml
deny_prompts:
- "Tell me something about Microsoft"
```

{% navtabs %}

{% navtab Valid %}
```json
{
  "messages": [
    {
      "role": "system",
      "content": "You are an IT specialist."
    },
    {
      "role": "user",
      "content": "What is an API?"
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
      "content": "You are an IT specialist."
    },
    {
      "role": "user",
      "content": "When was Microsoft founded?"
    }
  ]
}
```
{% endnavtab %}

{% endnavtabs %}

### Allow and deny

To allow only questions about Kong that are not related to AWS, you can configure the following prompts:

```yaml
allow_prompts:
- "Questions about Kong"
deny_prompts:
- "Anything related to AWS"
```

{% navtabs %}

{% navtab Valid %}
```json
{
  "messages": [
    {
      "role": "system",
      "content": "You are an IT specialist."
    },
    {
      "role": "user",
      "content": "What are Kong's products?"
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
      "content": "You are an IT specialist."
    },
    {
      "role": "user",
      "content": "How to install Git?"
    }
  ]
}
```

```json
{
  "messages": [
    {
      "role": "system",
      "content": "You are an IT specialist."
    },
    {
      "role": "user",
      "content": "Does Kong have an AWS plugin?"
    }
  ]
}
```
{% endnavtab %}

{% endnavtabs %}