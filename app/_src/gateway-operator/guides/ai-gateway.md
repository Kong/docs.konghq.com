---
title: AI Gateway
---

The `AIGateway` CRD is an opinionated CRD to simplify getting started with [Kong's AI capabilities](https://konghq.com/products/kong-ai-gateway).

`AIGateway` allows you to configure `largeLanguageModels` and will translate the configuration in to `Gateway`, `HTTPRoute` and `KongPlugin` resources automatically. 

{% include md/kgo/prerequisites-kic.md version=page.version release=page.release aiGateway=true %}

## Get Started

{:.important}
> This guide does not work yet. There are missing `create` permissions for both `Gateway` and `HTTPRoute` in the `kgo-gateway-operator-manager-role` `clusterrole`

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
---
kind: GatewayClass
apiVersion: gateway.networking.k8s.io/v1
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