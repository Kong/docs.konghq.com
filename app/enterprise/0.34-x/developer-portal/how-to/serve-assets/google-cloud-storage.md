---
title: How to Use Google Cloud Storage to Serve Dev Portal Assets
toc: false
---

![Google Cloud Platform](https://konghq.com/wp-content/uploads/2019/03/logo_gcp_horizontal_rgb.png)

### Introduction

**Google Cloud Storage** is a [RESTful](https://en.wikipedia.org/wiki/Representational_state_transfer) [online file storage](https://en.wikipedia.org/wiki/Online_file_storage) 
[web service](https://en.wikipedia.org/wiki/Web_service) for storing and 
accessing data on [Google Cloud Platform](https://en.wikipedia.org/wiki/Google_Cloud_Platform) infrastructure. The service 
combines the performance and scalability of Google's cloud with advanced 
security and sharing capabilities. It is comparable to [Amazons S3](https://en.wikipedia.org/wiki/Amazon_S3) online 
storage service.

In this tutorial we will walkthrough how to configure a Google Cloud Storage 
(GCS) Bucket to serve static content such as images and videos for use in your
Kong Dev Portal.


### Prerequisites

You will need to have the Dev Portal enabled, have editing access to the Dev 
Portal's template files, and an active Google Cloud Account with billing enabled. 


## Step 1 - Create a [Google Cloud Storage (GCS) Bucket](https://console.cloud.google.com/storage/create-bucket)

Navigate to your GCS account and select or create a project to hold your Dev 
Portal assets. 

Once in your project click the "Storage" option under the "Storage" section in 
the sidebar. From here click the "Create Bucket" button.

![create-bucket](https://konghq.com/wp-content/uploads/2019/03/create-bucket.png)


## Step 2 - Make the GCS Bucket objects publicly readable

Before uploading images to your new bucket, you will need to adjust the
permissions.

1. Click the "Permissions" tab on your newly created GCS Bucket
2. Click "Add Members"
3. Type "allUsers" in the "Members" text box
4. Select "Storage Legacy Object Reader" from the "Roles" dropdown
5. Click "Add"

![edit-bucket-permissions](https://konghq.com/wp-content/uploads/2019/03/bucket-permissions.png)

## Step 3 - Upload an image to the GCS Bucket and copy the public access link

From the "objects" tab select "Upload Files" and chose an image to upload.
Then click the "Public link" icon listed under "Public Access" to copy the images
GCS public link.

![upload-logo](https://konghq.com/wp-content/uploads/2019/03/upload-logo.png)


## Step 4 - Update your Dev Portal theme with the GCS Bucket object link

The following example replaces the Dev Portal's default logo. This is done by 
replacing the logo images default `src` values with the GCS Bucket image link in
the following files:

  * `header.hbs`
  * `unauthenticated/header.hbs`


**Before**
![header-before](https://konghq.com/wp-content/uploads/2019/03/orignal-header.png)

**After**
![header-after](https://konghq.com/wp-content/uploads/2019/03/new-header.png)


