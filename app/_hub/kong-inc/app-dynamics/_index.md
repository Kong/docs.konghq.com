---
name: AppDynamics
publisher: Kong Inc.
version: 3.1.0
desc: Integrate Kong with the AppDynamics APM Platform
description: |
  Report requests proxied by Kong to the AppDynamics APM Platform.
enterprise: true
type: plugin
categories:
  - analytics-monitoring
kong_version_compatibility:
  community_edition:
    compatible: null
  enterprise_edition:
    compatible: true
params:
  name: app-dynamics
  service_id: true
  route_id: true
  consumer_id: true
  konnect_examples: false
  protocols:
    - http
    - https
  dbless_compatible: 'yes'

---

# Kong Plugin for AppDynamics

This plugin integrates Kong with the AppDynamics APM platform so that
proxy requests handled by Kong can be identified and analyzed in
AppDynamics.  The plugin reports request and response timestamps as
well as error information to the AppDynamics platform so that they can
be analyzed in the AppDynamics flow map and correlated with other
systems participating in handling application API requests.

The plugin utilizes the
[AppDynamics C/C++ Application Agent and SDK](https://docs.appdynamics.com/pages/viewpage.action?pageId=42583435),
which must be downloaded and installed on the machine or in the
container that is running Kong Gateway.  Please refer to the
AppDynamics SDK web page for platform support information.

# Installation

To use the AppDynamics plugin in Kong Gateway, the AppDynamics C/C++
SDK must be installed on all nodes running Kong Gateway.  The SDK is
not distributed with Kong Gateway due to licensing restrictions.  It
must be downloaded from the
[AppDynamics Download Portal](https://accounts.appdynamics.com/downloads).
The only file needed by the plugin is the **libappdynamics.so** shared
library file.  It must be placed in one of the locations configured by
the
[system's shared library loader](https://tldp.org/HOWTO/Program-Library-HOWTO/shared-libraries.html).
Alternatively, the **LD_LIBRARY_PATH** environment variable can be set
to the directory containing the **libappdynamics.so** file when
starting Kong Gateway.

If the AppDynamics plugin is enabled in the configuration, Kong
Gateway will refuse to start if the **libappdynamics.so** file cannot
be loaded.  The error message will be similar to this:

```kong/plugins/app-dynamics/appdynamics.lua:74: libappdynamics.so: cannot open shared object file: No such file or directory```

# Configuration

The AppDynamics plugin is configured through environment variables
that need to be set when Kong Gateway is started.  The environment
variables used by the plugin are shown in the table below.  Note that
if an environment variable has no default, it must be set for the
plugin to operate correctly.

The AppDynamics plugin makes use of the AppDynamics C/C++ SDK to send
information to the AppDynamics controller.  Please refer to the
[AppDynamics C/C++ SDK documentation](https://docs.appdynamics.com/appd/21.x/21.12/en/application-monitoring/install-app-server-agents/c-c++-sdk/use-the-c-c++-sdk)
to get further information on the configuration parameters.

## Environment variables

| Name | Description | Type | Default |
|--|--|--|--|
| KONG_APPD_CONTROLLER_HOST | Hostname of the AppDynamics controller | String | |
| KONG_APPD_CONTROLLER_PORT | Port number to use to communicate with controller | NUMBER | 443 |
| KONG_APPD_CONTROLLER_ACCOUNT | Account name to use on controller | String | |
| KONG_APPD_CONTROLLER_ACCESS_KEY | Access key to use on the AppDynamics controller | String |
| KONG_APPD_LOGGING_LEVEL | Logging level of the AppDynamics SDK Agent | NUMBER | 2 |
| KONG_APPD_LOGGING_LOG_DIR | Directory into which agent log files are written | STRING | "/tmp/appd" |
| KONG_APPD_TIER_NAME | Tier name to use in business transactions | String | |
| KONG_APPD_APP_NAME | Application name to report to AppDynamics | STRING | "Kong" |
| KONG_APPD_NODE_NAME | Node name to report to AppDynamics | STRING | System hostname |
| KONG_APPD_INIT_TIMEOUT_MS | Maximum time to wait for a controller connection when starting | NUMBER | 5000 |
| KONG_APPD_CONTROLLER_USE_SSL | Use SSL encryption in controller communication | BOOLEAN | "on" |
| KONG_APPD_CONTROLLER_HTTP_PROXY_HOST | Hostname of proxy to use to communicate with controller | STRING | "" |
| KONG_APPD_CONTROLLER_HTTP_PROXY_PORT | Port number of controller proxy | NUMBER | 0 |
| KONG_APPD_CONTROLLER_HTTP_PROXY_USERNAME | Username to use to identify to proxy | SECRET_STRING | "" |
| KONG_APPD_CONTROLLER_HTTP_PROXY_PASSWORD | Password to use to identify to proxy | SECRET_STRING | "" |

### Possible values for the `KONG_APPD_LOGGING_LEVEL` parameter

The `KONG_APPD_LOGGING_LEVEL` environment variable can be set to
define the minimum log level.  It needs to be specified as a numeric
value with the following meanings:

| Value | Name | Description |
|--|--|--|
| 0 | TRACE | Detailed trace-level information |
| 1 | DEBUG | Debugging messages |
| 2 | INFO | Informational messages (low volume) |
| 3 | WARN | Warnings that permit the agent to operate, but should be looked into |
| 4 | ERROR | Errors, could indicate data loss |
| 5 | FATAL | Fatal errors that prevent the agent from operating |

# Agent logging

The AppDynamics agent logs information into separate log files that it
manages on its own and that are independent of the logs of Kong
Gateway.  By default, log files are written to the `/tmp/appd`
directory.  This location can be changed according to local policies
by setting the `KONG_APPD_LOGGING_LOG_DIR` environment variable.

When problems occur with the AppDynamics integration, make sure that
you inspect the AppDynamics agent's log files in addition to the Kong
Gateway logs.

# AppDynamics node name considerations

The AppDynamics plugin defaults the `KONG_APPD_NODE_NAME` to the local
host name, which typically reflects the container ID in containerized
applications.  As multiple instances of the AppDynamics agent must use
different node names and one agent exists for each of Kong Gateway's
worker processes, the node name is suffixed by the worker ID.  This
results in multiple nodes to be created for each Kong Gateway
instance, one for each worker process.
