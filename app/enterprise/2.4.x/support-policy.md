---
title: Kong Gateway (Enterprise) Version Support
---

The support for {{site.ee_product_name}} software versions is explained in this topic.

## Types of Releases
Kong primarily follows [semantic versioning](https://semver.org/) (SemVer) with its products. That is, products typically follow a pattern of `<MAJOR_VERSION>.<MINOR_VERSION>.<PATCH_VERSION>`. {{site.ee_product_name}} additionally has one more decimal point on the right which identifies a sub-patch based on the Kong Community Gateway. For the purposes of this support document:

* **Major Version** refers to a version of {{site.ee_product_name}} identified by the number to the left of the leftmost decimal point. For example, 2.1.3.0 has Major Version 2 and 1.3.0.0 has Major Version 1.

* **Minor Version** means a version of the Software identified by a change in the number in between the two leftmost decimal points (x.X.x). For example, 2.1.3.0 has Minor Version 1 and 1.3.0.0 has Minor Version 3.

* The **First Major Version Release** is the first chronologically generally available release of a given Major Version. The First Major Version Release of Major Version 2 of {{site.ee_product_name}} was 2.1.3.0 and the First Major Version Release of Major Version 1 was 1.3.0.0.

* The **Latest Major/Minor Version Release** is the most recent chronologically generally available Minor Version Release of a given Major Version.

For customers with an active enterprise support agreement, beginning with {{site.ee_product_name}} release version 2.1.3.x<sup>*</sup>. Kong provides support for each Major Version Release of {{site.ee_product_name}} for 24 months from the release date of the First Major Version Release.

Support includes:
* Technical support on the use of the software as documented including:
  * Assistance with configuration of the software
  * Guidelines on performance tuning
* Assistance with upgrades to later versions of the Kong software
* Access to bug-fix releases and/or workarounds based on the below Bug Fix Guidelines

**<sup>*</sup>** 24 month support applies beginning with {{site.ee_product_name}} release 2.1.3.x. For releases prior to that release, support remains at 12 months from the First Minor Version Release. Support for Kong Mesh remains at 12 months. The 24 month support applies to {{site.ee_product_name}} standard releases.

## Sunset Support
After the product hits the end of the support period, Kong will provide limited support to help the customer upgrade to a fully supported version of {{site.ee_product_name}} for up to an additional 12 month sunset period. Kong will not provide patches for software covered by this sunset period. If there is an issue that requires a patch during this period, the customer will need to upgrade to a newer {{site.ee_product_name}} version covered by 24 month active support.

## Bug Fix Guidelines
Unfortunately, all software is susceptible to bugs. Kong seeks to remedy bugs through a structured protocol as follows:

* Serious security vulnerabilities are treated with the utmost priority. See [here](/enterprise/{{page.kong_version}}/kong-security-update-process/) for our security vulnerability reporting and remedy process, including how to report a vulnerability.

* Bugs which result in production outages of {{site.ee_product_name}} or effective non-operation (such as catastrophic performance degradation) will be remedied through high priority bug fixes and provided in patch releases to the Latest Major/Minor Version Release of all currently supported Major Versions of the software and optionally ported to other versions at Kong’s discretion based on the severity and impact of the bug.

* Bugs which prevent the upgrade of a supported version of {{site.ee_product_name}} to a more recent supported version will be remedied through high priority bug fixes and provided in the Latest Major/Minor Version Release of all currently supported Major Versions of the software and optionally ported to other versions at Kong’s discretion based on the severity and impact of the bug.

* Other bugs as well as feature requests will be assessed for severity and fixes or enhancements applied to versions of {{site.ee_product_name}} at Kong’s discretion depending on the impact of the bug. Typically, these types of fixes and enhancements will only be applied to the most recent Minor Version in the most recent Major Version.

Customers with platinum or higher subscriptions may request fixes outside of the above and Kong will assess them at its sole discretion.

## Version Support for Kong Gateway (Enterprise)

| Version  | Released Date | End of Full Support | End of Sunset Support |
|:--------:|:-------------:|:-------------------:|:---------------------:|
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

> *Table 1: Version Support for {{site.ee_product_name}}*

## Version Support for Kong Mesh

| Version  | Released Date | End of Full Support | End of Sunset Support |
|:--------:|:-------------:|:-------------------:|:---------------------:|
|  1.0.x   |  2020-08-04   |     2021-08-04      |      2022-08-04       |

> *Table 2: Version Support for Kong Mesh*

## Additional Terms
1. The above is a summary only and is qualified by Kong’s [Support and Maintenance Policy](https://konghq.com/supportandmaintenancepolicy/).
2. The above applies to Kong standard software builds only.
