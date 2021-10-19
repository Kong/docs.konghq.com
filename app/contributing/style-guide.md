---
title: Style guide
no_version: true
---

## Content best practices

|Best practice                      |Do                                             |Don't                                              |
|---                                |---                                            |---                                                |  
|Use [US English](https://www.merriam-webster.com) (not British English)|The response **should** look like...|The response **shall** look like...|
|                                   |In the previous section, you **learned**...    |In the previous section, you **learnt**...         |
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
|Use sentence case for headings     |Understanding traffic flow in Kong Gateway     |Understanding Traffic Flow in Kong Gateway         |
|---                                |---                                            |---                                                |

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

### Placeholder values

- Use single curly braces, all caps text, and underscores between words.

    For example: `{EXAMPLE_VALUE}`

    In codeblocks, use [editable placeholders](/contributing/markdown-rules/#placeholders)
    where you want a user to enter their own value.

## Capitalization guidelines

Follow the user interface (UI). If a term is capitalized in the UI, it should be
capitalized in the documentation.

### Kong-specific terms

Capitalize the following Kong-specific terms:

#### Product names

- Kong Konnect (Kong Konnect for first mention, Konnect after)
- Kong Gateway (Enterprise)
- Kong Gateway
- Kong Mesh (Kong Mesh for first mention, Mesh after)
- Insomnia

#### Component names

- Dev Portal
- ServiceHub
- Vitals
- Immunity

### Generic terms

Do not capitalize the following generic terms:
- plugins
- control plane
- data plane
- hybrid mode
- service
- route
- consumer

## Code formatting

- Separate commands from output.
- Include properly formatted code comments.
- For long commands, split the code block into separate lines with `\`
to avoid horizontal scrolling.
- Never have more than one command in a block/example.
- Set a language for codeblocks, for example, bash, to enable syntax highlighting.
    - [List of supported languages](https://github.com/rouge-ruby/rouge/wiki/List-of-supported-languages-and-lexers)
    - If using HTML tags to create a codeblock for editable placeholders,
    see [guidelines for editable placeholders](/contributing/markdown-rules/#editable-placeholders-in-codeblocks)
- Do **NOT** use the command prompt marker ($) in code snippets.

### Inline code formatting

- Enclose sample code with single backticks.<br/>
  For example: \`sudo yum install /path/to/package.rpm`

## Images

- Add files to the corresponding product folder by navigating in the repo from **app > assets > images > docs**.
- When naming/titling image files, use lowercase letters and dashes only.
- Use SVGs whenever possible, otherwise use PNGs.
- Limit image file size to ~2MB.
- Compress and resize images before adding them to the site.
- Do not use shadows.
- Borders can be added to screenshots only `-1px` black.
- Add an `alt` attribute and detailed description of the image.
- **Do not** use GIFs, as they are not accessible and reduce page performance.

## Links

- Don't use link titles like "Read more" and "Click here". Instead, write descriptive titles that properly detail what content is accessible by clicking the link.
- If the linked content is a larger area like a panel, add a `title` attribute that describes the linked content to the `a` tag.

## Reference style guides

- [Valero Style Guide](https://velero.io/docs/v1.5/style-guide/#inline-code-formatting)
- [Splunk Style Guide](https://docs.splunk.com/Documentation/StyleGuide/current/StyleGuide/Howtouse)
- [Microsoft Style Guide](https://docs.microsoft.com/en-us/style-guide/welcome/)
- [Barrie Byron’s admirably curated list of style guides](https://docs.google.com/document/d/1wAVt65UpgBJ4e_tzPCVnPHwOqYYtENuRkojDSq-7nK0/edit)
- [Google Developers Guide](https://developers.google.com/style)
- [Kubernetes](https://kubernetes.io/docs/contribute/style/style-guide/)
