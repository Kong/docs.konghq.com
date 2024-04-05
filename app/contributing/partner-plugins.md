---
title: Documenting partner plugins
content_type: how-to
---

Plugin documentation is posted on the [Plugin Hub](/hub/). 

At this time, Kong only maintains validated plugin listings for verified partners, on a limited basis.
We don't maintain entries of custom plugins from individual contributors.
If you would like to have your plugin featured on the Kong Plugin Hub, we encourage you to become a [Kong Partner](https://konghq.com/partners/).

If you're looking to develop a plugin, see our plugin documentation:
* [Plugin development guide](/gateway/latest/plugin-development/)
* [PDK reference](/gateway/latest/plugin-development/pdk/)

If you have a plugin that's verified and ready to go, the following guide walks you through submitting plugin docs to our Hub.

{:.note}
> The Kong Plugin Hub is a documentation site. We **do not** host plugin source code or downloads.

## Prerequisites
* You have a completed plugin that has been verified by the Kong Partners team.
* You have set up a [local clone of the docs repository](https://github.com/Kong/docs.konghq.com/blob/main/docs/platform-install.md).

## Document a partner plugin

1. In your local clone of the docs repository, create a new branch for your plugin.

1. Create a publisher directory in the [`app/_hub/` directory](https://github.com/Kong/docs.konghq.com/tree/main/app/_hub/)
of the docs GitHub repository.

    The path can consist only of alphanumeric characters and hyphens (`-`).
    For example: `_app/_hub/company-name`.

    See other Kong Hub listings for examples of publisher names.

1. Create a subdirectory for your plugin within the publisher directory.
For example, `_app/_hub/company-name/example-plugin`.

1. Copy the contents of the 
[`/docs/templates/partner-plugin-template`](https://github.com/Kong/docs.konghq.com/tree/main//docs/templates/partner-plugin-template)
 directory into your own plugin's directory.

    You should now have a directory that looks like this:

    ```
    _app
      _hub
        company-name
          example-plugin
            examples
              _index.yml
            schemas
              _index.json
            _changelog.md
            overview
              _index.md
            _metadata.yml
    ```

1. Populate the files in the directory with your own info:

    * `_metadata.yml`: Sets the metadata for the plugin. 
    Follow the instructions in the file to fill it out.

    * `_schemas/_index.json`: A schema of your plugin's configuration, 
    in JSON format. Include all of the parameter descriptions in this schema.
    See [this example schema](https://github.com/Kong/docs.konghq.com/blob/main/app/_hub/imperva/imp-appsec-connector/schemas/_index.json).

    * `_examples/_index.yml`: A basic configuration example for your plugin.
    At minimum, this file must contain the plugin name, as well as any required
    parameters. This example is validated against the plugin's schema.

    * `overview/_index.md`: Markdown documentation for your plugin. This is where you
    explain how the plugin works, how to install it, and how to use it.

    * `_changelog.md`: A changelog for your plugin. For the first entry, note when the 
    plugin was published and which versions of Gateway it has been tested against.

1. Add an icon for your plugin into the `/app/assets/images/icons/hub/` directory. 
    
    Plugin icons are required for publication on the Kong plugin hub. Icons
    should be a square-format PNG or SVG file, 120x120 pixels in size. 

    The filename of your image should be `publisher_plugin-name` using 
    the `publisher` and `plugin` from the directory structure.
    For example, `my-company_oas-validation`.

## Adding images

If you have any diagrams or screenshots that you want to add to your plugin documentation:

1. Add to the images into the `app/assets/images/docs/plugins` directory.

   Make sure that any screenshots follow the [screenshot guidelines](/contributing/user-interfaces/#screenshots).

1. Insert them into the file at `app/_hub/company-name/example-plugin/_index.md`
using the following format:

    ```
    ![Authentication flow diagram](/assets/images/docs/plugins/my-plugin-auth-flow.png)
    > *Figure 1: Diagram showing an OAuth2 authentication flow with Keycloak.*
    ```

## Test and submit plugin

1. Run the docs site locally per the instructions in
the docs [README](https://github.com/Kong/docs.konghq.com#run-locally).

   You should find your Hub contribution listed at `localhost:3000/hub`.

1. Once you are happy with your listing, push your branch to the GitHub repository

    ```
    git push --set-upstream origin [name_of_your_new_branch]
    ```

1. Make a pull request against the [docs.konghq.com](https://github.com/Kong/docs.konghq.com/) 
repository to add your documentation to the Plugin Hub. 

The Kong docs team will review your PR, suggest improvements and adjustments as
necessary, and once approved, will merge and deploy your Plugin Hub addition!

## Custom plugins and documentation

If you're not interested in becoming a technical partner, there are other ways to publicize your plugin.

To write a custom plugin for your own needs, start with the [Plugin Development Guide](/gateway/latest/plugin-development/).

If you already wrote a plugin, and are thinking about making it available to the community, we strongly encourage you to host it on a publicly available repository (like GitHub), and distribute it via LuaRocks. A good resource on how to do so is the [distribution section](/gateway/latest/plugin-development/distribution/#distribute-your-plugin) of the Plugin Development Guide.

To give visibility to your plugin, you can create a post in the [Announcements](https://discuss.konghq.com/c/announcements/7) category of Kong Nation.
