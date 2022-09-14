---
title: Configuring Kong Manager to Send Email
book: admin_gui
---

A **Super Admin** can invite other **Admins** to register in Kong Manager, and **Admins** 
can reset their passwords using "Forgot Password" functionality. Both of these 
workflows use email to communicate with the user. 

Emails from Kong Manager require the following configuration:

* [`admin_emails_from`](/enterprise/{{page.kong_version}}/property-reference/#admin_emails_from)
* [`admin_emails_reply_to`](/enterprise/{{page.kong_version}}/property-reference/#admin_emails_reply_to)
* [`admin_invitation_expiry`](/enterprise/{{page.kong_version}}/property-reference/#admin_invitation_expiry)

⚠️**Important:** Kong does not check for the validity of email
addresses set in the configuration. If the SMTP settings are 
configured incorrectly, e.g., if they point to a non-existent 
email address, Kong Manager will _not_ display an error message. 

For additional information about SMTP, refer to the 
[general SMTP configuration](/enterprise/{{page.kong_version}}/property-reference/#general-smtp-configuration) 
shared by Kong Manager and Dev Portal.