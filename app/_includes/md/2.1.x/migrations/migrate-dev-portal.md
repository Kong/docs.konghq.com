<!---shared with deployment section and dev portal --->

Below are the Developer Portal migrations required to move from
**Kong Enterprise 1.5** to **Kong Enterprise 2.1**.
You can make these changes with our templates repository using the Kong Portal
CLI, or directly in the Kong Editor. We suggest using the templates/CLI to take
advantage of source control. Links to the templates repository, as well as the portal CLI, can be found below.

### Links
- [kong-portal-templates](https://github.com/Kong/kong-portal-templates)
- [kong-portal-cli](https://github.com/Kong/kong-portal-cli)

### Create Files
These files need to be created for the 2.1 Kong Developer Portal to function.
Create each file using the path and contents linked below:

- #### workspaces/default/themes/base/assets/js/app-0fcefa7.min.js
  - Templates Path: `/workspaces/default/themes/base/assets/js/app-0fcefa7.min.js`
  - File Content GitHub: [/default/themes/base/assets/js/app-0fcefa7.min.js](https://github.com/Kong/kong-portal-templates/tree/dev-master/workspaces/default/themes/base/assets/js/app-0fcefa7.min.js)
- #### workspaces/default/themes/base/layouts/system/markdown.html
  - Templates Path: `/workspaces/default/themes/base/layouts/system/markdown.html`
  - File Content GitHub: [/workspaces/default/themes/base/layouts/system/markdown.html](https://github.com/Kong/kong-portal-templates/tree/dev-master/workspaces/default/themes/base/layouts/system/markdown.html)
- #### workspaces/default/themes/base/assets/styles/markdown-fixes.css
  - Templates Path: `/workspaces/default/themes/base/assets/styles/markdown-fixes.css`
  - File Content GitHub: [/workspaces/default/themes/base/assets/styles/markdown-fixes.css](https://github.com/Kong/kong-portal-templates/tree/dev-master/workspaces/default/themes/base/assets/styles/markdown-fixes.css)
- #### workspaces/default/themes/base/assets/styles/markdown.css
  - Templates Path: `/workspaces/default/themes/base/assets/styles/markdown.css`
  - File Content GitHub: [/workspaces/default/themes/base/assets/styles/markdown.css](https://github.com/Kong/kong-portal-templates/tree/dev-master/workspaces/default/themes/base/assets/styles/markdown.css)

### Replace Files

These files already exist in your Dev Portal and need to be updated. Replace
their current contents with the content linked below.

- #### workspaces/default/content/applications/view.txt
    - Templates Path: `/workspaces/default/content/applications/view.txt`
    - File Content GitHub: [/workspaces/default/content/applications/view.txt](https://github.com/Kong/kong-portal-templates/tree/dev-master/workspaces/default/workspaces/default/content/applications/view.txt)

- #### workspaces/default/themes/base/layouts/_app.html
    - Templates Path: `/workspaces/default/themes/base/layouts/_app.html`
    - File Content: [/workspaces/default/themes/base/layouts/_app.html](https://github.com/Kong/kong-portal-templates/tree/dev-master/workspaces/default/themes/base/layouts/_app.html)

- #### workspaces/default/themes/base/layouts/system/create-app.html
    - Templates Path: `/workspaces/default/themes/base/layouts/system/create-app.html`
    - File Content GitHub: [/workspaces/default/themes/base/layouts/_app.html](https://github.com/Kong/kong-portal-templates/tree/dev-master/workspaces/default/themes/base/layouts/system/create-app.html)

- #### workspaces/default/themes/base/layouts/system/edit-app.html
    - Templates Path: `/workspaces/default/themes/base/layouts/system/edit-app.html`
    - File Content GitHub: [/workspaces/default/themes/base/layouts/system/edit-app.html](https://github.com/Kong/kong-portal-templates/tree/dev-master/workspaces/default/themes/base/layouts/system/edit-app.html)

- #### workspaces/default/themes/base/layouts/system/view-app.html
    - Templates Path: `/workspaces/default/themes/base/layouts/system/view-app.html`
    - File Content GitHub: [/workspaces/default/themes/base/layouts/system/view-app.html](https://github.com/Kong/kong-portal-templates/tree/dev-master/workspaces/default/themes/base/layouts/system/view-app.html)

- #### workspaces/default/themes/base/partials/footer.html
    - Templates Path: `/workspaces/default/themes/base/partials/footer.html`
    - File Content GitHub: [/workspaces/default/themes/base/partials/footer.html](https://github.com/Kong/kong-portal-templates/tree/dev-master/workspaces/default/themes/base/partials/footer.html)

- #### workspaces/default/themes/base/partials/theme/required-scripts.html
    - Templates Path: `/workspaces/default/themes/base/partials/theme/required-scripts.html`
    - File Content GitHub: [/workspaces/default/themes/base/partials/theme/required-scripts.html](https://github.com/Kong/kong-portal-templates/tree/dev-master/workspaces/default/themes/base/partials/theme/required-scripts.html)

### Delete Files

You can remove entirely these files from your Developer Portal.

- #### dashboard-6ae0d66.min.js
    - Templates Path: `workspaces/default/themes/base/assets/js/dashboard-6616db8.min.js`

### portal.conf.yaml

To help make future migrations easier, an `app_version` declaration has been
added in `portal.conf.yaml` as shown below.  Add the `app_version` to your
current configuration. You can view the complete `portal.conf.yaml` file on
[GitHub](https://github.com/Kong/kong-portal-templates/tree/dev-master/workspaces/default/portal.conf.yaml).

```
...
app_version: 0fcefa7
...
```
