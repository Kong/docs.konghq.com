
## Types of releases
Kong primarily follows [semantic versioning](https://semver.org/) (SemVer) with its products. That is, products typically follow a pattern of `{MAJOR_VERSION}.{MINOR_VERSION}.{PATCH_VERSION}`. {{site.ee_product_name}} additionally has one more decimal point on the right which identifies a sub-patch based on the Kong Community Gateway. For the purposes of this support document:

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

**<sup>*</sup>** 24 month support applies starting with {{site.ee_product_name}} 2.1.3.x. For prior releases, support remains at 12 months from the first minor version release. Support for the Kubernetes Ingress Controller and Kong Mesh remain at 12 months. The 24 month support applies to {{site.ee_product_name}} standard releases.

## Sunset support
After the product hits the end of the support period, Kong will provide limited support to help the customer upgrade to a fully supported version of {{site.ee_product_name}} for up to an additional 12 month sunset period. Kong will not provide patches for software covered by this sunset period. If there is an issue that requires a patch during this period, the customer will need to upgrade to a newer {{site.ee_product_name}} version covered by 24 month active support.

## Bug fix guidelines
Unfortunately, all software is susceptible to bugs. Kong seeks to remedy bugs through a structured protocol as follows:

* Serious security vulnerabilities are treated with the utmost priority. See [here](/gateway/latest/production/security-update-process/) for our security vulnerability reporting and remedy process, including how to report a vulnerability.

* Bugs which result in production outages of {{site.ee_product_name}} or effective non-operation (such as catastrophic performance degradation) will be remedied through high priority bug fixes and provided in patch releases to the Latest Major/Minor Version Release of all currently supported Major Versions of the software and optionally ported to other versions at Kong’s discretion based on the severity and impact of the bug.

* Bugs which prevent the upgrade of a supported version of {{site.ee_product_name}} to a more recent supported version will be remedied through high priority bug fixes and provided in the Latest Major/Minor Version Release of all currently supported Major Versions of the software and optionally ported to other versions at Kong’s discretion based on the severity and impact of the bug.

* Other bugs as well as feature requests will be assessed for severity and fixes or enhancements applied to versions of {{site.ee_product_name}} at Kong’s discretion depending on the impact of the bug. Typically, these types of fixes and enhancements will only be applied to the most recent Minor Version in the most recent Major Version.

Customers with platinum or higher subscriptions may request fixes outside of the above and Kong will assess them at its sole discretion.

## Version support for {{site.base_gateway}} (Enterprise)

| Version  | Released Date | End of Full Support | End of Sunset Support |
|:--------:|:-------------:|:-------------------:|:---------------------:|
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

## Version support for Kong Mesh

| Version  | Released Date | End of Full Support |
|:--------:|:-------------:|:-------------------:|
|  1.9.x   |  2022-08-24   |     2023-08-24      |
|  1.8.x   |  2022-06-15   |     2023-06-14      |
|  1.7.x   |  2022-04-11   |     2023-04-10      |
|  1.6.x   |  2022-02-24   |     2023-02-23      |
|  1.5.x   |  2021-11-23   |     2022-11-22      |

> *Table 2: Version Support for Kong Mesh*

## Version support for Kong Ingress Controller (Enterprise)

| Version  | Released Date | End of Full Support | End of Sunset Support |
|:--------:|:-------------:|:-------------------:|:---------------------:|
|  2.5.x |  2022-07-11   |     2023-07-11      |      2024-07-11       |
|  2.4.x |  2022-06-15   |     2023-06-15      |      2024-06-15       |
|  2.3.x |  2022-04-05   |     2023-04-05      |      2024-04-05       |
|  2.2.x |  2022-02-04   |     2023-02-04      |      2024-02-04       |
|  2.1.x |  2022-01-05   |     2023-01-05      |      2024-01-05       |
|  2.0.x |  2021-10-07   |     2022-10-07      |      2023-10-07       |
|  1.3.x |  2021-05-27   |     2022-05-27      |      2024-05-27       |  
|  1.2.x |  2021-03-24   |     2022-03-24      |      2024-03-24       |
|  1.1.x |  2020-12-09   |     2021-12-09      |      2023-12-09       |
|  1.0.x |  2020-10-05   |     2021-10-05      |      2023-10-05       |
|  0.x.x |  2018-06-02   |     2019-06-02      |      2020-06-02       |

> *Table 3: Version Support for Kong Ingress Controller*

## Additional terms
- The above is a summary only and is qualified by Kong’s [Support and Maintenance Policy](https://konghq.com/supportandmaintenancepolicy).
- The above applies to Kong standard software builds only.
