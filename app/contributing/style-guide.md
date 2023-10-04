---
title: Style guide
---

<!-- vale off -->

## Content best practices

|Best practice                      | ✅&nbsp; Do                                     | ❌&nbsp; Don't                                     |
|---                                |---                                              |---                                                |  
|Use [US English](https://www.merriam-webster.com) (not British English)|  The response **should** look like...|  The response **shall** look like...|
|                                   |In the previous section, you **learned**...    |In the previous section, you **learnt**...         |
|                                   | Color, recognize, analyze                     | Colour, recognise, analyse                        |
|                                   | While                                         | Whilst                                            |
|---                                |---                                            |---                                                |   
|Use present tense                  |This `command` **starts** a proxy.             |This `command` **will start** a proxy.             |
|---                                |---                                            |---                                                |
|Use active voice                   |You can explore the API using a browser.       |The API can be explored using a browser.           |
|                                   |The YAML file specifies the replica count.     |The replica count is specified in the YAML file.   |
|---                                |---                                            |---                                                |
|Use conversational tone            |Run the program.                               |Execute the program.                               |
|                                   |Use the Admin API.                             |Utilize the Admin API.                             |
|                                   |Open the link *to* do the thing.               |Open the link *in order to* do the thing.          |
|---                                |---                                            |---                                                |
|Don’t use Latin phrases            |For example, ...                               |e.g., ...                                          |
|                                   |That is, ...                                   |i.e., ...                                          |
|---                                |---                                            |---                                                |
|Avoid generic pronouns             |Once you have added **the inputs section**, ...|Once you have added **this**, ...                  |
|Don't use _displays_ or _appears_  |Do the thing.                                  |In the blank that **appears**, do the thing.       |
|---                                |---                                            |---                                                |
|Use descriptive headings           |Improve Vitals performance with InfluxDB       |Overview                                           |
|                                   |Query frequency and precision                  |Query behavior                                     |
|---                                |---                                            |---                                                |
|Use sentence case for headings     |Understanding traffic flow in {{site.base_gateway}}     |Understanding Traffic Flow in {{site.base_gateway}}         |
|---                                |---                                            |---                                                |
|Use descriptive link titles instead of "click here" |For more information, see the [style guide](#). | For more information, [click here](#).           |
|                                   |Learn about [content best practices](#) in the Kong style guide. | Learn about content best practices [here](#).|

<!-- vale on -->

## Formatting standards

### Automatic formatting

[Prettier](https://prettier.io/) is used to format all prose and code files. There are three ways to meet this standard:

* Install the [Prettier plugin](https://prettier.io/docs/en/editors.html) for your editor
* Run `npx prettier --write ./your/edited/files.md` in the terminal
* (Maintainers only) Add the `ci:autofix:prettier` label to a Pull Request

All files in `app/_src` are formatted with Prettier. Prose in `app` has not been bulk-formatted and _may_ be formatted as you edit those files

## Content types

At Kong, we use the four following standard content types when we write our documentation:

- [Explanation](https://github.com/Kong/docs.konghq.com/blob/main/docs/templates/explanation-template.md): Documentation that is understanding-oriented because it clarifies and discusses a particular topic.
- [How-to](https://github.com/Kong/docs.konghq.com/blob/main/docs/templates/how-to-template.md): Documentation that is goal-oriented and prescriptive and that takes readers through the steps to complete a real-world problem.
- [Reference](https://github.com/Kong/docs.konghq.com/blob/main/docs/templates/reference-template.md): Documentation that explains the technology, like API or command line documentation.
- [Tutorial](https://github.com/Kong/docs.konghq.com/blob/main/docs/templates/tutorial-template.md): Documentation that helps users learn about a topic by going step-by-step through a series of tasks.

Every documentation page should fit one of these four content types.

## Punctuation rules

- Commas and periods always go inside quotation marks, and colons and semicolons (dashes as well) go outside.
  - For example: “There was a storm last night,” Paul said.

### List punctuation

✅ &nbsp; Do use punctuation when constructing lists that contain full sentences:

{:.note .no-icon}
>In DB-less mode, you configure {{site.base_gateway}} declaratively. Therefore, the Admin API is mostly read-only. The only tasks it can perform are all related to handling the declarative configuration, including:
>
>- Setting a target's health status in the load balancer.
>- Validating configurations against schemas.
>- Uploading the declarative configuration using the `/config` endpoint.

❌ &nbsp; Don't use punctuation when creating ordered and unordered lists that are extensions of a sentence:

{:.note .no-icon}
>Kong Mesh enables the microservices transformation with:
>- Out-of-the-box service connectivity and discovery
>- Zero-trust security
>- Traffic reliability
>- Global observability across all traffic

## Placeholder and example values

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
    

### Inline placeholders

If you're adding a placeholder inline, such as in a sentence, enclose it in single
backticks: \`EXAMPLE_TEXT`

## Capitalization guidelines

Follow the user interface (UI).
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

### Plugin names

1. Capitalize the plugin _name_ but not the word _plugin_. For example, "Rate Limiting plugin".
2. Don’t capitalize the name if you’re using it in code. For example, `rate-limiting`.
3. Don’t capitalize if you’re referring to the concept, not the plugin.
For example, “Set up rate limiting in {{site.base_gateway}} with the Rate Limiting plugin”.

### Kong-specific terms

For product and component names, see [Word Choice](/contributing/word-choice/).

Object/entity names (for example, service, route, upstream) should be lowercase.

## Code formatting

- Separate commands from output.
- Include properly formatted code comments.
- For long commands, split the code block into separate lines with `\`
to avoid horizontal scrolling.
- Never have more than one command in a block/example.
- Set a language for code blocks, for example, bash, to enable syntax highlighting.
    - [List of supported languages](https://github.com/rouge-ruby/rouge/wiki/List-of-supported-languages-and-lexers)
- Do **NOT** use the command prompt marker ($) in code snippets.

### Icons

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

## Links

- Don't use link titles like "Read more" and "Click here". Instead, write descriptive titles that properly detail what content is accessible by clicking the link.
- If the linked content is a larger area like a panel, add a `title` attribute that describes the linked content to the `a` tag.

## Reference style guide

Follow Kong's style guide whenever possible. However, we recommend using the [Google developer style guide](https://developers.google.com/style/) for style and formatting cases that our guide doesn't cover.
