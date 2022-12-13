---
title: Kuma CNI
---

The operation of the Kuma data plane proxy, precludes that all the relevant inbound and outbound traffic on the host (or container) that runs the service is diverted
to pass through the proxy itself. This is done through [transparent proxying](/docs/{{ page.version }}/networking/transparent-proxying), which is set up automatically on Kubernetes. Installing it requires certain privileges, which are delegated to pre-sidecar initialisation steps.
There are two options to do this with Kuma:

* use the standard `kuma-init`, which is the default
* use the Kuma CNI

Kuma CNI can be leveraged in the two installation methods for Kubernetes: using [`kumactl`](/docs/{{ page.version }}/installation/kubernetes) and with [Helm](/docs/{{ page.version }}/installation/helm). The default settings are tuned for OpenShift with Multus, therefore to use it in other environments we need to set the relevant configuration parameters.

Below are the details of how to set-up each of the options, considering and example where a plain Kubernetes cluster deployed with `kubeadm` and the default Calico CNI is used.

{% tabs cni-kuma %}
{% tab cni-kuma kumactl %}

Supply the following arguments to `kumactl`, to enable the CNI setup and configure it for chaining with the CNI plugin.

```shell
kumactl install control-plane \
  --cni-enabled \
  --cni-chained \
  --cni-net-dir /etc/cni/net.d \
  --cni-bin-dir /opt/cni/bin \
  --cni-conf-name 10-calico.conflist
```

{% endtab %}
{% tab cni-kuma Helm %}

When using [Helm](/docs/{{ page.version }}/installation/helm), we should use the values in the `cni` section to set the relevant parameters.

```shell
helm install --version 0.5.7 --namespace kuma-system \
  --set cni.enabled=true,cni.chained=true,cni.netDir="/etc/cni/net.d",cni.binDir=/opt/cni/bin,cni.confName=10-calico.conflist \
   kuma kuma/kuma
```

{% endtab %}
{% endtabs %}
