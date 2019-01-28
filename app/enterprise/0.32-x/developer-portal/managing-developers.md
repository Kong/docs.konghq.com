---
title: Managing Developers
book: portal
chapter: 7
---
# Managing Developers for your Developer Portal

In this section you will learn how to manage [developers](/enterprise/{{page.kong_version}}/developer-portal/glossary/#types-of-humans) in your Kong Developer Portal. If you have not yet enabled the Portal follow the [Getting Started](/enterprise/{{page.kong_version}}/developer-portal/configuration/getting-started/) guide.

Once your Kong Developer Portal is enabled you will be able to view developers from the Developers tab in the Admin GUI. If you do not know how to access the Admin GUI see [Accessing Admin GUI](/enterprise/{{page.kong_version}}/admin-gui/).

## Developers Statuses

A status represents the state of a developer and the access they have to your APIs / Developer Portal.

* **Approved**
  * A Developer who can access the Developer Portal. Approved Developers can create credentials &amp; access **all** APIs that allow those credentials.
* **Requested**
  * A Developer who has requested access but has not yet been Approved.
* **Rejected**
  * A Developer who has had their request denied by a Kong Administrator.
* **Revoked**
  * A Developer who once had access to the Developer Portal but has since had access Revoked.

![Managing Developers](https://konghq.com/wp-content/uploads/2018/05/gui-developer-tabs.png)

## Approving Developers

Developers who have requested access to your **Kong Developer Portal** will appear under the **Requested Access** tab.
From this tab you can choose to *Accept* or *Reject* the developer from the actions in the table row. After selecting an action the corresponding tab will update.

### Enabling Auto Approval

You can choose to have developers automatically approved and skip the requested state. To enable follow these steps:

1. Navigate to the `DEVELOPER PORTAL AUTHENTICATION` section in `kong.conf`
2. Find and change the `portal_auto_approve` configuration option to `on`. Don't forget to remove the `#` from the beginning of the line. 
It should now look like:
`portal_auto_approve = on`
3. Restart kong (`kong restart`)

*See [Property References](/enterprise/{{page.kong_version}}/developer-portal/configuration/property-reference) to learn more about configuring the Kong Developer Portal.*

## Viewing Approved Developers

To view all currently approved developers choose the **Approved** tab. From here you can choose to *Revoke* or *Delete* a particular developer. Additionally you can use this view to send an email to a developer with the **Email Developer** `mailto` link. See [Emailing Developers](#emailing-developers) for more info.

## Viewing Revoked Developers

To view all currently revoked developers choose the **Revoked** tab. From here you can choose to *Re-approve* or *Delete* a developer.

## Viewing Rejected Developers

To view all currently rejected developers choose the **Rejected** tab. Rejected developers completed the registration flow on your Developer Portal but were rejected from the **Request Access** tab. You may *Approve* or *Delete* a developer from this tab.

## Emailing Developers

### Inviting Developers to Register

To invite a single or set of developers...

1. Click the **Invite Developers** button from the top right corner above the tabs
2. Use the popup modal to enter email addresses separated by commas
3. After all emails have been added click **Invite**. This will open a pre-filled message in your default email client with a link to the registration page for your Developer Portal

Each developer is bcc'd by default for privacy. You may choose to edit the message or send as is.

![Invite Developers](https://konghq.com/wp-content/uploads/2018/05/invite-developers.png)

### Sending Approved Email

To notify a developer they have been approved click the **Email Developer** action from their table row on the **Approved** tab. 

This link will open a pre-filled email in your default email client with a link to the login page &amp; their login email address for your Developer Portal. You may choose to edit the message or send as is.

Next: [Developer Access &rsaquo;]({{page.book.next}})
