---
title: Compatibility Guide
no_version: true
---

<!-- ## Form logic
Only product is displayed on page load
Hide version form if product is not selected
If (product) has been selected AND only has ("current") version, hide version form


## View results button

If (product + version), show compatible
If (product + version == "current" ), show compatible
If (missing product or version from dropdown selection) then throw error OR have default values
If product or version is missing, show nothing OR show error

## Reset button
Clicking reset button resets form AND results
Revert to page load state, only product is displayed

-->

<!-- VARIABLES -->
{% assign products = site.data.tables.compat-json %}
{% assign systems = product.versions.os %}
{% assign docker-components = product.versions.docker %}
{% assign k8s-components = product.versions.kubernetes %}
{% assign dbs = product.versions.databases %}
{% assign langs = product.versions.pdk %}

<form name="compat-form" id="compat-form" action="/compat-dropdown">
  Product: <select name="product" id="product-compat-dropdown">
    <option value="0" selected>Select product</option>
    {% for product in products %}
    <option value="{{ product.name }}">{{ product.name }}</option>
    {% endfor %}
    </select>
    <!-- grab the selected value and use this to determine which version dropdown to show -->
    <!-- add a version dropdown if there is a version for that product -->
    <br><br>
    <!-- {% if !product.noversions %}
      Version: <select name="version" id="version-compat-dropdown">
        <option value="0" selected>Select version</option>
        <option value="{{ product.versions[0].release }}">{{ product.versions[0].release }}</option>
      </select>
    {% endif %} -->
</form>

<button type="button" onclick="getFormValues()">View Results</button>
<button type="button" onclick="resetForm()">Reset Form</button>

---

## Results

<!-- Test #3: One big table for all the things, per version -->

{% for product in products %}
<h3 id="{{ product.name }}">{{ product.name }}</h3>

{% for version in product.versions %}

**Version {{ version.release }}**

<table style="width: 80%; display: table; background-color: #f5f5f5">
  <thead>
    <th style="width: 33%"><b>Component</b></th>
    <th style="width: 33%"><b>Category</b></th>
    <th><b>Supported Versions</b></th>
  </thead>
  <tbody style="width: 80%">
  {% for system in version.os %}
    <tr>
      <td>{{ system[0] | split: "-" | join: " " | capitalize }}</td>
      <td> OS </td>
      <td>{{ system[1] }}</td>
    </tr>
  {% endfor %}
  {% for docker-component in version.docker %}
    <tr style="background-color: #fafafa">
      <td>{{ docker-component[0] | split: "-" | join: " " | capitalize }}</td>
      <td>Docker</td>
      <td>{{ docker-component[1] }}</td>
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
    <tr style="background-color: #fafafa">
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

{% endfor %}
{% endfor %}

---

<!-- Test #2: Pulled all version content into lists with literals, then printed
the value for each item.

{% for product in products %}
<h3 id="{{ product.name }}">{{ product.name }}</h3>

{% for version in product.versions %}
<h4 id="{{ version.release }}">{{ version.release }}</h4>

<!-- OS compatibility

* Amazon Linux: {{ version.os.amazon-linux }}
* Centos: {{ version.os.centos }}
* RHEL: {{ version.os.rhel }}
* Debian: {{ version.os.debian }}

<!-- Docker compatibility
**Docker components**

* Docker Engine: {{ version.docker.docker-engine }}

<!-- PDK language compatibility
**PDKs**
* Javascript: {{ version.pdk.nodejs }}
* Go: {{ version.pdk.golang }}

<!-- Database compatibility
**Databases**
* PostgreSQL: {{ version.databases.postgres }}
* Cassandra: {{ version.databases.cassandra }}

<!-- Kubernetes/KIC compatibility
**Kubernetes**

* Kong Ingress Controller: {{ version.kubernetes.kong-ingress-controller }}

{% endfor %}
{% endfor %}

---

<!-- Test #1: Separate tables for each category

{% for product in products %}
<h3 id="{{ product.name }}">{{ product.name }}</h3>

{% for version in product.versions %}
<h4 id="{{ version.release }}">{{ version.release }}</h4>

<table style="width: 100%">
<thead>
  <th><b>Operating Systems</b></th>
  <th><b>Supported Versions</b></th>
</thead>
  <tbody>
  <tr>
    <td>Amazon Linux</td>
    <td style="text-align: center">
    {{ version.os.amazon-linux }}
    </td>
  </tr>
  <tr>
    <td>Centos</td>
    <td style="text-align: center">
      {{ version.os.centos }}
    </td>
  </tr>
  <tr>
    <td>RHEL</td>
    <td style="text-align: center">
      {{ version.os.rhel }}
    </td>
  </tr>
  <tr>
    <td>Debian</td>
    <td style="text-align: center">
      {{ version.os.debian }}
    </td>
  </tr>
  </tbody>
</table>

<table style="width: 80%">
<thead>
  <th><b>Docker Components</b></th>
  <th><b>Supported Versions</b></th>
</thead>
  <tbody>
  <tr>
  <td>Docker Engine</td>
  <td>{{ version.docker.docker-engine }}</td>
  </tr>
</tbody>
</table>

<table style="width: 80%">
<thead>
  <th><b>PDK Languages</b></th>
  <th><b>Supported Versions</b></th>
</thead>
  <tbody>
  <tr>
    <td>Javascript</td>
    <td style="text-align: center">
      {{ version.pdk.nodejs }}
    </td>
  </tr>
  <tr>
    <td>Go</td>
    <td style="text-align: center">
      {{ version.pdk.golang }}
    </td>
  </tr>
  </tbody>
  </table>

<table style="width: 80%">
<thead>
  <th><b>Databases</b></th>
  <th><b>Supported Versions</b></th>
</thead>
  <tbody>
  <tr>
    <td>PostgreSQL</td>
    <td style="text-align: center">
      {{ version.databases.postgres }}
    </td>
  </tr>
  <tr>
    <td>Cassandra</td>
    <td style="text-align: center">
      {{ version.databases.cassandra }}
    </td>
  </tr>

  </tbody>
  </table>

<table style="width: 80%">
<thead>
  <th><b>Kubernetes</b></th>
  <th><b>Supported Versions</b></th>
</thead>
  <tbody>
  <tr>
    <td>
      Kong Ingress Controller
    </td>
    <td style="text-align: center">
      {{ version.kubernetes.kic }}
    </td>
  </tr>

  </tbody>
  </table>

  {% endfor %}

  {% endfor %}


-->
