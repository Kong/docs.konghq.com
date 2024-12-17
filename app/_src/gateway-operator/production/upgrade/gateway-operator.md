---
title: Upgrading Gateway Operator
---

{{ site.kgo_product_name }} uses [Semantic Versioning][semver] and will not make breaking
changes between major releases.

To upgrade between minor releases, follow the steps shown in the [installation guide](/gateway-operator/{{ page.release }}/install/).

For major releases, consult the [changelog](/gateway-operator/changelog/) to see if there are any changes that require manual intervention before following the installation instructions.

When using the helm chart to install the operator please also consult the [`UPGRADE.md`][uprade_md_chart] file in the charts repository.

[uprade_md_chart]: https://github.com/Kong/charts/blob/main/charts/gateway-operator/UPGRADE.md
[semver]: https://semver.org/
