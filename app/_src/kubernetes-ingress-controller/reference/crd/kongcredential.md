---
title: "kongcredential"
type: 
purpose: |
  ...
---

<!-- vale off -->

<!-- This document is generated by KIC's 'generate.docs' make target, DO NOT EDIT -->
## Package
- [configuration.konghq.com/v1](#configurationkonghqcomv1)

### ConfigSource



ConfigSource is a wrapper around SecretValueFromSource.



| Field | Description |
| --- | --- |
| `secretKeyRef` _[SecretValueFromSource](#secretvaluefromsource)_ | Specifies a name and a key of a secret to refer to. The namespace is implicitly set to the one of referring object. |


_Appears in:_
- [KongPlugin](#kongplugin)


### KongProtocol

_Underlying type:_ `string`

KongProtocol is a valid Kong protocol. This alias is necessary to deal with https://github.com/kubernetes-sigs/controller-tools/issues/342





_Appears in:_
- [KongClusterPlugin](#kongclusterplugin)
- [KongIngressRoute](#kongingressroute)
- [KongPlugin](#kongplugin)

### NamespacedConfigSource



NamespacedConfigSource is a wrapper around NamespacedSecretValueFromSource.



| Field | Description |
| --- | --- |
| `secretKeyRef` _[NamespacedSecretValueFromSource](#namespacedsecretvaluefromsource)_ | Specifies a name, a namespace, and a key of a secret to refer to. |


_Appears in:_
- [KongClusterPlugin](#kongclusterplugin)

### NamespacedSecretValueFromSource



NamespacedSecretValueFromSource represents the source of a secret value specifying the secret namespace.



| Field | Description |
| --- | --- |
| `namespace` _string_ | The namespace containing the secret. |
| `name` _string_ | The secret containing the key. |
| `key` _string_ | The key containing the value. |


_Appears in:_
- [NamespacedConfigSource](#namespacedconfigsource)

### SecretValueFromSource



SecretValueFromSource represents the source of a secret value.



| Field | Description |
| --- | --- |
| `name` _string_ | The secret containing the key. |
| `key` _string_ | The key containing the value. |


_Appears in:_
- [ConfigSource](#configsource)

<!-- vale on -->