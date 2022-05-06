---
title: Easy Theme Editing in Kong Manager
---

### Introduction

The Kong Developer Portal ships with a default theme, including preset images, background colors, fonts, and button styles. These settings can be edited quickly and easily from within Kong Manager, without the need to edit code.

### Prerequisites

* Kong Enterprise 1.3 or later
* Access to Kong Manager
* The Developer Portal is enabled and running

### The Appearance Tab

From the **Workspace** dashboard in **Kong Manager**, click on the **Appearance** tab under **Dev Portal** on the left side bar.
This will open the Developer Portals theme editor. From this page the header logo, background colors, font colors, and button styles can be edited using the color picker interface.

![Appearance Tab](https://doc-assets.konghq.com/1.3/dev-portal/easy-themes/devportal-appearance-tab.png)

The predefined variables refer to the following elements:

![Appearance Tab - Variables](https://doc-assets.konghq.com/1.3/dev-portal/easy-themes/devportal-appearance-arrows.png)

Hovering over an element will show a color picker, as well as a list of predefined colors. These colors are defined by the current template and can be edited in the [theme.conf.yaml](#editing-theme-files-with-the-editor) file

![Appearance Tab - Color Picker](https://doc-assets.konghq.com/1.3/dev-portal/easy-themes/devportal-appearance-tab-variable-hover.png)

## Editing Theme Files with the Editor

The Dev Portal Editor within Kong Manager exposes the default Dev Portal theme files. The theme files can be found at the bottom of the file list under *Themes*. The variables exposed in the *Appearance* tab can be edited in the theme.conf.yaml file. See [Using the Editor](/enterprise/{{page.kong_version}}/developer-portal/using-the-editor) for more information on how to edit, preview, and save files in the Editor.

![Theme File in Editor](https://doc-assets.konghq.com/1.3/dev-portal/easy-themes/devportal-theme-conf-yaml.png)