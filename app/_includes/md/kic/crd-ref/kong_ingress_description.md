It serves as an "extension" to Ingress resource. It is not meant as a replacement to the Ingress resource in Kubernetes. 
The Ingress resource spec in Kubernetes can define routing policies based on HTTP Host header and paths. 
While this is sufficient in most cases, sometimes, users may want more control over routing at the Ingress level.
Once a `KongIngress` resource is created, it needs to be associated with an Ingress or Service resource using the 
`konghq.com/override` annotation.

{:.note}
> KongIngress is not supported on Gateway APIs resources, such as HTTPRoute and
> TCPRoute. These resources must use annotations.

{% if_version lte:2.7.x -%}
{:.important}
> Many fields available on KongIngress are also available as annotations. When an annotation is available,
> it is the preferred means of configuring that setting, and the annotation value will take precedence over
> a KongIngress value if both set the same setting.
{% endif_version %}

{% if_version gte:2.8.x -%}
{:.note}
> As of version 2.8, KongIngress sections other than `upstream` are
> [deprecated](https://github.com/Kong/kubernetes-ingress-controller/issues/3018).
> All settings in the `proxy` and `route` sections are now available with
> dedicated annotations, and these annotations will become the only means of
> configuring those settings in a future release. For example, if you had set
> `proxy.connect_timeout: 30000` in a KongIngress and applied an
> `konghq.com/override` annotation for that KongIngress to a Service, you will
> need to instead apply a `konghq.com/connect-timeout: 30000` annotation to the
> Service.
>
> Plans are to replace the `upstream` section of KongIngress with [a new
> resource](https://github.com/Kong/kubernetes-ingress-controller/issues/3174),
> but this is still in development and `upstream` is not yet officially
> deprecated.
{% endif_version %}
