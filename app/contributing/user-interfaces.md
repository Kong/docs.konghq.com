---
title: Documenting user interfaces
content_type: reference
---

## Documenting interactions with UI elements

When documenting UI instructions, make sure to write them as part of workflows.

As a general rule, we do not directly document CRUD (create, read, update, delete) tasks in the Kong documentation without any context.

{:.note}
> In cases of escalation around a specific task (for example, users keep struggling to delete a route in Kong Manager), create a troubleshooting doc for that content.

## Best practices for referring to UI elements 

* If the area of a screen only has an icon, refer to it by the title of the element + icon. 
* Use carets to describe only context menus, e.g.:

    * Click Service actions > Add new version.
    * Click All > Services.

* Say **Click**; do not say **Click on**
* Don’t use plus signs in labels. For example, if the button looks like this: `+ New Plugin`, refer to the button as `New Plugin`.

## Screenshots

You can use screenshots to express the capabilities, look and feel, and experience of a feature in situations where exclusively using text would make the documentation harder to understand. We recommend writing the documentation first, **without** using screenshots, and then assessing if a screenshot would enhance the documentation.

Screenshots are used to support documentation and do not _replace_ documentation. In some cases, using wireframes in place of screenshots is easier to maintain. Otherwise, all screenshots must follow these guidelines.

- Screenshots must be taken with browser developer tools.
- Resolution should be set to **1500x845**.
- Screenshots of UI elements should include only the relevant **panel**. Panels are a container within a UI window which contain multiple related elements.
- Mouse should not be visible.
- **Emphasis on elements in the screenshot:** Create a **rectangular** border around the point of interest. 
The border must use the color <span style="color:#0788ad">`#0788ad`</span> from the [colors style guide](https://kongponents.netlify.app/style-guide/colors.html).
- **Screenshot border:** Set the `image-border` class if your screeshot requires a border. You might need to set a border when:
    * Panels have a white background and will therefore blend into the surrounding area
    * You want to separate the screenshot clearly from another image
    * It's hard to tell which text belongs to the screenshot and which to the page content
- **Do not** use GIFs.
- Limit image file size to ~2MB.
- Add files to the corresponding product folder by navigating in the repo from `app > _assets > images > docs`.
- Use lowercase letters and dashes when naming an image file.
