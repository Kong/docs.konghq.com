---
title: Style guide
---

<!-- https://github.com/vmware-tanzu/velero/blob/main/site/content/docs/main/style-guide.md - use markdown snippets for help -->

<!-- > **TO DO: Heather to format this page.** -->


## Content best practices

### Use present tense

|Do|Don't|
|--- |--- |
|This `command` starts a proxy.|This command will start a proxy.|

### Use active voice

|Do|Don't|
|--- |--- |
|You can explore the API using a browser.|The API can be explored using a browser.|
|The YAML file specifies the replica count.|The replica count is specified in the YAML file.|


### Use conversational tone

|Do|Don't|
|--- |--- |
|Run the program.|Execute the program.|
|Utilize the Admin API.|Use the Admin API.|

### Don’t use Latin phrases

|Do|Don't|
|--- |--- |
|For example, ...|e.g., ...|
|That is, ...|i.e., ...|

### Write short declarative sentences


## Patterns to avoid

|Do|Don't|
|--- |--- |
|Remove "which" and "that". | This will be that. |
|In the blank that appears, do the thing. | In the blank that displays, do the thing. |

## Documentation formatting standards

### Use sentence case for headings.
  Except Heading level 1s (page title), where you should use title case.

### Use punctuation inside quotes

### Use appropriate capitalization for terms

### Use appropriate punctuation around placeholder values
For instance:
- Angle brackets
- Double braces
- Singles braces
- Curly braces
All caps or not
Titles


## Kong word list
Appropriate capitalization for terms
Service, Route, Consumer, Upstream: when do you capitalize?
These are objects/entities in Gateway
Do not capitalize plugins, control plane, data plane, hybrid mode
Capitalization
Object names are capitalized
Follow the User Interface
Be clear with your subject and use functionality words instead of the product name to describe an action, versus using the product name. For example, “the gateway does this” or “mesh”
Do capitalize
Product names
Kong Konnect (Kong Konnect for first mention, Konnect after)
Kong Gateway (Enterprise)
Kong Gateway (
Kong Mesh (Kong Mesh)
Insomnia
Component name
Dev Portal
ServiceHub
Vitals
Immunity

Dev Portal is Kong’s developer portal offering
Don’t capitalize
service
route
consumer


## Code formatting
<<See Valero style guide>>
Separating commands and output
Only include the command, not the response
Comments are allowed
For long commands, split into separate lines
Never have more than one command in a block/example
Inline code formatting
Always set a language for codeblocks (For example: bash)
List of languages: https://github.com/rouge-ruby/rouge/wiki/List-of-supported-languages-and-lexers
When and how to use codeblock navtabs
Don’t use the command prompt marker ($) in code snippet
adding a class for a code block for whatever language you are in
if it’s a command, add a code class (CSS will handle formatting)
always set a language for codeblocks (For example: bash)
when and how to use codeblock navtabs
the CSS will add the code prompt


## Markdown elements
Headings
Paragraphs
Links
List
Tables
Tabs
Admonitions
Don’t stack notes
Have a note, and have bulleted items if multiple items in the section
Warning/important/tip/note
When do you use each one?
When is adding any of these elements even appropriate?
Note what you would not normally expect
Warning: things that’ll break everything
Important: something you really need to consider
Note: ???
Tip: something that might help you improve


Example: > This is my note.
{:.note-warning}


## Images
When should you use an image/diagram? What about a screenshot?
Idea: screencaps made in Figma? Simplified mocks
If user can figure it out without a screenshot, don’t use a screenshot
Filetypes: SVG whenever possible? Otherwise, use PNGs
SVGs are editable and readable by screen readers -- if you externalize the strings iirc (well, that’s the part that makes them easier to localize)
File size limits: 2MB
Image dimensions:
Where do we host images? On github, under app/assets
Naming guidelines
Borders, shadowing?
No shadows
Borders potentially only on screenshots; 1px black?
Diagrams
<<add examples here>>

User Interface
<<add examples here>>


## Accessibility guidelines
Should be integrated in each section
Might be exceptions
Colours and contrast
Alt text for images
How do you write alt text?
When do you write alt text?
Minimal text in images (need bad and good examples)

## Doc set architecture common sections
Overview or Introduction?
Release notes:
Changelog
Release Notes
Updates topic
Deployment/Installation?
Getting Started


## Reference style guides
Valero Style Guide https://velero.io/docs/v1.5/style-guide/#inline-code-formatting
Splunk Style Guide https://docs.splunk.com/Documentation/StyleGuide/current/StyleGuide/Howtouse
Microsoft Style Guide https://docs.microsoft.com/en-us/style-guide/welcome/
Barrie Byron’s admirably curated list of style guides https://docs.google.com/document/d/1wAVt65UpgBJ4e_tzPCVnPHwOqYYtENuRkojDSq-7nK0/edit
Google Developers Guide https://developers.google.com/style
Kubernetes https://kubernetes.io/docs/contribute/style/style-guide/
