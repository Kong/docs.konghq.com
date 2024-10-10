<!-- Shared between KIC and KGO plugin installation -->
## Create a custom plugin

{:.note}
> To learn in details about plugin development for {{site.base_gateway}}, see the [Plugin Development](/gateway/{{page.release}}/plugin-development) guide.

1. Create a directory with plugin code.

   {:.note}
   > If you already have a real plugin, you can skip this step.

    ```bash
    mkdir myheader
    echo 'local MyHeader = {}

    MyHeader.PRIORITY = 1000
    MyHeader.VERSION = "1.0.0"

    function MyHeader:header_filter(conf)
      -- do custom logic here
      kong.response.set_header("myheader", conf.header_value)
    end

    return MyHeader
    ' > myheader/handler.lua

    echo 'return {
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

   After these steps, the directory should look like this:

    ```bash
    tree myheader
    ```

    ```bash
    myheader
    ├── handler.lua
    └── schema.lua

    0 directories, 2 files
    ```
