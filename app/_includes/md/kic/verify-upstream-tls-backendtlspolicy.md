```shell
echo 'apiVersion: gateway.networking.k8s.io/v1alpha3
kind: BackendTLSPolicy
metadata:
  name: goecho-tls-policy
spec:
  options:
    tls-verify-depth: "1"
  targetRefs:
  - group: core
    kind: Service
    name: echo
  validation:
    caCertificateRefs:
    - group: core
      kind: {{ include.ref_kind }}
      name: root-ca
    hostname: kong.example' | kubectl apply -f -
```
