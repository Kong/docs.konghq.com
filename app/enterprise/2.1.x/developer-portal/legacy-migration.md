---
title: Migrating from the Legacy Developer Portal
book: developer-portal
chapter: 3
---

> Note: Enterprise MIGRATIONS must be completed before migrating the Dev Portal, see [The Migration Guide](/enterprise/1.3-x/deployment/migrations/) for more information.

### Introduction

Starting in Kong Enterprise 1.3, the Kong Developer Portal supports a new
templating and file system. Because of these changes, existing Developer Portals
on 0.36 or earlier are no longer compatible and must be manually migrated to the 
new file system.

To learn more about the changes to the Developer Portal check out the 
[What's new in 1.3](/enterprise/1.3-x/developer-portal/overview/#whats-new-in-1.3)
section in the Developer Portal [Overview](/enterprise/1.3-x/developer-portal/overview)
and the Kong Enterprise [Changelog](/gateway/changelog).


### Enabling Legacy Mode

When upgrading to Kong Enterprise 1.3 from 0.36, existing Portal files will be
saved and can be accessed with **Legacy Mode** enabled. This will allow the
Portal to function similarly to 0.36, but some features will be unavailable. To
access these new features, the new Portal must be enabled, and the files must
be manually ported over.

To enable **Legacy Mode** set the following property in the Kong Configuration
file to `on`:

```
portal_is_legacy = on
```

### Migrating Spec Files

Spec files must be manually recreated in the new Developer Portal, this can 
be done by creating a new file in **Editor Mode** and copy and pasting the spec
file into the newly created file. This is the same process as the previous
version of the Developer Portal but will create the files in a different file
path, and therefore must be done manually. 

### Migrating Theme Customization

The Kong Developer Portal version 1.3 uses a new templating engine, and therefore
existing theme files are not compatible. Themes customizations must be manually
redone to use the new templating system. Checkout the guide 
[Working with Templates](/enterprise/{{page.kong_version}}/developer-portal/working-with-templates) to how to create pages and edit the new theme files.

