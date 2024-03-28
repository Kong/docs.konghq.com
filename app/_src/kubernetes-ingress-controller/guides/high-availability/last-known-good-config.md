---
title: Last Known Good Configuration
type: explanation
purpose: |
  Explain how Last Known Good Configuration works
---

{{site.kic_product_name}} stores the last valid configuration in memory and
uses it to configure new Pods. Any Pods created due to scale out events or Pod
restarts receive the latest configuration that was accepted by any Kong Pod.

{:.note}
> **Note:** Any changes you make with `kubectl` are not reflected until the
> Kubernetes API server state is fixed. This feature is designed to keep your
> deployment online until an operator can fix the k8s server state.

If the {{site.kic_product_name}} Pod is restarted with a broken configuration
on the Kubernetes API server, it fetches the last valid configuration from an
existing Kong instance and store it in memory.

If there are no running proxy Pods when the controller is restarted the last
known good configuration is lost. In this event, please fix the configuration
on your Kubernetes API server.