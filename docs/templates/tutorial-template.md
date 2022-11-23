---
title: Phrase starting with a verb # e.g. Get started with dynamic plugin ordering
content_type: tutorial

# Optional values. Uncomment any that apply to your document.

# alpha: true # Labels the page as alpha; adds a banner to the top of the page.
# beta: true # Labels the page as beta; adds a banner to the top of the page.
---

Tutorials are docs that help users learn by doing. The goal of a tutorial is to guide the user, step-by-step through a series of tasks that help them achieve a certain goal. Keep in mind that the goal and the steps should be achievable even for a beginner. 

Tutorials should include an introduction paragraph here. Good introductions explain who this tutorial is for and what this tutorial will help the user accomplish and learn. For example, if you were writing a tutorial about how to get started with a software product, your tutorial could include information about a general overview of what steps the user would be going through, what this software will help them accomplish, and that the end result of this tutorial will be that the software is installed with the basic settings configured. 

## Prerequisites <!-- Optional -->

Tutorial topics typically don't contain any prerequisites because you should be helping the user install those things in the steps. The only prerequisites you should include are those for external tools, like jq or Docker, for example. 

In the rare circumstance that you need prerequisites, write them as a bulleted list.

* Docker installed
* jq installed

## Task section <!-- Header optional if there's only one task section in the article -->

A tutorial section title directs the user to perform an action and generally starts with a verb. For example, "Install the software" or "Configure basic settings".

Each task section should include an introduction paragraph that explains what step the user doing, a brief explanation of the feature, and why the user is completing this step.

### Instructions

Steps in each section should break down the tasks the user will complete in sequential order.

Continuing the previous example of installing software, here's an example:

1. On your computer, open Terminal.
1. Install ____ with Terminal:
    ```sh
    example code
    ```
    Explanation of the variables used in the sample code, like "Where `example` is the filename."
1. Optional: To also install ____ to manage documents, install it using Terminal:
    ```sh
    example code
    ```
    Explanation of the variables used in the sample code, like "Where `example` is the filename."
1. To ______, do the following:
    1. Click **Start**.
    1. Click **Stop**.
1. To ____, do one of the following:
    * If you are using Kubernetes, start the software:
        ```sh
        example code
        ```
        Explanation of the variables used in the sample code, like "Where `example` is the filename."
    * If you are using Docker, start the software:
        ```sh
        example code
        ```
        Explanation of the variables used in the sample code, like "Where `example` is the filename."

You can also use tabs in a section. For example, if you can install the software with macOS or Docker, you might have a tab with instructions for macOS and a tab with instructions for Docker.

{% navtabs %}
{% navtab macOS %}

1. Open Terminal...
1. Run....

{% endnavtab %}
{% navtab Docker %}

1. Open Docker...
1. Run....

{% endnavtab %}
{% endnavtabs %}

### Explanation of instructions <!-- Optional, but recommended -->

This section should contain a brief, 2-3 sentence paragraph that summarizes what the user accomplished in these steps and what the outcome was. For example, "The software is now installed on your computer. You can't use it yet because the settings haven't been configured. In the next section, you will configure the basic settings so you can start using the software." 

{:.note}
> **Note**: You can also use notes to highlight important information. Try to keep them short.

## Second task section <!-- Optional -->

Adding additional sections can be helpful if you have to switch from working in one product to another or if you switch from one task, like installing to configuring. 

### Instructions

1. First step.
1. Second step.

### Explanation of instructions <!-- Optional, but recommended -->

## See also <!-- Optional, but recommended -->

This section should include a list of tutorials or other pages that a user can visit to extend their learning from this tutorial.

See the following examples of tutorial documentation:
* [Get started with services and routes](https://docs.konghq.com/gateway/latest/get-started/services-and-routes/)
* [Migrate from OSS to Enterprise](https://docs.konghq.com/gateway/latest/migrate-ce-to-ke/)
* [Set up Vitals with InfluxDB](https://docs.konghq.com/gateway/latest/kong-enterprise/analytics/influx-strategy/)
