---
title: Deploy to the Dev Portal
---

### Introduction

By connecting to Insomnia Designer through the Kong Studio bundle, you
can sync Spec files to and from your Dev Portal.

### Prerequisites

* [Insomnia Designer and the Insomnia Designer Kong Plugin Bundle](/enterprise/{{page.kong_version}}/studio/download-install) are installed
* Running Kong Enterprise 1.3 or later
* Admin API privileges for the Workspace you will be connecting to
* The Kong Developer Portal is enabled and running

### Step 1. Connect to Kong Enterprise

From Insomnia Designer:

1. Go to the Documents Listing View.
2. Find the spec you want to deploy to the Developer Portal.
3. Click on the documents **action menu** and select **Deploy to Kong Portal**.

    ![Menu](https://s3.amazonaws.com/helpscout.net/docs/assets/59e383122c7d3a40f0ed78e2/images/5ea7f9d02c7d3a7e9aebbe6e/file-ZA5DLrBBPs.png)


      Insomnia Designer will prompt you for information to connect to your **Kong Admin API**.


4. Enter your API URL.

    > Note: The URL here is the **ADMIN** **API** url set by the `admin_api_uri` property.

5. Enter the Workspace for the Developer Portal you want to upload the spec to.
6. (Optional) If your Admin API uses RBAC, enter the token to access the Workspace.


    ![Connect to Kong](https://s3.amazonaws.com/helpscout.net/docs/assets/59e383122c7d3a40f0ed78e2/images/5ea7fa1a2c7d3a7e9aebbe7d/file-aY1ixNgXnh.png)

6. Click **Connect to Kong** to validate the connection.


### Step 2. Deploy a Spec file

If successful, Insomnia Designer will then prompt you to specify a name for the spec file &mdash; this will be the name that appears in the Developer Portal.

![Deploy Spec](https://s3.amazonaws.com/helpscout.net/docs/assets/59e383122c7d3a40f0ed78e2/images/5ea7fa7b04286364bc991bb9/file-jzWwnImfbw.png)

1. Click **Upload to Kong Portal** to upload the spec file.
2. If there is an existing file with the same name, Insomnia Designer will prompt you to overwrite the existing file or cancel.
