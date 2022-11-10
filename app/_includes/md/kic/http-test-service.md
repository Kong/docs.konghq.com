## Deploy an upstream HTTP application

To proxy requests, you need an upstream application to proxy to. Deploying this
echo server provides a simple application that returns information about the
Pod it's running in:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl apply -f https://bit.ly/echo-service
```
{% endnavtab %}
{% navtab Response %}
```text
service/echo created
deployment.apps/echo created
```
{% endnavtab %}
{% endnavtabs %}
