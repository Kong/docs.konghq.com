---
title: Account and Organization Deactivation
no_version: true
---

A free {{site.konnect_saas}} organization is automatically deactivated after 30
days of inactivity.

Your organization is considered inactive when:
* There is no user login into the organization during the past 30 days.
* There are no API requests in either the current or the previous billing cycle
(30 day increments).

Organizations in Plus or Enterprise tiers are exempt, and are never deactivated
automatically. To close a Plus or Enterprise account, you can
request deactivation through [Kong Support](https://support.konghq.com/).

## What happens if an organization is deactivated?

If your organization account is deactivated, you can no longer log into the
organization, either through the Konnect UI or the API, and the following happens:

* All billing stops immediately, and all {{site.konnect_saas}} subscriptions
are removed.

* The control plane associated with the organization is decommissioned.

* Any users that were part of the organization are removed from any teams
associated with the organization, and lose any individual roles from that org.
Their accounts are otherwise unaffected.

* The email associated with the organization is locked and can't be used to
create another {{site.konnect_saas}} account.

If you have any runtimes registered through the Runtime Manager, they won't be
stopped by {{site.konnect_saas}}. They will no longer proxy data, but the
instances will keep running until you stop them manually.

## Deactivate or reactivate an organization

Contact [Kong Support](https://support.konghq.com/) to do any of the following:
* Deactivate an organization that you registered
* Reactivate an organization that has been deactivated
* Unlock an email for use with another organization
