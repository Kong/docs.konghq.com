---
title: Manage Developer Access
no_version: true
---

Manage developers and [developer registration](/konnect/dev-portal/access-and-approval/dev-reg) requests to
access the {{site.konnect_short_name}} Dev Portal. To allow automatic approval of developer registration requests,
enable [auto approve](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps).

## Prerequisite

[**Organization Admin** or **Portal Admin**](/konnect/org-management/users-and-roles)
permissions.

## Developer Status

A status represents the state of developers and their access to the {{site.konnect_short_name}} Dev
Portal:

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

## Requests Page Developers Tab

To access the Requests page Developers tab, from the {{site.konnect_short_name}} navigation menu, click
**Connections** > **Requests** > **Developers** tab.

![Konnect Developer Access Requests](/assets/images/docs/konnect/konnect-requests-dev-reg.png)

In the Requests page Developers tab, you can:

- Search for a developer who has requested access.
- [Approve a developer request](#approve-dev-reg) for access.
- [Reject a developer request](#reject-dev-reg) for access.
- [Delete a developer request](#delete-dev-reg) for access.

If there are no pending requests, the `No Developer Requests` message is displayed. The number of
pending requests is displayed in the Requests menu and the Developers tab.

### Approve a developer's access request {#approve-dev-reg}

1. Click **Connections > Requests > Developers** tab.

   Any pending developer requests are
   displayed in the Requests page Developers tab.

2. In the row for developer request you want to approve, click the icon and choose
   **Approve** from the context menu.

   The status is updated from **Pending** to **Approved**. The developer
   transfers from the pending Requests page Developers tab to the Developers page.

### Reject a developer's access request {#reject-dev-reg}

Rejected requests cannot be approved once rejected. This action cannot be undone.

A developer whose request was rejected but that rejected request still remains in
the Requests page will have to submit another request under a different email address.

If the rejected request is deleted, the developer can register
again with the same email address.

1. Click **Connections > Requests > Developers** tab.

   Any pending developer requests
   are displayed in the Requests page Developers tab.

2. In the row for developer request you want to reject, click the icon and choose
   **Reject** from the context menu.

   The status is updated to **Rejected**. You can
   let the rejected request remain on the Requests page Developers tab or outright
   [delete](#delete-dev-reg) it.

### Delete a developer's access request {#delete-dev-reg}

Delete a developer's request for access. This action cannot be undone. A developer
whose request was deleted will have to submit another request.

1. Click **Connections > Requests > Developers** tab.

   Any pending developer requests are displayed
   in the Requests page Developers tab.

2. In the row for developer request you want to delete, click the icon and choose
   **Delete** from the context menu.

   The request is deleted altogether.

## Developers Page

The Developers page shows all existing developers who have approved (or revoked) access to a
Dev Portal Service. The list of developers to manage populates as more developers
request access and are approved.

To access the Developers page, from the {{site.konnect_short_name}} navigation menu, click **Connections** > **Developers**.

![Konnect Developers](/assets/images/docs/konnect/konnect-devs-page.png)

Use the Developers page to:

- Search by name for an existing developer. Sort any column header in ascending or descending order.
- View details of a developer, such as their current status and applications. Click the row
  to open the developer details page.
- [Revoke access](#revoke-dev-access) for a developer.
- [Reinstate access](#approve-revoked-dev-access) for a revoked developer.
- [Delete a developer](#delete-dev).

### Revoke a developer's access {#revoke-dev-access}

Revoke access for a developer. Reasons for revoking a developer can include
violations of your organization's policies or for some other nefarious reasons.
Revoking access prevents a developer from signing up for access again with the same
email address, unless the revoked request is deleted.

A developer who has been revoked can be
[approved again](#approve-revoked-dev-access) at any time. You can also
[delete a developer](#delete-dev) entirely from the {{site.konnect_short_name}} portal.

1. Click **Connections > Requests > Developers** tab.

2. In the row for developer whose status you want to change, click the icon and choose **Revoke** from the
   context menu.

   The status is updated to **Revoked**.

### Approve a revoked developer again {#approve-revoked-dev-access}

Re-approve access for a revoked developer. A developer whose access was revoked can be approved again
any time at your discretion.

1. Click **Connections > Requests > Developers** tab.

2. In the row for developer whose status you want to change, click the icon and choose **Approve** from the
   context menu.

   The status is updated to **Approved**.

### Delete a developer {#delete-dev}

Delete a developer entirely from the {{site.konnect_short_name}} portal. Reasons for deleting a developer
can include the developer is no longer working for your organization or contributing to your project.
A deleted developer would have to sign up again to request access and approval.
Deleting a developer deletes everything owned by that developer, such as applications.

1. Click **Connections > Requests > Developers** tab.

2. In the row for the developer you want to delete, click the icon and choose **Delete** from the
   context menu.

   The developer and everything owned by that developer in the portal is deleted.
