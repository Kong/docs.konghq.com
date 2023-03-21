---
title: Manage Konnect Service Versions
content_type: reference
---

Every {{site.konnect_short_name}} service version is associated with one [runtime group](/konnect/runtime-manager/runtime-groups/).
Any configurations for the service version, such as implementations, plugins,
and routes, will also be associated with the same runtime group.

If a service has multiple service versions, each version can be
associated with a different runtime group, or with the same runtime group.
Through its versions, a service can made be available in multiple environments,
simply by creating new service versions in different runtime groups.

A common use case for this is environment specialization.
For example, if you have three runtime groups for `development`, `staging`, and
`production`, you can manage which environment the service is available in by
assigning a version to that group at creation time. You might have v1 running
in `production`, and be actively working on v2 in `development`. Once it's
ready to test, you'd create v2 in `staging` before finally creating v2 in
`production` alongside v1.

{:.note}
> **Note:** You can't move a service version from one runtime group to another.
Instead, create a new version of the service in the new environment when you're
ready to move to it.

Each service version is in one of the states:
* **Published**: This indicates that the service version is ready to be shared with API consumers. It displays in the Dev Portal where developers can request access to consume it via {{site.base_gateway}}. This is the default state.
* **Deprecated**: This indicates that the service version will be deprecated soon. It is still displayed in the Dev Portal and can receive API request via {{site.base_gateway}}. A banner with information about the deprecation is displayed at the top of the service version page in the Dev Portal and developers are notified via email that the version is deprecated.
* **Unpublished:** This indicates that the service version no longer displays in the Dev Portal, but it can still be accessed by existing Dev Portal applications via {{site.base_gateway}}.

