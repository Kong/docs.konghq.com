---
title: Register or Unregister an Application for a Service
no_version: true
toc: true
---

When [application registration is enabled](/konnect/dev-portal/applications/enable-app-reg/),
developers must register their applications with a Service. Requests for access must be
[approved by a Konnect admin](/konnect/dev-portal/applications/manage-app-reg-requests). If
[auto approve](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps) is not enabled.
-Application registration must be enabled for the Service by a {{site.konnect_short_name}} admin.

## Register an Application

From the Dev Portal, a developer is able to register for multiple applicable services. To apply to register an Application to a service, a developer must have a Dev Portal account.

1. Click your Email address in the top right corner of the manager to trigger the drop down menu. Select **My Apps**. 

2. From the list of applications, select the one you want to register. 

3. In the **Services** pane, click **View the catalog**. 

4. Select the service you want to register to from the **Services** menu.

5. In the pop-up modal, select the application you want to register to the selected service. Click **Request Access**.
   

You will be notified by email if your Application is approved.
You can check the status of your request in the [application details](/konnect/dev-portal/applications/dev-apps/#app-details-page) page.

## Unregister an Application

You can unregister an application with a pending, approved, or rejected registration status.
Unregistering a pending request removes the request from the {{site.konnect_short_name}} admin's
approval queue. If a {{site.konnect_short_name}} admin deletes the pending request, the pending request is removed from
the **Services** pane.

1. Click your Email address in the top right corner of the manager to trigger the drop down menu. Select **My Apps**. 

2. Click the application you want to unregister.

3. In the **Services** pane, click the icon for the Service and choose **Unregister**.

## Troubleshooting

If you encounter any of the errors below that appear in the Register dialog, follow the recommended solution.

Error Message | Solution
------------|------------
Application registration is not enabled for this Service. | [Enable application registration for the Service](/konnect/dev-portal/applications/enable-app-reg/). Contact your {{site.konnect_short_name}} admin if you do not have the role permissions to do so.
