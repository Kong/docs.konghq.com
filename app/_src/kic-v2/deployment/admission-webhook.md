---
title: Enable the Validating Admission Webhook
---

The {{site.kic_product_name}} ships with an admission webhook for KongPlugin and KongConsumer resources in the `configuration.konghq.com` API group.To enable the admission webhook you need a TLS certificate and key pair as part of the deployment.

## Setup admission webhook

1. Install {{site.kic_product_name}}.
    {% capture the_code %}
{% navtabs codeblock %}
{% navtab YAML manifests %}
```bash
$ kubectl apply -f https://raw.githubusercontent.com/Kong/kubernetes-ingress-controller/v{{ page.release }}/deploy/single/all-in-one-dbless.yaml
```
{% endnavtab %}
{% navtab Helm %}
```
$ helm repo add kong https://charts.konghq.com
$ helm repo update
$ helm install kong kong/ingress -n kong --create-namespace
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

1. Enable admission webhook.
   
   {:.note}
> If you are using Helm, you can set the `ingressController.admissionWebhook.enabled=true` in your values.yaml. It is set to `true` by default as of chart version 2.16.The chart generates a self-signed certificate by default.`ingressController.admissionWebhook.certificate` contains settings to use a user-provided certificate instead.

   This script takes all the following commands and packs them together. You need `kubectl` and `openssl` installed on your workstation to run the script successfully.

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
1. Create a certificate for the admission webhook.

    Kubernetes API-server makes an HTTPS call to the admission webhook to verify if the custom resource is valid or not. For this to work, Kubernetes API-server needs to trust the CA certificate that is used to sign the admission webhook's TLS certificate. You can use OpenSSL to generate a self-signed certificate or use the in-built CA in Kubernetes.

    Kubernetes comes with an in-built CA which can be used to provision a certificate for the admission webhook. For more information about generating a certificate using the in-built CA, see the [Managing TLS in a Cluster](https://kubernetes.io/docs/tasks/tls/managing-tls-in-a-cluster/).

    The `CN` field of the x509 certificate takes the form `<validation-service-name>.<ingress-controller-namespace>.svc`, by default it is `kong-validation-webhook.kong.svc`.

    To generate a self-signed certificate using OpenSSL.
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
    ............+++
    writing new private key to 'key.pem'
    ```
1. Create the secret.

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

   {% capture the_code %}
{% navtabs codeblock %}
{% navtab YAML manifests %}
```bash
kubectl patch deploy -n kong ingress-kong \
    -p '{"spec":{"template":{"spec":{"containers":[{"name":"ingress-controller","env":[{"name":"CONTROLLER_ADMISSION_WEBHOOK_LISTEN","value":":8080"}],"volumeMounts":[{"name":"validation-webhook","mountPath":"/admission-webhook"}]}],"volumes":[{"secret":{"secretName":"kong-validation-webhook"},"name":"validation-webhook"}]}}}}'
```
{% endnavtab %}
{% navtab Helm %}
```bash
kubectl patch deploy -n kong kong-controller \
    -p '{"spec":{"template":{"spec":{"containers":[{"name":"ingress-controller","env":[{"name":"CONTROLLER_ADMISSION_WEBHOOK_LISTEN","value":":8080"}],"volumeMounts":[{"name":"validation-webhook","mountPath":"/admission-webhook"}]}],"volumes":[{"secret":{"secretName":"kong-validation-webhook"},"name":"validation-webhook"}]}}}}'
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

    The results should look like this:
    {% capture the_code %}
{% navtabs codeblock %}
{% navtab YAML manifests %}
```
deployment.extensions/ingress-kong patched
```
{% endnavtab %}
{% navtab Helm %}
```bash
deployment.apps/kong-controller patched
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

1. Enable the validating admission.
    If you are using Kubernetes CA to generate the certificate, you don't need to supply a CA certificate (in the `caBunde` parameter) as part of the Validation Webhook configuration as the API-server already trusts the internal CA.
    {% capture failure_policy %}
    {% if_version gte:2.5.x %}Ignore{% endif_version %}
    {% if_version lte:2.4.x %}Fail{% endif_version %}
    {% endcapture %}

    ```bash
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
     admissionReviewVersions: ["v1", "v1beta1"]
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
       - kongplugins
     - apiGroups:
       - ''
       apiVersions:
       - 'v1'
       operations:
       - UPDATE
       resources:
       - secrets
     clientConfig:
       service:
         namespace: kong
         name: kong-validation-webhook
       caBundle: $(cat tls.crt  | base64) " | kubectl apply -f -
    ```
    The results should look like this:
    ```
    validatingwebhookconfiguration.admissionregistration.k8s.io/kong-validations configured
    ```
## Test the configurations

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
    ```text
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
    The output is similar to the following:
    ```text
    Error from server: error when creating "STDIN": admission webhook "validations.kong.konghq.com" denied the request: consumer already exists
    ```

The validation webhook rejected the KongConsumer resource as there already
exists a consumer in Kong with the same username.

### Verify incorrect KongPlugins

Try to create the following KongPlugin resource. The `foo` config property does not exist in the configuration definition and hence the admission webhook returns back an error. If you remove the `foo: bar` configuration line, the plugin will be
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

Validations also take place for incorrect secret types and wrong parameters to the secrets:

```bash
kubectl create secret generic some-credential \
  --from-literal=kongCredType=basic-auth \
  --from-literal=username=foo
```
The results should look like this:
```
Error from server: admission webhook "validations.kong.konghq.com" denied the request: missing required field(s): password
```

```bash
kubectl create secret generic some-credential \
  --from-literal=kongCredType=wrong-auth \
  --from-literal=sdfkey=my-sooper-secret-key
```
The rewsults should look like this:
```
Error from server: admission webhook "validations.kong.konghq.com" denied the request: invalid credential type: wrong-auth
```
