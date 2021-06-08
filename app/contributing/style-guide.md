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
|Avoid generic prounouns            |Once you have added **the inputs section**, ...|Once you have added **this**, ...                  |
|Don't use displays                 |In the blank that **appears**, do the thing.   |In the blank that **displays**, do the thing.      |
|---                                |---                                            |---                                                |
|Use descriptive headings           |Overview                                       |Improve Vitals performance with InfluxDB           |
|                                   |Query behavior                                 |Query frequency and precision                      |
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

### Placeholder values

## Capitalization guidelines

Follow the user interface(UI). If a term is capitalized in the UI, it should be capitalized in the documentation.

### Kong-specific terms

Capitalize the following Kong-specific terms:

#### Product names
- Kong Konnect (Kong Konnect for first mention, Konnect after)
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
- For long commands, split the code block into separate lines to avoid horizontal scrolling.
- Never have more than one command in a block/example.
- Always set a language for codeblocks, for example, bash.<br/>
  [List of supported languages](https://github.com/rouge-ruby/rouge/wiki/List-of-supported-languages-and-lexers)

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
