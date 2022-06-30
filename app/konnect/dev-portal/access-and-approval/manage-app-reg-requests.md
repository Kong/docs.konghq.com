---
title: Manage Application Registration Requests
no_version: true
---

When a developer [registers an application with a Service](/konnect/dev-portal/applications/dev-reg-app-service),
the requests must be approved by an admin if
[auto approve](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps) is not enabled. When
[application registration is enabled](/konnect/dev-portal/applications/enable-app-reg),
developers must register their applications with a Service. This guide explains different options available to you from the **Applications tab** that is available from the {% konnect_icon connections %} **Connections** section.

## Approve a Request {#approve-app-reg}

The **Applications** tab is for managing developer's requests to register an application with a service, any pending application requests are
displayed here.
This is how you approve an application registration request from the **Applications** tab:

* In the row for an application request you want to approve, click the {% konnect_icon cogwheel %} icon and select
   **Approve** from the context menu.

   The status is updated from **Pending** to **Approved**. The application
   transfers from the **Applications** tab to the **Applications** page.

   An email is sent to the developer to let them know their application to register
   for service was approved. In the Dev Portal, the status for the request
   is also updated in the **Services** pane of the
   [application details](/konnect/dev-portal/applications/dev-apps#app-details-page) page.

If there are no pending requests, the **No Application Requests** message is displayed.

## Reject a Request {#reject-app-reg}

An application registration request that
is rejected requires the developer submit another request after
unregistering their application from a Service.

This is how to reject a request for the **Applications** tab: 

* In the row for an application request you want to reject, click the {% konnect_icon cogwheel %} icon and select
   **Reject** from the context menu.

   The status is updated to **Rejected**. You can
   let the rejected request remain on the Requests page
   [delete](#delete-app-reg) it.

Any pending application requests are displayed in the Requests page Applications tab.


## Delete an app registration request {#delete-app-reg}

After a request is deleted, a developer can re-submit an application registration request. The Delete action cannot be undone.

This is how to delete an application registration request, from the **Applications** tab: 


* In the row for the application registration request you want to delete, click the {% konnect_icon cogwheel %} icon and select
   **Delete** from the context menu.

   The request is deleted from the Request page Applications tab. The pending request is also
   deleted from the **Services** pane of an application in the {{site.konnect_short_name}} Dev Portal.

 
   Any pending application requests are displayed
   in the Requests page Applications tab.


## Application Registration Status {#status}

The following status conditions reflect the current state of a registration request:

**Approved**
: An application created by a developer has been approved to access a Service in the {{site.konnect_short_name}} Dev Portal.

**Pending**
: A developer who has requested access to a Service, but has not
yet had their request reviewed by a {{site.konnect_short_name}} admin. 

**Rejected**
: An application registration request was rejected by a {{site.konnect_short_name}} admin.