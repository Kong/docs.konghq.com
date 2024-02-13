---
nav_title: Using the AI Prompt Decorator plugin
title: Using the AI Prompt Decorator plugin
---

## Overview

The AI Prompt Decorator configuration takes two arrays of objects: one for prepending messages, and
one for appending messages, in the following standardized format:

```yaml
- role: "<system, assistant, or user>"
  content: "<message content>"
```

This translates into the corresponding JSON format, and is attached to the beginning, or the end,
of the caller's chat `messages` array, depending on the plugin configuration.

{:.note}
> This plugin currently supports the `llm/v1/chat` type request only.

## Prerequisites

First, as in the [AI Proxy](/hub/kong-inc/ai-proxy/) documentation, create a service, route, and `ai-proxy` plugin
that will serve as your LLM access point.

You can now creat the `ai-prompt-decorator` plugin at global, service, or route level, using the following examples.
s
## Examples

### Prompt engineering

To engineer a prompt that will always respond in French, configure the plugin to always prepend the system
prompt as required:

```yaml
config:
  prepend:
    - role: "system"
      content: "You will always respond in the French (France) language."
```

Now a Kong consumer makes a call to the configured LLM, and this message is prepended to each call:

```json
{
  "messages": [
    // Plugin-injected prepend message:
    {
      "role": "system",
      "content": "You will always respond in the French (France) language."
    },

    // Caller's original request:
    {
      "role": "system",
      "content": "You are a legal document auditor."
    },
    {
      "role": "user",
      "content": "Please audit this base64-encoded PDF based on my configured rules: QkVHSU4tRE9DVFlQRS1QREYtLi4uLS4uLi0uLi4....."
    }
  ]
}
```

### Chat history

To engineer a complex chat history that can be continued by any user, configure the plugin to both prepend
and append **multiple** messages.

The ordering on each side is preserved in all cases (first in, first out):

```yaml
config:
  prepend:
    - role: "system"
      content: "You are a scientist, specialising in survey analytics."
    - role: "user"
      content: "Classify this test result set as positive, negative, or neutral."
    - role: "assistant"
      content: "These tests are NEUTRAL."
  append:
    - role: "user"
      content: "Do not mention any real participants' names in your justification."
```

After plugin execution, the LLM request will look like this:

```json
{
  "messages": [
    // Plugin-injected prepend messages:
    {
      "role": "system",
      "content": "You are a scientist, specialising in survey analytics."
    },
    {
      "role": "user",
      "content": "Classify this test result set as positive, negative, or neutral."
    },
    {
      "role": "assistant",
      "content": "These tests are NEUTRAL."
    },

    // Caller's original request:
    {
      "role": "user",
      "content": "These are the updated results, does it change the classification? <new_test_results>"
    },

    // Plugin-injected append message:
    {
      "role": "user",
      "content": "Do not mention any real participants' names in your justification."
    }
  ]
}
```
