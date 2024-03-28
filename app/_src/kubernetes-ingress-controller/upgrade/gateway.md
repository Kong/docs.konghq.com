---
title: Upgrading Kong Gateway with Kong Ingress Controller
type: how-to
purpose: |
  What do I need to know when upgrading Kong Gateway on Kubernetes? DB-backed mode vs DB-less
---

Every {{ site.kic_product_name }} deployment consists of two components that can be upgraded independently (learn more in [Deployment methods]).

- {{ site.kic_product_name }} (a control plane),
- {{ site.base_gateway }} (a data plane).

Learn to upgrade {{ site.base_gateway }} when running with {{ site.kic_product_name }}.

To see the available {{ site.base_gateway }} images, refer to Docker Hub:

- [{{ site.ce_product_name }}](https://hub.docker.com/r/kong/kong-gateway/tags)
- [{{ site.ee_product_name }}](https://hub.docker.com/_/kong/tags)

## Prerequisites

- {{ site.kic_product_name }} installed using the `kong/ingress` Helm chart.
- Enure your Helm charts repository is up-to-date by running `helm repo update`.
- [yq] installed (for YAML processing).
- Check the version of {{ site.base_gateway }} and {{ site.kic_product_name }} you're currently  running. 

    ```shell
    helm get values --all kong -n kong  | yq '{
      "gateway": .gateway.image.repository + ":" + .gateway.image.tag,
      "controller": .controller.ingressController.image.repository + ":" + .controller.ingressController.image.tag
    }'
    ```

    As an output, you should get the versions of {{ site.base_gateway }} and {{ site.kic_product_name }} deployed in your cluster, for example:

    ```text
    gateway: kong:3.3
    controller: kong/kubernetes-ingress-controller:{{ site.data.kong_latest_KIC.version }}
    ```

    To understand what version of {{ site.base_gateway }} is compatible with your version of {{ site.kic_product_name }}, refer to the [compatibility matrix].

{:.important}
>  **Upgrading {{ site.base_gateway }} in DB mode**
>
> There may be database migrations to run when running {{ site.base_gateway }} in DB-backed mode.
> Refer to [Upgrade {{ site.base_gateway }} 3.x.x] to learn more about upgrade paths between different versions of {{ site.base_gateway }}.

## Upgrade {{ site.base_gateway }} using Helm

1. Edit or create a `values.yaml` file so that it contains a `gateway.image.tag` entry. Set this value to the version of {{ site.base_gateway }} to be installed.

    ```yaml
    gateway:
      image:
        tag: {{ site.data.kong_latest_gateway.ce-version }}
    ```

1. Run `helm upgrade` with the `--values` flag.

    ```bash
    helm upgrade -n kong kong kong/ingress --values values.yaml --wait
    ```

    The result should look like this:
    
    ```bash
    Release "kong" has been upgraded. Happy Helming!
    NAME: kong
    LAST DEPLOYED: Fri Nov  3 15:27:49 2023
    NAMESPACE: kong
    STATUS: deployed
    REVISION: 5
    TEST SUITE: None
    ```

    Pass `--wait` to `helm upgrade` to ensure that the command only returns when the rollout finishes successfully. 

1. Verify the upgrade by checking the version of {{ site.base_gateway }} Deployment running in your cluster.

    ```bash
    kubectl get deploy kong-gateway -n kong -ojsonpath='{.spec.template.spec.containers[0].image}'
    ```

    You should see the new version of {{ site.base_gateway }}:

    ```bash
    kong:{{ site.data.kong_latest_gateway.ce-version }}
    ```

[Deployment methods]: /kubernetes-ingress-controller/{{ page.release}}/production/deployment-topologies/
[yq]: https://github.com/mikefarah/yq
[Compatibility Matrix]: /kubernetes-ingress-controller/{{page.release}}/reference/version-compatibility/#kong
[Upgrade {{ site.base_gateway }} 3.x.x]: https://docs.konghq.com/gateway/latest/upgrade/
