---
title: API Requests
beta: true
---

API Requests in {{site.konnect_short_name}} Analytics provides a fully integrated and intuitive web experience that allows you to view detailed records for requests made to your API, in near real-time.

Here are a couple of benefits of using API Requests:
* **Understand usage behavior:** By analyzing API requests, organizations can derive insights about consumer behavior, popular endpoints, peak usage times, and more. This information can be crucial for making informed decisions about product development and marketing strategies.
* **Built-in troubleshooting:** API requests can provide valuable insights into the sequence of events leading up to a problem. They can help identify what went wrong and where, making it easier to diagnose and fix issues. All that, out of the box within Konnect.

![api requests](/assets/images/konnect/analytics/konnect-analytics-api-requests.png)
> _**Figure 1:** Example API Requests list filtered by error codes and a single request selected._

## Inspect and filter API requests

At a glance, each API request on the Requests page shows the following information:
* Timestamp when the API request was made.
* Status code returned for the API request.
* HTTP method of the API request.
* Path that was requested.
* Latency numbers for:
  * Response: how long it took to return the request
  * Kong: how long it took for Kong to process the request
  * Upstream: how long it took for your upstream service to return the request back to Kong.

By clicking on a single API request, you can further inspect that request and see, for example, which API Product, Application, Consumer, or Control Plane is associated with this request. You can now continue to investigate each associated entity to see its configuration and adjust it if necessary.

You can filter API requests by specific properties such as a certain Gateway service or only a particular route of interest. You can also filter API requests for up to seven days.

## Share

API Requests encodes your filters into the browser URL which allows you to easily bookmark or share common filter criteria for quicker access to the exact requests you’d like to view at any given time.
