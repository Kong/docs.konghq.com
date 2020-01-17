---
title: Best Practices for API Design
toc: false
---

### Introduction

Staying up to date on the latest trends in API design helps you create APIs that are simple for application developers to learn and use successfully.

Here you will learn how API design benefits from the following guidelines:

* [Design first, then build](#design-first-then-build)
* [Ease of understanding and usage](#ease-of-understanding-and-usage)
* [Thorough documentation](#thorough-documentation)

## Design first, then build

Before you write a line of code, write down what your API shape should be, how you expect information to pass through it, and how it should respond to the information (including success and error-handling). This plan will provide you with an early opportunity to get feedback and to collaborate with others about the experience of using your API without accruing technical debt. 

Your design should refer to a single source of truth in a portable format such as OpenAPI / AsyncAPI, and it should indicate the transfer protocols format (e.g., GraphQL, Protobuf). That way, your design is easy to maintain, share, and save in source control since it’s in a text file that others can comment on and audit without switching context.

When designing before you build, Kong Studio can help your team collaborate with Import from Git and synchronize changes through the Git Sync feature. Kong Studio can also help you discover issues quickly through linting and previewing.

## Ease of understanding and usage

For an API to be easy to read and use, it should conform to best practices based on its type. For example, the [best practices for REST APIs](https://restfulapi.net/)<a href="#footnote-1"><sup id="note-return-1">1</sup></a> include building around resources and conforming to the HTTP semantics for methods. Not all of those help with a GraphQL API, so there are separate [best practices for GraphQL](https://graphql.org/learn/best-practices/). 

Kong Studio can help conform to either set of best practices, as it understands both REST and GraphQL through OpenAPI. It can generate requests from either type directly from the OpenAPI specification.

## Thorough documentation

Building your API so that it’s easy to read and use is only the first step. Now that you’ve created an intuitive API, it’s time to consider the presentation to your developer audience.  Generating OpenAPI, SDKs, or any other form of _reference documentation_ may not be enough for developers to fully understand and benefit from the value of your API. For guidance, your developers benefit from examples of usage and methods to integrate with other tools, in what we call _behavioral documentation_.

Good Behavioral Documentation consists of the following attributes:

* Examples of Requests / Responses
* Guides on how to perform common actions
* Guides on how to integrate with another popular tool
* Guides on how to build a basically functional service or tool

[Stripe Docs](https://stripe.com/docs) provide an exceptional model of reference documentation and behavioral documentation. Note that reference documentation can also have behavioral components intermixed—it’s not strictly one or the other.  Developers are most likely to learn, experiment, and succeed when you  provide a strong combination of both.

Kong Studio can help you provide thorough documentation by visualizing what your final output looks like and by enabling you to see changes in real time using the Preview feature.

#### Footnotes

<span id="footnote-1">1</span>: This is a great resource, and the comments on the pages often provide additional color, alternative use-cases, and thoughtful counter-arguments or exceptions. <a href="#note-return-1">return</a>
