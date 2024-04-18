    {% comment %}This file is intentionally indented as it's included in an <ol> on multiple pages{% endcomment %}
    {% assign key = include.key | default: 'gav' %}
    {%- assign credName = include.credName | default: 'credential' %}
    ```bash
    echo '
    apiVersion: v1
    kind: Secret
    metadata:
      name: {{ credName }}
      labels:
        konghq.com/credential: key-auth
    stringData:
      key: {{ key }}
    ' | kubectl apply -f -
    ```
    The results should look like this:
    ```text
    secret/{{ credName }} created
   ```
