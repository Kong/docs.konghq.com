---
title: Entities Managed by decK
content_type: reference
---

decK manages entity configuration for {{site.base_gateway}}, including all core proxy entities.

It does not manage {{site.base_gateway}} configuration parameters in `kong.conf`, or content and configuration for the Dev Portal.


Entity | Managed by decK?
-------|-----------------
Services | <i class="fa fa-check"></i>
Routes | <i class="fa fa-check"></i>
Consumers | <i class="fa fa-check"></i>
Plugins | <i class="fa fa-check"></i>
Certificates |<i class="fa fa-check"></i>
CA Certificates | <i class="fa fa-check"></i>
SNIs | <i class="fa fa-check"></i>
Upstreams | <i class="fa fa-check"></i>
Targets | <i class="fa fa-check"></i>
Vaults | <i class="fa fa-check"></i>
Keys and key sets | <i class="fa fa-times"></i>
Licenses | <i class="fa fa-times"></i>
Workspaces | <i class="fa fa-check"></i> <sup>1</sup>
RBAC: roles and endpoint permissions | <i class="fa fa-check"></i>
RBAC: groups and admins | <i class="fa fa-times"></i>
Developers | <i class="fa fa-times"></i>
Consumer groups | <i class="fa fa-times"></i>
Event hooks | <i class="fa fa-times"></i>
Keyring and data encryption | <i class="fa fa-times"></i>

{:.note .no-icon}
> **\[1\]**: decK can create workspaces and manage entities in a given workspace. 
However, decK can't delete workspaces, and it can't update multiple workspaces simultaneously.
See [Manage multiple workspaces](/deck/{{page.kong_version}}/guides/kong-enterprise/#manage-multiple-workspaces) for more information.

Because decK can't manage all of {{site.base_gateway}}'s configuration, you need to make other arrangements for deployment, backup, and restore of unmanaged entities.

This is also the case if the data plane loses connection to the control plane in hybrid mode. 
The data plane can function in disconnected mode, using a [backup declarative configuration file](/gateway/latest/reference/configuration/#declarative_config). 
However, this option is not available if you have any of the unmanaged entities configured.
