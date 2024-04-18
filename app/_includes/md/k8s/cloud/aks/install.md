You need `application-gateway-kubernetes-ingress` [installed in your cluster](https://azure.github.io/application-gateway-kubernetes-ingress/setup/install-new/) to configure Ingress resources on AKS.

After installing, check that your cluster is running the `ingress-appgw-deployment`.

```bash
kubectl get deployments.apps -n kube-system ingress-appgw-deployment
```
