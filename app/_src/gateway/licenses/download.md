---
title: Download Your Kong Gateway License
badge: enterprise
---

To enable Enterprise features, {{site.base_gateway}} requires a license file.
You will receive this file from Kong when you sign up for a
{{site.konnect_product_name}} Enterprise subscription.

[Contact Kong](https://konghq.com/get-started) for more information.

{% if_version lte:3.9.x %}
{:.note}
> **Note:** The free mode does not require a license. See
[{{site.base_gateway}} Licensing](/gateway/{{page.release}}/licenses)
for a feature comparison.
{% endif_version %}

Once a license has been deployed to a {{site.base_gateway}} node, retrieve it
using the [`/licenses` Admin API endpoint](/gateway/{{page.release}}/licenses/examples/).

If you have purchased a subscription but haven't received a license file,
contact your sales representative.
