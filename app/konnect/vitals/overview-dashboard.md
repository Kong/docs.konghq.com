---
title: Overview Dashboard
no_version: true
content_type: reference
---

The Overview Dashboard provides metrics for Services cataloged by Service Hub within a selected time interval for the following categories: 

* **Traffic**: Total number of HTTP requests.
* **Errors**: Percentage of failed HTTP requests. 

Both categories measure trends by comparing metrics across fixed comparable time intervals and plotting the data points. For example, hour-over-hour, day-over-day, week-over-week, and month-over-month.

You can view a graph for each category by clicking **Traffic** or **Errors**, and switching between the two views.

* **Traffic**: This graph displays the total number of HTTP requests categorized by successful and failed requests over the specified time interval. Succesful requests contain all requests that returned a 1xx-3xx status code. Failed requests contain all requests that returned a 4xx-5xx status code.

* **Errors**: This graph displays the total number of failed HTTP requests categorized by error response codes over the specified time interval.

Graphs can be interacted with, including hovering over chart items to display more details, and filtering options by clicking on items in the **legend**. 

You can select a time period using the **time period** drop-down menu. The intervals aggregate data at different increments of time.

Interval | Description  
------|----------|
Last 15 minutes | Data is aggregated in ten second increments.
Last hour| Data is aggregated in one minute increments.
Last 3 hours | Data is aggregated in one minute increments.
Last 6 hours | Data is aggregated in ten minute increments.
Last 12 hours| Data is aggregated in ten minute increments. 
Last 24 hours| Data is aggregated in ten minute increments. 
Last 7 days | Data is aggregated in one hour increments. 
Last 30 days | Data is aggregated in one hour increments.

{:.important}
> Free tier users can only select intervals up to 24 hours.