---
title: Getting Started with Kong Enterprise
toc: false
---

### Introduction

Thank you for installing Kong Enterprise! The following series of Getting Started
guides are designed to help you familiarize yourself with Kong Enterprise's features
and capabilities, with practical steps to start Kong Enterprise securely, access
Kong Manager as a **Super Admin**, and create new entities such as **Services**.

Each guide also contains links to more in-depth material. Note that Kong
 Enterprise 0.35 includes Kong 1.0 at its core, so CLI commands and most Admin 
 API endpoints are documented in standard [Kong documentation](/1.0.x/).

 If you have any issues or further questions, please 
[contact Support](https://support.konghq.com/support/s/) and they will be happy
 to help.

### Key Concepts

The following concepts have a special meaning in Kong Enterprise: 

* **Plugin**: a plugin executing actions inside Kong before or after a request
 has been proxied to the upstream API.

* **Workspace**: a private, segmented part of a shared Kong cluster that allows 
a particular team to access its own Admin API entities separately from other teams. 

* **Admin**: a Kong Enterprise user capable of accessing Admin API entities based
 on a set of **Permissions**.

* **Permission**: an ability to create, read, update, or destroy an Admin API
 entity defined by endpoints.

* **Role**: a set of **Permissions** that may be reused and assigned to **Admins**.

* **Super Admin**: an **Admin** whose **Role** has the **Permission** to: 
  * invite and disable other **Admin** accounts
  * assign and revoke **Roles** 
  * create new **Roles** with custom **Permissions**
  * create new **Workspaces**

* **Service**: the Admin API entity representing an external _upstream_ API or
 microservice.

* **Route**: the Admin API entity representing a way to map downstream requests
 to upstream services.

* **Consumer**: the Admin API entity representing a developer or machine using
 the API. When using Kong, a Consumer only communicates with Kong which proxies
 every call to the said upstream API.

## Get Started

<div class="docs-grid">
  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-window.svg" />
        <a href="/enterprise/0.35-x/getting-started/start-kong/">Start Kong Enterprise</a>
    </h3>
    <p>Learn to start Kong Enterprise securely with RBAC</p>
    <a href="/enterprise/0.35-x/getting-started/start-kong/">
        Start Kong Enterprise &rarr;
    </a>
  </div>

  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-window.svg" />
        <a href="/enterprise/{{page.kong_version}}/getting-started/add-workspace/">Add a Workspace</a>
    </h3>
    <p>Create groups within your organization with Workspaces.</p>
    <a href="/enterprise/{{page.kong_version}}/getting-started/add-workspace/">
        Add a Workspace &rarr;
    </a>
  </div>

  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-window.svg" />
        <a href="/enterprise/{{page.kong_version}}/getting-started/add-role/">Add a Role and Permissions</a>
    </h3>
    <p>Create sets to quickly assign multiple Admins the same permissions.</p>
    <a href="/enterprise/{{page.kong_version}}/getting-started/add-role/">Add a Role and Permissions &rarr;</a>
  </div>

  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-window.svg" />
        <a href="/enterprise/{{page.kong_version}}/getting-started/add-admin/">Add an Admin</a>
    </h3>
    <p>Authorize Admins with default and custom Roles and Permissions.</p>
    <a href="/enterprise/{{page.kong_version}}/getting-started/add-admin/">Add an Admin &rarr;</a>
  </div>

  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-window.svg" />
        <a href="/enterprise/{{page.kong_version}}/getting-started/add-service/">Add a Service and Route</a>
    </h3>
    <p>Start forwarding requests through Kong Enterprise</p>
    <a href="/enterprise/{{page.kong_version}}/getting-started/add-service/">Add a Service and Route &rarr;</a>
  </div>

  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-window.svg" />
        <a href="/enterprise/{{page.kong_version}}/getting-started/enable-plugin/">Enable a Plugin</a>
    </h3>
    <p>Expand Kong Enterprise with plugins</p>
    <a href="/enterprise/{{page.kong_version}}/getting-started/enable-plugin/">Enable a Plugin &rarr;</a>
  </div>

  <div class="docs-grid-block">
    <h3>
        <img src="/assets/images/icons/documentation/icn-window.svg" />
        <a href="/enterprise/{{page.kong_version}}/getting-started/enable-dev-portal">Enable the Dev Portal</a>
    </h3>
    <p>Publish API docs, onboard and manage developers</p>
    <a href="/enterprise/{{page.kong_version}}/getting-started/enable-dev-portal">Enable the Dev Portal &rarr;</a>
  </div>

</div>
