---
nav_title: Overview
---

The AI Prompt Template plugin lets you provide tuned AI prompts to users. Users only need to fill in the blanks with variable placeholders in the following format: `{% raw %}{{variable}}{% endraw %}`. This lets admins set up templates, which can be then be used by anyone in the organization.

This plugin also sanitises string inputs to ensure that JSON control characters are escaped, preventing arbitrary prompt injection.

{:.note}
> This plugin extends the functionality of the [AI Proxy plugin](/hub/kong-inc/ai-proxy/), and requires AI Proxy to be configured first. Check out the [AI Gateway quickstart](/) to get an AI proxy up and running within minutes!

## How it works

When activated, the AI Prompt Template plugin looks for template references in the following forms:

Chat:
```json
{
	"messages": "{template://developer-chat}",
	"properties": {
		"language": "python",
		"program": "flask web server"
	}
}
```

Prompt:
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

## Get started with the AI Prompt Template plugin

* [AI Gateway quickstart](/)
* [Configuration reference](/hub/kong-inc/ai-prompt-template/configuration/)
* [Basic configuration example](/hub/kong-inc/ai-prompt-template/how-to/basic-example/)
* [Learn how to use the plugin](/hub/kong-inc/ai-prompt-template/how-to/)

### Other AI plugins

You may also be interested in the following AI plugins:
* [AI Proxy](/hub/kong-inc/ai-proxy/)
* [AI Request Transformer](/hub/kong-inc/ai-request-transformer/)
* [AI Response Transformer](/hub/kong-inc/ai-request-transformer/)
* [AI Prompt Guard](/hub/kong-inc/ai-prompt-guard/)
* [AI Prompt Decorator](/hub/kong-inc/ai-prompt-decorator/)