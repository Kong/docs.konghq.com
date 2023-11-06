---
title: Admission Webhook
type: explanation
purpose: |
  Help the user understand. What is the KIC Admission Controller? How do I enable it? What does it validate?
---

The {{site.kic_product_name}} ships with an admission webhook for KongPlugin
and KongConsumer resources in the `configuration.konghq.com` API group.
You can generate TLS certificate and key pair that you need for admission webhook.

The admission webhook is enabled by default when installing {{ site.kic_product_name }} via the Helm chart. To disable the webhook set `ingressController.admissionWebhook.enabled=false` in your `values.yaml`.

{:.important}
> The admission webhook should not be disabled unless you are asked to do so by a member of the Kong team.

To learn how to manually enable the webhook for an existing non-Helm deployment, see the [{{ site.kic_product_name }} 2.x documentation](/kubernetes-ingress-controller/2.12.x/deployment/admission-webhook/?tab=script).

## Test the configuration
You can test if the admission webhook is enabled for duplicate KongConsumers, incorrect KongPlugins, incorrect credential secrets, and incorrect routes.

{% include /md/kic/prerequisites.md kong_version=page.kong_version disable_gateway_api=true %}

### Verify duplicate KongConsumers

1. Create a KongConsumer with username as `alice`:

    ```bash
    echo "apiVersion: configuration.konghq.com/v1
    kind: KongConsumer
    metadata:
      name: alice
      annotations:
        kubernetes.io/ingress.class: kong
    username: alice" | kubectl apply -f -
    ```
    The results should look like this:
    ```
    kongconsumer.configuration.konghq.com/alice created
    ```

1. Create another KongConsumer with the same username:

    ```bash
    echo "apiVersion: configuration.konghq.com/v1
    kind: KongConsumer
    metadata:
      name: alice2
      annotations:
        kubernetes.io/ingress.class: kong
    username: alice" | kubectl apply -f -
    ```
    The results should look like this:
    ```
    Error from server: error when creating "STDIN": admission webhook "validations.kong.konghq.com" denied the request: consumer already exists
    ```

The validation webhook rejected the KongConsumer resource as there already exists a consumer in Kong with the same username.

### Verify incorrect KongPlugins

Try to create the following KongPlugin resource. The `foo` config property does not exist in the configuration definition and
hence the admission webhook returns back an error. If you remove the `foo: bar` configuration line, the plugin will be
created successfully.

```bash
echo "
apiVersion: configuration.konghq.com/v1
kind: KongPlugin
metadata:
  name: request-id
config:
  foo: bar
  header_name: my-request-id
plugin: correlation-id
" | kubectl apply -f -
```
The results should look like this:
```
Error from server: error when creating "STDIN": admission webhook "validations.kong.konghq.com" denied the request: plugin failed schema validation: schema violation (config.foo: unknown field)
```

### Verify incorrect credential secrets

With 0.7 and later versions of {{site.kic_product_name}}, validations also take place
for incorrect secret types and wrong parameters to the secrets.

```bash
kubectl create secret generic missing-password-credential \
  --from-literal=kongCredType=basic-auth \
  --from-literal=username=foo
```
The results should look like this:
```
Error from server: admission webhook "validations.kong.konghq.com" denied the request: missing required field(s): password
```

```bash
kubectl create secret generic wrong-cred-credential \
  --from-literal=kongCredType=wrong-auth \
  --from-literal=sdfkey=my-sooper-secret-key
```
The results should look like this:
```
Error from server: admission webhook "validations.kong.konghq.com" denied the request: invalid credential type: wrong-auth
```

### Verify incorrect routes

In versions 2.12 and later, the controller validates route definitions

{% navtabs %}
{% navtab Gateway API %}
```bash
echo 'kind: HTTPRoute
apiVersion: gateway.networking.k8s.io/v1
metadata:
  name: echo-httproute
spec:
  parentRefs:
    - group: gateway.networking.k8s.io
      kind: Gateway
      name: kong
  rules:
    - matches:
        - path:
            type: RegularExpression
            value: /echo/**/broken
      backendRefs:
        - name: echo
          port: 1027' | kubectl apply -f -
```
The results should look like this:
```
Error from server: error when creating "STDIN": admission webhook "validations.kong.konghq.com" denied the request: HTTPRoute failed schema validation: schema violation (paths.1: invalid regex: '/echo/**/broken' (PCRE returned: pcre_compile() failed: nothing to repeat in "/echo/**/broken" at "*/broken"))
```
{% endnavtab %}
{% navtab Ingress %}
```bash
echo 'apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: echo
  annotations:
    konghq.com/strip-path: "true"
spec:
  ingressClassName: kong
  rules:
    - http:
        paths:
          - path: /~/echo/**/broken
            pathType: ImplementationSpecific
            backend:
              service:
                name: echo
                port:
                  number: 1025' | kubectl apply -f -
```
The results should look like this:
```
Error from server: error when creating "STDIN": admission webhook "validations.kong.konghq.com" denied the request: Ingress failed schema validation: schema violation (paths.1: invalid regex: '/echo/**/broken' (PCRE returned: pcre_compile() failed: nothing to repeat in "/echo/**/broken" at "*/broken"))
```
{% endnavtab %}
{% endnavtabs %}