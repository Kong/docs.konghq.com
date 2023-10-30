{% unless include.skip_title %}
## Deploy an upstream HTTP application
{% endunless %}

Create a Kubernetes service setup a [httpbin](https://httpbin.org)
service in the cluster and proxy it.

```bash
kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/httpbin-service.yaml
```
The results should look like this:
```text
service/httpbin created
deployment.apps/httpbin created
```
