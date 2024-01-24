You need the `aws-load-balancer-controller` [installed in your cluster](https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/deploy/installation/) to configure Ingress resources on EKS.

After installing, check that your cluster is running the  `aws-load-balancer-controller`.

```bash
kubectl get deployments.apps -n kube-system aws-load-balancer-controller
```