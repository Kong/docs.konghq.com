---
title: Manage Developer Access
no_version: true
---
From the **Connections** menu, you can manage developers and developer registration requests to
access the {{site.konnect_short_name}} Dev Portal. The **Connections** section contains three pages to help you manage different aspects of the Dev Portal:
* From the **Requests** page, you can manage developer and application registration requests.
* By clicking the **Developers** menu, you can manage access to your Dev Portal for individual developers.
* The **Applications** menu lists applications and their statuses.

To allow automatic approval of developer registration requests,
enable [auto approve](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps).

## Requests page

The **Requests** page is available by clicking the **Connections** tab from the {{site.konnect_short_name}} navigation menu. On the **Requests** page, you can manage registration requests for developers with the **Developers** tab, and applications with the **Applications** tab.


From the Developers tab, you can:

- [Approve a developer request for access.](#approve-dev-reg)
- [Reject a developer request for access.](#reject-dev-reg)
- [Delete a developer request for access.](#delete-dev-reg)
- [Approve a request for app registration with a Service.](/konnect/dev-portal/access-and-approval/manage-app-reg-requests/#approve-app-reg)
- [Reject a request for app registration with a Service.](/konnect/dev-portal/access-and-approval/manage-app-reg-requests/#reject-app-reg)
- [Delete a request for app registration with a Service.](/konnect/dev-portal/access-and-approval/manage-app-reg-requests/#delete-app-reg)
- Search for a developer who has requested access.

If there are no pending requests, a `No Developer Requests` message is displayed. The number of
pending requests is displayed in the Developers tab. See our list of [all available statuses](#status).


### Approve access request {#approve-dev-reg}
Once developers start registering for your Dev Portal, you can manually approve their applications. All pending developer requests are displayed in the **Developers** tab within the **Requests** section.

1. From the **Developers** tab, find the developer request you want to approve.

2.  Click the {% konnect_icon cogwheel %} icon then choose
   **Approve** from the context menu.

The status status is updated from **Pending** to **Approved**. The developer
is now visible on the _Developers_ page and is no longer shown on the _Requests_ page.

### Reject access request {#reject-dev-reg}
You can to reject a developer's request to register for your Dev Portal. Rejecting a developer will prevent them from accessing the Dev Portal. You can reject an access request from the **Developers** tab:

1.  From the **Developers** tab, find the developer request you want to reject.

2.  In the row for developer request you want to reject, click the {% konnect_icon cogwheel %} icon and choose
   **Reject** from the context menu.

   The status is updated to **Rejected**. You can
   let the rejected request remain on the Requests page Developers tab or
   [delete](#delete-dev-reg) it.

A developer whose request was rejected will have to use a different email address to register for the Dev Portal.
If a rejected request is deleted, the developer can register
again with the same email address.

{:.note}
> **Note:** Rejected requests cannot be approved once rejected. This action is permanent.

### Delete access request {#delete-dev-reg}

You can delete a developer's request to access your Dev Portal. This action cannot be undone. A developer
whose request was deleted will have to submit another request.

You can delete a developers access request from the **Developers** tab:

1. From the **Developers** tab, find the developer request you want to delete.

2. In the row for developer request you want to delete, click the {% konnect_icon cogwheel %} icon and choose
   **Delete** from the context menu.

## Developers Page

The Developers Page lists developers who have requested access to the Dev Portal, along with the developers’ current status and associated applications.
To access the Developers page, from the {{site.konnect_short_name}} navigation menu, click **Connections** then select the **Developers** tab.

Use the Developers page to:

- Search by name for an existing developer. Sort any column header in ascending or descending order.
- View details of a developer, such as their current status and applications. Click the row
  to open the developer details page.
- [Revoke access](#revoke-dev-access) for a developer.
- [Reinstate access](#approve-revoked-dev-access) for a revoked developer.
- [Delete a developer](#delete-dev).

### Revoke a developer's access {#revoke-dev-access}

Reasons for revoking a developer can include
violations of your organization's policies or other nefarious reasons.
Revoking access prevents a developer from signing up for access again with the same
email address, unless the revoked request is deleted.

A developer who has been revoked can be
[approved again](#approve-revoked-dev-access) at any time. You can also
[delete a developer](#delete-dev) entirely from the {{site.konnect_short_name}} portal.

1. From the **Developers** page, find the developer whose status you want to change.
2. Click the {% konnect_icon cogwheel %} icon and choose **Revoke** from the
   context menu.

### Approve a revoked developer again {#approve-revoked-dev-access}

A developer whose access was revoked can be approved again
at any time at your discretion.


1. From the **Developers** page, find the developer whose status you want to change.
2. In the row for the developer whose status you want to change, click the {% konnect_icon cogwheel %} icon and choose **Approve** from the
   context menu.

### Delete a developer {#delete-dev}

A deleted developer would have to sign up again to request access and approval.
Deleting a developer deletes everything owned by that developer, such as applications.


1. From the **Developers** page, find the developer whose status you want to change.
2. In the row for the developer you want to delete, click the {% konnect_icon cogwheel %} icon and choose **Delete** from the
   context menu.

## Developer status {#status}

A status represents the state of developers and their access to the {{site.konnect_short_name}} Dev Portal.

This list represents all of the statuses a developer's request can be in:

**Approved**
: A developer has been approved to access the {{site.konnect_short_name}} Dev Portal. Approved developers
   can generate credentials and access all APIs that allow those credentials.

**Pending**
: A developer who has requested access but has not yet had their request reviewed by a {{site.konnect_short_name}} admin.

**Rejected**
: A developer who has had their developer access request rejected by a {{site.konnect_short_name}} admin.

**Revoked**
: A developer who had prior access to the {{site.konnect_short_name}} Dev Portal but has since had
  their access revoked.
