---
title: Register or Unregister an Application for a Service
no_version: true
toc: true
---

When [application registration is enabled](/konnect/dev-portal/applications/enable-app-reg/),
developers must register their applications with a Service. Requests for access must be
[approved by a Konnect admin](/konnect/dev-portal/applications/manage-app-reg-requests) if
[auto approve](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps) is not enabled.

## Prerequisites

- Application registration must be enabled for the Service by a {{site.konnect_short_name}} admin.
- [Create an Application](/konnect/dev-portal/applications/dev-apps#create-an-application).

## Register an Application

This procedure assumes that there are no
existing Services configured for an application yet. You can register an application with multiple
applicable Services.

1. Log in to the {{site.konnect_short_name}} Dev Portal to access the Service
Catalog.

2. Click on a Service tile.

    Not all Services may have app registration enabled. Contact
    your {{site.konnect_short_name}} admin if you need it enabled on a Service.

3. Click **Register**.

4. Select the application you want to register from the **Select Application** list.

5. Click **Request Access**.

   A dialog message indicates your registration is under review if Auto Approve is not enabled,
   and you will be notified by email upon approval. Click **Close**.

   You can check the status of your request in the
   [application details](/konnect/dev-portal/applications/dev-apps/#app-details-page) page.

## Unregister an Application

Unregister an application from a Service. Reasons for unregistering include requesting
registration for the incorrect Service, an application is being decommissioned,
or the application registration has been rejected.

You can unregister an application with a pending, approved, or rejected registration status.
Unregistering a pending request removes the request from the {{site.konnect_short_name}} admin's
approval queue.

If a {{site.konnect_short_name}} admin deletes the pending request, the pending request is removed from
the **Services** pane.

1. Click **My Apps**.

2. Click the application you want to unregister.

3. In the **Services** pane, click the icon for the Service and choose **Unregister**.

   The Service connection is removed from the Services pane.

## Troubleshooting

If you encounter any of the errors below that appear in the Register dialog, follow the recommended solution.

Error Message | Solution
------------|------------
Application registration is not enabled for this Service. | [Enable application registration for the Service](/konnect/dev-portal/applications/enable-app-reg/). Contact your {{site.konnect_short_name}} admin if you do not have the role permissions to do so.
