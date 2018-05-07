---
title: Managing Developers
class: page-install-method
---
# Managing Developers for your Developer Portal

You can view developers and their current status (approved, revoked rejected & requested) from the Admin GUI by clicking on the Developers menu item. From here you can see developers in each status by viewing the different tabs.

![Managing Developers](/assets/images/enterprise/gui-developer-tabs.png)

## Approving Developers

Any developer who has requested access to your **developer portal** will appear under the **Requested Access** tab.
Choose to Accept or Reject the developer from the actions in the table row. After selecting an action the corresponding tab will update.
You can choose to have developers automatically approved which will skip this step. To enable follow these steps.

1. Navigate to the DEVELOPER PORTAL AUTHENTICATION section in `kong.conf`
2. Find and change the `portal_auto_approve` configuration option to `on` and remove the `#` from the beginning of the line. 
It should now look like
`portal_auto_approve = on`
3. Restart kong (`kong restart`)

## Viewing Approved Developers

To view all currently accepted developers choose the **Approved** tab. From here you can choose to *Revoke* or *Delete* a particular developer. Additionally you can use this view to send an email to a developer with the **Email Developer** mailto link. See [here](#emailing-developers) for more info.

## Viewing Revoked Developers

To view all currently revoked developers choose the **Revoked** tab. From here you can choose to *re-approve* or *delete* a developer.

## Viewing Rejected Developers

To view all currently Rejected developers choose the **Rejected** tab. Rejected developers completed the registration flow on your Developer Portal but were rejected from the **Request Access** tab. You may approve or completely delete a developer from this tab.

# Emailing Developers

## Inviting Developers to Register

To invite a single or set of developers click the **Invite Developers** button from the top right corner above the tabs.

Use the popup modal to enter email addresses separated by commas. When all emails have been added click **Invite**. This will open a pre-filled message in your default email client with a link to the registration page for your Developer Portal. Each developer is bcc'd by default for privacy. You may choose to edit the message or send as is.

![Invite Developers](/assets/images/enterprise/invite-developers.png)

## Sending Approved Email

To notify a developer they have been approved click the **Email Developer** action from their table row on the **Approved** tab. 

This link will open a pre-filled email in your default email client with a link to the login page & their login email address for your Developer Portal. You may choose to edit the message or send as is.
