{% unless include.skip_ingress_controller_install %}
1. Configure your Ingress Controller:

  {% include md/k8s/controller-install-tabs.md indent=true service=include.service release=include.release %}

{% endunless %}

1. Configure the `{{ include.service }}` section in `values-{{ include.release }}.yaml`. Replace `example.com` with your custom domain name.

  {% include md/k8s/ingress-tabs.md indent=true service=include.service type=include.type %}

{% unless include.skip_release %}
1. Run `helm upgrade` to update the release.

    ```bash
    helm upgrade kong-{{ include.release }} kong/kong -n kong --values ./values-{{ include.release }}.yaml
    ```
{% endunless %}

{% unless include.skip_dns %}
1. Fetch the `Ingress` IP address and update your DNS records to point at the Ingress address. You can configure DNS manually, or use a tool like [external-dns](https://github.com/kubernetes-sigs/external-dns) to automate DNS configuration.

    ```bash
    kubectl get ingress -n kong kong-{{ include.release }}-kong-{{ include.service }} -o jsonpath='{.spec.rules[0].host}{": "}{range .status.loadBalancer.ingress[0]}{@.ip}{@.hostname}{end}'
    ```
{% endunless %}