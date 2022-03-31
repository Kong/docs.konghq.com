---
title: Manage Application Service Connections
no_version: true
---

Revoke, reinstate, or delete an application's connection to a Service. When a developer
[registers a request](/konnect/legacy/dev-portal/applications/dev-reg-app-service) to access a Service for an
application, and the request is approved either [automatically](/konnect/legacy/dev-portal/access-and-approval/auto-approve-devs-apps)
or by a {{site.konnect_short_name}} admin, it creates an application connection between the
developer, their applications, and the associated Service Versions.

<!---When the state of the application changes, an email is sent to the developer to notify
them about the change in status.--->

## Prerequisite

[**Organization Admin** or **Service Admin**](/konnect/legacy/org-management/users-and-roles)
permissions.

## Application Connection to a Service Status

The following status conditions reflect the current state of an application's connection to a Service:

**Approved**
: An application connection to a Service was approved by a {{site.konnect_short_name}} admin.

**Revoked**
: An application connection to a Service that was formerly approved has been revoked by a
{{site.konnect_short_name}} admin.

## Applications Page

The Applications page shows all existing applications that have approved access to a Dev Portal Service.

To access the Applications page, from the {{site.konnect_product_name}} navigation menu,
click **Connections** > **Applications**.

![Konnect Applications](/assets/images/docs/konnect/konnect-apps-page.png)

Use the Applications page to:

- Search by name for an existing application.
- Sort any column header in ascending or descending order.
- View details of an application, such as its name, developer, creation date, and description.
- Access application connection details for an application. Click a row to open the
  [application connection details](#app-connection-service-details) page.

## Application Connection Details Page {#app-connection-service-details}

The application details page shows all of its connections to a Service.

To access the Applications page, from the {{site.konnect_short_name}} navigation menu,
click **Connections** > **Applications** and click on an application row.

![Konnect Revoke or Delete an Application Connection](/assets/images/docs/konnect/konnect-revoke-delete-app-connection.png)

Use the connection details page to:

- View details of an application, such as the current connection status and available versions of a Service.
- [Revoke access](#revoke-app-connection) for an application connection to a Service.
- [Reinstate access](#approve-revoked-service-connection) for a revoked application connection to a Service.
- [Delete an application connection](#delete-app-connection) to a Service.

### Revoke an Application's Connection to a Service {#revoke-app-connection}

Revoke an application's connection to a Service. A connection that has been revoked can be
[approved again](#approve-revoked-service-connection) at any time. You can also
[outright delete](#delete-app-connection) a connection.

1. Click **Connections > Applications**.

   The Applications page is displayed.

2. Click on an application row.

   The Connections details for an application are displayed.

3. In the row for the Service whose application connection status you want to revoke, click the icon and
   choose **Revoke** from the context menu.

   The status is updated to **Revoked**.

### Approve a Revoked Connection Again {#approve-revoked-service-connection}

Re-approve a connection to a Service for an application. An application connection
that was revoked for a Service can be approved again any time at your discretion.

1. Click **Connections > Applications**.

2. Click on an application row.

3. In the row for Service whose connection status you want to change, click the
icon and choose **Approve** from the context menu.

### Delete an Application's Connection to a Service {#delete-app-connection}

Delete an application's connection to a Service. One reason for deleting a connection
could be the misuse of a Service by an application. A request to register the application
to the Service can be made again by a developer.

1. Click **Connections > Applications**.

2. Click on an application row.

3. In the row for application connection you want to delete, click the icon and choose **Delete** from the
   context menu.
