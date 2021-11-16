---
title: Plugin docs
no_version: true
---

> WORK IN PROGRESS

## Add a new plugin doc for a Kong Inc plugin

1. Create a publisher directory at`_app/_hub/`, such as
 `_app/_hub/your-GitHub-handle` (if you are contributing as an individual)
 or `_app/_hub/company-name` (if you are contributing as a company). See other Kong Hub listings for examples of publisher names.
1. Create a subdirectory for your extension within your publisher directory -
such as `_app/_hub/your-name/your-extension`.
1. Copy the `/app/_hub/_init/my-extension/index.md` file into your extension's
subdirectory. If you are publishing a single version of your extension, which is typical to
start with, then the file name `index.md` should remain.
1. Edit your `index.md` file based on the guidance in comments in that file -
you'll find lots of helpful examples in other extension files. If you are
documenting a Kong plugin, be sure to see the next section.
1. Custom logos are required for publication on the Kong plugin hub. Custom logos
should be a square-format PNG file,
with no transparency, and 120x120 pixels in size. Add the logo file to
`/app/_assets/images/icons/hub/` - the filename of your image should be
`publisher_extension` using the "publisher" and "extension" name from step 2.
1. Be sure to run the docs site locally per the instructions in
the README - you should find your Hub contribution listed at
`localhost:3000/hub`
1. Once you are happy with your listing, push your branch to the GitHub repository
  ```
  git push --set-upstream origin [name_of_your_new_branch]
  ```
1. Find [your branch](https://github.com/Kong/docs.konghq.com/branches/yours) and make [a Pull Request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request) to add your documentation to the Kong Hub. [Having trouble, or have questions?](#where-to-seek-help)

Kong staff will review your PR, suggest improvements and adjustments as
necessary, and once approved, will merge and deploy your Kong Hub addition!


## Writing plugin documentation

Plugins are documented as extensions under `app/_hub/` - please look at
the existing plugins for examples, and see additional advice in
`app/_hub/_init/my-extension/index.md`.

* `description` - text to be added in the Description section. Use YAML's
  [pipe notation](https://stackoverflow.com/questions/15540635/what-is-the-use-of-pipe-symbol-in-yaml)
  to write multi-paragraph text. Note that due to the order that data
  is generated, you may not use forward-references in links (e.g. use
  `[example](http://example.com)` and not `[example][example]` pointing to
  an index at the end).
* `desc` (string, required) - a short, one-line description of the extension.
* `type` (array, required) - what kind of extension this is: `plugin` or
`integration` are supported at this time, though more types will be considered.
* `params`
  * `name` - the name of the plugin as it is referred to in Kong's config and Kong's
  Admin API (not always the same spelling as the page name)
  * `api_id` - boolean - whether this plugin can be applied to an API.
  Affects the generation of examples and config table.
  * `route_id` - boolean - whether this plugin can be applied to a Route.
  Affects the generation of examples and config table.
  * `service_id` - boolean - whether this plugin can be applied to a Service.
  Affects the generation of examples and config table.
  * `consumer_id` - boolean - whether this plugin can be applied to a Consumer.
  Affects the generation of examples and config table.
  * `config` - the configuration table.
  Each entry is a configuration item with the following fields:
    * `name` - the field name as read by Kong
    * `required` - `true` if required, `false` if optional, `semi`
    if semi-required (required depending on other fields)
    * `default` - the default value. If using Markdown
    (e.g. to make values appear type-written), wrap it in double-quotes like
    ``"`foobar`"``
    * `value_in_examples` - if the field is to appear in examples, this is
    the value to use. A required field with no `value_in_examples` entry
    will resort to the one in `default`.
    * `description` - description of the field.
    Use YAML's pipe notation if writing longer Markdown text.

## Custom plugins and documentation

The Kong Plugin Hub is documentation site. We do not host plugin source code or downloads.

If you want to write a custom plugin for your own needs, start by reading the [Plugin Development Guide](/gateway/latest/plugin-development).

If you already wrote a plugin, and are thinking about making it available to the community, we strongly encourage you to host it on a publicly available repository (like GitHub), and distribute it via LuaRocks. A good resource on how to do so is the Distribution Section of the Plugin Development Guide.

To give visibility to your plugin, you can create a post in the [Announcements](https://discuss.konghq.com/c/announcements/7) category of Kong Nation.
