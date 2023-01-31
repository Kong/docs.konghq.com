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
## Latency for an API over the last 30 days

This use case demonstrates how you can use custom reports to track the latency for an API, the Payment API in this case, over the last 30 days.

1. In {{site.konnect_short_name}}, navigate to **Analytics**, then **Reports**.
1. Click **New Report**.
1. Configure the report with the following:
    * **Name**: Payment API - Latency (last 30 days)
    * **Date/Time**: Last 30 days
    * **Chart type**: Line chart
    * **Select a metric**: Response latency (p99)
    * **Group by**: Service
    * **Choose granularity**: Daily
    * **Entity Selection**: Payment <!-- I don't see this anywhere in the UI? -->
    * Filtering: 
        * **Filter by**: Service
        * **Operator**: In
        * **Value**: Payment
1. Click **Create**.

[screenshot of finished report]

This report can provide your stakeholders with the answers to questions like:

* How performant has my API been over the last 30 days?
* Is my Payment API processing payments quickly enough?
* Are there any performance outliers?
* [struggling to come up with more examples]



### Conclusion 
