---
title: Getting Started with the Kong Developer Portal
book: developer-portal
chapter: 2
---

## What's new in 1.3

The Kong Developer Portal version 1.3 introduces a new templating engine and
file structure which should feel familiar to anyone who has used projects such
as Jekyll and Vuepress. If you are moving from the legacy portal to the newest
version the biggest changes are as follows:

- **Files Database Structure**
  - The files schema is simplified and now consists of only 2 fields, `path` and
  `contents`. You can read more about these fields in the
  [Structure and File Types](/enterprise/{{page.kong_version}}/developer-portal/structure-and-file-types) guide.
- **Templating language/structure**
  - The templates have received a complete overhaul to take advantage of the new
  Openresty native server-side/templating system. Content is now separate for
  html templates, allowing for a more extensible, upgradable, and manageable system.
  Check out the [Working with Templates](/enterprise/{{page.kong_version}}/developer-portal/working-with-templates)
  guide to learn more.
- **Portal CLI**
  - The Portal CLI tool is available to be used in conjunction with the
  templates repo, allowing for easy a simplified push/pull/watch process to and
  from your local machine and Kong. Checkout the [Dev Portal CLI](/enterprise/{{page.kong_version}}/developer-portal/helpers/cli)
  reference to learn more.
- **Permissions**
  - Developer Permissions make their debut in this version of the Portal,
  allowing admins to categorize developers and determine what pages/content they
  can or cannot see in each Developer Portal (think RBAC for Developers). Read the
  [Developer Permissions](/enterprise/{{page.kong_version}}/developer-portal/administration/developer-permissions)
  guide to learn more.

### Breaking Changes

The new Developer Portal is not compatible with previous Developer Portal
versions and templates.  The legacy Developer Portal will be supported through the
next few releases allowing current users to make the switch over before deprecation.
The release will include the functionality needed to support legacy deployments,
but will not be available via the demo build.

Existing files will need to be manually migrated to the new Developer Portal,
learn more in the [Migrating from Legacy](/enterprise/1.3-x/developer-portal/legacy-migration)
guide.

> Note: Enterprise MIGRATIONS must be completed before migrating the Dev Portal, see [The Migration Guide](/enterprise/1.3-x/deployment/migrations/) for more information.

Read the full Kong Enterprise 1.3 Changelog [here](/enterprise/changelog).
