---
nav_title: Using the AI Sanitizer plugin
title: Using the AI Sanitizer plugin 
---

## Prerequisites

You have an AI PII service. 
We'll use Kong's [AI PII Anonymizer service](https://hub.docker.com/r/kong/ai-pii-service) in these examples.

{:.note}
> This Docker image is private, contact [Kong Support](https://support.konghq.com/support/s/) to get access to it.

## Set up the Kong AI PII Anonymizer service

Run the AI PII service. Substitute your own platform and port number in the following command:

```sh
docker run --platform linux/x86_64 -d --name pii-service -p 9000:8080 kong/ai-pii-service 
```

## Configure the AI Sanitizer plugin

In the following example, we want to sanitize phone numbers and general information (such as person names, locations, and organizations).
Add the following example to a decK file:

```yaml
_format_version: "3.0"
services:
- name: ai-proxy
  url: http://localhost:65535
  routes:
  - name: openai-chat
    paths:
    - /
plugins:
- name: ai-proxy-advanced
  config:
    targets:
    - route_type: llm/v1/chat
      model:
        name: gpt-4o
        provider: openai
        options:
          max_tokens: 512
          temperature: 1.0
      auth:
          header_name: Authorization
          header_value: Bearer $OPENAI_API_TOKEN
- name: ai-sanitizer
  config:
    anonymize:
      - phone
      - general
    port: $SANITIZER_SERVICE_PORT
    host: $SANITIZER_SERVICE_HOST
    redact_type: synthetic
    stop_on_error: true
    recover_redacted: false
```

## Test request sanitization

We're going to pass a message that contains some sensitive data that meets our criteria.

```sh
curl -i -X POST http://localhost:8000/ \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  --data '
        {
          "model": "gpt-4",
          "messages": [
            {
              "role": "system",
              "content": "You are a helpful assistant. Please repeat the following information back to me."
            },
            {
              "role": "user",
              "content": "My name is John Doe, my phone number is 123-456-7890."
            }
          ],
          "stream": false
        }
      '
```

The response should contain a randomized name and phone number, for example:

```sh
"content": "Your name is Mrs. Kelli Smith MD, and your phone number is (555)555-5555.",
```