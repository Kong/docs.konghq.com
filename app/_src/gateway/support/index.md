---
title: Support
breadcrumb: Distributions
---

Kong primarily follows [semantic versioning](https://semver.org/) (SemVer) with its products, with an added segment for enterprise patch releases. Products follow a pattern of `{MAJOR}.{MINOR}.{PATCH}.{ENTERPRISE_PATCH}`. The `ENTERPRISE_PATCH` segment identifies a sub-patch based on the Kong Community Gateway. 

## Semantic Versioning

For the purposes of this support document:

* **Major Version** refers to a version of {{site.ee_product_name}} identified by the number to the left of the leftmost decimal point (X.y.z.a). For example, 2.1.3.0 has Major Version 2 and 1.3.0.4 has Major Version 1.

* **Minor Version** means a version of the Software identified by a change in the number in between the two leftmost decimal points (x.Y.z.a). For example, 2.1.3.0 has Minor Version 1 and 1.3.0.4 has Minor Version 3.

* **Patch Version (OSS Base)** means a version of the Software identified by a change in the number to the left of the rightmost decimal point (x.y.Z.a). For example, 2.1.3.0 has Patch Version 3 and 1.3.0.4 has Patch Version 0.

* **Enterprise Patch Version** means a version of the Software identified by a change in the number to the right of the rightmost decimal point (x.y.z.A). For example, 2.1.3.0 has Enterprise Patch Version 0 and 1.3.0.4 has Enterprise Patch Version 4.

Kong introduces major functionality and breaking changes by releasing a new major version. Major version releases happen rarely and are usually in response to changes in major industry trends, significant architectural changes or significant internal product innovation. There is no regular release cadence of Major versions.

Kong releases a new minor version every 10 weeks. Minor versions contain features and bug fixes. Minor versions are always backwards compatible within that major version sequence.  Every minor version is supported for a period of 1 year from date of release. This is done by releasing patch updates (also known as patch releases) that apply to each supported minor version.

At Kong’s discretion a specific minor version can be marked as a LTS version. The LTS version is supported on a given distribution for the duration of the distribution’s lifecycle, or for 3 years from LTS release whichever comes sooner. LTS only receives security fixes or certain critical patches at the discretion of Kong. Kong guarantees that at any given time, there will be at least 1 active LTS Kong version.


## Sunset support
After the product hits the end of the support period, Kong will provide limited support to help the customer upgrade to a fully supported version of {{site.ee_product_name}} for up to an additional 12 month sunset period. Kong will not provide patches for software covered by this sunset period. If there is an issue that requires a patch during this period, the customer will need to upgrade to a newer {{site.ee_product_name}} version covered by 24 month active support.

## Bug fix guidelines
Unfortunately, all software is susceptible to bugs. Kong seeks to remedy bugs through a structured protocol as follows:

* Serious security vulnerabilities are treated with the utmost priority. See [here](/gateway/latest/production/security-update-process/) for our security vulnerability reporting and remedy process, including how to report a vulnerability.

* Bugs which result in production outages of {{site.ee_product_name}} or effective non-operation (such as catastrophic performance degradation) will be remedied through high priority bug fixes and provided in patch releases to the Latest Major/Minor Version Release of all currently supported Major Versions of the software and optionally ported to other versions at Kong’s discretion based on the severity and impact of the bug.

* Bugs which prevent the upgrade of a supported version of {{site.ee_product_name}} to a more recent supported version will be remedied through high priority bug fixes and provided in the Latest Major/Minor Version Release of all currently supported Major Versions of the software and optionally ported to other versions at Kong’s discretion based on the severity and impact of the bug.

* Other bugs as well as feature requests will be assessed for severity and fixes or enhancements applied to versions of {{site.ee_product_name}} at Kong’s discretion depending on the impact of the bug. Typically, these types of fixes and enhancements will only be applied to the most recent Minor Version in the most recent Major Version.

Customers with platinum or higher subscriptions may request fixes outside of the above and Kong will assess them at its sole discretion.

## Supported versions

Kong supports the following versions:

{% navtabs %}
  {% navtab 2.6 %}
    {% include_cached gateway-support.html version="2.6" data=site.data.tables.support.gateway.versions.2x  eol="February 2023" %}
  {% endnavtab %}
    {% navtab 2.7 %}
    {% include_cached gateway-support.html version="2.7" data=site.data.tables.support.gateway.versions.2x  eol="February 2023" %}
  {% endnavtab %}
  {% navtab 2.8 LTS %}
    {% include_cached gateway-support.html version="2.8 LTS" data=site.data.tables.support.gateway.versions.2x  eol="August 2023" %}
  {% endnavtab %}
  {% navtab 3.0 %}
    {% include_cached gateway-support.html version="3.0" data=site.data.tables.support.gateway.versions.3x eol="August 2024" %}
  {% endnavtab %}
  {% navtab 3.1 %}
    {% include_cached gateway-support.html version="3.1" data=site.data.tables.support.gateway.versions.3x eol="December 2024" %}
  {% endnavtab %}
{% endnavtabs %}

## Older versions

These versions have reached the end of full support.

| Version  | Released Date | End of Full Support | End of Sunset Support |
|:--------:|:-------------:|:-------------------:|:---------------------:|
|  2.5.x.x |  2021-08-03   |     2022-08-24      |      2023-08-24       |
|  2.4.x.x |  2021-05-18   |     2022-08-24      |      2023-08-24       |  
|  2.3.x.x |  2021-02-11   |     2022-08-24      |      2023-08-24       |
|  2.2.x.x |  2020-11-17   |     2022-08-24      |      2023-08-24       |
|  2.1.x.x |  2020-08-25   |     2022-08-24      |      2023-08-24       |
|  1.5.x.x |  2020-04-10   |     2021-04-09      |      2022-04-09       |
|  1.3.x.x |  2019-11-05   |     2020-11-04      |      2021-11-04       |
|   0.36   |  2019-08-05   |     2020-08-04      |      2021-08-04       |
|   0.35   |  2019-05-16   |     2020-05-15      |      2020-11-15       |
|   0.34   |  2018-11-19   |     2019-11-18      |      2020-11-18       |
|   0.33   |  2018-07-11   |     2019-06-10      |      2020-06-10       |
|   0.32   |  2018-05-22   |     2019-05-21      |      2020-05-21       |
|   0.31   |  2018-03-13   |     2019-03-12      |      2020-03-12       |
|   0.30   |  2018-01-22   |     2019-01-21      |      2020-01-21       |