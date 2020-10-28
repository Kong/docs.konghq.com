---
title: Customizing Portal Emails
---

<div class="version-callout"><b>This feature is introduced in 1.3.0.1.</b></div>

## Introduction

Kong Enterprise **1.3.0.1** introduces editable Portal Emails.
This feature allows you to manage the message and appearance of emails being sent by the Kong Developer Portal.
Editable email templates are loaded as files similar to content files for portal rendering.
Email files can be managed in the same way as other files for rendering, via editor or via the Portal CLI Tool.
This feature is **not** supported on legacy portal mode.

If no email templates are loaded, Kong will fall back to the same emails as Kong Enterprise 1.3.0.0
By default on 1.3.0.1 and newer enabling a non-legacy portal on new workspaces loads default editable email templates.
For existing non-legacy Portals, editable email templates must be loaded manually.

Email specific values are templated in via tokens that work similarly to templating in portal layouts and partials.
Not all tokens are supported on all emails.


## Prerequisites

* Kong Enterprise **1.3.0.1** or later
* The Kong Developer Portal is not running in **Legacy Mode**
* The Kong Developer Portal is enabled and running
* [The emails you want are enabled in kong](/enterprise/{{page.kong_version}}/developer-portal/configuration/smtp/#portal_invite_email)
* If using CLI tool, kong-portal-cli tool 1.1 or later is installed locally and git installed


## Understanding Email Files

Portal templates use a combination of HTML, markdown, and [`tokens`](#token-descriptions).

The follow example is the `emails/approved-access.txt`  template:


{% raw %}
```yaml
---
layout: emails/email_base.html

subject: Developer Portal access approved {{portal.url}}
heading: Hello {{email.developer_name}}!
---
You have been approved to access {{portal.url}}.
<br>
Please visit <a href="{{portal.url}}/login">{{portal.url}}/login</a> to login.
```
{% endraw %}

Like other content files, these files have a headmatter between the two `---` . The layout is set by `layout` attribute, this is the layout file this email will render with.

- `subject` sets the subject line for email.
- `heading` is an optional value that by default is rendered as a h3

The body of the email is HTML content. You can reference the tokens allowed for the email in the table below. In this case {% raw %}`{{portal.url}}`{% endraw %} is used to access the portal url

## Supported Emails and Tokens

{% raw %}
|Path	                  |Supported Tokens	                                                                                    |Required Tokens	                                                   |Description|
|--- 	|---	|---	|---	|
|emails/invite.txt	        |  `{{portal.gui_url}}` `{{email.developer_email}}`                                          | `{{portal.gui_url}}`                                                |email sent to developer who is invited to a portal from the manager	|
|---	|---	|---	|---	|
|emails/request-access.txt	|`{{portal.gui_url}}` `{{email.developer_email}}` `{{email.developer_name}}` `{{email.admin_url}}`     	|`{{portal.gui_url}}` `{{email.developer_email}}`	                      |email sent to admin when a developer signs up for portal, in order to approve the developer	|
|emails/approved-access.txt	|`{{portal.url}}` `{{email.developer_email}}` `{{email.developer_name}}`	                            |`{{portal.gui_url}}`	                                                |email sent to developer when their account is approved	|
|emails/password-reset.txt	|`{{portal.url}}` `{{email.developer_email}}` `{{email.developer_name}}` `{{email.token}}` `{{email.token_exp}}` `{{email.reset_url}}`	|`{{portal.url}}` `{{email.token}}` or `{{email.reset_url}}`	|email sent to developer when a password reset  is requested (basic-auth only)	|
|emails/password-reset-success.txt	|`{{portal.url}}` `{{email.developer_email}}` `{{email.developer_name}}`	                    |`{{portal.url}}`	                                                    |email sent to developer when a password reset is successful (basic-auth only) 	|
|emails/account-verification.txt	|`{{portal.url}}` `{{email.developer_email}}` `{{email.developer_name}}` `{{email.token}}` `{{email.verify_url}}` `{{email.invalidate_url}}`	|`{{portal.url}}` `{{email.token}}` or  both `{{email.verify_url}}` and `{{email.invalidate_url}} `	|email sent to developer when portal_email_verification is on  to verify developer email (basic-auth only)	|
|emails/account-verification-approved.txt	|`{{portal.url}}` `{{email.developer_email}}` `{{email.developer_name}}`	              |`{{portal.url}}`	                                                    |email sent to developer when portal_email_verification is on and developer has verified email and developer has been approved by admin/auto-approve is on (basic-auth only)	|
|emails/account-verification-pending.txt	|`{{portal.url}}` `{{email.developer_email}}` `{{email.developer_name}}`	              |`{{portal.url}}`	                                                    |email sent to developer when portal_email_verification is on and developer has verified email and developer has yet to be approved by admin (basic-auth only)	|
{% endraw %}


## Token Descriptions

{% raw %}
|Token	|Description	|
|---	|---	|
|`{{portal.url}}`	|Dev Portal URL for the workspace	|
|---	|---	|
|`{{email.developer_email}}`	|Developers email	|
|`{{email.developer_name}}`	|Developers full name, this value is collected as part of registration by default. If meta-fields are edited to not include full_name then this will fallback to email 	|
|`{{email.admin_url}}`	|Kong Manger URL	|
|`{{email.reset_url}}`	|Dev Portal full URL for resetting password (assumes default path for password reset) 	|
|`{{email.token_exp}}`	|Human readable string for amount of time from sending of email, password reset token/url is valid.	|
|`{{email.verify_url}}`	|Link to verify account (assumes default path for account verification))	|
|`{{email.invalidate_url}}`	|Link to invalidate account verification request (assumes default path for account verification))	|
|`{{email.token}}`	|Can be used in combination with `{{portal.url}}` to manually build url string for password reset and account verification/invalidation. **Not recommended for use**, unless custom path for password reset or account verification has been set.	|
{% endraw %}


