---
title: <phrase with a verb>
content_type: how-to

# Optional values. Uncomment any that apply to your document.

# no_version: true # Disables the version selector dropdown. Set this on pages that belong to doc sets without versions like /konnect/.
# alpha: true # Labels the page as alpha; adds a banner to the top of the page.
# beta: true # Labels the page as beta; adds a banner to the top of the page.
---

How-to topics take readers through the steps to complete a real-world problem. They are goal-oriented, prescriptive, and for users with more experience. They answer questions like "how do I delete a service version in Konnect?" or "how do I install this software?". 

You should start a how-to topic with an introduction paragraph that explains who this how-to guide is for and what this guide will help the user accomplish. Keep the background information to a minimum. You can assume the user already has some knowledge of the concepts. You can also add links to explanation articles if needed.

For example, if you were writing a how-to topic about how to install a specific kind of software on your computer, your introduction paragraph might look like the following:

"This guide shows you how to install ____ on your computer. By installing _____, you can manage photos and documents using ______."

## Prerequisites <!-- Optional -->

Write prerequisites as a bulleted list. If this isn't a "getting started" topic, we can assume our products are already installed and don't need to be listed as prerequisites. Don't prescribe product role permissions.

For example, if you were writing about how to install a certain type software on your computer, you might have prerequisites like the following:

* A software account
* Docker installed
* A software license

## Task section <!-- Header optional if there's only one task section in the article -->

Task sections break down the task into steps that the user completes in sequential order. The title for a how-to task section directs the user to perform an action and generally starts with a verb. Examples include "Install Kubernetes", "Configure the security settings", and "Create a microservice".

Continuing the previous example of installing software, here's an example:

1. On your computer, open Terminal.
1. Install ____ with Terminal:
    ```sh
    example code
    ```
1. Optional: To also install ____ to manage documents, install it using Terminal:
    ```sh
    example code
    ```
1. To ______, do the following:
    1. Click **Start**.
    1. Click **Stop**.
1. To ____, do one of the following:
    * If you are using Kubernetes, start the software:
        ```sh
        example code
        ```
    * If you are using Docker, start the software:
        ```sh
        example code
        ```

## Second task section <!-- Optional -->

Adding additional sections can be helpful if you have to switch from working in one product to another or if you switch from one task, like installing to configuring.

1. First step.
1. Second step.

## See also <!-- Optional -->

This section should include a list of tutorials or other pages that a user can visit to extend their learning from this tutorial.

See the following examples of how-to documentation:
* https://docs.konghq.com/gateway/latest/kong-enterprise/analytics/reports/
* https://docs.konghq.com/gateway/latest/kong-manager/auth/ldap/service-directory-mapping/
* https://docs.konghq.com/gateway/latest/plugin-development/custom-entities/