---
title: Hybrid mode communication spec
---

WebSocket communication is a fundamental aspect of hybrid mode in {{site.base_gateway}}, enabling real-time data exchange between the control plane (CP) and the data plane (DP). In hybrid mode the DP initiates the connection and establishes a WebSocket channel with the CP. This doc will explain the process of establishing connections, data exchange, config management, and communication protocols between DP and CP nodes within the context of hybrid mode. 

## Establishing connections

In Hybrid mode, a connection is always initiated by the data plane. At startup, the DP attempts to establish a mTLS connection with the control plane. If the connection with the CP can't be established, the DP retries the connection at random intervals of between 5-10 seconds. This is done to avoid introducing load spikes to the CP.

The connection with CP is always mTLS protected. Validation of both parties certificate is mandatory and can not be disabled in config. 


## Data exchange

As soon as a mTLS connection is established, the DP will immediately send information to the CP in a WebSocket frame:

* The randomly generated Node ID of DP (sent as query argument `node_id`)`.
* The DP’s hostname (sent as query argument `node_hostname`).
* The DP’s {{site.base_gateway}} version (sent as query argument `node_version`).
* The DP’s enabled plugin set and their version (sent as part of the initial WebSocket frame).
* The IP address of the DP.

This is an example of a WebSocket frame: 

```
{
  "type": "basic_info",
  "plugins": [
    { "name": "acl", "version": "1.2.3" },
    { "name": "basic-auth", "version": "4.5.6" },
    etc...
  ]
}
```

The CP uses the information exchanged in the WebSocket frame for two purposes: 

1. To determine if the DP’s version is compatible with the CP’s version. 
1. To log the DP's information in the database. 

If the CP determines that the DP is using a compatible version of {{site.base_gateway}}, it will immediately export the current configuration and push it to the DP. This ensures that newly connected DPs always receive the latest configs on start-up. If the DP's version is not compatible with the CP's version a sync will not be allowed. 


## Configuration management

When a Kong admin makes a change to the Kong database entity, hybrid mode notices such change and builds a new config. The config is then pushed to all DPs that are currently connected in a WebSocket frame with the following format: 

```
{ "type": "reconfigure",
  "config_table": {
    "_format_version": "1.1",
    "consumers": [
      {
        "username": "user",
        "tags": [
          "internal-user"
        ],
        "plugins": [
          {
            "name": "rate-limiting",
            "enabled": true,
            "protocols": [
              "http",
              "https"
            ]
          }
        ]
      }
    ]
  }
}
```


All frames transferred from the CP to the DP are Gziped before being sent over WebSocket. This reduces the size of the payload significantly since Kong configs are highly compressible.

### Sensitive data management 

Because the CP node dumps the entire database config and send it to the DP, the following data may be included: 

* Private key of TLS certificate for proxied domains.
* IP address, port, client certificates, private keys and any other information used to access upstream services.
* Consumer information including emails, authentication plugin credentials like an API Key for the key-auth plugin.
* Unique ID for identifying the hybrid mode cluster. This is generated once and shared by every CP and DP within the same cluster. This ID is used for anonymous reporting and if anonymous reporting is not disabled.

The DP nodes also store the latest received configuration data on the filesystem in order to survive CP failures or streamline DP startup.

## Heartbeat and version reporting

The CP needs to know what the config version of each DP that is running in order to know if the DP is up to date, or if a config has failed. The config version is reported in the WebSocket Ping frame that the DP generates every 30 seconds. If a new config was pushed and applied successfully, then a Ping frame is generated immediately by the DP in order to report the version change to the CP. The Ping frame is also used to keep the TCP connection open so that configs can be pushed immediately. 


## FAQ

### How long can a disconnected DP continue working without impact to operations? 

Indefinitely. Because DP nodes cache the last known config from the CP, they will continue to function with that config indefinitely, even after restarts. However, there are exceptions that are worth noting. 

1. If the EE license expires the DP may stop working. 
2. If the config cache on the DP node is deleted, then the next time it restarts the DP will not have any configuration applied to it. 
3. Provisioning a new DP is not possible if the CP is down. However, the user could choose to use the `KONG_DECLARATIVE_CONFIG` option to load a fallback YAML config if the hybrid mode cache is unavailable. 

### Can a disconnected DP be restarted and still reconfigure itself based on the previous snapshot? 

Yes. 


### Can the DP configuration change in disconnected mode?

The DP config can be changed by one of these methods.

1. Copying a hybrid mode cache file from another DP node that contains the desired config and overwriting the config on the node. 
2. Remove the hybrid mode cache file then start the DP node with the `KONG_DECLARATIVE_CONFIG` option to load a fallback YAML config. As soon as the CP becomes available, the config cache will be updated and the DP will use the CP's config. 