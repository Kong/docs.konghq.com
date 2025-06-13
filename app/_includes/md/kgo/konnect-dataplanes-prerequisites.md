{% unless include.disable_accordian %}
<details markdown="1">
<summary>
  <strong>Prerequisites:</strong> Create a KonnectExtension in your cluster
</summary>

## Create a KonnectExtension in your cluster
{% endunless %}

The command below can be used to configure a `KonnectExtension`, which is used to attach a `Gateway` or a `DataPlane` to Konnect. You can find all the available `KonnectExtension` available options in the [overview page](/gateway-operator/{{page.release}}/reference/custom-resources/#konnectextension-1).

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=false version=page.version release=page.release with-control-plane=true is-kic-cp=include.is-kic-cp skip_install=include.skip_install api_auth_mode="secret" %}

```bash
echo '
kind: KonnectExtension
apiVersion: konnect.konghq.com/v1alpha1
metadata:
  name: my-konnect-config
  namespace: default
spec:{% if include.manual-secret-provisioning %}
  clientAuth:
    certificateSecret:
      provisioning: Manual
        secretRef:
          name: konnect-client-tls{% else %}
  clientAuth:
    certificateSecret:
      provisioning: Automatic{% endif %}
  konnect:
    controlPlane:
      ref:
        type: konnectNamespacedRef
        konnectNamespacedRef:
          name: gateway-control-plane' | kubectl apply -f -
```

{% unless include.disable_accordian %}
</details>
{% endunless %}
