---
title: File access and permissions
content_type: reference
---

This page describes the file access requirements for {{site.base_gateway}}.

### Users and groups

When a user installs a {{site.base_gateway}} official binary package, or uses the Docker image, Kong defaults to running under the `kong` user and group.

The following directories and files are installed by the binary and owned by the `kong` user and group:

- `/usr/local/kong/`: the default run-time data prefix directory for Kong
- `/usr/local/openresty/`: the OpenResty installation
- `/etc/kong/`: the default configuration directory

{:.note}
>**Note**: The `kong` shell is set to `/sbin/nologin`, this prevents using SSH to log in and execute commands.

### File read and write permissions

The following table contains {{site.base_gateway}} components and any additional file paths it accesses, in addition to the
standard system files that the `kong` user already has access to.

| Component | File path description | Read or Write |
| ------ | ----- | -- |
| `grpc-gateway` | The `.proto` file path configured in the plugin. | Read |
| `grpc-web`| The `.proto` file path configured in the plugin. <br> Dependent on proxy path traffic.| Write |
| Granular tracing| `tracing_write_endpoint`. <br> **Only if `tracing_write_strategy` is set to `file`**. <br> Dependent on proxy path traffic. | Write |
| Access logs and error logs| Under `prefix`, by default `/usr/local/kong/kogs`. <br> Dependent on proxy path traffic. | Write |
|Temporary data | Under `prefix`, by default `/user/local/kong`. <br> Includes cached configuration values and temporary body buffers.| Write |