---
title: Style guide
no_version: true
---

## Content best practices

|Best practice                      |Do                                             |Don't                                              |
|---                                |---                                            |---                                                |  
|Use present tense                  |This `command` **starts** a proxy.             |This `command` **will start** a proxy.             |
|---                                |---                                            |---                                                |
|Use active voice                   |You can explore the API using a browser.       |The API can be explored using a browser.           |
|                                   |The YAML file specifies the replica count.     |The replica count is specified in the YAML file.   |
|---                                |---                                            |---                                                |
|Use conversational tone            |Run the program.                               |Execute the program.                               |
|                                   |Utilize the Admin API.                         |Use the Admin API.                                 |
|---                                |---                                            |---                                                |
|Don’t use Latin phrases            |For example, ...                               |e.g., ...                                          |
|                                   |That is, ...                                   |i.e., ...                                          |
|---                                |---                                            |---                                                |
|Write short declarative sentences  |                                               |                                                   |
|---                                |---                                            |---                                                |
|Avoid generic prounouns            |Once you have added **the inputs section**, ...|Once you have added **this**, ...                  |
|Don't use displays                 |In the blank that **appears**, do the thing.   | In the blank that **displays**, do the thing.     |
|---                                |---                                            |---                                                |


## Formatting standards

### Markdown elements

#### Headings

- Use sentence case for headings.
   Except Heading level 1s (page title), where you should use title case.

#### Admonitions

- Do not stack admonitions, in other words, list several admonitions one after the other.

  Admonitions should be carefully selected, called-out text.
- Admonition types:
  - **Note:** information concerning program behavior that would not be exptected.
  - **Warning:** information necessary to avoid breaking something or losing data.
  - **Tip:** information that while not necessary could be beneficial to know.

## Punctuation rules

### Placeholder values

## Capitalization guidelines

- Follow the User Interface - if a term is capitalized in the UI, it should be capitalized in the documentation.

### Kong-specific terms

#### Product names
- Kong Konnect (Kong Konnect for first mention, Konnect after)
- Kong Gateway (Enterprise)
- Kong Gateway (
- Kong Mesh (Kong Mesh)
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
- Include properly formatted comments.
- For long commands, split the code block into separate lines.
- Never have more than one command in a block/example.
- Always set a language for codeblocks, for example, bash.
   [List of supported languages](https://github.com/rouge-ruby/rouge/wiki/List-of-supported-languages-and-lexers)

### Codeblock navtabs

### Inline code formatting

## Images

- Use SVGs whenever possible, otherwise use PNGs.
- Limit image file size to ~2MB.
- Do not use shadows.

### Screenshots

### Diagrams

## User Interface text

## Reference style guides

- [Valero Style Guide](https://velero.io/docs/v1.5/style-guide/#inline-code-formatting)
- [Splunk Style Guide](https://docs.splunk.com/Documentation/StyleGuide/current/StyleGuide/Howtouse)
- [Microsoft Style Guide](https://docs.microsoft.com/en-us/style-guide/welcome/)
- [Barrie Byron’s admirably curated list of style guides](https://docs.google.com/document/d/1wAVt65UpgBJ4e_tzPCVnPHwOqYYtENuRkojDSq-7nK0/edit)
- [Google Developers Guide](https://developers.google.com/style)
- [Kubernetes](https://kubernetes.io/docs/contribute/style/style-guide/)
