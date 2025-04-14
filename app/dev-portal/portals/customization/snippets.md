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

### Reference a Snippet within a Page

In its simplest usage, use the `Snippet` component within a Page, and specify the `name` of the Snippet. These properties are auto-completed from the list of your previously created Snippets.

```mdc
::snippet
---
name: "get-api-keys"
---
::
```

For more advanced usage, including passing data into Snippets, see our [dedicated MDC site](https://portaldocs.konghq.com/components/snippet).

### Modify a Snippet

In the middle panel, you can make changes to your MDC content, and instantly see the live Preview.

Once you have completed your changes, be sure to click **Save**.

{:.note}
> *To rename a Snippet, click the 'three dots' menu, and click Rename*

### Publishing Snippets

Newly created Pages are in `Published` status by default for ease of use. With the Snippet selected on the left sidebar, click the "three dots" menu in the top right corner and select `Unpublish`. This can be useful for providing messaging across Pages that is only displayed for a period of time, e.g. system outages or special events.

### Change Page visibility

In the top right corner, click the menu with three dots. You can toggle from `Private` to `Public`, and vice versa.


