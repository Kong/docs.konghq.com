---
title: Managing Developers
badge: enterprise
---

## Developer Status

A status represents the state of a developer and the access they have to the Dev
 Portal and APIs:

* **Approved**
  * A developer who can access the Dev Portal. Approved developers can create
  credentials &amp; access **all** APIs that allow those credentials.
* **Requested**
  * A developer who has requested access but has not yet been Approved.
* **Rejected**
  * A developer who has had their request denied by a Kong admin.
* **Revoked**
  * A developer who once had access to the Dev Portal but has since had access
  Revoked.


![Managing Developers](https://konghq.com/wp-content/uploads/2018/05/gui-developer-tabs.png)

## Approving Developers

Developers who have requested access to a Dev Portal will appear under the
**Requested Access** tab. From this tab, you can choose to *Accept* or *Reject*
the developer from the actions in the table row. After selecting an action, the
corresponding tab is updated.


## View Approved Developers

To view all currently approved developers, click the **Approved** tab. From here, you can choose to *Revoke* or *Delete* a particular developer. Additionally, you can use this view to send an email to a developer with the **Email Developer** `mailto` link. See [Emailing Developers](#emailing-developers) for more info.


## View Revoked Developers

To view all currently revoked developers, click the **Revoked** tab. From here, you can choose to *Re-approve* or *Delete* a developer.


### View Rejected Developers

To view all currently rejected developers, click the **Rejected** tab. Rejected developers completed the registration flow on your Dev Portal but were rejected from the **Request Access** tab. You may *Approve* or *Delete* a developer from this tab.


## Email Developers

### Invite Developers to Register

To invite a single or multiple developers:

1. Click **Invite Developers**.
2. Use the popup modal to enter email addresses separated by commas.
3. After all emails have been added, click **Invite**. A pre-filled message
opens in your default email client with a link to the registration page for
your Dev Portal.

Each developer is BCC'd by default for privacy. You may choose to edit the message or send as is.

![Invite Developers](https://konghq.com/wp-content/uploads/2018/05/invite-developers.png)

## Developer Management Property Reference

For comprehensive documentation on developer management properties, see [Default Dev Portal Authentication](/gateway/{{page.release}}/reference/configuration/#default-developer-portal-authentication-section).
