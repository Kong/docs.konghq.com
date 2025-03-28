{% unless include.disable_accordian %}
<details markdown="1">
<summary>
  <strong>Prerequisites:</strong> Create a KonnectExtension in your cluster
</summary>

## Create a KonnectExtension in your cluster
{% endunless %}

The command below can be used to configure a `DataPlane` in an hybrid `ControlPlane` referenced via `NamespacedRef`, with automatic secret provisioning and one `DataPlane` label. You can find all the `KonnectExtension` available options and knobs in the [overview page](/gateway-operator/{{page.release}}/guides/konnect-dataplanes/overview).

{% navtabs %}
{% navtab NamespacedRef CP reference %}

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=true version=page.version release=page.release with-control-plane=true is-kic-cp=include.is-kic-cp skip_install=include.skip_install api_auth_mode="secret" %}

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
          name: my-controlplane ' | kubectl apply -f -
```

{% endnavtab %}
{% navtab KonnectID CP reference %}

{% include md/kgo/konnect-entities-prerequisites.md disable_accordian=true version=page.version release=page.release with-control-plane=false skip_install=true api_auth_mode="secret" %}

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
        type: konnectID
        konnectID: 11111111-1111-1111-1111-111111111111' | kubectl apply -f -
```

{% endnavtab %}
{% endnavtabs %}

{% unless include.disable_accordian %}
</details>
{% endunless %}
