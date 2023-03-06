---
title: Documenting user interfaces
content_type: reference
---

 How do you direct users to interact with a UI element? 
 Do you say “click” or “click on”? 
 Where do you provide explicit instructions, and where do you condense?

Use carets to describe only context menus, e.g.:

Click Service actions > Add new version.

Click All > Services.

Don’t use plus signs in labels. For example, if the button looks like this: “+ New Plugin”, refer to the button as “New Plugin”.


CRUD (create, read, update, delete) tasks:
Can only exist as part of tutorial/getting-started/how-to 
Does not exist anywhere else. 
In cases of escalation, create a troubleshooting doc and add it in. 
If the area of a screen only has an icon, refer to it by the title of the element + icon. (accessibility). 

Screenshots: 
Only two levels in Runtime manager -> Certificates 


## Screenshots

You can use screenshots to express the capabilities, look and feel, and experience of a feature in situations where exclusively using text would make the documentation harder to understand. We recommend writing the documentation first, **without** using screenshots, and then assessing if a screenshot would enhance the documentation.

Screenshots are used to support documentation and do not _replace_ documentation. In some cases, using wireframes in place of screenshots is easier to maintain. Otherwise, all screenshots must follow these guidelines.

- Screenshots must be taken with browser developer tools.
- Resolution should be set to **1500x845**.
- Screenshots of UI elements should include only the relevant **panel**. Panels are a container within a UI window which contain multiple related elements.
- Mouse should not be visible.
- Emphasis can be added by creating a **square** border around the point of interest. The border must use the color <span style="color:#0788ad">`#0788ad`</span> from the [colors style guide](https://kongponents.netlify.app/style-guide/colors.html).
- In situations that require it a `1px` black border can be used.
- **Do not** use GIFs.
- Limit image file size to ~2MB.
- Add files to the corresponding product folder by navigating in the repo from `app > _assets > images > docs`.
- Use lowercase letters and dashes when naming an image file.
