---
title: FAQ
---

**How can I use the {{site.kgo_product_name}}?**

You can install the {{site.kgo_product_name}} by following the instructions in the [installation guide](/gateway-operator/latest/install/).

The quickest way to get started is to attach your data planes to {{site.konnect_short_name}}. For more information, see the [getting started with {{site.konnect_short_name}}](/gateway-operator/{{ page.release }}/get-started/konnect/install/). 

---

**How can I get help with the {{site.kgo_product_name}}?**

If you’re a {{site.ee_product_name}} customer, please raise a support ticket. If you’re an Open Source user, please create an issue in [Kong/gateway-operator-docs/](https://github.com/Kong/gateway-operator-docs/issues)

---

**Will you still support the Kong Helm chart?**

Yes. The Kong Helm chart is the primary way that customers install Kong today, and we’re committed to maintaining it going forward. Helm will always support any functionality that needs to be configured during installation, but will not support any day-2 operations.

---

**How is this different from Helm?**

Helm follows a more procedural approach to deployment, where you define the sequence of actions to be performed during installation or upgrade. Operators, on the other hand, are built on a declarative model. They observe the desired state defined in custom resources and ensure that the actual state of the system matches it. This declarative approach allows Operators to continuously reconcile and maintain the desired state, making them more robust and resilient.
