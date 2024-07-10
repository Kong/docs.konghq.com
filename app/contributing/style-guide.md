---
title: Style guide
---

## Language 

The Kong docs use [American English (US English)](https://en.wikipedia.org/wiki/American_English).
There are some spelling, grammar, and vocabulary differences between American English and other varieties.

Here are some examples:

| ✅&nbsp; Do use (American English) | ❌&nbsp; Don't use (other variations) |
|---                         | ---                         | 
| The response **should** look like... |   The response **shall** look like...|
| In the previous section, you **learned**...   | In the previous section, you **learnt**...  |
| Color, recognize, analyze                     |  Colour, recognise, analyse                 |
| While                                         |  Whilst                                     |

## Voice and tone

Write for people, not computers. You are human, Kong's users are human -- let's write for each other.

At Kong, we try to keep our tone **conversational**, but not at the expense of clarity.
We keep language simple and concise, take things seriously when we need to, and keep our readers in mind in whatever we write.

Here are some examples of parallel conversational and formal terms and phrasing:

<!--vale off-->

| ✅&nbsp; Do use       | ❌&nbsp; Don't use |
|---                    | ---                |
| *Run* the program.    | *Execute* the program. |
| *Use* the Admin API.  | *Utilize* the Admin API. |
| Open the link *to* do the thing. | Open the link *in order to* do the thing. |
| In the open tab, do the thing. | In the open tab that *appears*, do the thing. <br> In the open tab that *displays*, do the thing. |
| Clearly refer to subjects. <br>For example, say "Once you have added *the inputs section*, ..." | Avoid generic pronouns. <br> For example, don't say "Once you have added *this*, ..." |

<!-- vale on-->

### Active voice

Use active voice, and avoid passive voice. 

With active voice, the subject performs an action. With passive voice, the action is being performed upon the subject:

| ✅&nbsp; Active       | ❌&nbsp; Passive |
|---                    | ---               |
| The plugin *applies* rate limiting to consumers. | Rate limits *are applied to* consumers by the plugin. |
| You *can explore* the API using a browser. | The API *can be explored* using a browser.  |
| The YAML file *specifies* the replica count. | The replica count *is specified* in the YAML file.   |

There are exceptions to this guideline.
You might use passive voice to communicate that the subject is passive and is having something done to it.

For example: "The CA provider's external account can be registered automatically". 
In this sentence, the account is passive and isn't doing anything, so you can use passive voice.

### Present tense

Whenever possible, use present tense instead of past or future.

| ✅&nbsp; Do use     | ❌&nbsp; Don't use |
|---                  | ---                |
|This `command` *starts* a proxy.          | This `command` *will start* a proxy.  |
|This `command` *starts* a proxy.          | This `command` *has started* a proxy.     |

### Contractions

Don't be afraid to use contractions (*can't*, *isn't*, *you'll*, and so on)! It adds to the conversational tone.

As with everything, there are exceptions to the rule.
You can omit contractions when aiming for a more serious tone, typically to emphasize a warning or caution.

For example, you might use a contraction in a phrase like "This plugin **isn't** available in Konnect" to let a reader know about plugin availability.
On the other hand, you might say "**Do not** use this plugin in Konnect because it will break things" to warn them about potential consequences.

### Latin phrases

Don't use Latin phrases or short forms. Use the english version of the same phrase.

| ✅&nbsp; Do use    | ❌&nbsp; Don't use |
|---                 | ---         |  
| For example, ...   | e.g., ...   |
| That is, ...       | i.e., ...   |
| So (or therefore), ...      | Ergo, ...   |

### Recommendations

Recommendations should have a reason. If you’re recommending an approach, explain why.

A recommendation should apply to most users. It’s not a suggestion. 
For example, we wouldn’t recommend DB-less mode without context, but we could recommend it in a specific use case that explains why.

When recommending a course of action, use the phrase "we recommend". 

| ✅&nbsp; Do use    | ❌&nbsp; Don't use |
|---                 | ---                | 
| **We recommend** using an access token **because it's more secure**. | **Kong recommends** using an access token. |
| **We don't recommend** storing a password in plaintext **because it's not secure**. | **It is recommended** that you use an access token. |

## Grammar and syntax

### Punctuation rules

Commas and periods always go inside quotation marks, and colons, semicolons, and dashes go outside.

For example: “There was a storm last night,” Paul said.

#### List punctuation

✅ &nbsp; Do use punctuation when constructing lists that contain full sentences:

