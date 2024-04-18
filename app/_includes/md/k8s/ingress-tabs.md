{% capture content  %}
{% navtabs ingress %}
{% navtab EKS %}
{% include md/k8s/single-ingress.md provider="eks" service=include.service type=include.type %}
{% endnavtab %}
{% navtab AKS %}
{% include md/k8s/single-ingress.md provider="aks" service=include.service type=include.type %}
{% endnavtab %}
{% navtab GKE %}
{% include md/k8s/single-ingress.md provider="gke" service=include.service type=include.type %}
{% endnavtab %}
{% navtab KIC %}
{% include md/k8s/single-ingress.md provider="kic" service=include.service type=include.type %}
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}

{% if include.indent %}
{{ content | indent }}
{% else %}
{{ content }}
{% endif %}