<!-- License and bintray access info step; used in Kubernetes installation topics-->
{% if include.license == "prereq" %}
* You have signed up for a **paid Enterprise subscription** and received a
`license.json` file from Kong.
{% endif %}

{% if include.license == "<1.3" %}
{{site.ee_product_name}} requires a license to run.

If you have lost access to your `license.json` file but still have a valid
license for Kong Gateway (Enterprise), open a
[support case](https://support.konghq.com/) to request the file.
{% endif %}

{% if include.license == "1.5-2.2" %}

{{site.base_gateway}} requires a license file.
You receive this file from Kong when you sign up for an Enterprise subscription.
[Contact Kong](https://konghq.com/get-started/) for more information.

If you have purchased a subscription but haven't received a license file,
contact your sales representative.

If you have lost access to your license file, open a
[support case](https://support.konghq.com/).

{% endif %}
