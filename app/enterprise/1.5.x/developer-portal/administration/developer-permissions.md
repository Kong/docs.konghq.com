---
title: Developer Roles and Content Permissions
---

## Introduction

Access to the Developer Portal can be fine-tuned with the use of Developer Roles and Content Permissions, managed through the Dev Portal Permissions page of Kong Manager. This page can be found by clicking on the **Permissions** link under **Dev Portal** in the Kong Manager side navigation.

## Roles

The Roles Tab contains a list of available developer roles as well as the ability to create and edit roles.

Selecting "Create Role" will allow us to enter the unique role name, as well as a comment to provide context for the nature of the role. We can assign the role to existing developers from within the role creation page. Clicking "Create" will save the role and return us to the Roles List view. Here we can see our newly created role as well as any other previously defined roles.

Clicking "View" will show us the Role Details page with a list of developers assigned.

From the Role Details page, we can click the "Edit" button to make changes to the role. We can also access this page from the Roles List "Edit" button. Here we can change the name and comment of the role, assign or remove developers, or delete the role.

Deleting a role will remove it from any developers assigned the role and remove the role restriction from any content files it is applied to.

## Content

The Content Tab shows the list of content files used by the Dev Portal. Here we can apply roles to our content files, restricting access to  developers who posess certain roles. Selecting an individual content file displays a dropdown of availabled developer roles. Here we can choose which role has accese to the file. Unchecking all availabled roles will leave the file unauthenticated.

An additional option is preset in the list: the `*` role. This predefined role behaves differently from other roles. When a content file has the `*` role attached to it, any developer may view the page as long as they are authenticated. Additionally, the `*` role may not be used in conjunction with other user defined roles and will deselect these roles when `*` is selected

⚠️**Important:** `dashboard.txt` and `settings.txt` content files are assigned the `*` role by default. All other content files have no roles by default. This means that until a role is added, the file is unauthenticated even if Dev Portal Authentication is enabled. Content Permissions are ignored when Dev Portal Authentication is disabled. For more information visit the <a href="/enterprise/{{page.kong_version}}/developer-portal/configuration/authentication">Dev Portal Authentication</a> section.

## readable_by attribute

When a role is applied to a content file via the Content Tab, a special attribute `readable_by` is added to the headmatter of the file.

```
---
readable_by:
  - role_name
  - another_role_name
---
```

 In the case of spec files, `readable_by` is applied under the key `x-headmatter` or `X-headmatter`.

```
x-headmatter:
  readable_by:
    - role_name
    - another_role_name
```

The value of `readable_by` is an array of string role names that have access to view the content file. The exception is when the `*` role is applied to the file. In this case, the value of `readable_by` is no longer an array, but the single string character `*`.

```
readable_by: "*"
```

⚠️**Important:** Please note that if you manually remove or edit the `readable_by` attribute, it will modify the permissions of the file. Attempting to save a content file with a `readable_by` array containing an nonexistent role name will result in an error. Additionally, if you make changes to permissions in the Content Tab or via the Portal Editor, be sure to sync any local files so that permissions are not overwritten next time you push changes.
