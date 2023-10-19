
{% include_cached /md/kic/add-certificate.md hostname=include.hostname kong_version=page.kong_version %}

1. Update your routing configuration to use this certificate.
 {% capture the_code %}
{% navtabs codeblock %}
{% navtab Ingress %}
```bash
kubectl patch --type json ingress echo -p='[{
    "op":"add",
	"path":"/spec/tls",
	"value":[{
        "hosts":["kong.example"],
		"secretName":"{{include.hostname}}"
    }]
}]'
```
{% endnavtab %}
{% navtab Gateway APIs %}
```bash
kubectl patch --type=json gateway kong -p='[{
    "op":"add",
	"path":"/spec/listeners/-",
	"value":{
		"name":"proxy-ssl",
		"port":443,
		"protocol":"HTTPS",
		"tls":{
				"certificateRefs":[{
				    "group":"",
					"kind":"Secret",
					"name":"{{include.hostname}}"
				}]
		}
    }
}]'

```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}

    The results should look like this:

    {% capture the_code %}
{% navtabs codeblock %}
{% navtab Ingress %}
```text
ingress.networking.k8s.io/echo patched
```
{% endnavtab %}
{% navtab Gateway APIs %}
```text
gateway.gateway.networking.k8s.io/kong patched
```
{% endnavtab %}
{% endnavtabs %}
{% endcapture %}
{{ the_code | indent }}


