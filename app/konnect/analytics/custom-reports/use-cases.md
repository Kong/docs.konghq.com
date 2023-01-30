---
title: Use Cases
content_type: tutorial
badge: plus
---

Custom reporting in {{site.konnect_saas}} gives you the power to monitor your API data in detail and export that data to CSV. 

This narrative driven tutorial guides you through the process of creating custom reports for key API metrics using {{site.konnect_saas}} custom reports. This tutorial covers building reports for the following use cases:

* Total number of requests across an API in the current month.
* Daily API usage for an API over the last 30 days. 
* Total API usage by application for all APIs in the current month. 
* Capturing requests per minute for an API over the last 30 days. 

## Narrative?? Situation? 

You have just joined an organization as an API product manager. Your first task is to create a few reports that model business KPIs so that the executive team and investors have a grasp on the state of the API. You've selected the following KPIs because they would give a brief but wholistic understanding of the API: 

* **Number of requests:** This metric measures the total number of requests made to the API. This is good for understanding total usage of an API, and can potentially be used to uncover scalability requirements. 
* **Error response rate:** This metric measures the percentage of requests that result in errors. With this metric you can potentially pinpoint any issues users of your API are having. 
* **Average throughput:** Throughput is the measurement of the number of requests an API can handle per second. 
* **Latency:** latency is the measurement of the time it takes for the API to respond to a request. 

These KPIs can help you define the type of reports you need to show the stakeholders in your organization:

* Total number of requests across APIs 
* Daily API usage 
* Total API usage, by application
* Requests per minute for a specific API 

With {{site.konnect_saas}}, you can create these reports across any number of time frames.

some sort of intro sentence... to this section after 
## Build custom reports 
Maybe instructions about how it works but probably not needed? 

I like the idea of listing the potential categories here and then introducing them like a recipe in each section: 

* Name: API Usage (current month)
* Date/Time: Current Month
* Entity Selection: All Entities

Then show off the corresponding chart, and provide an outro paragraph about the data and what it means. 

## Total number of requests across APIs over the last 30 days

To build a custom report, navigate to the custom reports dashboard by selecting **Analytics**, then **reports**. To build a report that displays the total number of requests across all of your APIs over the last 30 days, set the following options in the UI: 

* **Name**: API usage (last 30 days)
* **Horizontal Bar Chart**
* **Date/Time**: Last 30 days
* **Metric**: Request count
* **Group By**: Service
* **Then by**: None

[screenshot of finished report]

This report can provide your stakeholders with the answers to questions like:

* How many requests were made to the API during the current month? 
* How does this month compare to the previous months? 
* Which service receives the most requests?

The data can be used to support other types of exploratory questions about your API: 

* What is the most popular service? 
* Are there spikes in requests across months? 
* Are there any errors or issues that might be impacting the number of requests our API is receiving? 

## Daily API usage for an API over the last 30 days

From the previous report, you determine that the Accounts API is receiving the most traffic. 
You don't know whether this is a cause for concern or not, so you decide to take a closer look.

To gain further insight into the Accounts API, let's build a report that displays the number of requests per day for the Accounts API over the last 30 days. Set the following options in the UI:

* **Name**: Daily Accounts API Usage (last 30 days)
* **Chart type**: Line chart
* **Date/Time**: Last 30 days
* **Metric**: Request count
* **Group by**: Service

Add a filter for the Account API. Click on **Add Filter**, then set the following options:

* **Filter by**: Service
* **Filter value**: Accounts API (or your own API name)

[screenshot of finished report]

This report can provide your stakeholders with the answers to questions like:

* What does average traffic over time look like for this service?
* Are there any anomalies, such as spikes or drops in traffic?
* If there are anomalies, do they repeat? Are there any patterns in the data?
* If there's an issue with API traffic, has it been resolved or is it ongoing?

## Daily API usage by application over the last 30 days

At this point you have two custom reports: 

* Total number of requests across APIs. 
* Daily API Usage for an API over the last 30 days.

These two custom reports can work together to provide you with a lot of information about your organizations product. These alone can help drive a lot internal change to your API. Let's dive deeper, if you want to learn about the types of third-party applications that your users use to connect to your API, set the following options in the UI: 

* **Name**: API Usage by Application (last 30 days)
* **Chart type**: Vertical bar chart
* **Date/Time**: Last 30 days
* **Metric**: Request count
* **Group by**: Service
* **Then by**: Application

[screenshot of finished report]

This report can be used to highlight which applications users prefer, where to distribute resources, and combined with the other reports, you can now communicate usage data about your API to your stakeholders. 
## Latency for the Payment API over the last 30 days

1. In {{site.konnect_short_name}}, navigate to **Analytics**, then **Reports**.
1. Click **New Report**.
1. Configure the report with the following:
    * **Name**: Payment API - Latency (last 30 days)
    * **Date/Time**: Last 30 days
    * **Chart type**: Line Chart
    * **Select a metric**: Response latency (p99)
    * **Group by**: None
    * **Then by**: None
    * **Entity Selection**: Payment <!-- I don't see this anywhere in the UI? -->
1. Click **Create**.

This report can provide your stakeholders with the answers to questions like:

* How performant has my Payment API been over the last 30 days?
* 
A fast Payment API is critical for ACMEs business. With this report, Amy can show how performant that service has been over the last 30 days. She is using p99 which shows a more accurate picture of what most end users experience looks like instead of hiding outliners behind an average latency.


## 
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