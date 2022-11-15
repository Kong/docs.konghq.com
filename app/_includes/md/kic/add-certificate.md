Routing configuration can include a certificate to present when clients connect
over HTTPS. This is not required, as {{site.base_gateway}} will serve a default
certificate if it cannot find another, but including TLS configuration along
with routing configuration is typical.

First, create a test certificate for the `{{ include.hostname }}` hostname:

{% navtabs codeblock %}
{% navtab Command %}
```bash
openssl req -subj '/CN={{ include.hostname }}' -new -newkey rsa:2048 -sha256 \
  -days 365 -nodes -x509 -keyout server.key -out server.crt \
  -addext "subjectAltName = DNS:{{ include.hostname }}" \
  -addext "keyUsage = digitalSignature" \
  -addext "extendedKeyUsage = serverAuth" 2> /dev/null;
  openssl x509 -in server.crt -subject -noout
```
Older OpenSSL versions, including the version provided with OS X Monterey,
require using the alternative version of this command.

{% endnavtab %}
{% navtab Alternative Command %}
```bash
openssl req -subj '/CN={{ include.hostname }}' -new -newkey rsa:2048 -sha256 \
  -days 365 -nodes -x509 -keyout server.key -out server.crt \
  -extensions EXT -config <( \
   printf "[dn]\nCN={{ include.hostname }}\n[req]\ndistinguished_name = dn\n[EXT]\nsubjectAltName=DNS:{{ include.hostname }}\nkeyUsage=digitalSignature\nextendedKeyUsage=serverAuth") 2>/dev/null;
  openssl x509 -in server.crt -subject -noout
```
{% endnavtab %}
{% navtab Response %}
```text
subject=CN = {{ include.hostname }}
```
{% endnavtab %}
{% endnavtabs %}

Second, create a Secret containing the certificate:

{% navtabs codeblock %}
{% navtab Command %}
```bash
kubectl create secret tls {{ include.hostname }} --cert=./server.crt --key=./server.key
```
{% endnavtab %}
{% navtab Response %}
```text
secret/{{ include.hostname }} created
```
{% endnavtab %}
{% endnavtabs %}
