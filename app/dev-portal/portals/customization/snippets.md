---
title: Snippets
---

Snippets allow you to reuse content and MDC components across [Pages](/dev-portal/portals/customization/custom-pages). You can enable or disable snippets with visibility controls and publishing status. You can also restrict access to logged in developers.

To get started creating Snippets, navigate to your Dev Portal and click [**Portal editor**](/dev-portal/portals/customization/portal-editor/), then click **Snippets**.

{:.note}
> Snippets are built using Markdown Components (MDC). See the [dedicated MDC site](https://portaldocs.konghq.com/components/snippet) for more information about Snippet syntax and usage.


### Create a new Snippet
* Click to create a new Snippet at the top of the left sidebar.
* Give the Snippet a "name". This will be used to refer to your Snippet from Pages, and must be a unique lowercase, `kebab-case` string.
* The Snippet will be created with the `title` in front matter set to the specified name. Snippet front matter can be useful to keep track of what you're working on alongside other Editors as well as providing additional data to the Snippet.
* Edit the content of your Snippet in the middle panel using any Markdown or MDC, and you'll see a Live Preview in the right panel.

{:.important}
> **Notes:**
> * Preview may not always be able to display parameterized values. When the Page is rendered in your Portal, parameters will be resolved. Depending on the type of syntax used, the preview may not reflect parameterized values in Page or Snippet views.
> * Snippets are published by default. The Snippet won't be displayed in your Portal until it's reused in a Page.
> * Snippets are created with the default page visibility that is set in your [settings](/dev-portal/portals/settings/general).
> * Snippets are limited to 1,000,000 characters.

## Reference a Snippet in a Page

You can reuse the Snippet component within a Page by specifying the name of the Snippet. These properties are auto-completed from the list of your previously created Snippets.

For example:

```mdc
::snippet
---
name: "get-api-keys"
---
::
```

For more advanced usage, including passing data into Snippets, see our [dedicated MDC site](https://portaldocs.konghq.com/components/snippet).


## Unpublishing Snippets

Newly created Pages are published by default. If you want to unpublish a Snippet, select the Snippet in the sidebar and click the menu in the top right corner and select **Unpublish**. 

This can be useful for providing messaging across Pages that is only displayed for a period of time, for example, system outages or special events.

## Change Snippet visibility
If you want to change the visibility of a Snippet, select the Snippet in the sidebar and click the menu in the top right corner and toggle **Private** and **Public** as needed.


