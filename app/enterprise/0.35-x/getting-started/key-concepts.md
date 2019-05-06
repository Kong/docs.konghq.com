---
title: Key Concepts
toc: false
---

* **Plugin**: a plugin executing actions inside Kong before or after a request has been proxied to the upstream API.

* **Workspace**: a private, segmented part of a shared Kong cluster that allows a particular team to access its own Admin API entities seperately from other teams. 

* **Admin**: a Kong Enterprise user capable of accessing Admin API entities based on a set of **Permissions**.

* **Permission**: an ability to create, read, update, or destroy an Admin API entity defined by endpoints.

* **Role**: a set of **Permissions** that may be reused and assigned to **Admins**.

* **Super Admin**: an **Admin** whose **Role** has the **Permission** to: 
  * invite and disable other **Admin** accounts
  * assign and revoke **Roles** 
  * create new **Roles** with custom **Permissions**
  * create new **Workspaces**

* **Service**: the Kong entity representing an external _upstream_ API or microservice.

* **Route**: the Kong entity representing a way to map downstream requests to upstream services.

* **Consumer**: the Kong entity representing a developer or machine using the API. When using Kong, a Consumer only communicates with Kong which proxies every call to the said upstream API.