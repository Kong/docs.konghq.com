## Installation

To use the AppDynamics plugin in {{site.base_gateway}}, the AppDynamics C/C++
SDK must be installed on all nodes running {{site.base_gateway}}. Due to licensing restrictions, the SDK is
not distributed with {{site.base_gateway}}. AppDynamics
must be downloaded from the
[AppDynamics Download Portal](https://accounts.appdynamics.com/downloads).
The `libappdynamics.so` shared
library file is the only required file, it must be placed in one of the locations configured by
the
[system's shared library loader](https://tldp.org/HOWTO/Program-Library-HOWTO/shared-libraries.html).
Alternatively, the `LD_LIBRARY_PATH` environment variable can be set
to the directory containing the `libappdynamics.so` file when
starting {{site.base_gateway}}.

If the AppDynamics plugin is enabled but the `libappdynamics.so` file cannot be loaded, {{site.base_gateway}} will refuse to start.
You will receive an error message like this:

```
kong/plugins/app-dynamics/appdynamics.lua:74: libappdynamics.so: cannot open shared object file: No such file or directory
```

## Configuration

The AppDynamics plugin is configured through environment variables
that need to be set when {{site.base_gateway}} is started. The environment
variables used by the plugin are shown in the table below.

{:.note}
> If an environment variable listed in the table does not have a `default` value, you must set the value for that variable, or the plugin may not operate correctly.

The AppDynamics plugin makes use of the AppDynamics C/C++ SDK to send
information to the AppDynamics controller. Refer to the
[AppDynamics C/C++ SDK documentation](https://docs.appdynamics.com/appd/21.x/21.12/en/application-monitoring/install-app-server-agents/c-c++-sdk/use-the-c-c++-sdk)
for more information about the configuration parameters.

### Environment variables

| Variable | Description | Type | Default |
|--|--|--|--|
| `KONG_APPD_CONTROLLER_HOST` | Hostname of the AppDynamics controller. | String | |
| `KONG_APPD_CONTROLLER_PORT` | Port number to use to communicate with the controller. | Integer | `443` |
| `KONG_APPD_CONTROLLER_ACCOUNT` | Account name to use with controller. | String | |
| `KONG_APPD_CONTROLLER_ACCESS_KEY` | Access key to use with the AppDynamics controller. | String |
| `KONG_APPD_LOGGING_LEVEL` | Logging level of the AppDynamics SDK agent. | Integer | `2` |
| `KONG_APPD_LOGGING_LOG_DIR` | Directory into which agent log files are written. | String | `/tmp/appd` |
| `KONG_APPD_TIER_NAME` | Tier name to use for business transactions. | String | |
| `KONG_APPD_APP_NAME` | Application name to report to AppDynamics. | String | `Kong` |
| `KONG_APPD_NODE_NAME` | Node name to report to AppDynamics. This value defaults to the system's hostname.| String | `hostname` |
| `KONG_APPD_INIT_TIMEOUT_MS` | Maximum time to wait for a controller connection when starting, in milliseconds. | Integer | `5000` |
| `KONG_APPD_CONTROLLER_USE_SSL` | Use SSL encryption in controller communication. `true`, `on`, or `1` are all interpreted as `True`, any other value is considered `false`.| Boolean | `on` |
| `KONG_APPD_CONTROLLER_HTTP_PROXY_HOST` | Hostname of proxy to use to communicate with controller. | String |  |
| `KONG_APPD_CONTROLLER_HTTP_PROXY_PORT` | Port number of controller proxy. | Integer |  |
| `KONG_APPD_CONTROLLER_HTTP_PROXY_USERNAME` | Username to use to identify to proxy. This value is a string that is never shown in logs. This value can be specified as a vault reference.| String |  |
| `KONG_APPD_CONTROLLER_HTTP_PROXY_PASSWORD` | Password to use to identify to proxy. This value is a string that is never shown in logs. This value can be specified as a vault reference.| String |  |

#### Possible values for the `KONG_APPD_LOGGING_LEVEL` parameter

The `KONG_APPD_LOGGING_LEVEL` environment variable is a numeric value that controls the desired logging level.
Each value corresponds to a specific level:

| Value | Name | Description |
|--|--|--|
| 0 | `TRACE` | Reports finer-grained informational events than the debug level that may be useful to debug an application. |
| 1 | `DEBUG` | Reports fine-grained informational events that may be useful to debug an application. |
| 2 | `INFO` | Default log level. Reports informational messages that highlight the progress of the application at coarse-grained level.|
| 3 | `WARN` | Reports on potentially harmful situations. |
| 4 | `ERROR` | Reports on error events that may allow the application to continue running.|
| 5 | `FATAL` | Fatal errors that prevent the agent from operating. |

## Agent logging

The AppDynamics agent sorts log information into separate, independent of Kong, log files.
By default, log files are written to the `/tmp/appd` directory.
This location can be changed by setting the `KONG_APPD_LOGGING_LOG_DIR` environment variable.

If problems occur with the AppDynamics integration, inspect the AppDynamics agent's log files in addition to the Kong
Gateway logs.

## AppDynamics node name considerations

The AppDynamics plugin defaults the `KONG_APPD_NODE_NAME` to the local
host name, which typically reflects the container ID of the containerized
application. Multiple instances of the AppDynamics agent must use
different node names, and one agent must exists for each of {{site.base_gateway}}'s
worker processes, the node name is suffixed by the worker ID. This
results in multiple nodes being created for each {{site.base_gateway}}
instance, one for each worker process.
