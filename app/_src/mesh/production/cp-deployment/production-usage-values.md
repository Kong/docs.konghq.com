---
title: Production usage values
---

To install a production-ready {{site.mesh_product_name}}, care must be taken in multiple areas to ensure the service mesh is secure, reliable, and performant. When deploy {{site.mesh_product_name}} on Kubernetes, please use the provided values here to deploy your {{site.mesh_product_name}} installation.

Please note that values list in this page are meant to be a starting point for your installation, it's always recommended to read the full [reference of helm configuration](/mesh/{{ page.release }}/reference/kuma-cp/#helm-valuesyaml) to find supports for other options available before executing the install steps. These value will override the values in the default reference helm configuration, and they may be overridden again by further `values.yaml` files or `helm` command arguments. Please refer to [Helm documentation](https://helm.sh/docs/chart_template_guide/values_files/) to learn more about how values are calculated.

The `values.yaml` files here can be used as follows:

```sh
# Install a single-zone {{site.mesh_product_name}} control plane
helm install {{ site.mesh_helm_install_name }} {{ site.mesh_helm_repo }} --namespace {{site.mesh_namespace}} -f ./values.single-zone-cp.yaml

# Install the global control plane for a multi-zone {{site.mesh_product_name}} control plane
helm install {{ site.mesh_helm_install_name }} {{ site.mesh_helm_repo }} --namespace {{site.mesh_namespace}} -f ./values.global-cp.yaml

# Install a federated zone for the multi-zone {{site.mesh_product_name}} control plane
helm install {{ site.mesh_helm_install_name }} {{ site.mesh_helm_repo }} --namespace {{site.mesh_namespace}} -f ./values.federated-zone-cp.yaml \
  --set '{{site.set_flag_values_prefix}}controlPlane.zone=zone-prod' \
  --set '{{site.set_flag_values_prefix}}controlPlane.kdsGlobalAddress=kds-global.example.com'
```

