---
nav_title: Using the AI Semantic Prompt Guard plugin
title: Using the AI Semantic Prompt Guard plugin
---

The AI Semantic Prompt Guard configuration takes two arrays of objects: one for `allow` prompts, and
one for `deny` prompts.

## Prerequisites

First, as in the [AI Proxy](/hub/kong-inc/ai-proxy/) documentation, create a service, route, and `ai-proxy` plugin
that will serve as your LLM access point.

You can now create the AI Semantic Prompt Guard plugin at the global, service, or route level, using the following examples.

## Examples

