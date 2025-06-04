---
title: Kong Gateway Enterprise Version Support
breadcrumb: Distributions
---

Kong adopts a structured approach to versioning its products.
Products follow a pattern of `{MAJOR}.{MINOR}.{PATCH}.{ENTERPRISE_PATCH}`.
The `ENTERPRISE_PATCH` segment identifies a sub-patch for {{site.ee_product_name}} based on {{site.ce_product_name}}. 

This policy **only** applies to {{site.base_gateway}} and {{site.ee_product_name}}. 
For the {{site.konnect_product_name}} version support policy, review the [{{site.konnect_product_name}} policy](/konnect/compatibility/#kong-gateway-version-compatibility).

{:.note}
> **Long Term Support Policy Update**
> <br><br>
> Beginning in March 2025, we plan to release 4 minor versions per year, every year: one in March, one in June, one in September, and the last one in December. 
> Each year, the first version we release will become an LTS release. 
> Starting from 3.10, we will have 1 LTS release every year, in March* of that year.
> <br><br>
> Example of planned LTS schedule for next 4 years:
> <table>
>  <thead>
>    <th>LTS Version</th>
>    <th>Planned release date</th>
>  </thead>
>  <tbody>
>    <tr>
>      <td>3.10</td>
>      <td>March 2025</td>
>    </tr>
>    <tr>
>      <td>3.14</td>
>      <td>March 2026</td>
>    </tr>
>    <tr>
>      <td>3.18</td>
>      <td>March 2027</td>
>    </tr>
>    <tr>
>      <td>3.22</td>
>      <td>March 2028</td>
>    </tr>
>  </tbody>
> </table>
> Each LTS is supported for 3 years from the date of release. 
> This will allow adjacent LTS releases to have a support overlap of 2 years in which customers can plan their upgrades.
> <br><br>
> _* Release timeframes are subject to change._

## Versioning

For the purposes of this support document:

**Release versioning**
  * **Major Version** means a version identified by the number to the left of the leftmost decimal point (X.y.z.a). For example, 2.1.3.0 indicates Major Version 2 and 1.3.0.4 indicates Major Version 1.
  
  * **Minor Version** means a version identified by a change in the number in between the two leftmost decimal points (x.Y.z.a). For example, 2.1.3.0 indicates Minor Version 1 and 1.3.0.4 indicates Minor Version 3.

**Patches**
  * **Community Edition Patch** means a patch identified by a change in the number to the left of the rightmost decimal point (x.y.Z.a). For example, Community/OSS version 2.8.3 indicates Release Version 2.8 with patch number 3 and 3.3.0 indicates Release version 3.0 with Patch number 0.
  
  * **Enterprise Patch Version** means a version identified by a change in the number to the right of the rightmost decimal point (x.y.z.A). For example, 2.8.3.0 indicates Enterprise Release version 2.8 with Patch Version 3.0 and 3.3.2.1 indicates Enterprise Release Version 3.3 with patch number 2.1

Kong introduces major functionality and breaking changes by releasing a new major version. Major version releases happen rarely and are usually in response to changes in major industry trends, significant architectural changes or significant internal product innovation. There is no regular release cadence of major versions.

Kong aims to release a new minor version approximately every 12 weeks. Minor versions contain features and bug fixes. Minor versions are usually¹ backwards compatible within that major version sequence. Every minor version is supported for a period of 1 year from date of release. This is done by releasing patches that apply to each supported minor version. Customers are encouraged to keep their installations up to date by applying the patches appropriate to their installed version. All patches released by Kong are roll-up patches (for example, patch 1.5 for release version 3.3 includes all the fixes in patches 1.4, 1.3, 1.2, and 1.1).

{:.note}
> ¹**Note:** There can be exceptions to the versioning model. 
Due to backports, new features and breaking changes are possible at any version level, including patch versions.
To avoid issues, do not upgrade to any new version automatically, and 
make sure to review all relevant [changelog entries](/gateway/changelog/) before manually upgrading your deployments.

### Long-term support (LTS) {#long-term-support}

Kong may designate a specific minor version as a **Long-Term Support (LTS)** version. Kong provides technical support for the LTS version on a given distribution for the duration of the distribution’s lifecycle, or for 3 years from LTS version release, whichever comes sooner. An LTS version is backwards compatible within its major version sequence. An LTS version receives all security fixes. Additionally, an LTS version may receive certain non-security patches at Kong's discretion. At any time, there will be at least 1 active LTS {{site.ee_product_name}} version.

### Sunset support
After the product hits the end of the support period, Kong will provide limited support to help the customer upgrade to a fully supported version of {{site.ee_product_name}} for up to an additional 12 month sunset period. Kong will not provide patches for software covered by this sunset period. If there is an issue that requires a patch during this period, the customer will need to upgrade to a newer {{site.ee_product_name}} version covered by active support.

{% include_cached /md/support-policy.md %}

## Supported versions

Kong supports the following versions of {{site.ee_product_name}}: 

{% navtabs %}
  {% navtab 3.10 LTS %}
    {% include_cached gateway-support.html version="3.10" data=site.data.tables.support.gateway.versions.310 eol="March 2028" %}
  {% endnavtab %}
  {% navtab 3.9 %}
    {% include_cached gateway-support.html version="3.9" data=site.data.tables.support.gateway.versions.39 eol="Dec 2025" %}
  {% endnavtab %}
  {% navtab 3.8 %}
    {% include_cached gateway-support.html version="3.8" data=site.data.tables.support.gateway.versions.38 eol="Sept 2025" %}
  {% endnavtab %}
  {% navtab 3.4 LTS %}
    {% include_cached gateway-support.html version="3.4" data=site.data.tables.support.gateway.versions.34 eol="August 2026" %}
  {% endnavtab %}
{% endnavtabs %}


### Marketplaces

{{site.ee_product_name}} is available through the following marketplaces:
- Azure Marketplace
- AWS Marketplace
- Google Cloud Marketplace

Latest versions are not guaranteed.

### Supported public cloud deployment platforms

{{site.ee_product_name}} supports the following public cloud deployment platforms:

* AWS EKS
* AWS EKS Fargate
* AWS ECS
* AWS ECS Fargate
* Azure AKS
* Azure Container Instances
* Azure Container Apps
* Google Cloud GKE
* Google Cloud GKE Autopilot
* Google Cloud Run

## Older versions

These versions have reached the end of full support.

| Version  | Released Date | End of Full Support | End of Sunset Support |
|:--------:|:-------------:|:-------------------:|:---------------------:|
|  3.7.x.x |  2024-05-28   |     2025-05-28      |      2026-05-28       |
|  3.6.x.x |  2024-02-12   |     2025-02-12      |      2026-02-12       |
|  3.5.x.x |  2023-11-08   |     2024-11-08      |      2025-11-08       |
|  3.3.x.x |  2023-05-19   |     2024-05-19      |      2025-05-19       |
|  3.2.x.x |  2023-02-28   |     2024-02-28      |      2025-02-28       |
|  3.1.x.x |  2022-12-06   |     2023-12-06      |      2024-12-06       |
|  3.0.x.x |  2022-09-09   |     2023-09-09      |      2024-09-09       |
|  2.8.x.x |  2022-03-02   |     2025-03-26      |      2026-03-26       |
|  2.7.x.x |  2021-12-16   |     2023-02-24      |      2024-08-24       |
|  2.6.x.x |  2021-10-14   |     2023-02-24      |      2024-08-24       |
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

{:.note}
> **Note:** This policy **only** applies to {{site.base_gateway}} and {{site.ee_product_name}}. For the {{site.konnect_product_name}} version support policy, review the [{{site.konnect_product_name}} policy](/konnect/compatibility/#kong-gateway-version-compatibility).

## See also

* [Version support policy for {{site.mesh_product_name}}](/mesh/latest/support-policy/)
* [Version support policy for {{site.kic_product_name}}](/kubernetes-ingress-controller/latest/support-policy/)
