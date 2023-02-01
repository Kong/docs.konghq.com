---
title: Report Use Cases
content_type: tutorial
badge: plus
---

Custom reporting in {{site.konnect_saas}} gives you the power to monitor your API data in detail and export that data to CSV. 

This tutorial guides you through determining which custom report to create based on KPIs and the process of creating those custom reports for key API metrics. 

In this tutorial scenario, you just joined an organization as an API product manager. Your first task is to create a few reports that model business KPIs so that the executive team and investors have a grasp on the state of the API. You've selected the following KPIs because they would give a brief, but wholistic, understanding of the API: 

* **Number of requests:** This metric measures the total number of requests made to the API. This is good for understanding total usage of an API, and can potentially be used to uncover scalability requirements. 
* **Error response rate:** This metric measures the percentage of requests that result in errors. With this metric, you can potentially pinpoint any issues users of your API are having. 
* **Average throughput:** Throughput is the measurement of the number of requests an API can handle per second. 
* **Latency:** This metric measures the time it takes for the API to respond to a request. This can be a good measure of the user experience  when a user makes a request to an API.

## Build reports 

Let's build some custom reports by navigating to {% konnect_icon analytics %} **Analytics** in the {{site.konnect_short_name}} menu, then **Reports**.

This brings you to a list of all custom reports in the organization. From here, click **New Report** to get started.

### Total number of requests across APIs over the last 30 days

To build a report that displays the total number of requests across all of your APIs over the last 30 days, set the following options in the UI: 

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

### Daily API usage for an API per minute over the last 30 days

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

#### Request per minute for the Account API over the last 30 days

Having access to the daily usage report that you created in the last section can give you a macro view of your API. But to be able to answer questions about anomalies, spikes, and traffic, combining the daily report with a per minute report that displays real-time performance. 

To configure the {{site.konnect_saas}} custom reporting feture to deliver a per minute report for the Account API, set the following options in the UI: 

* **Name**: Account API - RPM (last 30 days)

* **Chart type**: Line chart
* **Date/Time**: Last 30 days
* **Metric**: Requests Per Minute
* **Group by**: Service

add a filter for the Account API: 

* **Filter by**: Service
* **Operator**: In
* **Value**: Account

[screenshot of finished report]

Where a daily report can help stakeholders understand overall demand for the account API, the per minute report provides a more detailed picture. And by combining the two reports you can provide a lot of insight into the usage and performance of your API. 



### Daily API usage by application over the last 30 days

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

If the accounts API is seeing a large number of requests per day and per minute, the organization may need to explore upgrading the API to handle the load. Or explore the current monitization policy to take advantage of the traffic.

If the accounts API is seeing a low amount of per day traffic, but the per minute report shows traffic, you could be dealing with a variety of situations: 

* Activitiy: The API is being used heavily during a specific part of the day. 
* Security: Bots, or scripts, could be attempting to misuse your API. 
* Stability: If the API is experiencing technical issues, such as slow response times or errors, could be resulting in a large number of retries that spike the requests per minute. 



### Latency for an API over the last 30 days

At this point, you have multiple reports that display how your company's APIs are performing generally.

Your company determines that it is critical that payments are processed quickly using the Payments API, so you decide to generate a report that will tell you how performant the Payment API is over the last 30 days. To build the report, set the following options in the UI:

* **Name**: Payment API - Latency (last 30 days)
* **Date/Time**: Last 30 days
* **Chart type**: Line chart
* **Select a metric**: Response latency (p99)
* **Group by**: Service
* **Choose granularity**: Daily
* **Entity Selection**: Payment 

Add a filter for the Payment API. Click on **Add Filter**, then set the following options:
 
* **Filter by**: Service
* **Operator**: In
* **Value**: Payment

[screenshot of finished report]

This report can provide your stakeholders with the answers to questions like:

* How performant has my API been over the last 30 days?
* Is my Payment API processing payments quickly enough?
* Are there any performance outliers?

## Conclusion 

You now have reports that you can use to track the KPIs idetified earlier:

* **Number of requests:** The following reports all display the request count for your APIs:
    * "API usage (last 30 days)"
    * "Daily Accounts API Usage (last 30 days)"
    * "Account API - RPM (last 30 days)"
    * "API Usage by Application (last 30 days)"
* **Error response rate:** 
    * The "API usage (last 30 days)" report displays if there are any errors or issues that might be impacting the number of requests the API is receiving.
* **Average throughput:** The following reports all display the number of requests your APIs can handle per second:
    * "API usage (last 30 days)"
    * "Daily Accounts API Usage (last 30 days)"
    * "Account API - RPM (last 30 days)"
    * "API Usage by Application (last 30 days)"
* **Latency:** 
    * The "Payment API - Latency (last 30 days)" report displays how performant the Payment API is.  
