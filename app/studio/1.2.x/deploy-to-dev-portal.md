---
title: Deploy to the Dev Portal
---

### Introduction

By connecting to your Kong Enterprise instance, Kong Studio can sync Spec files to
and from your Dev Portal.


### Prerequisites

* Running Kong Enterprise 1.3 or later
* Admin API privileges for the Workspace you will be connecting to
* The Kong Developer Portal is enabled and running



### Step 1. Connect to Kong Enterprise

From Kong Studio:

1. Open the spec you want to deploy to the Developer Portal
1. Click on the **caret menu** and select **Deploy to Kong Portal**

    ![Menu](https://doc-assets.konghq.com/studio/1.0/dev-portal/01-menu.png)


    Kong Studio will prompt you for information to connect to your **Kong Admin API**


1. Enter your API URL.
    >Note: The URL here is the **ADMIN** **API** url set by the `admin_api_uri` property
1. Enter the Workspace for the Developer Portal you want to upload the spec to.
1. If your Admin API uses RBAC, enter the Token for to access the Workspace.


    ![Connect to Kong](https://doc-assets.konghq.com/studio/1.0/dev-portal/02-connect-to-kong.png)

1. Click **Connect to Kong** to validate Kong Studio’s connection. 


### Step 2. Deploy a Spec file

If successful, Kong Studio will then prompt you to specify a file name for the spec file - this will be the name of the file in the Developer Portal.

![Deploy Spec](https://doc-assets.konghq.com/studio/1.0/dev-portal/03-deploy-spec.png)

1. Click **Upload to Kong Portal** to upload the spec file
1. If there is an existing file with the same name Kong Studio will prompt you to overwrite the existing file or cancel
