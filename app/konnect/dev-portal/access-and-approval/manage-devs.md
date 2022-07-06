---
title: Manage Developer Access
no_version: true
content-type: reference
---
**Connections** is used to manage Dev Portal registration requests, and Dev Portal developer accounts.
The **Connections** section contains three pages to help you manage different aspects of the Dev Portal:
* The **Requests** page has options to manage developer and application registration requests.
* The **Developers** page has options to manage access to your Dev Portal for individual developers.
* The **Applications** page lists applications and their statuses.

To allow automatic approval of developer registration requests,
enable [auto approve](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps).

## Requests page

The **Requests** page is available by clicking {% konnect_icon connections %} **Connections**, from the {{site.konnect_short_name}} navigation menu. On the **Requests** page, you can manage registration requests for developers by clicking the **Developers** tab, and application requests by clicking the **Applications** tab.

### Approve access request {#approve-dev-reg}

After developers register for the Dev Portal their applications must be manually approved. All pending developer requests are displayed in the **Developers** tab within the **Requests** section. The number of pending requests is displayed in the Developers tab. If there are no pending requests, a `No Developer Requests` message is displayed.

To approve a developers registration application from the **Developers** page, follow these steps:

1. Find the developer request you want to approve.

2.  Click the {% konnect_icon cogwheel %} icon and choose
   **Approve** from the context menu.

The status is updated from **Pending** to **Approved**. The developer
is now visible in the **Developers** page and is no longer shown in the **Requests** section.

### Reject access request {#reject-dev-reg}

You can to reject a developer's request to register to the Dev Portal. Rejecting a developer will prevent them from accessing the Dev Portal. You can reject an registration request from the **Developers** tab. 

To reject a developer's registration request, from the **Developers** tab follow these steps: 

1.  Find the request you want to reject.

2.  In the row for developer request you want to reject, click the {% konnect_icon cogwheel %} icon and choose
   **Reject** from the context menu.

   The status is updated to **Rejected**. You can
   let the rejected request remain on the requests page or
   [delete](#delete-dev-reg) it.

A developer whose request was rejected will have to use a different email address to register for the Dev Portal.
If a rejected request is deleted, the developer can re-register with the same email address.

{:.note}
> **Note:** Rejecting a request is a permanent action. Rejected requests cannot be approved once rejected. 

### Delete access request {#delete-dev-reg}

You can delete a developer's access request. This action cannot be undone. A developer
whose request was deleted will have to submit another request.

To delete an access request from the **Developers** tab follow these steps: 

1. Find the developer request you want to delete.

2. In the row for developer request you want to delete, click the {% konnect_icon cogwheel %} icon and choose
   **Delete** from the context menu.

### Revoke a developer's access {#revoke-dev-access}

Revoking access prevents a developer from signing up for access again with the same
email address, unless the revoked request is deleted. Reasons for revoking a developer can include
violations of your organization's policies or other nefarious reasons.

A developer who has been revoked can be
[approved again](#approve-revoked-dev-access) at any time. You can also
[delete a developer](#delete-dev) entirely from the {{site.konnect_short_name}} Portal.

To revoke a developer's access, from the **Developers** page follow these steps:

1. Find the developer whose status you want to change.
2. Click the {% konnect_icon cogwheel %} icon and choose **Revoke** from the
   context menu.

### Approve a revoked developer again {#approve-revoked-dev-access}

A developer whose access was revoked can be re-approved
at your discretion.
To re-approve a revoked developer, navigate to the **Developers** page, and follow these steps: 

1. Find the developer whose status you want to change.
2. In the row for the developer whose status you want to change, click the {% konnect_icon cogwheel %} icon and choose **Approve** from the
   context menu.

### Delete a developer {#delete-dev}

A deleted developer would have to sign up again and request access and approval.
Deleting a developer deletes everything owned by that developer including their applications.
To delete a developer, navigate to the **Developers** page, and follow these steps: 

1. Find the developer whose status you want to change.
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
