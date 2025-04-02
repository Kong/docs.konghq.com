{% unless include.disable_accordian %}
<details markdown="1">
<summary>
  <strong>Prerequisites:</strong> {% unless include.skip_install %}Install {{site.kgo_product_name}} and c{% else %}C{% endunless %}reate a valid KonnectAPIAuthConfiguration {% if include.with-control-plane %} and KonnectGatewayControlPlane{% endif %} in your cluster.
</summary>

{% endunless %}

{% unless include.skip_install %}
## Install {{site.kgo_product_name}} and create a valid KonnectAPIAuthConfiguration {% if include.with-control-plane %} and KonnectGatewayControlPlane{% endif %} in your cluster.
{% include md/kgo/prerequisites.md disable_accordian=true version=page.version release=page.release kconfCRDs=true konnectEntities=true %}
{% endunless %}

### Create an access token in Konnect

You may create either a Personal Access Token (PAT) or a Service Account Token (SAT) in Konnect. Please refer to the
[Konnect authentication documentation](/konnect/api/#authentication) for more information. You will need this token
to create a `KonnectAPIAuthConfiguration` object that will be used by the {{site.kgo_product_name}} to authenticate
with Konnect APIs.

### Create a {{site.konnect_product_name}} API auth configuration

Depending on your preferences, you can create a `KonnectAPIAuthConfiguration` object with the token specified
directly in its spec or as a reference to a Kubernetes Secret. The `serverURL` field should be set to the Konnect API
URL in a region where your {{site.konnect_product_name}} account is located. Please refer to the [list of available API URLs](/konnect/network/)
for more information.

{% navtabs token collapse %}
{% if include.api_auth_mode == "both" or include.api_auth_mode == "direct" %}
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
  serverURL: us.api.konghq.com
' | kubectl apply -f -
```
{% endnavtab %}
{% endif %}
{% if include.api_auth_mode == "both" or include.api_auth_mode == "secret" %}
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
  serverURL: us.api.konghq.com
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
{% endif %}
{% endnavtabs %}

You can verify the `KonnectAPIAuthConfiguration` object was reconciled successfully by checking its status.

```shell
kubectl get konnectapiauthconfiguration konnect-api-auth
```

The output should look like this:

```console
NAME               VALID   ORGID                                  SERVERURL
konnect-api-auth   True    <your-konnect-org-id>                  https://us.api.konghq.com
```

{% if include.with-control-plane %}
### Create a {{site.base_gateway}} control plane

Creating the `KonnectGatewayControlPlane` object in your Kubernetes cluster will provision a {{site.konnect_product_name}} Gateway
control plane in your [Gateway Manager](/konnect/gateway-manager). The `KonnectGatewayControlPlane` CR
[API](/gateway-operator/{{ page.release }}/reference/custom-resources/#konnectgatewaycontrolplane) allows you to
explicitly set a type of the {{site.base_gateway}} control plane, but if you don't specify it, the default type is
a [Self-Managed Hybrid
gateway control plane](/konnect/gateway-manager/#kong-gateway-control-planes).

You can create one by applying the following YAML manifest:

```yaml
echo '
kind: KonnectGatewayControlPlane
apiVersion: konnect.konghq.com/v1alpha1
metadata:
  name: gateway-control-plane
  namespace: default
spec:
  name: gateway-control-plane # Name used to identify the Gateway Control Plane in Konnect{% if include.control_plane_type == "dcgw" %}
  cloud_gateway: true{% endif %}{% if include.is-kic-cp == true %}
  cluster_type: CLUSTER_TYPE_K8S_INGRESS_CONTROLLER{% endif %}
  konnect:
    authRef:
      name: konnect-api-auth # Reference to the KonnectAPIAuthConfiguration object
  ' | kubectl apply -f -
```

You can see the status of the Gateway Control Plane by running:

```shell
kubectl get konnectgatewaycontrolplanes.konnect.konghq.com gateway-control-plane
```

If the Gateway Control Plane is successfully created, you should see the following output:

```shell
NAME                    PROGRAMMED   ID                                     ORGID
gateway-control-plane   True         <konnect-control-plane-id>             <your-konnect-ord-id>
```

Having that in place, you will be able to reference the `gateway-control-plane` in your {{site.konnect_product_name}} entities as their parent.
{% endif %}

{% if include.create_network %}
### Create a Network

To use this CRD, you will need a `Network`. For detailed instructions, see the [Create Cloud Gateways Network](/gateway-operator/latest/guides/konnect-entities/cloud-gateways-network/) document.

If you have already created a network, you can refer to it by name later in this guide.
{% endif %}

{% unless include.disable_accordian %}
</details>
{% endunless %}
