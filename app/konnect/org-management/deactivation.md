---
title: Account and Organization Deactivation
---

A free {{site.konnect_saas}} organization is automatically deactivated after 30
days of inactivity.

Your organization is considered inactive when:
* There is no user login into the organization within the last 30 days.
* There are no API requests in either the current or the previous billing cycle
(30 day increments).

To close a Plus or Enterprise account, you can
request deactivation from [Kong Support](https://support.konghq.com/) or by going to the My Account page in Konnect and clicking the Delete Account button. 

## What happens if an organization is deactivated?

If your organization account is deactivated, and can no longer log into the
organization, either through the {{site.konnect_short_name}} UI or the API, then the following happens:

* All billing stops immediately, and all {{site.konnect_saas}} subscriptions
are removed.

* The control plane (both the {{site.base_gateway}} and {{site.product_mesh_name}} global control planes) associated with the organization are decommissioned.

* {{site.product_mesh_name}} local zone control planes and data plane nodes (workloads) continue to run, but will not receive new configuration updates.

* Any users that were part of the organization are removed from any teams
associated with the organization, and lose roles associated with the deactivated organization.
Their accounts are otherwise unaffected.

* The email associated with the organization is locked and can't be used to
create another {{site.konnect_saas}} account.

If you have registered data plane nodes, they won't be
stopped by {{site.konnect_saas}}. They will no longer proxy data, but the
nodes will keep running until manually stop them.

## Deactivate or reactivate an organization

Contact [Kong Support](https://support.konghq.com/) to do any of the following:
* Deactivate an organization that you registered
* Reactivate an organization that has been deactivated
* Unlock an email for use with another organization


## Right To Be Forgotten

If you want to exercise your data subject rights, including the right to be forgotten (RTBF) under GDPR review the [Privacy Policy](https://konghq.com/privacy) and start the request process.
