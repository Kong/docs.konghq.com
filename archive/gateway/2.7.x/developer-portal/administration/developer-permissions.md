---
title: Developer Roles and Content Permissions
badge: enterprise
---

Access to the Dev Portal can be fine-tuned with the use of Developer
Roles and Content Permissions, managed through the Dev Portal Permissions page
of Kong Manager. This page can be found by clicking the **Permissions** link
under **Dev Portal** in the Kong Manager navigation bar.

## Roles

The Roles Tab contains a list of available developer roles as well as providing
the ability to create and edit roles.

Selecting Create Role allows you to enter a unique role name, as well as a
comment to provide context for the nature of the role. You can assign the role
to existing developers from within the role creation page. Clicking Create
saves the role and returns you to the Roles List view. There you can see your
newly created role as well as any other previously defined roles.

Clicking View displays the Role Details page with a list of developers assigned.

From the Role Details page, click the Edit button to make changes to the role. You can also access this page from the Roles List Edit button. Here you can change the name and comment of the role, assign or remove developers, or delete the role.

Deleting a role will remove it from any developers assigned the role and remove
the role restriction from any content files it is applied to.

## Content

The Content Tab shows the list of content files used by the Dev Portal. You can
apply roles to your content files, restricting access only to developers who
possess certain roles. Selecting an individual content file displays a
dropdown of available developer roles where you can choose which role has
access to the file. Unchecking all available roles will leave the file
unauthenticated.

An additional option, the `*` role, is preset in the list. This predefined role
behaves differently from other roles. When a content file has the `*` role
attached to it, any developer may view the page as long as they are
authenticated. Additionally, the `*` role may not be used in conjunction with
other user-defined roles and will deselect those roles when `*` is selected.

{:.important}
> **Important:** The `dashboard.txt` and `settings.txt` content files are
assigned the `*` role by default. All other content files have no roles by
default. This means that until a role is added, the file is unauthenticated
even if Dev Portal Authentication is enabled. Content Permissions are ignored
when Dev Portal Authentication is disabled.

## readable_by attribute

When a role is applied to a content file using the Content Tab, a special
attribute `readable_by` is added to the headmatter of the file.

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

The value of `readable_by` is an array of string role names that have access to
view the content file. An exception is when the `*` role is applied to the
file. In this case, the value of `readable_by` is no longer an array, because
it contains the single string character `*`.

```
readable_by: "*"
```

⚠️**Important:** If you manually remove or edit the `readable_by` attribute, it
will modify the permissions of the file. Attempting to save a content file with
a `readable_by` array containing a nonexistent role name will result in an
error. Additionally, if you make changes to permissions in the Content Tab or
the Portal Editor, be sure to sync any local files so that permissions are not
overwritten the next time you push changes.
