---
title: Last Known Good Configuration
type: explanation
purpose: |
  Explain how Last Known Good Configuration works
---

{{site.kic_product_name}} stores the last valid configuration in memory and
uses it to configure new pods. Any pods created due to scale out events or pod
restarts will receive the latest configuration that was accepted by any Kong pod.

{:.note}
> **Note:** Any changes you make with `kubectl` will not be reflected until the
> Kubernetes API server state is fixed. This feature is designed to keep your
> deployment online until an operator can fix the k8s server state.

If the {{site.kic_product_name}} pod is restarted with a broken configuration
on the Kubernetes API server, it will fetch the last valid configuration from an
existing Kong instance and store it in memory.

If there are no running proxy pods when the controller is restarted the last
known good configuration will be lost. In this event, please fix the configuration
on your Kubernetes API server.