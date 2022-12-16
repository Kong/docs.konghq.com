When this resource is created, a corresponding consumer entity will be created in Kong.
While KongConsumer exists in a specific Kubernetes namespace, KongConsumers from all namespaces
are combined into a single Kong configuration, and no KongConsumers with the same
`kubernetes.io/ingress.class` may share the same Username or CustomID value.
