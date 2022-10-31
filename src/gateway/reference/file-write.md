---
title: File permissions and access for Kong Gateway
---

As any other software does, {{site.base_gateway}} needs to access files to read and write data.
This page describes the file access requirements for {{site.base_gateway}}.

### The `kong` user

When user install the official binary package (e.g. RPM, DEB, etc.) or the Docker image,
Kong by default runs under the `kong` user and group.

The following directories and files are installed by the package and owned by `kong` user and group:

- `/usr/local/kong/`: the default run-time data ("prefix") directory for Kong
- `/usr/local/openresty/`: the OpenResty installation
- `/etc/kong/`: the default configuration directory

Note that since the `kong` user's shell is specified as `/sbin/nologin`, it cannot execute
commands in the context of SSH, since SSH invokes the user's shell to run commands.

### File write and read access

Following table shows the componenet and the file path it accesses, in addition to
standard system files and `kong` user already has access to.


| Component | File path | Read or Write | Description |
| --------- | --------- | ----------- |
| `grpc-gateway` and `grpc-web` plugins | The proto file paths configured in the plugin | Read |  |
| `file-log` plugin | The log file path configured in the plugin | Write | Dependent on proxy path traffic |
| Granular tracing | `tracing_write_endpoint` | Write | Only if `tracing_write_strategy` is set to `file` | Dependent on proxy path traffic |
| access logs and error logs | Under `prefix`; by default, `/usr/local/kong/logs/` | Write | Dependent on proxy path traffic |
| Temporary data | Under `prefix`; by default, `/usr/local/kong/` | Write | Including cached configuration values, temporary body buffers etc. |


---
