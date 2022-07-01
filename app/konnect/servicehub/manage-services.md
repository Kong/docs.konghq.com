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

1. In the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), click **New service**.

1. Enter a display name.

    A display name can be any string containing letters, numbers, spaces, or the following
    characters: `.`, `-`, `_`, `~`, or `:`. Spaces are equal to the `-` character.

    For example, you can use `example_service`, `ExampleService`, `Example-Service`, or `Example Service`.
    `Example-Service` and `Example Service` would be considered the same name.

    The display name you create generates a service name. {{site.konnect_short_name}}
    uses the service name for internal metadata.

1. (Optional) Enter a description.

1. Click **Create**.

    A new service is created and {{site.konnect_short_name}} automatically
    redirects to the service's overview page.

## Add labels to a service

1. In the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service from the list.

1. In the header next to **Labels**, click **Edit**.

1. Click **Add label** and add any labels in `key:value` pair format.

    For example, you might set `location:us-west`, where `location` is the key
    and the `us-west` is the value.

    These labels are completely custom. Set anything that you need.

1. Click **Save**.

## Update a service

1. In the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service from the list.

1. Edit any of the following:
  * **Service display name**: Click on the name to reveal a text box, then click outside of the text box to save.
  * **Service description**: Click **Edit** next to the description, make your edits, then click the checkmark to save.
  * **Labels**: Click **Edit** next to the labels, make your edits, then click **Save**.

## Share a service

If you have a Service Admin or Organization Admin role, you can share any
service that you have access to.

For more information, see [Manage Teams, Roles, and Users](/konnect/org-management/teams-and-roles/#entity-and-role-sharing).

1. In the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service from the list.

1. Click **Share service**.

1. Select a user or team to share the service with.

1. Select a role to grant to the user or team.

1. Click **Share service** to save.

## Delete a service

Deleting a service permanently removes it and all of its service versions, implementations, routes, and plugins from the Service Hub.

1. In the {% konnect_icon servicehub %} [**Service Hub**](https://cloud.konghq.com/servicehub), select a service from the list.

1. Click the **Service actions** drop-down menu and select **Delete service**.

1. Confirm that you want to permanently delete this service.
