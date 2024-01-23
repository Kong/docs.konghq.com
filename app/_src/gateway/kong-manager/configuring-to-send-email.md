---
title: Configuring Kong Manager to Send Email
badge: enterprise
---

A **Super Admin** can invite other **Admins** to register in Kong Manager, and **Admins**
can reset their passwords using the "Forgot Password" functionality. Both of these
workflows use email to communicate with the user.

Emails from Kong Manager require the following configuration through `kong.conf`:

* [`admin_emails_from`](/gateway/{{page.release}}/reference/configuration/#admin_emails_from)
* [`admin_emails_reply_to`](/gateway/{{page.release}}/reference/configuration/#admin_emails_reply_to)
* [`admin_invitation_expiry`](/gateway/{{page.release}}/reference/configuration/#admin_invitation_expiry)

If running {{site.base_gateway}} in hybrid deployment mode, these admin SMTP settings are meant to be applied to the control plane.

Kong does not check for the validity of email addresses set in the configuration. If the SMTP settings are configured incorrectly, for example if they point to a non-existent email address, Kong Manager will _not_ display an error message.

For additional information about SMTP, refer to the [general SMTP configuration](/gateway/{{page.release}}/reference/configuration/#general-smtp-configuration) shared by Kong Manager and Dev Portal.