The values in this page may reference resources that need to be created in advance when certain features are enabled, please read the value files carefully and prepare these resources according to notes near the `(action)` keywords. If you decide to disable the feature that require a resource to be pre-existing, please remove/change those fields according to the full [reference of helm configuration](/mesh/{{ page.release }}/reference/kuma-cp/#helm-valuesyaml).

Please choose one `values.yaml` file according to your installation scenario:

<!-- v2.7.x and below does not support controlPlane.defaults.adminRoleGroups -->
{% if_version gte:2.8.x %}
{% tabs values-yaml useUrlFragment=true %}
{% tab values-yaml single zone control plane %}
```yaml
kuma:
  controlPlane:
    mode: "zone"

    tls:
      apiServer:
        # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
        # it contains the keys "tls.crt" and "tls.key", and the content items should be in "PEM" format: 
        secretName: kong-mesh-apiserver-tls

    apiServer:
      corsAllowedDomains:
        # change these values you want to access the control plane API server or Mesh GUI from a custom domain
        - https://localhost:5682
        # if you want to access the API server using the HTTP port, add the following line
        # - http://localhost:5681

    defaults:
      # change these values you want to open the admin access rights of control plane API server to more groups
      adminRoleGroups:
        - mesh-system:admin
        - system:masters

    envVars:
      # if you want to access the API server using the HTTP port, change the following switch to "true" 
      KUMA_API_SERVER_HTTP_ENABLED: "false"

    secrets:
      # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
      # to obtain this license, please contact your Kong Account Manager and import it into your cluster:
      # kubectl create  -n kong-mesh-system secret generic kong-mesh-license --from-file license.json=$KMESH_LICENSE_FILE
      - Secret: kong-mesh-license
        Key: license.json
        Env: KMESH_LICENSE_INLINE

    # please tune the resource allocation according to your actual mesh size and traffic load after {{site.mesh_product_name}} is installed. 
    # try to make the resource limits identical to requests to make components are assigned as a QoS class of Guaranteed
    # More detail on sizing the CP: {{ site.links.web }}/mesh/{{ page.release }}/introduction/kuma-requirements/#sizing-your-control-plane
    resources:
      requests:
        cpu: 1000m
        memory: 1024Mi
      limits:
        cpu: 1000m
        memory: 1024Mi

    replicas: 2
    autoscaling:
      enabled: true

      metrics:
        - type: Resource
          resource:
            name: cpu
            target:
              type: Utilization
              averageUtilization: 50
        - type: Resource
          resource:
            name: memory
            target:
              type: Utilization
              averageUtilization: 50


    podDisruptionBudget:
      enabled: true

  cni:
    # -- Install Kuma with CNI instead of proxy init container
    enabled: false
    resources:
      requests:
        cpu: 100m
        memory: 100Mi
      limits:
        cpu: 100m
        memory: 100Mi

ratelimit:
  # -- Whether Ratelimit Service should be deployed
  enabled: false
  replicas: 2
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 5
    metrics:
      - type: Resource
        resource:
          name: cpu
          target:
            type: Utilization
            averageUtilization: 80

  # please tune the resource allocation according to your actual mesh size and traffic load after {{site.mesh_product_name}} is installed. 
  # try to make the resource limits identical to requests to make components are assigned as a QoS class of Guaranteed
  resources:
    requests:
      cpu: 500m
      memory: 512Mi
    limits:
      cpu: 500m
      memory: 512Mi

  secrets:
    # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
    # the value should be set according to your redis server configuration
    # it is only required when the ratelimit component is enabled
    - Secret: ratelimit-redis-auth
      Key: redis-pass
      Env: REDIS_AUTH
global:
  ratelimit:
    servertls:
      enabled: true
```
{% endtab %}

{% tab values-yaml global control plane %}
```yaml
kuma:
  controlPlane:
    mode: "global"

    tls:
      apiServer:
        # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
        # it contains the keys "tls.crt" and "tls.key", and the content items should be in "PEM" format:
        secretName: kong-mesh-apiserver-tls
      # todo: fix action
      kdsGlobalServer:
        # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
        # it contains the keys "ca.crt", "tls.crt" and "tls.key", and the content items should be in "PEM" format:
        secretName: kong-mesh-kds-tls

    apiServer:
      corsAllowedDomains:
      # change these values you want to access the control plane API server or Mesh GUI from a custom domain 
      - https://localhost:5682
      # if you want to access the API server using the HTTP port, add the following line
      # - http://localhost:5681

    defaults:
      # change these values you want to open the admin access rights of control plane API server to more groups
      adminRoleGroups:
      - mesh-system:admin
      - system:masters

    envVars:
      # if you want to access the API server using the HTTP port, change the following switch to "true" 
      KUMA_API_SERVER_HTTP_ENABLED: "false"

    secrets:
    # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
    # to obtain this license, please contact your Kong Account Manager and import it into your cluster:
    # kubectl create  -n kong-mesh-system secret generic kong-mesh-license --from-file license.json=$KMESH_LICENSE_FILE
    - Secret: kong-mesh-license
      Key: license.json
      Env: KMESH_LICENSE_INLINE
  
    # please tune the resource allocation according to your actual mesh size and traffic load after {{site.mesh_product_name}} is installed
    # try to make the resource limits identical to requests to make components are assigned as a QoS class of Guaranteed
    # More detail on sizing the CP: {{ site.links.web }}/mesh/{{ page.release }}/introduction/kuma-requirements/#sizing-your-control-plane
    resources:
      requests:
        cpu: 1000m
        memory: 1024Mi
      limits:
        cpu: 1000m
        memory: 1024Mi

    replicas: 2
    autoscaling:
      enabled: true

      metrics:
        - type: Resource
          resource:
            name: cpu
            target:
              type: Utilization
              averageUtilization: 50
        - type: Resource
          resource:
            name: memory
            target:
              type: Utilization
              averageUtilization: 50


    podDisruptionBudget:
      enabled: true
```
{% endtab %}

{% tab values-yaml federated zone control plane %}
```yaml
kuma:
  controlPlane:
    mode: "zone"
    # (action): please specify a name for the zone
    zone: 
    
    tls:
      apiServer:
        # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
        # it contains the keys "tls.crt" and "tls.key", and the content items should be in "PEM" format: 
        secretName: kong-mesh-apiserver-tls
        # todo: fix location!
        kdsZoneClient:
          # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
          # the certificate can be extracted from the trusted global CP server
          # it should contain the key "ca.crt", and the content certificate should be in "PEM" format
          secretName: kong-mesh-global-cp-kds-ca
          skipVerify: false

    apiServer:
      corsAllowedDomains:
        # change these values you want to access the control plane API server or Mesh GUI from a custom domain 
        - https://localhost:5682
        # if you want to access the API server using the HTTP port, add the following line
        # - http://localhost:5681

    defaults:
      # change these values you want to open the admin access rights of control plane API server to more groups
      adminRoleGroups:
        - mesh-system:admin
        - system:masters

    # (action): please specify the address of the global CP
    # e.g. grpcs://my-global-cp.my-hostname.com:5685
    kdsGlobalAddress: ""

    envVars:
      KMESH_MULTIZONE_GLOBAL_KDS_AUTH_TYPE: cpToken
      # if you want to access the API server using the HTTP port, change the following switch to "true" 
      KUMA_API_SERVER_HTTP_ENABLED: "false"

    secrets:
    # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
    # the CP token is only required when installing a zone CP that is connecting to a global CP
    # to obtain this CP token, please generate it using the `kumactl` connecting to the global CP
    # kumactl generate zone-token --zone <zone-name> --scope cp --valid-for 43920h > $TOKEN_FLIE
    # kubectl create  -n kong-mesh-system secret generic kong-mesh-global-cp-token --from-file token=$TOKEN_FLIE
    - Secret: kong-mesh-global-cp-token
      Key: token
      Env: KMESH_MULTIZONE_ZONE_KDS_AUTH_CP_TOKEN_INLINE
  
    # please tune the resource allocation according to your actual mesh size and traffic load after {{site.mesh_product_name}} is installed. 
    # try to make the resource limits identical to requests to make components are assigned as a QoS class of Guaranteed
    # More detail on sizing the CP: {{ site.links.web }}/mesh/{{ page.release }}/introduction/kuma-requirements/#sizing-your-control-plane
    resources:
      requests:
        cpu: 1000m
        memory: 1024Mi
      limits:
        cpu: 1000m
        memory: 1024Mi

    replicas: 2
    autoscaling:
      enabled: true

      metrics:
        - type: Resource
          resource:
            name: cpu
            target:
              type: Utilization
              averageUtilization: 50
        - type: Resource
          resource:
            name: memory
            target:
              type: Utilization
              averageUtilization: 50


    podDisruptionBudget:
      enabled: true

  cni:
    # -- Install Kuma with CNI instead of proxy init container
    enabled: false
    resources:
      requests:
        cpu: 100m
        memory: 100Mi
      limits:
        cpu: 100m
        memory: 100Mi

  ingress:
    # -- If true, it deploys Ingress for cross cluster communication
    enabled: false
    # please tune the resource allocation according to your actual mesh size and traffic load after {{site.mesh_product_name}} is installed. 
    # try to make the resource limits identical to requests to make components are assigned as a QoS class of Guaranteed
    resources:
      requests:
        cpu: 1000m
        memory: 1024Mi
      limits:
        cpu: 1000m
        memory: 1024Mi

    replicas: 2
    autoscaling:
      enabled: true
      metrics:
        - type: Resource
          resource:
            name: cpu
            target:
              type: Utilization
              averageUtilization: 50
        - type: Resource
          resource:
            name: memory
            target:
              type: Utilization
              averageUtilization: 50

    podDisruptionBudget:
      enabled: true

ratelimit:
  # -- Whether Ratelimit Service should be deployed
  enabled: false
  replicas: 2
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 5
    metrics:
      - type: Resource
        resource:
          name: cpu
          target:
            type: Utilization
            averageUtilization: 80

  # please tune the resource allocation according to your actual mesh size and traffic load after {{site.mesh_product_name}} is installed. 
  # try to make the resource limits identical to requests to make components are assigned as a QoS class of Guaranteed
  resources:
    requests:
      cpu: 500m
      memory: 512Mi
    limits:
      cpu: 500m
      memory: 512Mi

  secrets:
    # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
    # the value should be set according to your redis server configuration
    # it is only required when the ratelimit component is enabled
    - Secret: ratelimit-redis-auth
      Key: redis-pass
      Env: REDIS_AUTH
global:
  ratelimit:
    servertls:
      enabled: true
```
{% endtab %}
{% endtabs %}
{% endif_version %}


{% if_version lte:2.7.x %}
{% tabs values-yaml useUrlFragment=true %}
{% tab values-yaml single zone control plane %}
```yaml
kuma:
  controlPlane:
    mode: "zone"

    tls:
      apiServer:
        # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
        # it contains the keys "tls.crt" and "tls.key", and the content items should be in "PEM" format: 
        secretName: kong-mesh-apiserver-tls

    apiServer:
      corsAllowedDomains:
        # change these values you want to access the control plane API server or Mesh GUI from a custom domain
        - https://localhost:5682
        # if you want to access the API server using the HTTP port, add the following line
        # - http://localhost:5681

    envVars:
      # if you want to access the API server using the HTTP port, change the following switch to "true" 
      KUMA_API_SERVER_HTTP_ENABLED: "false"

    secrets:
      # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
      # to obtain this license, please contact your Kong Account Manager and import it into your cluster:
      # kubectl create  -n kong-mesh-system secret generic kong-mesh-license --from-file license.json=$KMESH_LICENSE_FILE
      - Secret: kong-mesh-license
        Key: license.json
        Env: KMESH_LICENSE_INLINE

    # please tune the resource allocation according to your actual mesh size and traffic load after {{site.mesh_product_name}} is installed. 
    # try to make the resource limits identical to requests to make components are assigned as a QoS class of Guaranteed
    # More detail on sizing the CP: {{ site.links.web }}/mesh/{{ page.release }}/introduction/kuma-requirements/#sizing-your-control-plane
    resources:
      requests:
        cpu: 1000m
        memory: 1024Mi
      limits:
        cpu: 1000m
        memory: 1024Mi

    replicas: 2
    autoscaling:
      enabled: true

      metrics:
        - type: Resource
          resource:
            name: cpu
            target:
              type: Utilization
              averageUtilization: 50
        - type: Resource
          resource:
            name: memory
            target:
              type: Utilization
              averageUtilization: 50


    podDisruptionBudget:
      enabled: true

  cni:
    # -- Install Kuma with CNI instead of proxy init container
    enabled: false
    resources:
      requests:
        cpu: 100m
        memory: 100Mi
      limits:
        cpu: 100m
        memory: 100Mi

ratelimit:
  # -- Whether Ratelimit Service should be deployed
  enabled: false
  replicas: 2
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 5
    metrics:
      - type: Resource
        resource:
          name: cpu
          target:
            type: Utilization
            averageUtilization: 80

  # please tune the resource allocation according to your actual mesh size and traffic load after {{site.mesh_product_name}} is installed. 
  # try to make the resource limits identical to requests to make components are assigned as a QoS class of Guaranteed
  resources:
    requests:
      cpu: 500m
      memory: 512Mi
    limits:
      cpu: 500m
      memory: 512Mi

  secrets:
    # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
    # the value should be set according to your redis server configuration
    # it is only required when the ratelimit component is enabled
    - Secret: ratelimit-redis-auth
      Key: redis-pass
      Env: REDIS_AUTH
global:
  ratelimit:
    servertls:
      enabled: true
```
{% endtab %}

{% tab values-yaml global control plane %}
```yaml
kuma:
  controlPlane:
    mode: "global"

    tls:
      apiServer:
        # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
        # it contains the keys "tls.crt" and "tls.key", and the content items should be in "PEM" format:
        secretName: kong-mesh-apiserver-tls
      # todo: fix action
      kdsGlobalServer:
        # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
        # it contains the keys "ca.crt", "tls.crt" and "tls.key", and the content items should be in "PEM" format:
        secretName: kong-mesh-kds-tls

    apiServer:
      corsAllowedDomains:
      # change these values you want to access the control plane API server or Mesh GUI from a custom domain 
      - https://localhost:5682
      # if you want to access the API server using the HTTP port, add the following line
      # - http://localhost:5681

    envVars:
      # if you want to access the API server using the HTTP port, change the following switch to "true" 
      KUMA_API_SERVER_HTTP_ENABLED: "false"

    secrets:
    # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
    # to obtain this license, please contact your Kong Account Manager and import it into your cluster:
    # kubectl create  -n kong-mesh-system secret generic kong-mesh-license --from-file license.json=$KMESH_LICENSE_FILE
    - Secret: kong-mesh-license
      Key: license.json
      Env: KMESH_LICENSE_INLINE
  
    # please tune the resource allocation according to your actual mesh size and traffic load after {{site.mesh_product_name}} is installed
    # try to make the resource limits identical to requests to make components are assigned as a QoS class of Guaranteed
    # More detail on sizing the CP: {{ site.links.web }}/mesh/{{ page.release }}/introduction/kuma-requirements/#sizing-your-control-plane
    resources:
      requests:
        cpu: 1000m
        memory: 1024Mi
      limits:
        cpu: 1000m
        memory: 1024Mi

    replicas: 2
    autoscaling:
      enabled: true

      metrics:
        - type: Resource
          resource:
            name: cpu
            target:
              type: Utilization
              averageUtilization: 50
        - type: Resource
          resource:
            name: memory
            target:
              type: Utilization
              averageUtilization: 50


    podDisruptionBudget:
      enabled: true
```
{% endtab %}

{% tab values-yaml federated zone control plane %}
```yaml
kuma:
  controlPlane:
    mode: "zone"
    # (action): please specify a name for the zone
    zone: 
    
    tls:
      apiServer:
        # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
        # it contains the keys "tls.crt" and "tls.key", and the content items should be in "PEM" format: 
        secretName: kong-mesh-apiserver-tls
        # todo: fix location!
        kdsZoneClient:
          # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
          # the certificate can be extracted from the trusted global CP server
          # it should contain the key "ca.crt", and the content certificate should be in "PEM" format
          secretName: kong-mesh-global-cp-kds-ca
          skipVerify: false

    apiServer:
      corsAllowedDomains:
        # change these values you want to access the control plane API server or Mesh GUI from a custom domain 
        - https://localhost:5682
        # if you want to access the API server using the HTTP port, add the following line
        # - http://localhost:5681

    # (action): please specify the address of the global CP
    # e.g. grpcs://my-global-cp.my-hostname.com:5685
    kdsGlobalAddress: ""

    envVars:
      KMESH_MULTIZONE_GLOBAL_KDS_AUTH_TYPE: cpToken
      # if you want to access the API server using the HTTP port, change the following switch to "true" 
      KUMA_API_SERVER_HTTP_ENABLED: "false"

    secrets:
    # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
    # the CP token is only required when installing a zone CP that is connecting to a global CP
    # to obtain this CP token, please generate it using the `kumactl` connecting to the global CP
    # kumactl generate zone-token --zone <zone-name> --scope cp --valid-for 43920h > $TOKEN_FLIE
    # kubectl create  -n kong-mesh-system secret generic kong-mesh-global-cp-token --from-file token=$TOKEN_FLIE
    - Secret: kong-mesh-global-cp-token
      Key: token
      Env: KMESH_MULTIZONE_ZONE_KDS_AUTH_CP_TOKEN_INLINE
  
    # please tune the resource allocation according to your actual mesh size and traffic load after {{site.mesh_product_name}} is installed. 
    # try to make the resource limits identical to requests to make components are assigned as a QoS class of Guaranteed
    # More detail on sizing the CP: {{ site.links.web }}/mesh/{{ page.release }}/introduction/kuma-requirements/#sizing-your-control-plane
    resources:
      requests:
        cpu: 1000m
        memory: 1024Mi
      limits:
        cpu: 1000m
        memory: 1024Mi

    replicas: 2
    autoscaling:
      enabled: true

      metrics:
        - type: Resource
          resource:
            name: cpu
            target:
              type: Utilization
              averageUtilization: 50
        - type: Resource
          resource:
            name: memory
            target:
              type: Utilization
              averageUtilization: 50


    podDisruptionBudget:
      enabled: true

  cni:
    # -- Install Kuma with CNI instead of proxy init container
    enabled: false
    resources:
      requests:
        cpu: 100m
        memory: 100Mi
      limits:
        cpu: 100m
        memory: 100Mi

  ingress:
    # -- If true, it deploys Ingress for cross cluster communication
    enabled: false
    # please tune the resource allocation according to your actual mesh size and traffic load after {{site.mesh_product_name}} is installed. 
    # try to make the resource limits identical to requests to make components are assigned as a QoS class of Guaranteed
    resources:
      requests:
        cpu: 1000m
        memory: 1024Mi
      limits:
        cpu: 1000m
        memory: 1024Mi

    replicas: 2
    autoscaling:
      enabled: true
      metrics:
        - type: Resource
          resource:
            name: cpu
            target:
              type: Utilization
              averageUtilization: 50
        - type: Resource
          resource:
            name: memory
            target:
              type: Utilization
              averageUtilization: 50

    podDisruptionBudget:
      enabled: true

ratelimit:
  # -- Whether Ratelimit Service should be deployed
  enabled: false
  replicas: 2
  autoscaling:
    enabled: true
    minReplicas: 2
    maxReplicas: 5
    metrics:
      - type: Resource
        resource:
          name: cpu
          target:
            type: Utilization
            averageUtilization: 80

  # please tune the resource allocation according to your actual mesh size and traffic load after {{site.mesh_product_name}} is installed. 
  # try to make the resource limits identical to requests to make components are assigned as a QoS class of Guaranteed
  resources:
    requests:
      cpu: 500m
      memory: 512Mi
    limits:
      cpu: 500m
      memory: 512Mi

  secrets:
    # (action): please prepare the content of this secret before installing {{site.mesh_product_name}}
    # the value should be set according to your redis server configuration
    # it is only required when the ratelimit component is enabled
    - Secret: ratelimit-redis-auth
      Key: redis-pass
      Env: REDIS_AUTH
global:
  ratelimit:
    servertls:
      enabled: true
```
{% endtab %}
{% endtabs %}
{% endif_version %}

