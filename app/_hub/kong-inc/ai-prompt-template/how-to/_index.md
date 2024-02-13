---
nav_title: Using the AI Prompt Template plugin
title: Using the AI Prompt Template plugin
---

## Variable Syntax

Currently, only "double-curley-brace" mustache-style string placeholders are supported.

For example, in the template, define the prompt and the variable:

```yaml
- name: sample-template
  template: "Explain to me what {{thing}} is."
```

The template call from the consumer would contain a map of the variables to fill in, and must look like:

```json
{
  "prompt": "{template://sample-template}",
  "properties": {
    "thing": "gravity"
  }
}
```

## Allowing Un-Templated Requests

Enable config option `config.allow_untemplated_requests` to allow consumers to continue to call the LLM, even when an explicit template
hasn't been referenced in their request.

## Examples

### `llm/v1/chat`

```json
{
	"messages": "{template://developer-chat}",
	"properties": {
		"language": "python",
		"program": "flask web server"
	}
}
```

### `llm/v1/completions` ('Prompt')

```json
{
	"prompt": "{template://developer-prompt}",
	"properties": {
		"language": "python",
		"program": "flask web server"
	}
}
```

Based on the following plugin configuration, where `program` and `language` are defined as template variables:

```yaml
plugins:
- name: ai-prompt-template
  config:
    allow_untemplated_requests: true
    templates:
    - name: "developer-chat"
      template:  |-
        {
            "messages": [
            {
                "role": "system",
                "content": "You are a {{program}} expert, in {{language}} programming language."
            },
            {
                "role": "user",
                "content": "Write me a {{program}} program."
            }
            ]
        }
    - name: "developer-prompt"
      template:  |-
        {
            "prompt": "You are a {{language}} programming language expert. Write me a {{program}} program."
        }
```
