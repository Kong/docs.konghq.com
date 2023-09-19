---
title: Installation Options
disable_image_expand: true
---

Kong can be installed on many different systems. From bare metal, to virtual machines, and cloud native Kubernetes environments, Kong is a low-demand, high-performing API gateway.

{% if_version lte:3.3.x %}
{% include install.html config=site.data.tables.install_options %}
{% endif_version %}

{% if_version gte:3.4.x %}
{% include install.html config=site.data.tables.install_options_34x %}
{% endif_version %}
