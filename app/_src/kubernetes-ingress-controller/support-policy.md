---
title: Version Support Policy
badge: enterprise
content-type: reference
---

The support for {{site.kic_product_name}} software versions is explained in this topic.

## Version support for Kong Ingress Controller (Enterprise)

Kong primarily follows [semantic versioning](https://semver.org/) (SemVer) with its products.

At Kong’s discretion a specific minor version can be marked as a LTS version. The LTS version is supported on a given distribution for the duration of the distribution’s lifecycle, or for 3 years from LTS release whichever comes sooner. LTS only receives security fixes or certain critical patches at the discretion of Kong. Kong guarantees that at any given time, there will be at least 1 active LTS Kong version.

LTS versions of {{site.kic_product_name}} are supported for 3 years after release. Standard versions are supported for 1 year after release.

## Supported versions



<table style="display:table" width="100%">
<thead>
<tr>
  <th>Kubenetes Version</th>
  <th>OpenShift Version</th>
  <th>Upstream k8s EOL</th>
  <th>Supported Kong Gateway Versions</th>
  <th>Recommended KIC Version</th>
  <th>EOL</th>
</tr>
</thead>
<tbody>
  <tr>
    <td>1.17</td>
    <td>4.4</td>
    <td>Dec 2020</td>
    <td>2.8 LTS</td>
    <td>2.5 LTS</td>
    <td>March 2025</td>
  </tr>
  <tr>
    <td>1.18</td>
    <td>4.5</td>
    <td>June 2021</td>
    <td>2.8 LTS</td>
    <td>2.5 LTS</td>
    <td>March 2025</td>
  </tr>
  <tr>
    <td>1.19</td>
    <td>4.6</td>
    <td>Oct 2021</td>
    <td>2.8 LTS</td>
    <td>2.5 LTS</td>
    <td>March 2025</td>
  </tr>
  <tr>
    <td>1.20</td>
    <td>4.7</td>
    <td>Feb 2022</td>
    <td>2.8 LTS</td>
    <td>2.5 LTS</td>
    <td>March 2025</td>
  </tr>
  <tr>
    <td>1.21</td>
    <td>4.8</td>
    <td>June 2022</td>
    <td>2.8 LTS</td>
    <td>2.5 LTS</td>
    <td>March 2025</td>
  </tr>

  <tr>
    <td>1.22</td>
    <td>4.8</td>
    <td>Oct 2022</td>
    <td>2.8 LTS, 3.x</td>
    <td>2.5 LTS</td>
    <td>Sept 2023</td>
  </tr>
  <tr>
    <td>1.23</td>
    <td>4.8</td>
    <td>Feb 2023</td>
    <td>2.8 LTS, 3.x</td>
    <td>{{ site.data.kong_latest_KIC.release }}</td>
    <td>Sept 2023</td>
  </tr>
  <tr>
    <td>1.24</td>
    <td>4.8</td>
    <td>July 2023</td>
    <td>2.8 LTS, 3.x</td>
    <td>{{ site.data.kong_latest_KIC.release }}</td>
    <td>Sept 2023</td>
  </tr>
  <tr>
    <td>1.25</td>
    <td>N/A</td>
    <td>Oct 2023</td>
    <td>2.8 LTS, 3.x</td>
    <td>{{ site.data.kong_latest_KIC.release }}</td>
    <td>Sept 2023</td>
  </tr>
  <tr>
    <td>1.26</td>
    <td>N/A</td>
    <td>Feb 2024</td>
    <td>2.8 LTS, 3.x</td>
    <td>{{ site.data.kong_latest_KIC.release }}</td>
    <td>Sept 2023</td>
  </tr>
</tbody>
</table>

## All {{site.kic_product_name}} versions

| Version  | Released Date | End of Full Support | End of Sunset Support |
|:--------:|:-------------:|:-------------------:|:---------------------:|
|  2.8.x |  2022-12-19   |     2023-12-19      |      2024-12-19       |
|  2.7.x |  2022-09-27   |     2023-09-27      |      2024-09-27       |
|  2.6.x |  2022-09-15   |     2023-09-15      |      2024-09-15       |
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

> *Table 1: Version Support for Kong Ingress Controller*

{% include_cached /md/support-policy.md %}

## See also
* [Version support policy for {{site.base_gateway}}](/gateway/latest/support-policy)
* [Version support policy for {{site.mesh_product_name}}](/mesh/latest/support-policy)
