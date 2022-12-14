---
title: Support
breadcrumb: Distributions
---

Kong primarily follows [semantic versioning](https://semver.org/) (SemVer) with its products, with an added segment for enterprise patch releases. Products follow a pattern of `{MAJOR}.{MINOR}.{PATCH}.{ENTERPRISE_PATCH}`. The `ENTERPRISE_PATCH` segment identifies a sub-patch based on the Kong Community Gateway. For the purposes of this support document:

* **Major Version** refers to a version of {{site.ee_product_name}} identified by the number to the left of the leftmost decimal point (X.y.z.a). For example, 2.1.3.0 has Major Version 2 and 1.3.0.4 has Major Version 1.

* **Minor Version** means a version of the Software identified by a change in the number in between the two leftmost decimal points (x.Y.z.a). For example, 2.1.3.0 has Minor Version 1 and 1.3.0.4 has Minor Version 3.

* **Patch Version (OSS Base)** means a version of the Software identified by a change in the number to the left of the rightmost decimal point (x.y.Z.a). For example, 2.1.3.0 has Patch Version 3 and 1.3.0.4 has Patch Version 0.

* **Enterprise Patch Version** means a version of the Software identified by a change in the number to the right of the rightmost decimal point (x.y.z.A). For example, 2.1.3.0 has Enterprise Patch Version 3 and 1.3.0.4 has Enterprise Patch Version 4.

Kong introduces major functionality and breaking changes by releasing a new major version. Major version releases happen rarely and are usually in response to changes in major industry trends, significant architectural changes or significant internal product innovation. There is no regular release cadence of Major versions.

Kong releases a new minor version every 10 weeks. Minor versions contain features and bug fixes. Minor versions are always backwards compatible within that major version sequence.  Every minor version is supported for a period of 1 year from date of release. This is done by releasing patch updates (also known as patch releases) that apply to each supported minor version.

At Kong’s discretion a specific minor version can be marked as a LTS version. The LTS version is supported on a given distribution for the duration of the distribution’s lifecycle, or for 3 years from LTS release whichever comes sooner. LTS only receives security fixes or certain critical patches at the discretion of Kong. Kong guarantees that at any given time, there will be at least 1 active LTS Kong version.

## Supported versions

Kong Gateway currently supports the following versions:

* 2.8 LTS
* 3.x

{% navtabs %}
  {% navtab 2.8 LTS %}
    {% include_cached gateway-support.html data=site.data.tables.support.gateway.lts-28 %}
  {% endnavtab %}
  {% navtab 3.x %}
    {% include_cached gateway-support.html data=site.data.tables.support.gateway.3x %}
  {% endnavtab %}
{% endnavtabs %}