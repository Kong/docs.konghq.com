---
title: Style guide
no_version: true
---

<!-- vale off -->

## Content best practices

|Best practice                      | ✅&nbsp; Do                                     | ❌&nbsp; Don't                                     |
|---                                |---                                              |---                                                |  
|Use [US English](https://www.merriam-webster.com) (not British English)|  The response **should** look like...|  The response **shall** look like...|
|                                   |In the previous section, you **learned**...    |In the previous section, you **learnt**...         |
|                                   | Color, recognize, analyze                     | Colour, recognise, analyse                        |
|Use present tense                  |This `command` **starts** a proxy.             |This `command` **will start** a proxy.             |
|---                                |---                                            |---                                                |
|Use active voice                   |You can explore the API using a browser.       |The API can be explored using a browser.           |
|                                   |The YAML file specifies the replica count.     |The replica count is specified in the YAML file.   |
|---                                |---                                            |---                                                |
|Use conversational tone            |Run the program.                               |Execute the program.                               |
|                                   |Use the Admin API.                             |Utilize the Admin API.                             |
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

<!-- vale on -->

## Formatting standards

### Admonitions

- Do not stack admonitions, in other words, list several admonitions one after the other.<br/>
  Admonitions should be carefully selected, called-out text.
- Admonition types:
  - **Note:** Information concerning behavior that would not be expected, but won't break anything if it's not followed.
  - **Warning:** Information necessary to avoid breaking something or losing data.
  - **Important:** Information that the reader really needs to pay attention to, otherwise things won't work.
For more information about formatting admonitions see [markdown-rules](/contributing/markdown-rules/#admonitions).

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

* **URLs:**
    * For guides with examples that are intended to be runnable as-is, use `localhost` as the domain name.

        For example: `curl -i -X https://localhost:8001/services`

        If you are following a guide where {{site.base_gateway}} is running on `localhost`, this example can be copied and pasted straight into a terminal.
        It should work with no changes.

    * For situations where you need a generic domain name and the examples are illustrative only (not intended to be runnable as-is), use `example` or `example.com`.

        For example: `user@example.com` or `https://example.okta.admin.com`

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

For product and component names, see [Word Choice](/contributing/word-choice).

Object/entity names (for example, service, route, upstream) should be lowercase.

## Code formatting

- Separate commands from output.
- Include properly formatted code comments.
- For long commands, split the code block into separate lines with `\`
to avoid horizontal scrolling.
- Never have more than one command in a block/example.
- Set a language for code blocks, for example, bash, to enable syntax highlighting.
    - [List of supported languages](https://github.com/rouge-ruby/rouge/wiki/List-of-supported-languages-and-lexers)
    - If using HTML tags to create a code block for editable placeholders,
    see [guidelines for editable placeholders](/contributing/markdown-rules/#editable-placeholders-in-codeblocks)
- Do **NOT** use the command prompt marker ($) in code snippets.

### Inline code formatting

- Enclose sample code with single backticks.<br/>
  For example: \`sudo yum install /path/to/package.rpm`

## Screenshots

You can use screenshots to express the capabilities, look and feel, and experience of a feature in situations where exclusively using text would make the documentation harder to understand. We recommend writing the documentation first, **without** using screenshots, and then assessing if a screenshot would enhance the documentation.

Screenshots are used to support documentation and do not _replace_ documentation. In some cases, using wireframes in place of screenshots is easier to maintain. Otherwise, all screenshots must follow these guidelines.

- Screenshots must be taken with browser developer tools.
- Resolution should be set to **1500x843.75**.
- Screenshots of UI elements should include only the relevant **panel**. Panels are a container within a UI window which contain multiple related elements.
- Mouse should not be visible.
- Emphasis can be added by creating a **square** border around the point of interest. The border must use the color `#0788ad` from the [colors style guide](https://kongponents.netlify.app/style-guide/colors.html).
- In situations that require it a `1px` black border can be used.
- **Do not** use GIFs.
- Limit image file size to ~2MB.
- Add files to the corresponding product folder by navigating in the repo from **app > _assets > images > docs**.
- Use lowercase letters and dashes when naming an image file.

### Icons

When deciding which icon to use for a doc, use the following guidelines:

1. Is there a Unicode version?

   We use Unicode for common icons such as ✅&nbsp; and ❌&nbsp;. You can copy and paste a
   Unicode icon directly into markdown.

2. Is there a Font Awesome icon?

   We also use the free version of Font Awesome to supplement Unicode icons.
   Check out [their catalog](https://fontawesome.com/v5/search?m=free) to find
   an icon code, then see our [icon usage instructions](/contributing/markdown-rules/#icons).

3. Does the [`/_assets/images/icons/`](https://github.com/Kong/docs.konghq.com/tree/main/app/_assets/images/icons)
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
