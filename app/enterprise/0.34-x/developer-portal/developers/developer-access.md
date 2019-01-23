---
title: Developer Account Management
---

## Granting Access to Developers

Since [Developers][developers] are a type of [Consumer](/0.13.x/getting-started/adding-consumers/), plugins and auth credentials can be similarly applied to them. In this section we will learn how Developers can get access to your routes and services by managing their credentials.

## How to Manage Your Developer Credentials

As a Developer, once you are [approved](/enterprise/{{page.kong_version}}/developer-portal/management/developers/#developer-status), you can login to the Dev Portal Dashboard and [create](#creating-a-credential), [update](#updating-a-credential), or [delete](#deleting-a-credential) credentials. The credential options available will be based on which authentication plugins the Kong admin has enabled.

Current plugins supported:

- [ACL](/plugins/acl/)
- [Basic Authentication](/plugins/basic-authentication/)
- [Key Authentication](/plugins/key-authentication/)
- [OAuth 2.0](/plugins/basic-authentication/)
- [HMAC Signature Authentication](/plugins/hmac-authentication/)
- [JWT](/plugins/jwt/)

> Note: This refers to Developer API credentials, not authentication for access to the Dev Portal. Learn more about which authentication plugins are supported by the Dev Portal on the [Authentication](/enterprise/{{page.kong_version}}/developer-portal/configuration/authentication) page.

<video width="100%" autoplay loop controls>
  <source src="https://konghq.com/wp-content/uploads/2018/05/May-16-2018-15-44-26_.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

### Creating a Credential

In the Dev Portal Dashboard, click "Create API Credential". Select the Authentication plugin from the dropdown inside the modal window and fill out the form. Click "Create API Credential" inside the modal and you should see a confirmation that the credential was successfully created.

### Updating a Credential

In the Dev Portal Dashboard, find the credential you wish to edit. Click "Edit". Edit the form inside the modal window with updated information, then click "Edit API Credential". You should see a confirmation that the credential was successfully saved.

### Deleting a Credential

> WARNING: This is a destructive action. Deleting a credential means that all applications or services using this credential will no longer have access.

In the Dev Portal Dashboard, find the credential you wish to delete. Click the trash icon <svg data-v-1421dd7e="" width="14" height="16" xmlns="http://www.w3.org/2000/svg"><path data-v-1421dd7e="" d="M3 3V2c0-1.1045695.8954305-2 2-2h4c1.1045695 0 2 .8954305 2 2v1h2c.5522847 0 1 .4477153 1 1v1H0V4c0-.5522847.4477152-1 1-1h2zm2 0V2h4v1H5zM1 6h2v8h8V6h2v8c0 1.1045695-.8954305 2-2 2H3c-1.1045695 0-2-.8954305-2-2V6zm5 0v7c-.5522847 0-1-.4477153-1-1V7c0-.5522847.4477153-1 1-1zm2 0c.5522847 0 1 .4477153 1 1v5c0 .5522847-.4477153 1-1 1V6z" fill="#BFBFBF" fill-rule="evenodd"></path></svg>. In the confirmation modal, click "Delete API Credential" to delete. You should see a confirmation that the credential was successfully deleted.

## Dev Portal Account Management

To update your Dev Portal account's email, username, password, or to delete your account, login into the Dev Portal and select "Settings" from the user drop down menu. 

Deleting your account will immediately revoke access to the Dev Portal and will delete any API credentials associated with your account. 


[developers]: /enterprise/{{page.kong_version}}/developer-portal/glossary/#types-of-humans

