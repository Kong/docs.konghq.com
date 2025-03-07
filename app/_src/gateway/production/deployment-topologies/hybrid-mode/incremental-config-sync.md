---
title: Incremental Configuration Sync
---

In hybrid mode, whenever you make changes to {{site.base_gateway}} entity configuration on the Control Plane, it immediately triggers a cluster-wide update of all Data Plane configurations. 
In these updates, {{site.base_gateway}} sends the entire configuration set to the Data Planes - therefore, the bigger your configuration set is, the more time it takes to send and process, and the extra memory is consumed proportional to the configuration size.

You can enable **incremental configuration sync** to address this issue. 
When a configuration changes, instead of sending the entire configuration set for each change, {{site.base_gateway}} only sends the parts of the configuration that have changed. 

<!--vale off-->
{% mermaid %}
flowchart TD

A[Client]
B(<img src="/assets/images/logos/KogoBlue.svg" style="max-height:20px" class="no-image-expand"/> Kong Control Plane)
C(<img src="/assets/images/logos/KogoBlue.svg" style="max-height:20px" class="no-image-expand"/> Kong Data Plane)
D(<img src="/assets/images/logos/KogoBlue.svg" style="max-height:20px" class="no-image-expand"/> Kong Data Plane)
E[Client]
F(<img src="/assets/images/logos/KogoBlue.svg" style="max-height:20px" class="no-image-expand"/> Kong Control Plane)
G(<img src="/assets/images/logos/KogoBlue.svg" style="max-height:20px" class="no-image-expand"/> Kong Data Plane)
H(<img src="/assets/images/logos/KogoBlue.svg" style="max-height:20px" class="no-image-expand"/> Kong Data Plane)

 subgraph id1 [<b>With</b> incremental config sync]
 direction TB

 E --"POST Route config
 1 entity
 A few KB"---> F --"Route config
 1 entity
 A few KB"---> G & H
 end

 subgraph id2 [<b>Without</b> incremental config sync]
 direction TB

 A --"POST Route config
 1 entity
 A few KB"---> B --Route config
 30k entities
 30MB---> C & D

 end

style id1 stroke-dasharray:3,rx:10,ry:10
style id2 stroke-dasharray:3,rx:10,ry:10
linkStyle 0,1,2,3 stroke:#2e8e05,color:#2e8e05
linkStyle 4,5 stroke:#d44324,color:#d44324

{% endmermaid %}
<!--vale on-->
> _**Figure 1**: In an environment with 30k entities of about 30MB total, sending a POST request to update one entity sends the whole 30MB config to every data plane. With incremental config enabled, that same POST request only triggers an update of a few KB._

Incremental config sync achieves significant memory savings and CPU savings. 
This means lower total cost of ownership for {{site.base_gateway}} users, shorter config propagation delay, and less impact to proxy latency. 
See our [blog on incremental config sync](https://konghq.com/blog/product-releases/incremental-config-sync-tech-preview) for the performance comparisons.

## Enable incremental config sync

You can enable incremental config sync when installing {{site.base_gateway}} in [hybrid mode](/gateway/{{page.release}}/production/deployment-topologies/hybrid-mode/setup/), or when setting up a {{site.konnect_short_name}} Data Plane.

During setup, set the following values in your `kong.conf` files on both Control Planes and Data Planes:

```
cluster_rpc = on
cluster_rpc_sync = on
```

Or, if running {{site.base_gateway}} in Docker, set the following environment variables:
```
export KONG_CLUSTER_RPC_SYNC=on
export KONG_CLUSTER_RPC=on
```

## Using incremental config sync with custom plugins

When incremental config sync is enabled, the configuration change notification from the Control Plane only triggers an event for changed entities, and doesn't trigger cache updates in Data Plane nodes. 
This causes outdated and inconsistent configuration for custom plugins.

If you are running {{site.base_gateway}} on {{site.konnect_short_name}} or in hybrid mode, you need to adjust your custom plugins to be compatible with incremental config sync.

### Workaround for custom plugins

To ensure your custom plugin configuration is kept up to date, you must add additional code logic to register the CRUD events for the entities the plugin cares about, and invalidate the relevant cache data.

Add the code at the end of the `init_worker` function for the custom plugin.
For example:


```lua
function _M.init_worker()
  -- ...
  -- ... your original custom code
  -- add the example code below AFTER any custom plugin code
 
  -- Check if worker_events can be registed successfully
  if not (kong.worker_events and kong.worker_events.register) then
    return
  end

  -- Check the deployment mode and incremental sync feature is enabled
  if kong.configuration.database == "off" and not kong.sync then
    return
  end
  
  -- Do the event registration and force invalidate the corresponding cache
  kong.worker_events.register(
    function(data)
    -- logic to identify what cache need to be invalidated
    kong.cache:invalidate(CACHE_KEY) -- Your plugin logic to invalidate the cache
  end, "crud", "ENTITY_NAME") -- Register the events for entity the plugin cares
  
  -- Repeat the register events for other ENTITIES
  
end
```

## Using incremental config sync with rate limiting plugins

We don't recommend using the `local` strategy for rate limiting plugins with incremental config sync.

When load balancing across multiple Data Plane nodes, rate limiting is enforced per node, and it can leading to inconsistencies and potential resets when updates occur.
With the `local` strategy, these plugins may have inconsistencies in sync behavior during rapid configuration updates, impacting performance for API traffic control. 


