{% unless include.disable_accordian %}
<details class="custom" markdown="1">
<summary>
<blockquote class="note">
  <p style="cursor: pointer">Before you create any Konnect entity, make sure you've <u>installed {{site.kgo_product_name}} and created a valid KonnectAPIAuthConfiguration</u> in your cluster.</p>
</blockquote>
</summary>

## Prerequisites
{% endunless %}

{% include md/kgo/prerequisites.md disable_accordian=true version=page.version release=page.release kconf-crds=true %}

### Create an access token in Konnect

You may create either a Personal Access Token (PAT) or a Service Account Token (SAT) in Konnect. Please refer to the
[Konnect authentication documentation](/konnect/api/#authentication) for more information. You will need this token
to create a `KonnectAPIAuthConfiguration` object that will be used by the {{site.kgo_product_name}} to authenticate
with Konnect APIs.

### Create a `KonnectAPIAuthConfiguration` object

Depending on your preferences, you might want to create a `KonnectAPIAuthConfiguration` object with the token specified
directly in its spec or as a reference to a Kubernetes Secret. The `serverURL` field should be set to the Konnect API
URL in a region where your Konnect account is located. Please refer to the [list of available API URLs](/konnect/network/)
for more information.

{% navtabs token %}
{% navtab Directly in specification %}
```yaml
echo '
kind: KonnectAPIAuthConfiguration
apiVersion: konnect.konghq.com/v1alpha1
metadata:
  name: konnect-api-auth
  namespace: default
spec:
  type: token
  token: kpat_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
  serverURL: eu.api.konghq.com
' | kubectl apply -f -
```
{% endnavtab %}
{% navtab Stored in a Secret %}
Please note that the Secret must have the `konghq.com/credential: konnect` label to make the {{site.kgo_product_name}}
reconcile it.

```yaml
echo '
kind: KonnectAPIAuthConfiguration
apiVersion: konnect.konghq.com/v1alpha1
metadata:
  name: konnect-api-auth
  namespace: default
spec:
  type: secretRef
  secretRef:
    name: konnect-api-auth-secret
  serverURL: eu.api.konghq.com
---
kind: Secret
apiVersion: v1
metadata:
  name: konnect-api-auth-secret
  namespace: default
  labels:
    konghq.com/credential: konnect
stringData:
  token: kpat_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
' | kubectl apply -f -
```
{% endnavtab %}
{% endnavtabs %}

You can verify the `KonnectAPIAuthConfiguration` object was reconciled successfully by checking its status.

```shell
kubectl get konnectapiauthconfiguration konnect-api-auth
```

The output should look like this:

```console
NAME               VALID   ORGID                                  SERVERURL
konnect-api-auth   True    <your-konnect-org-id>                  https://eu.api.konghq.tech
```

{% unless include.disable_accordian %}
</details>
{% endunless %}
