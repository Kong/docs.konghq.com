{% assign source_type = include.ca_source_kind | downcase %}
{% assign kind = include.ca_source_kind %}
{% assign id = "bf6e0f14-78cd-45ad-9325-87ec7ef7b891" %}
{% if include.ca_source_kind == "Secret" %}
{% assign id = "bf6e0f14-78cd-45ad-9325-87ec7ef7b892" %}
{% endif %}

First, create a {{ kind }} with the root CA certificate.

```shell
kubectl create {{ source_type }} {% if source_type == "secret" %}generic {%endif%}root-ca \
  --from-file=ca.crt=./certs/root.crt \
  --from-literal=id={{ id }} # An arbitrary ID for the certificate
kubectl label {{ source_type }} root-ca konghq.com/ca-cert=true # This label is required for the CA certificate to be recognized by Kong
kubectl annotate {{ source_type }} root-ca kubernetes.io/ingress.class=kong
```

The results should look like this.

```text
{{ source_type }}/root-ca created
{{ source_type }}/root-ca labeled
{{ source_type }}/root-ca annotated
```

{% if include.associate_with_service %}
Now, associate the root CA certificate with the `Service` passing its name to `konghq.com/ca-certificates-{{ source_type }}s` annotation.

{:.note}
> The `konghq.com/ca-certificates-{{ source_type }}s` annotation is a comma-separated list of `{{ kind }}`s holding CA certificates.
> You can add multiple `{{ kind }}`s to the list.

```shell
kubectl annotate service echo konghq.com/ca-certificates-{{ source_type }}s='root-ca'
```

The result should look like this.

```text
service/echo annotated
```
{% endif %}
