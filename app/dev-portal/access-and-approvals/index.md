---
title: Access and Approvals
---

When Dev Portal [security settings](../portals/settings/security#auto-approve-developers) require approval for Developer and Application registration, portal admins will be notified to approve those registratios.

## Developers

A list of all Developers registered for the Dev Portal is listed by default. Email addresses for new signups are validated by the registered Developer.

[Learn more](developers) about the Developer registration process.

### Filters

* **Approved**: Developers who have been previously approved
* **Pending Approval**: Developers who are awaiting approval after registering

### Developer approval

In the list, click the three dots menu on the right side of an unapproved Developer, and select **Approve*. The Developer will now be permitted to login to the portal. 

{:.note}
> If [RBAC is enabled](../portals/settings/security.md#role-cased-access-control) for the portal, a Developer needs to be added to a [Team](teams) in order to view specific APIs or register an API in their Applications.

### Add Developer to Team

Click the three dots menu on the right side of an approved Developer, and select **Add to Team**. Search/select the appropriate Team, and click **Save**. Developers can be members of multiple Teams.

## Applications

When an approved Developer creates an Application (in "My Apps" from the Developers' portal view), the Application will be included in the default list of All Applications.

## Filters

* **Approved**: Applications which have been previously approved
* **Pending Approval**: Applications which are awaiting approval after creation

### Application approval

In the list, click the three dots menu on the right side of an unapproved Application, and select **Approve*. The Application will now be capable of generating credentials / API keys.