{:.note .no-icon}
>In DB-less mode, you configure {{site.base_gateway}} declaratively. Therefore, the Admin API is mostly read-only. The only tasks it can perform are all related to handling the declarative configuration, including:
>
>- Setting a target's health status in the load balancer.
>- Validating configurations against schemas.
>- Uploading the declarative configuration using the `/config` endpoint.

❌ &nbsp; Don't use punctuation when creating ordered and unordered lists that are extensions of a sentence:

{:.note .no-icon}
>{{site.mesh_product_name}} enables the microservices transformation with:
>- Out-of-the-box service connectivity and discovery
>- Zero-trust security
>- Traffic reliability
>- Global observability across all traffic

### Headings and page titles

When writing section headings or page titles, be descriptive. 
What is someone going to do in this section, or on this page? 
If it's an overview, what is it an overview of?

For example:

| ✅&nbsp; Do use | ❌&nbsp; Don't use |
|---              | ---                |
| {{site.base_gateway}} Overview | Overview |
| Improve Vitals performance with InfluxDB | InfluxDB  |
| Query frequency and precision    | Query behavior    |

Use sentence case for section headings. For example:

| ✅&nbsp; Do use | ❌&nbsp; Don't use |
|---              | ---                |  
| Understanding traffic flow in {{site.base_gateway}} | Understanding Traffic Flow in {{site.base_gateway}} |
| Get started with the Request Transformer Advanced plugin | Get Started with the Request Transformer Advanced Plugin |

### Capitalization

When documenting a user interface (UI), follow its formatting.
If a term is capitalized in the UI and you are referring to the specific UI element, it should be capitalized in the documentation.

Don't capitalize the following terms:

- application
- certificate
- consumer
- control plane
- database
- data plane
- developer
- hybrid mode
- plugin
- route
- service
- service mesh
- target
- upstream

#### Plugin name capitalization

1. Capitalize the plugin _name_ but not the word _plugin_. For example, "Rate Limiting plugin".
2. Don’t capitalize the name if you’re using it in code. For example, `rate-limiting`.
3. Don’t capitalize if you’re referring to the concept, not the plugin.
For example, “Set up rate limiting in {{site.base_gateway}} with the Rate Limiting plugin”.

#### Kong-specific term capitalization

For product and component names, see [Word Choice](/contributing/word-choice/).

Object/entity names (for example, service, route, upstream) should be lowercase.

## Formatting

### Automatic formatting

