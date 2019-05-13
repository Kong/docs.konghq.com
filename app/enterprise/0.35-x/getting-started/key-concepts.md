---
title: Key Concepts
toc: false
---
The following guides introduce the key concepts in Kong Enterprise, 
with practical steps to start Kong securely, access Kong Manager 
as a **Super Admin**, and create new entities such as **Services**. 

Each guide also contains links to more in-depth material. Note that 
Kong Enterprise 0.35 includes Kong 1.0 at its core, so CLI 
commands and most Admin API endpoints are documented in standard 
[Kong documentaiton](/1.0.x/).

If there are any issues or further questions, please 
[contact Support](https://support.konghq.com/support/s/) and 
they will be happy to help.

To explore these concepts in depth, let's 
[start Kong Enterprise](enterprise/{{page.kong_version}}/getting-started/start-kong)

The following concepts have a special meaning in Kong 
Enterprise: 

* **Plugin**: a plugin executing actions inside Kong before or after a request has been proxied to the upstream API.

* **Workspace**: a private, segmented part of a shared Kong cluster that allows a particular team to access its own Admin API entities separately from other teams. 

* **Admin**: a Kong Enterprise user capable of accessing Admin API entities based on a set of **Permissions**.

* **Permission**: an ability to create, read, update, or destroy an Admin API entity defined by endpoints.

* **Role**: a set of **Permissions** that may be reused and assigned to **Admins**.

* **Super Admin**: an **Admin** whose **Role** has the **Permission** to: 
  * invite and disable other **Admin** accounts
  * assign and revoke **Roles** 
  * create new **Roles** with custom **Permissions**
  * create new **Workspaces**

* **Service**: the Admin API entity representing an external _upstream_ API or microservice.

* **Route**: the Admin API entity representing a way to map downstream requests to upstream services.

* **Consumer**: the Admin API entity representing a developer or machine using the API. When using Kong, a Consumer only communicates with Kong which proxies every call to the said upstream API.

To explore these concepts in depth, let's 
[start Kong Enterprise](enterprise/{{page.kong_version}}/getting-started/start-kong)