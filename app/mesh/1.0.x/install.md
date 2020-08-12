---
title: Install Kong Mesh
no_search: true
---

# Install {{site.mesh_product_name}}

{{site.mesh_product_name}} is built on top of Kuma and Envoy and in order to create a seamless experience it follows the same exact installation and configuration procedures as Kuma, but with its own binaries instead.

On this page you will find access to the official {{site.mesh_product_name}} distributions that provide a drop-in replacemement to Kuma's native binaries.

<div class="page page-install">
  {% capture header_caption %}Latest Release v{{ site.data.kong_latest.version }} &bull; See <a href="{{ site.repos.kong }}/blob/master/CHANGELOG.md">Changelog</a> &bull; Check out the <a href="https://github.com/kong/kong/blob/master/UPGRADE.md">suggested upgrade paths</a> and the <a href="/latest/network/">network &amp; firewall guide</a>{% endcapture %}
  {% include header.html header_caption=header_caption %}</a>
  <section class="content-section">
    <div class="container">
      <div class="distributions">
        {% for method in site.data.distributions %}
          <a href="{% if method.soon %}#{% else %}/install/{{ method.id }}/{% endif %}" class="box {% if method.soon %}soon{% endif %}" title="{{ method.name }}">
            <img src="/assets/images/distributions/{{ method.id }}.{% if method.png %}png{% else %}svg{% endif %}" alt="{{ method.name }}"/>
          </a>
        {% endfor %}
      </div>
      <br><br>
      <p>Updating from an older version? Check out the <a href="{{ site.repos.kong }}/blob/master/UPGRADE.md">suggested upgrade paths</a>.</p>
    </div>
  </section>
</div>

To make sure that we have installed the right version of {{site.mesh_product_name}}, you can always run the following commands and make sure that the version output is being prefixed with `{{site.mesh_product_name}}`:

```sh
$ kumactl version
Kong Mesh [VERSION NUMBER]

$ kuma-cp version
Kong Mesh [VERSION NUMBER]

$ kuma-dp version
Kong Mesh [VERSION NUMBER]
```