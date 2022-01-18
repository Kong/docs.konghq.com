---
title: Account and Organization Deactivation
no_version: true
---

A {{site.konnect_saas}} organization is automatically deactivated after 30
days of inactivity.

Your organization is considered inactive when:
* There is no user login into the organization during the past 30 days.
* There are no API requests in either the current or the previous billing cycle.

## What happens if an organization is deactivated?

If your org is deactivated, you can no longer log into the organization, either
through the Konnect UI or the API, and the following happens:

* All billing stops immediately, and all {{site.konnect_saas}} subscriptions
are removed.

* The control plane associated with the organization is decommissioned.

* Any users that were part of the organization lose any roles or permissions
associated with the organization. Their accounts are otherwise unaffected.

* The email associated with the organization is locked and can't be used to
create another {{site.konnect_saas}} account.

If you have any runtimes registered through the Runtime Manager, they won't be
stopped by {{site.konnect_saas}}. They will no longer proxy data, but the
instances will keep running until you stop them manually.

## Deactivate or reactivate an organization

There is currently no way to manually deactivate an organization.

If you need to reactivate an organization or unlock an email for use with
another organization, reach out to [Kong Support](https://support.konghq.com/).


_Oustanding questions:_
- _Is a deactivated org ever deleted permanently? Can a user request that an
org be deleted permanently? How would they do that?_
- _How long do users have after deactivation happens to recover their org? Is there
any situation where data might be deleted automatically?_
- _Recovering an email attached to an account_
- _Can you deactivate org manually?_
