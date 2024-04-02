---
title: Enable the Validating Admission Webhook
---

The {{site.kic_product_name}} ships with an admission webhook for KongPlugin
and KongConsumer resources in the `configuration.konghq.com` API group.
You can generate TLS certificate and key pair that you need for admission webhook.

## Enable the webhook

You can enable webhook using Helm chart, with a script, or manually.

{% navtabs %}
{% navtab Helm chart %}
If you are using the [Helm chart](https://github.com/Kong/charts/blob/main/charts/kong/README.md),
you can enable the webhook by setting `ingressController.admissionWebhook.enabled=true`
in your values.yaml. It is set to `true` by default as of chart version 2.16.

The chart generates a self-signed certificate by default. The `ingressController.admissionWebhook.certificate` is set to use a user-provided certificate instead.

{% endnavtab %}
{% navtab Script %}
If you are using the stock YAML manifests to install and setup Kong for Kubernetes, then you can set up the admission webhook using a script. You need `kubectl` and `openssl` installed on your workstation for the script to work.

```bash
curl -sL https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/main/hack/deploy-admission-controller.sh | bash
```
The results should look like this:
```
Generating a 2048 bit RSA private key
.......+++
.......................................................................+++
writing new private key to '/var/folders/h2/chkzcfsn4sl3nn99tk5551tc0000gp/T/tmp.SX3eOgD0/tls.key'
-----
secret/kong-validation-webhook created
deployment.apps/ingress-kong patched
validatingwebhookconfiguration.admissionregistration.k8s.io/kong-validations created
```
{% endnavtab %}
{% navtab Manual%}
Kubernetes API-server makes an HTTPS call to the admission webhook to verify if the custom resource is valid or not. For this to work, Kubernetes API-server needs to trust the CA certificate that is used to sign the admission webhook's TLS certificate.



1. Generate a certificate for admission webhook.

   You can either use a self-signed certificate or a Kubernetes CA. The `CN` field of the x509 certificate takes the form `<validation-service-name>.<ingress-controller-namespace>.svc`, which in the default case is `kong-validation-webhook.kong.svc`.

   * self-signed certificate

     Use `openssl` to generate a self-signed certificate:

     ```bash
     openssl req -x509 -newkey rsa:2048 -keyout tls.key -out tls.crt -days 365  \
     -nodes -subj "/CN=kong-validation-webhook.kong.svc" \
     -extensions EXT -config <( \
    printf "[dn]\nCN=kong-validation-webhook.kong.svc\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:kong-validation-webhook.kong.svc\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth")
     ```

     The results should look like this:
     ```
     Generating a 2048 bit RSA private key
     ..........................................................+++
     .............+++
     writing new private key to 'key.pem'
     ```

   * In-built Kubernetes CA
    Kubernetes comes with an in-built CA which can be used to provision a certificate for the admission webhook. For more information about generating a certificate using the in-built CA, see [Managing TLS in a cluster](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/).

1. Create a Kubernetes secret object based on the key and certificate.
   The PEM-encoded certificate is stored in a file named `tls.crt` and private key is stored in `tls.key`.

   ```bash
   kubectl create secret tls kong-validation-webhook -n kong \
    --key tls.key --cert tls.crt
   ```
   The results should look like this:
   ```
   secret/kong-validation-webhook created
   ```

1. Update the Ingress Controller deployment.
   Use this command to patch the {{site.kic_product_name}} deployment to mount the certificate and key pair and also enable the admission webhook.

    ```bash
    kubectl patch deploy -n kong ingress-kong \
    -p '{"spec":{"template":{"spec":{"containers":[{"name":"ingress-controller","env":[{"name":"CONTROLLER_ADMISSION_WEBHOOK_LISTEN","value":":8080"}],"volumeMounts":[{"name":"validation-webhook","mountPath":"/admission-webhook"}]}],"volumes":[{"secret":{"secretName":"kong-validation-webhook"},"name":"validation-webhook"}]}}}}'
    ```
    The results should look like this:
    ```
    deployment.extensions/ingress-kong patched
    ```

   If you are using the Helm chart, run `helm upgrade -f <path to values.yamvl> <release name> kong/kong`
   after enabling the webhook or updating the certificate configuration. Note that
   chart versions 2.16 and later enable the webhook by default.

1. Enable the validating admission.

   If you are using Kubernetes CA to generate the certificate, you don't need to supply a CA certificate (in the `caBundle` parameter) as part of the Validation Webhook configuration as the API-server already trusts the internal CA.

    {% capture failure_policy %}
    {% if_version gte:2.5.x %}Ignore{% endif_version %}
    {% if_version lte:2.4.x %}Fail{% endif_version %}
    {% endcapture %}
    
    ```bash
    readonly CABUNDLE=$(base64 < ./tls.crt)
    echo "apiVersion: admissionregistration.k8s.io/v1
    kind: ValidatingWebhookConfiguration
    metadata:
      name: kong-validations
    webhooks:
    - name: validations.kong.konghq.com
      objectSelector:
        matchExpressions:
        - key: owner
          operator: NotIn
          values:
          - helm
      failurePolicy: {{ failure_policy | strip }}
      sideEffects: None
      admissionReviewVersions: [\"v1\", \"v1beta1\"]
      rules:
      - apiGroups:
        - configuration.konghq.com
        apiVersions:
        - '*'
        operations:
        - CREATE
        - UPDATE
        resources:
        - kongconsumers
        - kongconsumergroups
        - kongplugins
        - kongclusterplugins
        - kongingresses
      - apiGroups:
        - ''
        apiVersions:
        - 'v1'
        operations:
        - UPDATE
        resources:
        - secrets
      - apiGroups:
        - networking.k8s.io
        apiVersions:
          - 'v1'
        operations:
        - CREATE
        - UPDATE
        resources:
        - ingresses
      - apiGroups:
        - gateway.networking.k8s.io
        apiVersions:
        - 'v1alpha2'
        - 'v1beta1'
        operations:
        - CREATE
        - UPDATE
        resources:
        - gateways
        - httproutes
      clientConfig:
        service:
         namespace: kong
         name: kong-validation-webhook
       caBundle: ${CABUNDLE}" | kubectl apply -f -
    ```
    The results should look like this:
    ```
    validatingwebhookconfiguration.admissionregistration.k8s.io/kong-validations configured
    ```
{% endnavtab %}
{% endnavtabs %}

## Test the configuration
You can test if the admission webhook is enabled for duplicate KongConsumers, incorrect KongPlugins, incorrect credential secrets, and incorrect routes.

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
Error from server: error when creating "STDIN": admission webhook "validations.kong.konghq.com" denied the request: 400 Bad Request {"fields":{"config":{"foo":"unknown field"}},"name":"schema violation","code":2,"message":"schema violation (config.foo: unknown field)"}
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

{% if_version gte:2.12.x %}
### Verify incorrect routes

In versions 2.12 and later, the controller validates route definitions

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
{% endif_version %}
