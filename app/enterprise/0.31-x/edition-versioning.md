---
title: Kong Enterprise Edition Versioning
---

Kong Enterprise Edition is distributed as a bundle of elements, including:

- **Kong Core**, built from Kong Community Edition
- **Admin GUI**, a native graphical interface to manage Kong
- **Enterprise Core Features**, such as [Admin RBAC](https://support.konghq.com/hc/en-us/articles/115001049953-Setting-Up-Admin-API-RBAC), Vitals, etc
- **Enterprise Plugins**, such as OAuth2 Introspection, OpenID Connect, and Enterprise Rate Limiting

Kong Enterprise Edition is versioned as follows:

X.Y(-Z)
Changes to the released version of Kong Enterprise Edition occur as follows:

- **X** is incremented when Kong Inc. determines that the nature of a given change warrants incrementing this integer. There is no semantically meaningful value behind this number, or increments of this number.

- **Y** is incremented every time ANY of the version number digits of the components are incremented, regardless of the scope of change, or semantic meaning of the component change.

- **Z** is incremented against previously released versions of Kong Enterprise Edition when a critical fix must be implemented against an old release.

The nature of this versioning scheme is such that the scope of semantic weight of changes in each release of Kong Enterprise Edition **cannot be interpreted solely through the change in version number**. Because of this, we strongly encourage Enterprise Edition users to consult the [Kong Enterprise Changelog](/enterprise/changelog) and [Upgrading Kong Enterprise](/enterprise/0.32-x/upgrades-migrations/) before upgrading.
