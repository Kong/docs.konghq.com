---
title: Manage Application Registration Requests
no_version: true
---

When a developer [registers an application with a Service](/konnect/dev-portal/applications/dev-reg-app-service),
the requests must be approved by an admin if
[auto approve](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps) is not enabled. When
[application registration is enabled](/konnect/dev-portal/applications/enable-app-reg),
developers must register their applications with a Service.

## Prerequisite

[**Organization Admin** or **Service Admin**](/konnect/org-management/users-and-roles)
permissions.

## Application Registration Status

The following status conditions reflect the current state of a registration request:

**Approved**
: An application created by a developer has been approved to access a Service in the {{site.konnect_short_name}} Dev Portal.

**Pending**
: A developer who has requested access to a Service for an application but has not
yet had their request reviewed by a {{site.konnect_short_name}} admin, if auto approve is not enabled.

**Rejected**
: An application registration request for Service access was rejected by a {{site.konnect_short_name}} admin.

## Requests Page Applications Tab

To access the Requests page Applications tab, from the {{site.konnect_short_name}} navigation menu, click
**Connections** > **Requests** > **Applications** tab.

![Konnect Application Registration Requests](/assets/images/docs/konnect/konnect-requests-app-reg.png)

In the Requests page Applications tab, you can:

- Search for an application in the list by its name.
- [Approve a request](#approve-app-reg) for app registration with a Service.
- [Reject a request](#reject-app-reg) for app registration with a Service.
- [Delete a request](#delete-app-reg) for app registration with a Service.

If there are no pending requests, the No Application Requests message is displayed. The number of
pending requests is displayed in the Requests menu and the Applications tab.

### Approve an app registration request {#approve-app-reg}

1. Click **Connections > Requests > Applications** tab.

   Any pending application requests are
   displayed in the Requests page Applications tab.

2. In the row for Application request you want to approve, click the icon and choose
   **Approve** from the context menu.

   The status is updated from **Pending** to **Approved**. The application
   transfers from the pending Requests page Applications tab to the Applications page.

   An email is sent to the developer to let them know their application registration
   for service access was approved. In the dev portal, the status for the request
   is also updated in the Services pane of the
   [application details](/konnect/dev-portal/applications/dev-apps#app-details-page) page.

### Reject an app registration request {#reject-app-reg}

Rejected requests cannot be approved once rejected.

An application registration request that
was rejected will require the developer to submit another request after
unregistering their application from a Service.

1. Click **Connections > Requests > Applications** tab.

   Any pending application requests
   are displayed in the Requests page Applications tab.

2. In the row for application request you want to reject, click the icon and choose
   **Reject** from the context menu.

   The status is updated to **Rejected**. You can
   let the rejected request remain on the Requests page Applications tab or outright
   [delete](#delete-app-reg) it.

   <!---An email is sent to the developer to let them know their application registration
   for Service access was rejected.--->

   The status displays in the Services pane in the
   application details page available from the developer My Apps dashboard in the dev portal.
   The application will not appear in the Select Application list in the Register service dialog
   until the application is first unregistered.

   ![Konnect Unregister Rejected Application Request to a Service](/assets/images/docs/konnect/konnect-unregister-rejected-app.png)


### Delete an app registration request {#delete-app-reg}

Delete an application registration request. The Delete action cannot be undone.  

After a request is deleted, a developer can register the app for the Service again. The application still
appears in the Select Application list in the Register for Service dialog for the Service.

1. Click **Connections > Requests > Applications** tab.

   Any pending application requests are displayed
   in the Requests page Applications tab.

2. In the row for the application registration request you want to delete, click the icon and choose
   **Delete** from the context menu.

   The request is deleted from the Request page Applications tab. The pending request is also
   deleted from the Services pane of an application in the {{site.konnect_short_name}} Dev Portal.

   <!---An email is sent to the developer to let them know their application registration
   for Service access was deleted.--->
