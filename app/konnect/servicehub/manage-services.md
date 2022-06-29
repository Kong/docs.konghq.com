---
title: Manage Konnect Services
no_version: true
---

Through the [Service Hub](https://cloud.konghq.com/servicehub/), you can
create and manage all {{site.konnect_short_name}} services, service versions, and service
implementations in one place.

Access all {{site.konnect_short_name}} service configuration through the {% konnect_icon servicehub %}
**Service Hub**.

## Add a service to the catalog

1. In the {% konnect_icon servicehub %} Service Hub, click **+ New service**.

1. Enter a **Display name**.

    A display name can be any string containing letters, numbers, or the following
    characters: `.`, `-`, `_`, `~`, or `:`. Do not use spaces in display names.

    For example, you can use `service_name`, `ServiceName`, or `Service-name`.
    However, `Service Name` is invalid.

1. (Optional) Enter a **Description**.

1. Click **Create**.

    A new service is created and {{site.konnect_short_name}} automatically
    redirects to the service's overview page.

## Update a service

1. In the {% konnect_icon servicehub %} Service Hub, select a service from the list.

1. Edit the service name and description directly on this page: click on either
element to reveal a text box, enter the new text, then click outside of the text
box to save.

## Share a service

If you have a Service Admin or Organization Admin role, you can share any
service that you have access to.

For more information, see [Manage Teams, Roles, and Users](/konnect/org-management/teams-and-roles/#entity-and-role-sharing).

1. In the {% konnect_icon servicehub %} Service Hub, select a service from the list.

1. Click **Share service**.

1. Select a user or team to share the service with.

1. Select a role to grant to the user or team.

1. Click **Share service** to save.

## Delete a service

1. In the {% konnect_icon servicehub %} Service Hub, select a service from the list.

1. In the top right of the overview page, click the **Service actions** menu and select
**Delete service**.

1. In the dialog that appears, confirm that you want to delete this service.
