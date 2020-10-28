<!---shared with deployment section and dev portal --->

Developer Portal migrations are required to upgrade from
**{{site.ee_product_name}} 1.5** to **{{site.ee_product_name}} 2.1**.
You can make these changes with the Kong templates repository using either the
Kong Portal CLI, or directly in the Kong Developer Portal Editor UI. Using the
CLI to take advantage of source control is recommended.

### Links to templates and CLI
- [kong-portal-templates](https://github.com/Kong/kong-portal-templates)
- [kong-portal-cli](https://github.com/Kong/kong-portal-cli)

### Create files
The following files must be created for the 2.1 Kong Developer Portal to function
properly. Create each file using the name, path, and contents linked below:

- #### workspaces/default/themes/base/assets/js/app-0fcefa7.min.js
  - Templates Path: `/workspaces/default/themes/base/assets/js/app-0fcefa7.min.js`
  - File Content on GitHub: [/default/themes/base/assets/js/app-0fcefa7.min.js](https://github.com/Kong/kong-portal-templates/tree/master/workspaces/default/themes/base/assets/js/app-0fcefa7.min.js)
- #### workspaces/default/themes/base/layouts/system/markdown.html
  - Templates Path: `/workspaces/default/themes/base/layouts/system/markdown.html`
  - File Content on GitHub: [/workspaces/default/themes/base/layouts/system/markdown.html](https://github.com/Kong/kong-portal-templates/tree/master/workspaces/default/themes/base/layouts/system/markdown.html)
- #### workspaces/default/themes/base/assets/styles/markdown-fixes.css
  - Templates Path: `/workspaces/default/themes/base/assets/styles/markdown-fixes.css`
  - File Content on GitHub: [/workspaces/default/themes/base/assets/styles/markdown-fixes.css](https://github.com/Kong/kong-portal-templates/tree/master/workspaces/default/themes/base/assets/styles/markdown-fixes.css)
- #### workspaces/default/themes/base/assets/styles/markdown.css
  - Templates Path: `/workspaces/default/themes/base/assets/styles/markdown.css`
  - File Content on GitHub: [/workspaces/default/themes/base/assets/styles/markdown.css](https://github.com/Kong/kong-portal-templates/tree/master/workspaces/default/themes/base/assets/styles/markdown.css)

### Replace content in existing files

Update the following files that already exist in your Dev Portal workspaces for
1.5.x. Replace the existing contents of the files with the 2.1.x content
linked below.

- #### workspaces/default/content/applications/view.txt
    - Templates Path: `/workspaces/default/content/applications/view.txt`
    - File Content GitHub: [/workspaces/default/content/applications/view.txt](https://github.com/Kong/kong-portal-templates/tree/master/workspaces/default/content/applications/view.txt)

- #### workspaces/default/themes/base/layouts/_app.html
    - Templates Path: `/workspaces/default/themes/base/layouts/_app.html`
    - File Content: [/workspaces/default/themes/base/layouts/_app.html](https://github.com/Kong/kong-portal-templates/tree/master/workspaces/default/themes/base/layouts/_app.html)

- #### workspaces/default/themes/base/layouts/system/create-app.html
    - Templates Path: `/workspaces/default/themes/base/layouts/system/create-app.html`
    - File Content GitHub: [/workspaces/default/themes/base/layouts/_app.html](https://github.com/Kong/kong-portal-templates/tree/master/workspaces/default/themes/base/layouts/system/create-app.html)

- #### workspaces/default/themes/base/layouts/system/edit-app.html
    - Templates Path: `/workspaces/default/themes/base/layouts/system/edit-app.html`
    - File Content GitHub: [/workspaces/default/themes/base/layouts/system/edit-app.html](https://github.com/Kong/kong-portal-templates/tree/master/workspaces/default/themes/base/layouts/system/edit-app.html)

- #### workspaces/default/themes/base/layouts/system/view-app.html
    - Templates Path: `/workspaces/default/themes/base/layouts/system/view-app.html`
    - File Content GitHub: [/workspaces/default/themes/base/layouts/system/view-app.html](https://github.com/Kong/kong-portal-templates/tree/master/workspaces/default/themes/base/layouts/system/view-app.html)

- #### workspaces/default/themes/base/partials/footer.html
    - Templates Path: `/workspaces/default/themes/base/partials/footer.html`
    - File Content GitHub: [/workspaces/default/themes/base/partials/footer.html](https://github.com/Kong/kong-portal-templates/tree/master/workspaces/default/themes/base/partials/footer.html)

- #### workspaces/default/themes/base/partials/theme/required-scripts.html
    - Templates Path: `/workspaces/default/themes/base/partials/theme/required-scripts.html`
    - File Content GitHub: [/workspaces/default/themes/base/partials/theme/required-scripts.html](https://github.com/Kong/kong-portal-templates/tree/master/workspaces/default/themes/base/partials/theme/required-scripts.html)

### Delete obsolete files

You can remove the following files from your Developer Portal.

- #### dashboard-6ae0d66.min.js
    - Templates Path: `workspaces/default/themes/base/assets/js/dashboard-6616db8.min.js`

### Declare application version

To make future migrations easier, an `app_version` declaration has been
added in `portal.conf.yaml` as shown below.  Add the `app_version` to your
current portal configuration files. You can view the complete `portal.conf.yaml` file on
[GitHub](https://github.com/Kong/kong-portal-templates/tree/dev-master/workspaces/default/portal.conf.yaml).

```
...
app_version: 0fcefa7
...
```
