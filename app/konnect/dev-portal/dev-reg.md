---
title: Sign Up for a Dev Portal Account
no_version: true
---

Anyone that wants to access the {{site.konnect_short_name}} Dev Portal needs to register as a Developer for that specific Dev Portal, including {{site.konnect_short_name}} admins. This means that admins will have separate credentials for [Konnect](https://cloud.konghq.com/) and the Dev Portal.

All Developer registrations are either manually approved by {{site.konnect_short_name}} admins, or automatically approved by configuring your [auto-approve settings](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps/).


## Register as a Developer {#register}

All Developers must register through the {{site.konnect_short_name}} [Dev Portal](/konnect/servicehub/service-documentation/#publishing/). Because each Dev Portal has a unique URL, reach out to your {{site.konnect_short_name}} admin for the URL you should access.

1. Navigate to the {{site.konnect_short_name}} Dev Portal URL provided by your {{site.konnect_short_name}} admin.

2. At the bottom of the login form, click **Sign Up**.

3. Fill out the registration form and click **Create Account**.

   You should receive an email to confirm your email address. Click the verification link in the email.

4. Set a password for your account.

If your admin has auto-approve enabled, you can log into the Dev Portal immediately after setting a password. Learn how to [set up auto-approval for developer access as an admin](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps/).

If auto-approve is not enabled, an admin has to review and approve your request manually. All manually approved developers are notified via email upon gaining access to the Dev Portal. Learn how to [manually approve developer access as an admin](/konnect/dev-portal/access-and-approval/manage-devs/#approve-dev-reg).

## Login/Register with SSO {#sso}
{:.badge .enterprise}
The {{site.konnect_short_name}} Dev Portal supports single sign-on (SSO) login and registration. The {{site.konnect_short_name}} Admin must configure SSO before it's available on the Dev Portal. For information on how to enable SSO on your Dev Portal as a {{site.konnect_short_name}} Admin, review the [enable single sign-on instructions](/konnect/dev-portal/customization/#single-sign-on/).

1. Navigate to the {{site.konnect_short_name}} Dev Portal URL provided by your {{site.konnect_short_name}} admin.

2. From the login form, click **Login with SSO**.

3. After you are redirected to the Identity Provider (IdP) that the {{site.konnect_short_name}} Admin configured, sign in using your IdP's credentials.

4. Once you've logged in, you will be redirected to the {{site.konnect_short_name}} catalog.


## Account Management {#management}

If you attempt to register multiple times with the same email address, you’ll receive an email with the status of your registration. [Possible statuses](/konnect/dev-portal/access-and-approval/manage-devs/#developer-status) are: `Pending`, `Rejected`, `Revoked`, and `Approved`.

If you forget your password, click on "Forgot your password?" and enter the email address associated with your Dev Portal account. If an account exists with the email address provided, you’ll receive an email prompting you to change your password.

Contact your {{site.konnect_short_name}} admin if you have login issues.
