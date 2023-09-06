    {% comment %}This file is intentionally indented as it's included in an <ol> on multiple pages{% endcomment %}
    {% assign key = include.key | default: 'gav' %}
    {%- assign credName = include.credName | default: 'credential' %}
    ```bash
    kubectl create secret generic {{ credName }} \
      --from-literal=kongCredType=key-auth  \
      --from-literal=key={{ key }}
    ```
    The results should look like this:
    ```text
    secret/{{ credName }} created
   ```
