---
title: AI Gateway
---

{% assign gatewayApiVersion = "v1beta1" %}
{% if_version gte:1.1.x %}
{% assign gatewayApiVersion = "v1" %}
{% endif_version %}

The `AIGateway` CRD is an opinionated CRD to simplify getting started with [Kong's AI capabilities](https://konghq.com/products/kong-ai-gateway).

`AIGateway` allows you to configure `largeLanguageModels` and will translate the configuration in to `Gateway`, `HTTPRoute` and `KongPlugin` resources automatically. 

{% include md/kgo/prerequisites.md version=page.version release=page.release aiGateway=true %}

## Get Started

Before using `AIGateway`, you need to provide API credentials for your AI providers. `AIGateway` supports the following providers:

* `openai`
* `azure`
* `cohere`
* `mistral`

```yaml
echo '
---
apiVersion: v1
kind: Secret
metadata:
  name: acme-ai-cloud-providers
type: Opaque
stringData:
  openai: "<INSERT TOKEN HERE>"
' | kubectl apply -f -
```

After providing authentication credentials, create a `GatewayClass` and `AIGateway` resource. The `AIGateway` resource contains a list of `largeLanguageModels`. Each of these will be exposed as individual `HTTPRoute`s based on the `identifier` field.

```yaml
echo '
---
kind: GatewayClass
apiVersion: gateway.networking.k8s.io/{{ gatewayApiVersion }}
metadata:
  name: kong-ai-gateways
spec:
  controllerName: konghq.com/gateway-operator
---
apiVersion: gateway-operator.konghq.com/v1alpha1
kind: AIGateway
metadata:
  name: kong-aigateway
spec:
  gatewayClassName: kong-ai-gateways
  largeLanguageModels:
    cloudHosted:
    - identifier: marketing-team-classic-chatgpt
      model: gpt-3.5-turbo-instruct
      promptType: completions
      aiCloudProvider:
        name: openai
    - identifier: devteam-chatgpt
      model: gpt-4
      promptType: chat
      defaultPrompts:
      - role: system
        content: "You are a helpful assistant who responds in the style of Sherlock Holmes."
      defaultPromptParams:
        maxTokens: 50 # shorter responses
      aiCloudProvider:
        name: openai
  cloudProviderCredentials:
    name: acme-ai-cloud-providers
' | kubectl apply -f -
```

{{ site.kgo_product_name }} converts the `AIGateway` definition in to a `Gateway` and multiple `HTTPRoute` definitions. The creation of a `Gateway` results in a `ControlPlane` and a `DataPlane` being deployed to handle traffic.

## Call the API

Once the `ControlPlane` and `DataPlane` pods are running, you can call the API.

```bash
❯ kubectl get pods
NAME                                                       READY   STATUS    RESTARTS   AGE
dataplane-kong-aigateway-8w9v2-hb7dn-7c4bdf74d4-lsqsv      1/1     Running   0          12m
controlplane-kong-aigateway-4mtd8-dzlmz-589bfb8fbd-8lrgc   1/1     Running   0          12m
```

To call the API, fetch the `PROXY_IP` for the `Gateway`:

```bash
export PROXY_IP=$(kubectl get gateway kong-aigateway -o jsonpath='{.status.addresses[0].value}')
```

Finally, make a `curl` request to one of the `identifier` paths that you defined. If you used the above example, try `devteam-chatgpt`:

```bash
curl $PROXY_IP/devteam-chatgpt -H 'Content-Type: application/json' -X POST -d '{
    "messages": [
        {
            "role": "user",
            "content": "What is the theory of relativity?"
        }
    ]
}'
```

For more information about how to use the AI plugins, see the [plugin hub](/hub/kong-inc/ai-proxy/#input-formats).