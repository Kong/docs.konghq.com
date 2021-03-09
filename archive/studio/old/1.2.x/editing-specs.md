---
title: Editing Spec Files with Kong Studio
---


## Importing Your First Spec File

The first time you open Kong Studio, it will prompt you to get started by importing a spec file, or opening the sample
*Petstore OpenAPI *spec 

![Import the Petstore](https://doc-assets.konghq.com/studio/1.0/editing-specs/01-import-petstore.png)


In either case, importing a spec file will create a new **Workspace** with the same name as the spec file, and open the spec file in the Editor tab.  The **Workspace** is the *project* where you can edit and debug your spec. Each spec file you import will open into a new Workspace, or overwrite the current Workspace if you choose. 

![Spec in Editor](https://doc-assets.konghq.com/studio/1.0/editing-specs/02-edit-spec.png)


## Importing Specs from File

1. Click on the **Workspace Dropdown** menu and select **Import/Export**

![Import/Export Menu](https://doc-assets.konghq.com/studio/1.0/editing-specs/03-import-export.png)


1. Select the dropdown **Import Data** and select **From File**
2. Choose the file from your computer and select **Import**
3. From the Import Prompt, choose to either create a **New Workspace** or overwrite the **Current** Workspace


## Import Specs from a URL

1. Click on the **Workspace Dropdown** menu and select **Import/Export**
2. Select the dropdown **Import Data** and select **From URL**
3. Type in the URL and select **Fetch and Import**

1. From the Import Prompt, choose to either create a **New Workspace** or overwrite the **Current** Workspace



## Import Specs from the Clipboard

1. Click on the **Workspace Dropdown** menu and select **Create Workspace**

![Create Workspace](https://doc-assets.konghq.com/studio/1.0/editing-specs/create-workspace.png)

1. Name the Workspace and click **Create**

![Name the New Workspace](https://doc-assets.konghq.com/studio/1.0/editing-specs/name-workspace.png)

1. This will open a blank Specification file, right click in the Editor field and select **Paste**


## Editing Spec Files

The **Editor** view in Kong Studio allows you to edit spec files. As you edit, Kong Studio will lint the spec and update the **Spec Navigation** side bar in real time. Errors in your spec file will be shown with a red dot next to the line number. Hovering over the dot will display details about the error. 

![Error Alert](https://doc-assets.konghq.com/studio/1.0/editing-specs/spec-error.png)

Once you are ready to debug your spec file with **Insomnia**, click to the **Debug** tab or click **Debug** in the top right corner of the **Editor**. To learn how to debug spec files with **Insomnia** check out [Debugging with Insomnia Documentation](/studio/{{page.kong_version}}/debugging-with-insomnia)



## Switch between Spec Files

Each spec file lives within its own **Workspace. **To switch between spec files, you must switch between Workspaces.


1. Open the **Workspace Dropdown** menu
2. From the **Switch Workspace** section, select the Workspace you wish to open.


![Switch Workspace](https://doc-assets.konghq.com/studio/1.0/editing-specs/switch-workspace.png)


## Delete a Spec File

To delete an imported spec file, you must delete its associated **Workspace**.


1. Open the **Workspace Dropdown** menu 
2. Click **Workspace Settings**

![Workspace Settings](https://doc-assets.konghq.com/studio/1.0/editing-specs/workspace-settings.png)

1. Under **Workspace Actions** select **Delete**


![Delete Workspace](https://doc-assets.konghq.com/studio/1.0/editing-specs/delete-workspace.png)
