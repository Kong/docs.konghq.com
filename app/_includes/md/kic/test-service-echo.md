{% unless include.skip_title %}
## Deploy an echo service
{% endunless %}

To proxy requests, you need an upstream application to send a request to. Deploying this echo server provides a simple application that returns information about the Pod it's running in:

```bash
kubectl apply -f {{site.links.web}}/assets/kubernetes-ingress-controller/examples/echo-service.yaml
```
The results should look like this:
```text
service/echo created
deployment.apps/echo created
```