## Editing Email Templates

The default email templates will be automatically loaded into the Kong Developer Portal's file system when the Dev Portal is activated. These templates can now be edited in Kong Manager via the **Portal Editor** or via the **Portal CLI** tool.
**Note:** If you are using a Dev Portal initiated in a Kong Enterprise version prior to 1.3.0.1, you will need to manually load the email templates into the file system. Follow the steps in [Loading Email Templates on Existing Dev Portals](#loading-email-templates-on-existing-dev-portals).

### Editing via the Portal Editor

Email templates can now be edited in the Portal Editor along with the rest of the files in the Kong Developer Portal file system. To view and edit these files:

1. Log into Kong Manager and navigate to the Workspace whose Dev Portal you wish to edit.
2. Select the **Editor** from the sidebar under **Dev Portal**

The email templates can be found under the **Emails** section in the Portal Editor sidebar:

![Portal Editor - Emails](https://doc-assets.konghq.com/1.3/dev-portal/editor/dev-portal-emails.png)

### Editing via the Portal CLI Tool

1. Clone [https://github.com/Kong/kong-portal-templates] master branch, and navigate into its directory
2. If you have any customizations or permissions changes that you wish to keep:
    Run `portal fetch <workspacename>` This will pull in your modifications locally.
3.  After making any changes  `portal deploy <workspacename>` to deploy all files.


## Editing Email Appearance

To edit the appearance of emails, you can change the layout file emails use.
By default emails are set to use the layout `emails/email_base.html` if this file does not exist in side your theme(default theme is `base`) then a hardcoded fallback will be used.

You can edit the layout this layout file via the Portal Editor or locally with the Portal CLI tool, follow the instructions for the editing email text, but instead modifying the layout file.

If you want different emails to have a different appearance, you can set different layout files for each email file.

The default email layout looks like:

{% raw %}
```html

<!DOCTYPE html>
<html>
  <head>
  </head>
  <body>
    <img
      src="{{portal.url}}/{{theme.images.logo}}"
      alt="{{portal.name}}"
      style="max-height: 32px; max-width: 200px;">
    <h3>{{page.heading}}</h3>
    <p>
      {*page.body*}
    </p>
  </body>
</html>
```
{% endraw %}


The `img` tag loads the logo that can be set in the appearance tab in the manager. If you do not want to display a logo, remove the `<img>` tag. If you want to set different sizing for your logo, you can change the inline style attribute.

> Note: Logo will not render for many email clients that pre-fetch images if portal is not set to be accessible from a public url (for example if you are testing the Portal with a localhost)

By modifying the html of this file, you can change the appearance of your emails. For example if you wanted to add a footer that would show on all emails, add it under the `<p>` tag

Be sure to keep in mind the html support limitations of the email clients you plan to support.



## Loading Email Templates on Existing Dev Portals

**Note:** This is only necessary for existing Dev Portals created on Kong Enterprise 1.3.0, new Portals created in 1.3.0.1 and later will have these files already loaded, unless manually deleted.

Editable email templates can be loaded either via the editor or via the `kong-portal-cli` tool.

### Load Email Templates via the Portal Editor

1. Log into Kong Manager and navigate to the workspace you want to edit. Click on **Editor** in the sidebar.
2. Press the “New File+” button in the top left.
3. Select Content type “email”
4. Type in one of the supported paths from above
5. Press create File, this will generate a default email template that is valid for that email.
6. Do this for emails you wish to edit.

    Note: By default these emails you create will have layout key set:  `layout: emails/email_base.html`
    If you don’t create this layout file, all emails fallback to a default layout.
    You will want to create this layout if you want to customize the Appearance of emails in addition to message.

To create an email layout:

1. Press the “New File+” button in the top left.
2. Select Content type “theme”
3. Type in the path for the layout, `themes/<THEME_NAME>/layouts/email_base.html`. The default theme name is base.
    The layout that loads in the new portals in 1.3.0.1 is the following, (this adds the logo image that can be set in the appearance tab in the manager):

{% raw %}
```html

<!DOCTYPE html>
<html>
  <head>
  </head>
  <body>
    <img
      src="{{portal.url}}/{{theme.images.logo}}"
      alt="{{portal.name}}"
      style="max-height: 32px; max-width: 200px;">
    <h3>{{page.heading}}</h3>
    <p>
      {*page.body*}
    </p>
  </body>
</html>
```
{% endraw %}

Find out more about customizing the email layout in the section below

### Load Email Templates via the Portal CLI Tool

1. Clone the [portal templates master branch](https://github.com/Kong/kong-portal-templates) and
   navigate into the folder you cloned.
2. If you have any customizations or permissions changes that you want to keep:

     1. Run `portal fetch <workspacename>`. This pulls in your modifications locally.

     2. Merge in the portal templates master branch
        to apply changes for 1.3.0.1, including emails.

3. Run `portal deploy <workspacename>`. This deploys all files.