[Prettier](https://prettier.io/) is used to format all prose and code files. There are three ways to meet this standard:

* Install the [Prettier plugin](https://prettier.io/docs/en/editors.html) for your editor
* Run `npx prettier --write ./your/edited/files.md` in the terminal
* (Maintainers only) Add the `ci:autofix:prettier` label to a Pull Request

All files in `app/_src` are formatted with Prettier. Prose in `app` has not been bulk-formatted and _may_ be formatted as you edit those files.

### Content types

At Kong, we use the four following standard content types when we write our documentation:

- [Explanation](https://github.com/Kong/docs.konghq.com/blob/main/docs/templates/explanation-template.md): Documentation that is understanding-oriented because it clarifies and discusses a particular topic.
- [How-to](https://github.com/Kong/docs.konghq.com/blob/main/docs/templates/how-to-template.md): Documentation that is goal-oriented and prescriptive and that takes readers through the steps to complete a real-world problem.
- [Reference](https://github.com/Kong/docs.konghq.com/blob/main/docs/templates/reference-template.md): Documentation that explains the technology, like API or command line documentation.
- [Tutorial](https://github.com/Kong/docs.konghq.com/blob/main/docs/templates/tutorial-template.md): Documentation that helps users learn about a topic by going step-by-step through a series of tasks.

Every documentation page should fit one of these four content types.

### Placeholder and example values

The type of placeholder you use depends on context:

* **Generic placeholder values:** In most situations (such as plugin parameters, YAML examples, or Kong configuration), use all caps text and underscores between words.

    For example: `service: SERVICE_NAME`

* **Placeholders in API URLs or OpenAPI specs**: Enclose placeholders in `{ }` characters and write them in all caps,
per [Swagger guidelines](https://swagger.io/docs/specification/describing-parameters/).
    
    For example: `/services/{SERVICE_NAME|ID}/plugins`

* **Hostnames and example URLs:**
    * For guides with examples that are intended to be runnable as-is, use `localhost` as the domain name.

        For example: `curl -i -X https://localhost:8001/services`

        If you are following a guide where {{site.base_gateway}} is running on `localhost`, this example can be copied and pasted straight into a terminal.
        It should work with no changes.

    * For situations where you need a generic domain name and the examples are illustrative only (not intended to be runnable as-is), use `example` or `example.com`.

        For example: `user@example.com` or `https://example.okta.admin.com`
* **Path parameters**
    * Path parameters must be denoted with curly braces `{}`.
    
        For example: `http://localhost:8001/services/{service_id_or_name}/routes/{route_id_or_name}`
    
#### Inline placeholders

If you're adding a placeholder inline, such as in a sentence, enclose it in single
backticks: \`EXAMPLE_TEXT`

### Code formatting

- Separate commands from output.
- Include properly formatted code comments.
- For long commands, split the code block into separate lines with `\`
to avoid horizontal scrolling.
- Never have more than one command in a block/example.
- Set a language for code blocks, for example, bash, to enable syntax highlighting.
    - [List of supported languages](https://github.com/rouge-ruby/rouge/wiki/List-of-supported-languages-and-lexers)
- Do **NOT** use the command prompt marker ($) in code snippets.

## Icons

When deciding which icon to use for a doc, use the following guidelines:

1. Is there a Unicode version?

   We use Unicode for common icons such as ✅&nbsp; and ❌&nbsp;. You can copy and paste a
   Unicode icon directly into markdown.

2. Is there a Font Awesome icon?

   We also use the free version of Font Awesome to supplement Unicode icons.
   Check out [their catalog](https://fontawesome.com/v5/search?m=free) to find
   an icon code, then see our [icon usage instructions](/contributing/markdown-rules/#icons).

3. Does the [`/_assets/images/icons/`](https://github.com/Kong/docs.konghq.com/tree/main/app/assets/images/icons)
   folder contain the icon that you're looking for?

   For custom icons, we have to import them manually. This includes all of the
   icons used in docs navigation and all icons that are used for UI labels in
   {{site.konnect_short_name}} and Kong's UIs. If you find one, see our
   [icon usage instructions](/contributing/markdown-rules/#icons).

4. If the answer to all of the above is "no", you can
   [upload a custom image](/contributing/markdown-rules/#icons).

## Documenting third-party tools

Our documentation sometimes requires integration with third-party tools and services to help users succeed with our products. 
As a general rule, we try to avoid rewriting docs that exist elsewhere. When writing docs that involve interactions with third-party tools and services, think about the following:

* Does the third-party app have a complete doc in their own documentation that covers the process?
* Does the process include a lot of custom configuration of the third-party product to get it to work with Kong? 
* Do you need to switch back and forth between Kong and the third-party to complete a task?

Depending on your answers, you should:
* **Link to third-party documentation**: Always link to the official documentation of third-party products.
In many cases, a link is enough, often as part of a step or a group of prerequisites. Here's a doc that uses this method:
  * [Add Developer Teams from Identity Providers](/konnect/dev-portal/access-and-approval/add-teams/)
  
* **Include third-party instructions with integrations**: Provide instructions that involve switching between products, and include links to the official third-party documentation when possible. For example:
  * [How to configure Transit Gateways](/konnect/gateway-manager/data-plane-nodes/transit-gateways/)

### Pitfalls to avoid

To reduce maintenance challenges when documenting third-party instructions, avoid the following:

* **Do not** include screenshots of third-party UIs.
* Do not refer to specific UI elements:
  * ❌&nbsp; **Don't use**: "Click the blue **Add** button in the top-right corner."
  * ✅&nbsp; **Use**: "Click **Add**."

* Describe the necessary variables, but do not specify their location in the UI:
  * ❌&nbsp; **Don't use**:  "Enter the API key found in the **Security tab** under **API Settings**."
  * ✅&nbsp; **Use**: "Enter the API key provided by your API provider."

## Links

Write descriptive titles that make it clear what the reader is getting by clicking the link.
Don't use link titles like "Read more" and "Click here":

| ✅&nbsp; Do use      | ❌&nbsp; Don't use |
|---                 | ---         |  
|For more information, see the [style guide](#). |  For more information, [click here](#).       |
|Learn about [content best practices](#) in the Kong style guide. |  Learn about content best practices [here](#).|

If the linked content is a larger area like a panel, add a `title` attribute that describes the linked content to the `a` tag.

## Reference style guide

Follow Kong's style guide whenever possible. However, we recommend using the [Google developer style guide](https://developers.google.com/style/) for style and formatting cases that our guide doesn't cover.
