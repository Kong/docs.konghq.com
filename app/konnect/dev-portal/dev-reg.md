---
title: Sign Up for a Dev Portal Account
---

Anyone that wants to access the {{site.konnect_short_name}} Dev Portal needs to register and request access to that specific Dev Portal, including {{site.konnect_short_name}} admins. Admins will have separate credentials for [{{site.konnect_short_name}}](https://cloud.konghq.com/) and the Dev Portal.

If your organization has multiple [geographic regions](/konnect/geo/), developers must register and request access to the Dev Portal in each geo separately. Dev Portals in different geos don't share any data, including developer information.

Developer registrations can be manually approved by {{site.konnect_short_name}} admins, or automatically approved by configuring your [auto-approve settings](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps/).


## Register as a Developer {#register}

All developers must register through the {{site.konnect_short_name}} Dev Portal. A {{site.konnect_short_name}} admin can provide you with the correct registration URL. 

To register as a developer, navigate to the {{site.konnect_short_name}} Dev Portal and follow these steps: 

1. Click **Sign Up**.

2. Fill out the registration form, then click **Create Account**.

3. A registration link will be sent to the email address you registered. Click the verification link in the registration email. 

4. Create a password for your account.

If your admin has enabled auto-approve, you can log into the Dev Portal immediately after setting a password. For more information on auto-approving registration, read the [set up auto-approval for developer access as an admin](/konnect/dev-portal/access-and-approval/auto-approve-devs-apps/) documentation.

If auto-approve is not enabled, an admin has to review and approve your request manually. All manually approved developers are notified via email upon gaining access to the Dev Portal. To learn more about the manual approval process, read the [manual approval](/konnect/dev-portal/access-and-approval/manage-devs/#approve-dev-reg) documentation.

## Login/Register with SSO {#sso}

The {{site.konnect_short_name}} Dev Portal supports single sign-on (SSO) login and registration. The {{site.konnect_short_name}} admin must configure SSO before it's available on the Dev Portal. For information on how to enable SSO on your Dev Portal as a {{site.konnect_short_name}} admin, review the [single sign-on setup instructions](/konnect/dev-portal/customization/#single-sign-on/). 

To log in to the Dev Portal using SSO, navigate to the Dev Portal and follow these steps: 

1. From the login form, click **Login with SSO**.

2. After you are redirected to the identity provider (IdP), log in using your IdP's credentials.

3. You will be automatically logged in and redirected to the Dev Portal catalog.

## Account Management {#management}

If you attempt to register multiple times with the same email address, you will receive an email with a registration status. [Possible statuses](/konnect/dev-portal/access-and-approval/manage-devs/#status/) are: `Pending`, `Rejected`, `Revoked`, and `Approved`.

If you forgot your password: 

* From the Dev Portal, click on "Forgot your password?" and enter the email address associated with your Dev Portal account.

If an account exists with the email address provided, you’ll receive an email prompting you to change your password.

Otherwise, contact a {{site.konnect_short_name}} admin if you have login issues.
