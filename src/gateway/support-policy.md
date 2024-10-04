---
title: Version Support Policy
badge: enterprise
content-type: reference
---


## Version support for {{site.base_gateway}} (Enterprise)

| Version  | Released Date | End of Full Support | End of Sunset Support |
|:--------:|:-------------:|:-------------------:|:---------------------:|
|  3.1.x.x |  2022-12-06   |     2024-08-30      |      2025-08-30       |
|  3.0.x.x |  2022-08-31   |     2024-08-30      |      2025-08-30       |
|  2.8.x.x |  2022-03-02   |     2023-08-24      |      2024-08-24       |
|  2.7.x.x |  2021-12-16   |     2023-02-24      |      2023-08-24       |
|  2.6.x.x |  2021-10-14   |     2023-02-24      |      2023-08-24       |
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

> *Table 1: Version Support for {{site.ee_product_name}}*

## Types of releases
Kong adopts a structured approach to versioning its products.
Products follow a pattern of `{MAJOR}.{MINOR}.{PATCH}.{ENTERPRISE_PATCH}`.
The `ENTERPRISE_PATCH` segment identifies a sub-patch for {{site.ee_product_name}} based on {{site.ce_product_name}}.

For the purposes of this support document:

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

**<sup>*</sup>** 24 month support applies starting with {{site.ee_product_name}} 2.1.3.x. For prior releases, support remains at 12 months from the first minor version release. Support for the {{site.kic_product_name}} and {{site.mesh_product_name}} remain at 12 months. The 24 month support applies to {{site.ee_product_name}} standard releases.

## Sunset support
After the product hits the end of the support period, Kong will provide limited support to help the customer upgrade to a fully supported version of {{site.ee_product_name}} for up to an additional 12 month sunset period. Kong will not provide patches for software covered by this sunset period. If there is an issue that requires a patch during this period, the customer will need to upgrade to a newer {{site.ee_product_name}} version covered by 24 month active support.


{% include_cached /md/support-policy.md %}

## See also

* [Version support policy for {{site.mesh_product_name}}](/mesh/latest/support-policy/)
* [Version support policy for {{site.kic_product_name}}](/kubernetes-ingress-controller/latest/support-policy/)
