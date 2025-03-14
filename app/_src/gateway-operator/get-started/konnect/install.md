---
title: Install Kong Gateway Operator
content-type: tutorial
book: kgo-konnect-get-started
chapter: 1
---

{{ site.kgo_product_name }} can deploy and manage data planes attached to a {{ site.konnect_short_name }} control plane.
All the services, routes, and plugins are configured in {{ site.konnect_short_name }} and sent to the data planes automatically.

{% if_version gte:1.4.x %}
{% include md/kgo/prerequisites.md disable_accordian=true version=page.version release=page.release kconfCRDs=true konnectEntities=true %}
{% endif_version %}

{% if_version lte:1.3.x %}
{% include md/kgo/prerequisites.md disable_accordian=true version=page.version release=page.release %}
{% endif_version %}

Once the `gateway-operator-controller-manager` deployment is ready, you can deploy a `DataPlane` resource that is attached to a {{ site.konnect_short_name }} control plane.
