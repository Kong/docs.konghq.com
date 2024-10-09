---
title: Kong Custom plugin distribution
---



{{ site.kgo_product_name }} can install Kong custom plugins packaged as container images. This guide shows how to install and use a custom plugin in {{site.base_gateway}} instances managed by the {{ site.kgo_product_name }}.

{% include md/kgo/prerequisites.md version=page.version release=page.release kongplugininstallation=true %}

## Create and package a custom plugin

1. Create a directory with test plugin code.

   {:.note}
   > If you already have a real plugin, you can skip this step.

    ```bash
    $ mkdir myheader
    $ echo 'local MyHeader = {}

    MyHeader.PRIORITY = 1000
    MyHeader.VERSION = "1.0.0"

    function MyHeader:header_filter(conf)
      -- do custom logic here
      kong.response.set_header("myheader", conf.header_value)
    end

    return MyHeader
    ' > myheader/handler.lua

    $ echo 'return {
      name = "myheader",
      fields = {
        { config = {
            type = "record",
            fields = {
              { header_value = { type = "string", default = "roar", }, },
            },
        }, },
      }
    }
    ' > myheader/schema.lua
    ```

   After your plugin code available in a directory, the directory should look like this:

    ```bash
    $ tree myheader
    myheader
    ├── handler.lua
    └── schema.lua

    0 directories, 2 files
    ```

2. Build container image with the plugin code.

It is expected to have plugin related files in the root of the image. Thus for aforementioned plugin, the Dockerfile would look like this:

```Dockerfile
FROM scratch

COPY myheader /
```

where `myheader` is a directory that contains `handler.lua` and `schema.lua`.

Build the image:

```bash
docker build -t myheader:1.0.0 .
```

next push it to a registry that is available to the Kubernetes cluster where {{ site.kgo_product_name }} is running.
