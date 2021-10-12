---
title: Access Your Kong Gateway License
toc: false
---

To enable Enterprise features, {{site.base_gateway}} requires a license file.
You will receive this file from Kong when you sign up for a
{{site.konnect_product_name}} Enterprise subscription.

[Contact Kong](https://konghq.com/get-started/) for more information.

<div class="alert alert-ee blue">
<b>Note:</b> The free mode does not require a license. See
<a href="/enterprise/{{page.kong_version}}/deployment/licensing">Kong Gateway Licensing</a>
for a feature comparison.
</div>

Once a license has been deployed to a {{site.base_gateway}} node, retrieve it
using the [`/licenses` Admin API endpoint](/enterprise/{{page.kong_version}}/admin-api/licenses/examples).

If you have purchased a subscription but haven't received a license file,
contact your sales representative.
