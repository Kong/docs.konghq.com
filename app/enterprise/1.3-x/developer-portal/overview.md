---
title: Getting Started with the Kong Developer Portal
toc: false
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


<div class="docs-grid">
  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-doc-reference.svg" />
        <a href="/enterprise/changelog/#dev-portal">Changelog</a>
    </h3>
    <p></p>
    <a href="#whats-new-in-13">
        Read the full Kong Developer Portal changelog &rarr;
    </a>
  </div>

  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-quickstart.svg" />
        <a href="/enterprise/1.3-x/developer-portal/legacy-migration">Migrating from Legacy</a>
    </h3>
    <p></p>
    <a href="/enterprise/1.3-x/developer-portal/legacy-migration">
        Migrate your Legacy Portal to the New 1.3 Developer Portal &rarr;
    </a>
  </div>
 </div> 

<div class="docs-grid">
  <h2>Key Concepts</h2>
  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-doc-reference.svg" />
        <a href="/enterprise/1.3-x/developer-portal/structure-and-file-types">Structure and File Types</a>
    </h3>
    <p></p>
    <a href="/enterprise/1.3-x/developer-portal/structure-and-file-types">
      Learn how the Kong Developer Portal structures content and serves files  &rarr;
    </a>
  </div>

  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-doc-reference.svg" />
        <a href="/enterprise/1.3-x/developer-portal/working-with-templates">Working With Templates</a>
    </h3>
    <p></p>
    <a href="/enterprise/1.3-x/developer-portal/working-with-templates">
      Learn how to create custom pages and templates &rarr;
    </a>
  </div>

  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-doc-reference.svg" />
        <a href="/enterprise/1.3-x/property-reference/#developer-portal-section">Networking</a>
    </h3>
    <p></p>
    <a href="/enterprise/1.3-x/property-reference/#developer-portal-section">
      View the Developer Portal Networking Property Reference &rarr;
    </a>
  </div>

  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-doc-reference.svg" />
        <a href="/enterprise/1.3-x/developer-portal/using-the-editor">Editor Mode</a>
    </h3>
    <p></p>
    <a href="/enterprise/1.3-x/developer-portal/using-the-editor">
       Create, Edit, and Delete Files from within Kong Manager &rarr;
    </a>
  </div>
</div>

<div class="docs-grid">
  <h2>Configuration</h2>
  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-doc-reference.svg" />
        <a href="/enterprise/{{ page.kong_version }}/developer-portal/configuration/authentication">Authentication</a>
    </h3>
    <p></p>
    <a href="/enterprise/{{ page.kong_version }}/developer-portal/configuration/authentication">
      Control access to the Kong Developer Portal &rarr;
    </a>
  </div>
    
  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-doc-reference.svg" />
        <a href="/enterprise/{{ page.kong_version }}/developer-portal/configuration/smtp">SMTP</a>
    </h3>
    <p></p>
    <a href="/enterprise/{{ page.kong_version }}/developer-portal/configuration/smtp">
      Configure Email Settings for the Dev Portal &rarr;
    </a>
  </div>
</div>

<div class="docs-grid">
  <h2>Administration</h2>
  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-doc-reference.svg" />
        <a href="/enterprise/{{ page.kong_version }}/developer-portal/administration/managing-developers">Managing Developers</a>
    </h3>
    <p></p>
    <a href="/enterprise/{{ page.kong_version }}/developer-portal/administration/managing-developers">
      Approve, Invite, and Edit Developers &rarr;
    </a>
  </div>

  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-doc-reference.svg" />
        <a href="/enterprise/{{ page.kong_version }}/developer-portal/administration/developer-permissions">Permissions</a>
    </h3>
    <p></p>
    <a href="/enterprise/{{ page.kong_version }}/developer-portal/administration/developer-permissions">
      Fine tune access to files with Developer Roles and Permissions &rarr;
    </a>
  </div>
</div>

<div class="docs-grid">
  <h2>Theme Customization</h2>
  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-doc-reference.svg" />
        <a href="/enterprise/{{ page.kong_version }}/developer-portal/theme-customization/easy-theme-editing">Easy Theme Editing</a>
    </h3>
    <p></p>
    <a href="/enterprise/{{ page.kong_version }}/developer-portal/theme-customization/easy-theme-editing">
      Edit the look and feel of the Kong Developer Portal from within Kong Manager &rarr;
    </a>
  </div>
</div>

<div class="docs-grid">
  <h2>Helpers</h2>
  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-doc-reference.svg" />
        <a href="/enterprise/{{ page.kong_version }}/developer-portal/helpers/cli">Dev Portal CLI</a>
    </h3>
    <p></p>
    <a href="/enterprise/{{ page.kong_version }}/developer-portal/helpers/cli">
      View the Kong Developer Portal CLI Reference &rarr;
    </a>
  </div>
</div>
