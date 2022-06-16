---
title: Overview Dashboard
no_version: true
content_type: reference
---

The Overview Dashboard provides metrics for Services cataloged by Service Hub within a selected time interval for the following categories: 

* **Traffic**: Total number of HTTP requests.
* **Errors**: Percentage of failed HTTP requests. 

Each category measures trends by comparing metrics week-over-week. Time periods for trends are fixed to the last seven days and don't change if you select a different time period from the week before.

You can view a graph for each category by clicking **Traffic** or **Errors**, and switching between the two views.

* **Traffic**: This graph displays the total number of HTTP requests categorized by successful and failed requests over the specified time interval.

* **Errors**: This graph displays the total number of failed HTTP requests categorized by error response codes over the specified time interval.

Graphs can be interacted with, including hovering over chart items to display more details, and filtering options by clicking on items in the **legend**. 

You can select a time period using the **time period** drop-down menu. The intervals aggregate data at different increments of time.

Interval | Description  
------|----------|
Last 15 minutes | Data is aggregated in ten seconds increments.
Last hour| Data is aggregated in one minute increments.
Last 3 hours | Data is aggregated in one minute increments.
Last 6 hours | Data is aggregated in ten minute increments.
Last 12 hours| Data is aggregated in ten minute increments. 
Last 24 hours| Data is aggregated in ten minute increments. 
Last 7 days | Data is aggregated in one hour increments. 
Last 30 days | Data is aggregated in one hour increments.

{:.important}
> Free tier users can only select intervals up to 24 hours.

Selecting a different time period changes all of the metrics within the selected category to match the selected period, **except for trends**.
