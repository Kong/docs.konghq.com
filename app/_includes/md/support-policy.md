
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

* Serious security vulnerabilities are treated with the utmost priority. See [here](/gateway/latest/plan-and-deploy/security/kong-security-update-process/) for our security vulnerability reporting and remedy process, including how to report a vulnerability.

* Bugs which result in production outages of {{site.ee_product_name}} or effective non-operation (such as catastrophic performance degradation) will be remedied through high priority bug fixes and provided in patch releases to the Latest Major/Minor Version Release of all currently supported Major Versions of the software and optionally ported to other versions at Kong’s discretion based on the severity and impact of the bug.

* Bugs which prevent the upgrade of a supported version of {{site.ee_product_name}} to a more recent supported version will be remedied through high priority bug fixes and provided in the Latest Major/Minor Version Release of all currently supported Major Versions of the software and optionally ported to other versions at Kong’s discretion based on the severity and impact of the bug.

* Other bugs as well as feature requests will be assessed for severity and fixes or enhancements applied to versions of {{site.ee_product_name}} at Kong’s discretion depending on the impact of the bug. Typically, these types of fixes and enhancements will only be applied to the most recent Minor Version in the most recent Major Version.

Customers with platinum or higher subscriptions may request fixes outside of the above and Kong will assess them at its sole discretion.
