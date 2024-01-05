{:.note}
> If you are testing and do not have a VPN set up for your VPC, you may change the
> `alb.ingress.kubernetes.io/scheme` annotation to `internet-facing` to add a public IP.
> This is **not recommended for long running deployments**