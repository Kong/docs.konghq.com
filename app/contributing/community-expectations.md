---
title: Community expectations
no_version: true
---

This section outlines our community expectations around inclusive language and accessibility. 

## Inclusive language

Use inclusive language that does not exclude groups. Be aware of how impactful language is, and use it with care. 

See: [Microsoft's Bias-free communication](https://docs.microsoft.com/en-us/style-guide/bias-free-communication). 

## Accessibility

We are currently working on making our Docs site accessible in compliance with [WCAG 2.1](https://www.w3.org/WAI/standards-guidelines/wcag/glance/). Please ensure that all contributions do not derail from our goal. Overall, take into account the following for text-based contributions:

* All non-decorative images have useful and descriptive text alternatives. 
* Avoid screenshots and use descriptive text instead. 
* Use clear, concise, and easy-to-understand language. 
* Organize content intentionally and make things easy to find. 
* Don't get too experimental - stick to content and organization that's predictable. 

For code-based contributions, check the following:

* All clickable elements can be tabbed through in a [predictable sequence](https://www.w3.org/TR/UNDERSTANDING-WCAG20/navigation-mechanisms-focus-order.html). 
* HTML is written:
    * without skipping header level (`h1` to `h2`, instead of `h1` to `h3`).
    * using the proper elements (`li` for lists instead of `div`).
* No accessibility should be "hacked" by using JavaScript or other means. For example, don't force tabbing (`.on('keyup')`). Instead, write HTML that tabs properly. 
* Color contrast is compatible with WCAG standards. Use a [color contrast checker](https://color.a11y.com/) or Dev Tools. 
