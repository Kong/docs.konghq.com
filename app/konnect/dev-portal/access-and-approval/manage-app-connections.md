---
title: Manage Application Registrations
content_type: reference
---

When a developer
[registration](/konnect/dev-portal/applications/dev-reg-app-service) request is approved, it creates a connection between
the developer, their applications, and any associated API product versions. In {{site.konnect_short_name}}, you can revoke, reinstate, or delete a connection to an API product version. This functionality is managed from the **Applications** page within the {% konnect_icon dev-portal %} **Dev Portal** section. 

## Applications section

The Applications section shows existing applications that have been approved to access a Gateway service.

To access the **Applications** section, from the {{site.konnect_product_name}} navigation menu, click {% konnect_icon dev-portal %} **Dev Portal**, then open the **Applications** page.

In this section you can: 

- Search for existing applications.
- View details of an application, such as its name, developer, creation date, and description.
- Access connection details for an application. 

To access an application's details page, open the **Applications** section and click on an application. This details page displays traffic and API Product version connection information for a specific application. From this page you can:

## Revoke an application's connection to an API product version {#revoke-app-connection}

A connection that has been revoked can be
[approved again](#approve-revoked-service-connection) at any time. You can also
[delete](#delete-app-connection) a connection. 
To revoke a connection, follow these steps: 

1. Navigate to the application's details page, by clicking on a specific application from the **Applications** section. 

2. From the **Connections** panel, find a connection that has been rejected, click the context menu, then select **Revoke**.

The status updates from **Approved** to **Revoked**.

## Approve a revoked connection {#approve-revoked-service-connection}

Revoking access to a connection ends the connection between an application and its associated API product version. This action _can_ be undone.
To approve a revoked connection, follow these steps: 

1. Navigate to an application's details page, by clicking on a specific application from the **Applications** section. 

2. From the **Connections** panel, find a connection that has been rejected, click the
context menu, then select **Approve**. 

This status updates from **revoked** to **approved**.

## Delete connection {#delete-app-connection}

When an a connection to an API product version is deleted, if a developer wants to reconnect to the API product version, they must submit a new application registration request. 
To delete a connection from an application, follow these steps: 

1. Navigate to the application's details page, by clicking on a specific application from the **Applications** section. 

2. From the **Connections** panel, find the connection that you want to delete, click the context menu, then select **Delete** 

The connection will be removed from the applications page. 

## Application connection statuses

The following status conditions reflect the current state of an application's connection to an API product version:

**Approved**
: An application connection to an API product version was approved by a {{site.konnect_short_name}} admin.

**Revoked**
: An application connection to an API product version that was formerly approved has been revoked by a
{{site.konnect_short_name}} admin.
