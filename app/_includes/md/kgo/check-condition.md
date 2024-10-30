{% assign name = include.name %}
{% assign kind = include.kind %}
{% assign conditionType = include.conditionType | default: "Programmed" %}
{% assign reason = include.reason | default: "Programmed" %}
{% assign generation = include.generation | default: 1 %}

{% unless include.disableDescription %}
You can verify the `{{ kind }}` was reconciled successfully by checking its `{{ conditionType }}` condition.
{% endunless %}

```shell
kubectl get {{ kind | downcase }} {{ name }} -o=jsonpath='{.status.conditions[?(@.type=="{{ conditionType }}")]}' | jq
```

The output should look similar to this:

```console
{
  "observedGeneration": {{ generation }},
  "reason": "{{ reason }}",
  "status": "True",
  "type": "{{ conditionType }}"
}
```
