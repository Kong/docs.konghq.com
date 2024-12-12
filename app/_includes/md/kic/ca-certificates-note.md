{:.note}
> CA certificates in Kong are provisioned by creating `Secret` or `ConfigMap` resource in Kubernetes.
> Resources holding CA certificates must have the following properties:
> - the `konghq.com/ca-cert: "true"` label applied.
> - a `cert` or `ca.crt` data property which contains a valid CA certificate in PEM format.
> - a `kubernetes.io/ingress.class` annotation whose value matches the value of the controller's `--ingress-class`
    argument. By default, that value is `kong`.
> - an `id` data property which contains a random UUID.
>
> Each CA certificate that you create needs a unique ID. Any random UUID should suffice here and it doesn't have a
> security implication. You can use [uuidgen](https://linux.die.net/man/1/uuidgen) (Linux, OS X)
> or [New-Guid](https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/new-guid) (Windows) to
> generate an ID.
