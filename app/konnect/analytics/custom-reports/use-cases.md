---
title: Use Cases
content_type: tutorial
badge: plus
---

##  Overview
Custom reporting in {{site.konnect_saas}} gives you the power to monitor your API data in detail and export that data to CSV. 

This narrative driven tutorial will guide you through the process of creating custom reports for key API metrics using {{site.konnect_saas}} custom reports. Specifically this tutorial will cover building reports for the following use cases:

* Total number of requests across an API in the current month.
* Daily API usage for an API over the last 30 days. 
* Total API usage by application for all APIs in the current month. 
* Capturing requests per minute for an API over the last 30 days. 

## Narrative?? Situation? 

You have just joined an organization as an API product manager, your first task is to create a few reports that model business KPIs so that the executive team and investors have a grasp on the state of the API. You've selected the following APIs because they would give a brief but wholistic understanding of the API: 

* Number of requests: This metric measures the total number of requests made to the API. This is good for understanding total usage of an API, and can potentially be used to uncover scalability requirements. 
* Error response rate: This metric measures the percentage of requests that result in errors. With this metric you can potentially pinpoint any issues users of your API are having. 
* Average throughput: Throughput is the measurement of the number of requests an API can handle per second. 
* Latency: latency is the measurement of the time it takes for the API to respond to a request. 

These KPIs can help you define the type of reports you need to show the stakeholders in your organization:

* Total number of requests across APIs 
* Daily API usage 
* Total API usage, by application
* Requests per minute for a specific API 

With {{site.konnect_saas}} custom reports you can create those reports across any number of time frames.

some sort of intro sentence... to this section after 
## Build custom reports 
Maybe instructions about how it works but probably not needed? 

I like the idea of listing the potential categories here and then introducing them like a recipe in each section: 

* Name: API Usage (current month)
* Date/Time: Current Month
* Entity Selection: All Entities

Then show off the corresponding chart, and provide an outro paragraph about the data and what it means. 

## Total number of requests across APIs 

To build a custom report, navigate to the custom reports dashboard by selecting **Analytics**, then **reports**. To build a report that displays the total number of requests across all of your APIs over the last 30 days, set the following options in the UI: 

* **Name**: API usage
* **Horizontal Bar Chart**
* **Date/Time**: Last 30 days
* **Metric**: Request count
* **Group By**: Service
* **Then by**: None

<picture of finished chart>

This report can provide your stakeholders with the answers to questions like:

* How many requests were made to the API during the current month? 
* How does this month compare to the previous months? 
* Which service receives the most requests?

The data can be used to support other types of exploratory questions about your API: 

* What is the most popular service? 
* Are there spikes in requests across months? 
* Are there any errors or issues that might be impacting the number of requests our API is receiving? 


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