---
title: Using the Editor through Kong Manager
badge: enterprise
---

Kong Manager offers a robust file editor for editing the template files of the Dev Portal from within the browser.

## Prerequisites

* Access to Kong Manager
* The Kong Developer Portal is **enabled** and **running**

>NOTE: Editor Mode is *not* available when running the Dev Portal in **legacy** mode.

## Enter Editor Mode

From the **Kong Manager** dashboard of your **Workspace**, click **Editor** under **Dev Portal** in the sidebar.

This will launch the **Editor Mode**.
## Navigating the Editor

When enabled, the Dev Portal is pre-populated with Kong's default theme. The file editor exposes these files to the UI, allowing them to be edited quickly and easily from inside the browser. When you first open the editor, you will be presented with a list of files on the left, and a blank editing form.

1. Create new files for the Dev Portal right from the Editor by clicking `New File+`.
1. List of all exposed template files in the Dev Portal, separated by Content / Spec / Themes.
1. Code View - Select a file from the sidebar to show the code here.
1. Portal Preview - View a live preview of the selected Dev Portal file.
1. Toggle View - Choose between three different views: full screen code, split view, and full screen preview mode.

![Dev Portal with Numbers](/assets/images/docs/dev-portal/editor-mode-numbered.png)

## Editing Files

Select a file from the sidebar to open it for editing. This will expose the file to the Code View and show a live update in the Portal Preview. Clicking Save in the top right corner will save the updates to the database and update the file on the Dev Portal.

## Adding new files

Clicking the `New File +` button opens the New File Dialog.

Once created, files will immediately be available from within the Editor.

## Authenticating files

Authentication is handled by `readable_by` value on content pages (for gui view, go to permissions page)
    - set readable_by: '*' to equal old authenticated
    - to restrict access to certain roles, set readable_by to an array of accepted roles (you must first create roles on the permissions page)
    - on specs, readable_by is set inside "x-headmatter" object

## Deleting files

To _permanently_ delete a file from within the Editor, right click on the file name and select **Delete** from the popup menu.
