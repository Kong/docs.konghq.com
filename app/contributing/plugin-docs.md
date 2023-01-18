---
title: Plugin docs
---

Plugin documentation is posted on the [Plugin Hub](/hub/). 
All plugin docs, whether developed by Kong and external contributors,
follow a [specific template](https://github.com/Kong/docs.konghq.com/tree/main/app/_hub/_init/my-extension).

We are currently accepting plugin submissions to our plugin hub from trusted technical partners, on a limited basis. For more information, see the [Kong Partners page](https://konghq.com/partners/).

{:.note}
> The Kong Plugin Hub is a documentation site. We **do not** host plugin source code or downloads.

## Add a new plugin doc

1. Set up or find your publisher directory:
  * If you're contributing a plugin developed by Kong, 
 use the existing `_app/_hub/kong-inc` directory.
  * If you're documenting a plugin created by another company, 
  create a publisher directory at`_app/_hub/`, such as
 `_app/_hub/company-name`. 

    See other Kong Hub listings for examples of publisher names.

1. Create a subdirectory for your plugin within your publisher directory.
For example, `_app/_hub/kong-inc/your-plugin`.

1. Copy the `/app/_hub/_init/my-extension/_index.md` and 
the `/app/_hub/_init/my-extension/versions.yml` files into your plugin's subdirectory.

1. Edit your `_index.md` file based on the guidance in comments in that file.
You'll also find lots of helpful examples in other plugin doc files.

1. Edit your `versions.yml` file with the minimum {{site.base_gateway}} version that this plugin supports.
    This will generate a doc for every subsequent gateway version, 
    starting with the one you specify.

1. Plugin icons are required for publication on the Kong plugin hub. Icons
should be a square-format PNG file, 120x120 pixels in size. 

    The filename of your image should be `publisher_plugin-name` using 
    the `publisher` and `plugin` name from step 2.
    For example, `kong-inc_oas-validation`.

    Add the icon file to `/app/_assets/images/icons/hub/`. 


1. Run the docs site locally per the instructions in
the README - you should find your Hub contribution listed at
`localhost:3000/hub`.

1. Once you are happy with your listing, push your branch to the GitHub repository

    ```
    git push --set-upstream origin [name_of_your_new_branch]
    ```

1. Find [your branch](https://github.com/Kong/docs.konghq.com/branches/yours) and make a [pull request](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/creating-a-pull-request) to add your documentation to the Plugin Hub. 

The Kong docs team will review your PR, suggest improvements and adjustments as
necessary, and once approved, will merge and deploy your Plugin Hub addition!


## Custom plugins and documentation

If you want to write a custom plugin for your own needs, start by reading the [Plugin Development Guide](/gateway/latest/plugin-development).

If you already wrote a plugin, and are thinking about making it available to the community, we strongly encourage you to host it on a publicly available repository (like GitHub), and distribute it via LuaRocks. A good resource on how to do so is the [Distribution section](/gateway/latest/plugin-development/distribution/#distribute-your-plugin) of the Plugin Development Guide.

To give visibility to your plugin, you can create a post in the [Announcements](https://discuss.konghq.com/c/announcements/7) category of Kong Nation.
