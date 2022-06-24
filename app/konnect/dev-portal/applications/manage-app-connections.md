---
title: Manage Application Service Connections
no_version: true
---

When a developer
[registration](/konnect/dev-portal/applications/dev-reg-app-service) request is approved, it creates an application connection between the
developer, their applications, and the associated Service Versions. In Konnect Cloud you can revoke, reinstate, or delete an application's connection to a Service. functionality is managed from the **Applications** page. 

## Applications Page

The Applications page shows existing applications that have been approved to access a Konnect Service.

To access the Applications page, from the {{site.konnect_product_name}} navigation menu, click {% konnect_icon connections %} **Connections**, then open the **Applications** tab.

Use the Applications page to:

- Search by name for an existing application.
- Sort any column header in ascending or descending order.
- View details of an application, such as its name, developer, creation date, and description.
- Access application connection details for an application. Click a row to open the
  [application connection details](#app-connection-service-details) page.

## Application Connection Details Page {#app-connection-service-details}

The application details page shows all of its connections to a Service.

To access the Applications page, from the {{site.konnect_short_name}} navigation menu,
click {% konnect_icon connections %} **Connections**, then open the **Applications** tab and click on an application row.


Use the connection details page to:

- View details of an application, such as the current connection status and available versions of a Service.
- [Revoke access](#revoke-app-connection) for an application connection to a Service.
- [Reinstate access](#approve-revoked-service-connection) for a revoked application connection to a Service.
- [Delete an application connection](#delete-app-connection) to a Service.



## Approve a Revoked Connection {#approve-revoked-service-connection}

1. Click {% konnect_icon connections %} **Connections**, then open the **Applications** tab.

2. Click on an application row.

3. In the row for a Service whose connection status you want to change, click the
icon and choose **Approve** from the context menu.

Connections that have been previously revoked can also be reapproved by following the same steps. 
## Revoke an Application's Connection to a Service {#revoke-app-connection}


 A connection that has been revoked can be
[approved again](#approve-revoked-service-connection) at any time. You can also
[delete](#delete-app-connection) a connection.

1. Click {% konnect_icon connections %} **Connections**, then open the **Applications** tab.

   The Applications page is displayed.

2. Click on an application row.

   The Connections details for an application are displayed.

3. In the row for the Service whose application connection status you want to revoke, click the icon and
   choose **Revoke** from the context menu.

   The status is updated to **Revoked**.


### Delete an Application's Connection to a Service {#delete-app-connection}

Delete an application's connection to a Service. A request to register the deleted application
must be made again by a developer. 

1. Click {% konnect_icon connections %} **Connections**, then open the **Applications** tab.

2. Click on an application row.

3. In the row for application connection you want to delete, click the icon and choose **Delete** from the
   context menu.

## Application Connection Statuses

The following status conditions reflect the current state of an application's connection to a Service:

**Approved**
: An application connection to a Service was approved by a {{site.konnect_short_name}} admin.

**Revoked**
: An application connection to a Service that was formerly approved has been revoked by a
{{site.konnect_short_name}} admin.