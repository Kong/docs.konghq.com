---
title: Use a custom nginx.conf file
type: reference
purpose: |
  How do I use a custom nginx.conf file?
---

You can specify a custom `nginx.conf` file by creating a `ConfigMap` or `Secret` and mounting it inside your container that contains an `nginx_kong.lua` template.

The `deployment.userDefinedVolumes` field in `values.yaml` takes an array of objects that get appended as-is to the existing `spec.template.spec.volumes` array in the {{ site.base_gateway }} deployment resource. The `deployment.userDefinedVolumeMounts` field is appended as-is to the existing `spec.template.spec.containers[].volumeMounts` and `spec.template.spec.initContainers[].volumeMounts` arrays.

The volumes to mount are provided under the `deployment` key in your Helm `values.yaml` file. The structure of the configuration matches the Kubernetes [ConfigMapVolumeSource](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.26/#configmapvolumesource-v1-core) or [SecretVolumeSource](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.26/#secretvolumesource-v1-core) structure.

## Create a ConfigMap

```bash
kubectl create configmap custom-template --from-file=nginx_kong.lua=./nginx_kong.lua -n kong
```

## Mount the ConfigMap

```bash
gateway:
  deployment:
    userDefinedVolumes:
      - name: custom-template
        configMap:
          name: custom-template
          items:
            - key: "nginx_kong.lua"
              path: "nginx_kong.lua"
    userDefinedVolumeMounts:
      - name: custom-template
        subPath: "nginx_kong.lua"
        mountPath: "/usr/local/share/lua/5.1/kong/templates/nginx_kong.lua"
        readOnly: true
```

## Validate your configuration

To ensure that your changes are working, you can `cat` the nginx file inside the container.

```bash
kubectl exec -n kong kong-gateway-POD_NAME -c proxy -- cat /usr/local/share/lua/5.1/kong/templates/nginx_kong.lua
```

The output should show the custom configuration file that you placed inside the `ConfigMap`.