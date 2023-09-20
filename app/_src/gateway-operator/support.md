---
title: Support
badge: enterprise
content-type: reference
---

Learn about the support for {{site.kgo_product_name}} software versions.

## Version support for {{site.kgo_product_name}}

Kong primarily follows [semantic versioning](https://semver.org/) (SemVer) for its products.

At Kong’s discretion a specific minor version can be marked as a LTS version. The LTS version is supported on a given distribution for the duration of the distribution’s lifecycle, or for 3 years from LTS release whichever comes sooner. LTS only receives security fixes or certain critical patches at the discretion of Kong. Kong guarantees that at any given time, there will be at least 1 active LTS Kong version.

LTS versions of {{site.kgo_product_name}} are supported for 3 years after release. Standard versions are supported for 1 year after release.

{:.note}
> {{site.kgo_product_name}} is a recently released product and does not currently provide an LTS version.

## Supported versions

{% assign latest_kgo_release = site.data.kong_latest_kgo.release %}
{% assign latest_kgo_eol = "Sept 2024" %}

<table style="display:table" width="100%">
<thead>
<tr>
  <th>Kubernetes Version</th>
  <th>OpenShift Version</th>
  <th>Upstream K8s EOL</th>
  <th>KGO Version</th>
  <th>KGO EOL</th>
</tr>
</thead>
<tbody>
  <tr>
    <td>1.27</td>
    <td>N/A</td>
    <td>Jun 2024</td>
    <td>{{ latest_kgo_release }}</td>
    <td>{{ latest_kgo_eol }}</td>
  </tr>
</tbody>
</table>

## {{site.kgo_product_name}} versions

| Version  | Released Date | End of Full Support | End of Sunset Support |
|:--------:|:-------------:|:-------------------:|:---------------------:|
|  1.0.x  |  2023-09-27   |     2024-09-27      |      2025-09-27       |