---
title: "nginx.conf"
type: reference
purpose: |
  How do I use a custom nginx.conf file?
---

To load a custom nginx template `nginx_kong.lua` to some path inside a container:
1. Save the template in a ConfigMap or a Secret.
1. Mount the template into the container.

   ```bash
   deployment:
  userDefinedVolumes:
  - name: custom-template
    configMap:
      name: custom-template
      items:
      - key: "nginx_kong.lua"
        path: "nginx_kong.lua"
  userDefinedVolumeMounts:
  - mountPath: "/var/kong" # the template where you want to put
    name:custom-template
    readOnly: true
    subPath: "nginx_kong.lua"
   ```