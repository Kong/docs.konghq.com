---
title: Getting Started with the Kong Developer Portal
---

# Getting Started with the Kong Developer Portal

## Enable the Dev Portal

1. Open the Kong configuration file in your editor of choice (`kong.conf`)
2. Find and change the `portal` configuration option to `on` and remove the `#` from the beginning of the line, it should now look like:
  - **`portal = on`**
        1. Enables the **Dev Portal File API** which can be accessed at: `:8001/files`
        2. Serves the **Dev Portal** **Loader** on port  `:8003`
        3. Enables the **Public Dev Portal API** on port  `:8004`
          - The **Public Dev Portal File API** can be accessed at `:8004/file`
3. Restart Kong (`kong restart`)

> Note: Not all deployments of Kong utilize a configuration file, if this describes you (or you are unsure) please reference the [Kong configuration docs](/{{page.kong_version}}/configuration/) in order to implement this step.

## Uploading the Example Dev Portal files

Now that we have enabled the Dev Portal, it is time to download the Example Dev Portal Files archive, (made of Pages, Partials, and Specifications) so that the Dev Portal Loader will have something to render (more on that later).

* Login to Bintray and download the [Example Dev Portal files](https://bintray.com/kong/kong-dev-portal/download_file?file_path=v0.0.2_theme.tar.gz) archive.
* Unarchive the Example Dev Portal files archive and navigate to it in your terminal
* Run the following commands in your terminal to upload the Example Dev Portal files to Kong:
    * `chmod +x sync.sh`
    * `./sync.sh`
        * If you open this file in your text editor you will see that it is making basic `curl` requests to the Dev Portal File API. We will be making similar requests later.
* Navigate in your browser to `http://127.0.0.1:8001/files`
    * You should see a list of files, with types, and contents. These are the Example Dev Portal files that we have uploaded via the Dev Portal File API.
* If you are enabling Authentication, jump to the **Authentication** section before moving forward.

## Visit the Example Dev Portal

Now that you have enabled the Dev Portal in Kong, and uploaded the Example Dev Portal files using the Dev Portal File API we can visit the Example Dev Portal:

* Navigate your browser to `http://127.0.0.1:8003`

You should now see the Default Dev Portal Homepage, and be able to navigate through the example pages.
