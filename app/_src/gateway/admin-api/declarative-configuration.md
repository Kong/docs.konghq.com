---
title: Declarative Configuration
no_version: true
---


## Declarative Configuration


Loading the declarative configuration of entities into {{site.base_gateway}}
can be done in two ways: at start-up, through the `declarative_config`
property, or at run-time, through the Admin API using the `/config`
endpoint.

To get started using declarative configuration, you need a file
(in YAML or JSON format) containing entity definitions. You can
generate a sample declarative configuration with the command:

```
kong config init
```

It generates a file named `kong.yml` in the current directory,
containing the appropriate structure and examples.


### Reload Declarative Configuration

This endpoint allows resetting a DB-less Kong with a new
declarative configuration data file. All previous contents
are erased from memory, and the entities specified in the
given file take their place.

To learn more about the file format, see the
[declarative configuration](/gateway/{{page.release}}/production/deployment-topologies/db-less-and-declarative-config) documentation.

<div class="endpoint post indent">/config</div>

{:.indent}
Attributes | Description
---:| ---
`config`<br>**required** | The config data (in YAML or JSON format) to be loaded.


#### Request Querystring Parameters

Attributes | Description
---:| ---
`check_hash`<br>*optional* | If set to 1, Kong will compare the hash of the input config data against that of the previous one. If the configuration is identical, it will not reload it and will return HTTP 304.


#### Response

```
HTTP 200 OK
```

``` json
{
    {
        "services": [],
        "routes": []
    }
}
```

The response contains a list of all the entities that were parsed from the
input file.

---