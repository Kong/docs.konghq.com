---
title: Kong Platform Compatibility
no_version: true
toc: false
redirect_to: /konnect-platform/
---

Provided below are compatibility tables for Kong products. Select a Kong product
and version (if applicable) to see technologies that have been tested for
interoperability with the Kong platform.

Please see [Kong Gateway Version Support](https://docs.konghq.com/konnect-platform/support-policy/)
for more information about Kong's support for {{site.base_gateway}} and our
[Support & Maintenance Policy](https://konghq.com/supportandmaintenancepolicy/).

<!-- VARIABLES -->
{% assign products = site.data.tables.compat %}
{% assign systems = product.versions.os %}
{% assign k8s-components = product.versions.kubernetes %}
{% assign dbs = product.versions.databases %}
{% assign langs = product.versions.pdk %}
<!-- {% assign brs = product.versions.browsers %}
{% assign gtws = product.versions.gateways %} -->

<!-- Dropdown selector and buttons -->
<script>
  window.productCompatibility = {{ site.data.tables.compat | jsonify }}
</script>

<div class="compat-form">
<form name="compat-form" id="compat-form" action="/compat-dropdown">
  <div class="dropdown-label">Product:</div> <select class="product-dropdown" name="product" id="product-compat-dropdown">
    {% for product in products %}
    <option value="{{ product.slug }}">{{ product.name }}</option>
    {% endfor %}
    </select>
    <!-- grab the selected value and use this to determine which version dropdown to show -->
    <!-- add a version dropdown if there is a version for that product -->
    <br>
    <div id="version-selector" style="display:none">
    <div class="dropdown-label">Version: </div><select class="version-dropdown" name="version" id="version-compat-dropdown"></select>
    </div>
</form>

<button type="button" class="compat-button" onclick="getFormValues()">View Results</button>
<button type="button" class="compat-button" onclick="resetForm()">Reset Form</button>

</div>

<!-- Output of the product and version selector form -->

{% for product in products %}
{% for version in product.versions %}

<div class="results-table" id="{{ product.slug }}-{{ version.release | replace: '.', '_' }}">

<div class="compat-title" id="{{ product.name }}">{{ product.name }}</div>
{% if version.release %}
<div class="version-title"> Version {{ version.release }}</div>
{% endif %}

{% if product.slug == 'kong-gateway' %}
<br><br><p> If you need help using Kong Gateway with any of the supported technologies, ask a question in <a href="https://discuss.konghq.com/">our community</a>.</p>

<p>If you have an Enterprise tier subscription, contact <a href="https://support.konghq.com/">Kong Support</a>.</p>

{% elsif product.slug == 'kong-gateway-oss' %}
<br><br><p> If you need help using Kong Gateway (OSS) with any of the supported technologies, <a href="https://github.com/Kong/kong/discussions">ask a question</a> or <a href="https://github.com/Kong/kong/issues">file an issue</a> in our GitHub repository.</p>

{% endif %}

<table class="compat-table">
  <thead>
    <th style="width: 33%"><b>Component</b></th>
    <th style="width: 33%"><b>Category</b></th>
    <th><b>Supported Versions</b></th>
  </thead>
  <tbody>
  <!-- {% for br in version.browsers %}
    <tr>
      <td>{{ br[0] | split: "-" | join: " " | capitalize }}</td>
      <td>Browser</td>
      <td>{% if br[1] == "supported" %}
      <i class="fa fa-check"></i>
      {% elsif br[1] == "not supported" %}
      <i class="fa fa-times"></i>
      {% else %}
      unknown
      {% endif %}</td>
    </tr>
  {% endfor %}
  {% for gtw in version.gateways %}
    <tr>
      <td>{{ gtw[0] | split: "-" | join: " " | capitalize }}</td>
      <td>Kong Gateway</td>
      <td>{{ gtw[1] }}</td>
    </tr>
  {% endfor %} -->
  {% for system in version.os %}
    <tr>
      <td>{{ system[0] | split: "-" | join: " " | capitalize }}</td>
      <td> OS </td>
      <td>{{ system[1] }}</td>
    </tr>
  {% endfor %}
  {% for k8s-component in version.kubernetes %}
    <tr>
      <td>{{ k8s-component[0] | split: "-" | join: " " | capitalize }}</td>
      <td>Kubernetes</td>
      <td>{{ k8s-component[1] }}</td>
    </tr>
  {% endfor %}
  {% for db in version.databases %}
    <tr>
      <td>{{ db[0] | capitalize }}</td>
      <td>Database</td>
      <td>{{ db[1] }}</td>
    </tr>
  {% endfor %}
  {% for lang in version.pdk %}
    <tr>
      <td>{{ lang[0] | capitalize }}</td>
      <td>PDK</td>
      <td>{{ lang[1] }}</td>
    </tr>
  {% endfor %}
  </tbody>
</table>
</div>

{% endfor %}
{% endfor %}
