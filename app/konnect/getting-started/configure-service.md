---
title: Configuring a Service
no_search: true
no_version: true
beta: true
---

## Add a Service and Version

For the purpose of this example, you’ll create a Service, version it, and
expose the version by creating an implementation pointing to the Mockbin API.
Mockbin is an *echo*-type public website that returns requests back to the
requester as responses.

1. On the Services page, click **Add New Service**.

2. Enter a **Service Name**. For this example, enter `example_service`.

    A Service Name can be any string containing letters, numbers, or characters;
    for example, `service_name`, `Service Name`, or `Service-name`.

3. Enter a **Version Name**. For this example, enter `v.1`.

    A Version Name can be any string containing letters, numbers, or characters;
    for example, `1.0.0`, `v.1`, or `version#1`. A Service can have multiple
    Versions.

4. (Optional) Enter a **Description**.

5. Click **Create**.

    A new Service is created and the page automatically redirects back to the
    **example_service** overview page.


## Summary and Next Steps

In this section, you added a Service named `example_service` with the version
`v.1`.

Next, go on to [implement the Service Version](/konnect/getting-started/implement-service).
