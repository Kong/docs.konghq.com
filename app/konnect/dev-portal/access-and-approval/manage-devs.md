---
title: Manage Developer Access
no_version: true
content-type: reference
---

In the {% konnect_icon dev-portal %} **Dev Portal** section, there are three ways to manage access and authorization settings for the Dev Portal: 
* The **Access Requests** page lists developer registration and application registration requests.
* The **Developers** page lists developers who have requested access to the Dev Portal, along with the developer's current status and associated applications.
* The **Applications** page lists applications and their statuses.

To allow automatic approval of developer registration requests,
enable [auto approve](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps).

## Access Requests page

The **Access Requests** page is available by clicking {% konnect_icon dev-portal %} **Dev Portal**, from the {{site.konnect_short_name}} navigation menu. On the **Access Requests** page, you can manage registration requests for developers using the **Developers** tab, and application requests using the **Applications** tab. When auto-approve is disabled, all registration requests must be manually approved from the **Access Requests** page. 

### Manage developer access requests {#approve-dev-reg}

All pending developer requests are displayed in the **Developers** tab in the **Access Requests** section.

To approve or reject an access requests, go to the **Developers** page:

1. Find the developer request you want to view.

2. Click the {% konnect_icon cogwheel %} icon and choose
   **Approve**, **Reject**, or **Delete** from the menu.

The three options available are defined below: 

* **Approve** - The developer access request is approved. The developer is able to log in to the Dev Portal. The developer is now visible from the **Developers** page in {{site.konnect_short_name}}. 
* **Reject** - The developer access request is rejected. Rejected developers are removed from the requests list. The developer is unable to submit another registration request.
* **Delete** - The developer access request is deleted. A developer can submit another registration request. To prevent a developer from submitting requests, you must [revoke](#revoke-dev-access) access.

## Developers page

From this page, you can manage users who have already been approved and are actively using the Dev Portal. 

### Revoke access {#revoke-dev-access}

Revoking access prevents a developer from signing up for access again with the same
email address, unless the revoked request is deleted. Reasons for revoking a developer can include
violations of your organization's policies or other nefarious reasons.

To revoke a developer's access, from the **Developers** page, follow these steps:

1. Find the developer whose status you want to change.
2. Click the {% konnect_icon cogwheel %} icon and choose **Revoke** from the
   context menu.

This action can be undone by clicking the {% konnect_icon cogwheel %} and choosing **Approve**.

### Delete a developer {#delete-dev}

A deleted developer would have to sign up again and request access and approval.
Deleting a developer deletes everything owned by that developer including their applications.
To delete a developer, navigate to the **Developers** page, and follow these steps: 

1. Find the developer whose status you want to change.
2. In the row for the developer you want to delete, click the {% konnect_icon cogwheel %} icon and choose **Delete** from the
   context menu.

### Developers page statuses

A status represents the state of developers and their access to the {{site.konnect_short_name}} Dev Portal.

This list represents all of the statuses an approved developer can be in:

**Approved**
: A developer has been approved to access the {{site.konnect_short_name}} Dev Portal. Approved developers
   can generate credentials and access all APIs that allow those credentials.

**Revoked**
: A developer who had prior access to the {{site.konnect_short_name}} Dev Portal but has since had
  their access revoked.
