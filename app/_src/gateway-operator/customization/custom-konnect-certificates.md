---
title: Use custom certificates with Konnect CP/DP
---

1. Generate a new certificate and key:

```sh
openssl req -new -x509 -nodes -newkey rsa:2048 -subj "/CN=kongdp/C=US" -keyout ./tls.key -out ./tls.crt
```

1. Create a Kubernetes secret that contains the previously created certificate:

```sh
kubectl create secret tls konnect-client-tls --cert=./tls.crt --key=./tls.key
```

1. Label the secret to tell KGO to reconcile it:

```sh
kubectl label secret konnect-client-tls konghq.com/konnect-dp-cert=true
```

{% include md/kgo/konnect-dataplanes-prerequisites.md disable_accordian=false version=page.version release=page.release is-kic-cp=include.is-kic-cp manual-secret-provisioning=true%}