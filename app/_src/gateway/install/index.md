---
title: Installation Options
subtitle: Kong is a low-demand, high-performing API gateway. You can setup Kong with Konnect or it can be installed on many different self-managed systems.
disable_image_expand: true
---

{% if_version lte:3.3.x %}
{% include install.html config=site.data.tables.install_options %}
{% endif_version %}

{% if_version gte:3.4.x %}

<blockquote class="note">
  <p><strong>Set up your Gateway in under 5 minutes with {{ site.konnect_product_name }}:</strong></p><br/>
  <p>
    <a href="/konnect/">{{ site.konnect_product_name }}</a> is an API lifecycle management platform that lets you build modern applications better, faster, and more securely.
  </p>
  <p><a href="/konnect/getting-started/">Start for Free &rarr;</a></p>
</blockquote>

Or you can setup Kong on your own self-managed system:

{% include install.html config=site.data.tables.install_options_34x %}

{% endif_version %}
