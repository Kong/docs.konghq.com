---
title: Documenting Kong-owned plugins
content_type: how-to
---

Plugin documentation is posted on the [Plugin Hub](/hub/). 
All Kong plugin docs must follow a [specific template](https://github.com/Kong/docs.konghq.com/tree/main/docs/templates/kong-plugin-template).

{:.note}
> Looking for instructions on submitting a partner plugin? See the [Partner Plugins guide](/contributing/partner-plugins/).

## Prerequisites

* You have a parallel plugin PR in one of the Kong source code repositories.
* You plugin has description for every config parameter field in its Lua schema file.
* You have set up a [local clone of the docs repository](https://github.com/Kong/docs.konghq.com/blob/main/docs/platform-install.md).

## Add a new plugin doc

1. In your local clone of the docs repository, create a new branch for your plugin.

1. Create a subdirectory for the plugin [within the `_app/_hub/kong-inc` directory](https://github.com/Kong/docs.konghq.com/tree/main/app/_hub/kong-inc/).
For example, `_app/_hub/kong-inc/your-plugin`.

1. Copy the contents of the 
[`/docs/templates/kong-plugin-template`](https://github.com/Kong/docs.konghq.com/tree/main//docs/templates/kong-plugin-template)
 directory into your own plugin's directory.

    You should now have a directory that looks like this:

    ```
    _app
      _hub
        kong-inc
          example-plugin
            how-to
              _index.md
            _changelog.md
            _index.md
            _metadata.yml
            versions.yml
    ```

1. Populate the files in the directory with your own info:

    * `_metadata.yml`: Sets the metadata for the plugin. 
    Follow the instructions in the file to fill it out.

    * `_index.md`: Introduction for your plugin. This is where you
    explain how the plugin works and why someone would want to use it.

    * `_changelog.md`: A changelog for your plugin. For the first entry,
    just note when the plugin was published. 

    * `how-to/_index.md`: Markdown documentation on how to use the plugin.
      You can create any number of files in the `how-to` folder, e.g. 
      `how-to/_getting-started.md`, `how-to/_metrics.md`, etc.

    * `versions.yml`: Set the {{site.base_gateway}} version that the plugin is introduced in.
        This will generate a doc for every subsequent gateway version, 
        starting with the one you specify.

1. Add an icon for your plugin into the 
[`/app/assets/images/icons/hub`](https://github.com/Kong/docs.konghq.com/tree/main/app/assets/images/icons/hub) 
directory. 
    
    Plugin icons are required for publication on the Kong plugin hub. Icons
    should be a PNG or SVG file, 120x120 pixels in size. 

    The filename of your image should be `kong-inc_plugin-name`.
    For example, `kong-inc_oas-validation`.

1. Create a basic example for your plugin in the [plugin toolkit repository](https://github.com/Kong/docs-plugin-toolkit/tree/main/examples).

    This example will be validated against the plugin's schema,
    so make sure to include all required configuration parameters.

## Adding images

If you have any diagrams or screenshots that you want to add to your plugin documentation:

1. Add to the images into the `app/_assets/images/docs/plugins` directory.

   Make sure that any screenshots follow the [screenshot guidelines](/contributing/user-interfaces/#screenshots).

1. Insert images into any of the markdown files for your plugin using the following format:

    ```
    ![Authentication flow diagram](/assets/images/docs/plugins/my-plugin-auth-flow.png)
    > *Figure 1: Diagram showing an OAuth2 authentication flow with Keycloak.*
    ```

## Test and submit plugin

1. Run the docs site locally per the instructions in
the docs [README](https://github.com/Kong/docs.konghq.com#run-locally).

   You should find your Hub contribution listed at `localhost:3000/hub`.

1. Once you are happy with your listing, push your branch to the GitHub repository:

    ```
    git push --set-upstream origin [name_of_your_new_branch]
    ```

1. Make a pull request against the [docs.konghq.com](https://github.com/Kong/docs.konghq.com/) 
repository to add your documentation to the Plugin Hub. 

The Kong docs team will review your PR, suggest improvements and adjustments as
necessary, and once approved, will merge and deploy your Plugin Hub addition!

## Custom plugins and documentation

If you want to write a custom plugin for your own needs, start by reading the [Plugin Development Guide](/gateway/latest/plugin-development/).

If you already wrote a plugin, and are thinking about making it available to the community, we strongly encourage you to host it on a publicly available repository (like GitHub), and distribute it via LuaRocks. A good resource on how to do so is the [distribution section](/gateway/latest/plugin-development/distribution/#distribute-your-plugin) of the Plugin Development Guide.

To give visibility to your plugin, you can create a post in the [Announcements](https://discuss.konghq.com/c/announcements/7) category of Kong Nation.

If you're interested in becoming a technical partner and publishing your plugin on the Kong Plugin Hub, please reach out to our [Kong Partners team](https://konghq.com/partners/).
