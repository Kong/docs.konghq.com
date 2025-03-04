<!-- prereq for installation topics before 2.3 -->
{% if include.license == "prereq" %}
* You have signed up for a **paid Enterprise subscription** and received a
`license.json` file from Kong.
{% endif %}

<!-- content for "access your license" topics in 1.3.x and earlier. Might be
worth merging the two versioned options and finding generic language. -->
{% if include.license == "<1.3" %}
{{site.ee_product_name}} requires a license to run.

If you have lost access to your `license.json` file but still have a valid
license for {{site.ee_product_name}}, open a
[support case](https://support.konghq.com/) to request the file.
{% endif %}

<!-- content for "access your license" topics in 1.5.x-2.2.x -->
{% if include.license == "1.5-2.2" %}

{{site.base_gateway}} requires a license file.
You receive this file from Kong when you sign up for an Enterprise subscription.
[Contact Kong](https://konghq.com/get-started) for more information.

If you have purchased a subscription but haven't received a license file,
contact your sales representative.

If you have lost access to your license file, open a
[support case](https://support.konghq.com/).
{% endif %}

<!-- content for "access your license" topics in 1.5.x-2.2.x -->
{% if include.license == "json-example" %}

1. Download the `license.json` file you received from Kong Support.

2. Open the file and ensure it's in proper JSON format:

   ```json
    {"license":{"signature":"91e6dd9716d12ffsn4a5ckkb16a556dbebdbc4d0a66d9b2c53f8c8d717eb93dd2bdbe2cb3ef51c20806f14345128907da35","payload":{"customer":"Kong Inc","license_creation_date":"2019-05-07","product_subscription":"Kong Enterprise Edition","admin_seats":"5","support_plan":"None","license_expiration_date":"2021-04-01","license_key":"00Q1K00000zuUAwUAM_a1V1K000005kRhuUAE"},"version":1}}
   ```
{% endif %}
