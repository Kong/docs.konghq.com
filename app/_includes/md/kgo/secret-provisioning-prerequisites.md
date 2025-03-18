{% unless include.disable_accordian %}
<details markdown="1">
<summary>
  <strong>Prerequisites:</strong> Choose your certificate provisioning method
</summary>

## Choose your certificate provisioning method
{% endunless %}

{% navtabs %}
{% navtab Manual secret provisioning %}

1. Generate a new certificate and key:

```sh
openssl req -new -x509 -nodes -newkey rsa:2048 -subj "/CN=kongdp/C=US" -keyout ./tls.key -out ./tls.crt
```

1. Create a Kubernetes secret that contains the previously created certificate:

```sh
kubectl create secret tls konnect-client-tls -n kong --cert=./tls.crt --key=./tls.key
```

1. Label the secret to tell KGO to reconcile it:

```sh
kubectl label secret konnect-client-tls konghq.com/konnect-dp-cert=true
```

{% include md/kgo/konnect-dataplanes-prerequisites.md disable_accordian=false version=page.version release=page.release is-kic-cp=include.is-kic-cp manual-secret-provisioning=true%}

{% endnavtab %}
{% navtab Automatic secret provisioning %}
{% include md/kgo/konnect-dataplanes-prerequisites.md disable_accordian=false version=page.version release=page.release is-kic-cp=include.is-kic-cp manual-secret-provisioning=false%}
{% endnavtab %}
{% endnavtabs %}

{% unless include.disable_accordian %}
</details>
{% endunless %}
