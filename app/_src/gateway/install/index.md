---
title: Installation Options
subtitle: Kong Gateway is a low-demand, high-performing API gateway. You can set up Kong Gateway with Konnect, or install it on various self-managed systems.
disable_image_expand: true
---

{% if_version lte:3.3.x %}
{% include install.html config=site.data.tables.install_options %}
{% endif_version %}

{% if_version gte:3.4.x %}

<blockquote class="note">
  <p><strong>Set up your Gateway in under 5 minutes with {{ site.konnect_product_name }}:</strong></p>
  <p>
    <a href="/konnect/">{{ site.konnect_product_name }}</a> is an API lifecycle management platform that lets you build modern applications better, faster, and more securely.
  </p>
  <p><a href="https://konghq.com/products/kong-konnect/register?utm_medium=referral&utm_source=docs&utm_campaign=gateway-konnect&utm_content=install-gateway" class="no-link-icon">Start for Free &rarr;</a></p>
</blockquote>

Or you can set up {{site.base_gateway}} on your own self-managed system:

{% include install.html config=site.data.tables.install_options_34x %}

{% endif_version %}

{:.note}
> Kong images are published on Docker Hub
> 
> *Kong Gateway (Open Source)* images are in the form `kong/kong:<version>` and published on [Docker Hub kong/kong](https://hub.docker.com/r/kong/kong/tags/) repository
> *Kong Gateway Enterprise* images are in the form `kong/kong-gateway:<version>` and published on [Docker Hub kong/kong-gateway](https://hub.docker.com/r/kong/kong-gateway/tags/) repository
