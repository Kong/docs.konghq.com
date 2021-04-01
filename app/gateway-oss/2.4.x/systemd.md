---
title: Control Kong through systemd
toc: false
---

### Introduction

This document includes instructions on how to integrate Kong with
[systemd](https://freedesktop.org/wiki/Software/systemd/) for
Debian and RPM based packages. Note that some of the supported GNU/Linux
distributions for Kong may not have adopted systemd as their default init
system (for example, CentOS 6 and RHEL 6). For the following instructions, it
is assumed that Kong has already been [installed and
configured](https://konghq.com/install/#kong-community) on a systemd-supported GNU/Linux
distribution.

## Start Kong

```
$ sudo systemctl start kong
```

## Stop Kong

```
$ sudo systemctl stop kong
```

## Start Kong automatically at system boot

To enable Kong to automatically start at system boot:

```
$ sudo systemctl enable kong
```

To disable Kong from automatically starting at system boot:

```
$ sudo systemctl disable kong
```

## Restart Kong

```
$ sudo systemctl restart kong
```

## Query Kong status

```
$ sudo systemctl status kong
```

## Customize the Kong unit file

The official systemd service is located at `/lib/systemd/system/kong.service`.
For scenarios where customizations are needed (for example, configuring Kong
or modifying the service file behavior), we recommend to create another
service at `/etc/systemd/system/kong.service` to avoid conflicts upon
reinstalling or upgrading Kong.

All environment variables prefixed with `KONG_` and capitalized will override
the settings specified in the `/etc/kong/kong.conf.default` file. For example:
`log_level = debug` in the .conf file translates to the `KONG_LOG_LEVEL=debug`
environment variable.

There is also the possibility of opting to _not_ use environment variables in
the service file but instead use a configuration file. In this case, modify
the `ExecStartPre` systemd directive to execute `kong prepare` with the `-c`
argument to point to your configuration file. For example, if you have a
custom configuration file at `/etc/kong/kong.conf`, modify the `ExecStartPre`
directive as follows:

```
ExecStartPre=/usr/local/bin/kong prepare -p /usr/local/kong -c /etc/kong/kong.conf
```

When linking non environment files using the `EnvironmentFile` systemd
directive, note that the systemd parser will only recognize environment
variables assignments. For example, if one of the Kong's default configuration
files are linked (`/etc/kong/kong.conf.default` and `/etc/kong.conf`), non
environment variables assignments in the file could lead to systemd errors. In
this case, systemd will not allow the Kong service to be started. For this
reason, we recommend specifying an `EnvironmentFile` other than the default
ones:

```
EnvironmentFile=/etc/kong/kong_env.conf
```

### Logging to syslog and journald

In this case, adding the below `Environment` systemd directives to your
customized systemd service file at `/etc/systemd/system/kong.service` will do
it:

```
Environment=KONG_PROXY_ACCESS_LOG=syslog:server=unix:/dev/log
Environment=KONG_PROXY_ERROR_LOG=syslog:server=unix:/dev/log
Environment=KONG_ADMIN_ACCESS_LOG=syslog:server=unix:/dev/log
Environment=KONG_ADMIN_ERROR_LOG=syslog:server=unix:/dev/log
```

To view the journald logs:
   `journalctl -u kong`

To view the syslog logs:
   `tail -F /var/log/syslog`

### Customize Kong's Nginx instance [using the Nginx directive injection system

To use the [Nginx directive injection system](/{{page.kong_version}}/configuration/#injecting-individual-nginx-directives),
add the below `Environment` systemd directive to your custom service at
`/etc/systemd/system/kong.service` if environment variables are preferred.
Note the quoting rules defined by systemd to specify an environment variable
containing spaces:

```
Environment="KONG_NGINX_HTTP_OUTPUT_BUFFERS=4 64k"
```

### Customize Kong's Nginx instance using `--nginx-conf`

To use the [`--nginx-conf` argument](/{{page.kong_version}}/configuration/#custom-nginx-templates),
modify the `ExecStartPre` systemd directive to execute `kong prepare` with the
`--nginx-conf` argument. For example, if you have a custom template at
`/usr/local/kong/custom-nginx.template`, modify the `ExecStartPre` directive
as follows:

```
ExecStartPre=/usr/local/bin/kong prepare -p /usr/local/kong --nginx-conf /usr/local/kong/custom-nginx.template
```

### Customize Kong's Nginx instance including files via the injected Nginx directives

To [include files via the injected Nginx
directives](/{{page.kong_version}}/configuration/#including-files-via-injected-nginx-directives),
add the below `Environment` systemd directive to your custom service at
`/etc/systemd/system/kong.service` if environment variables are preferred:

```
Environment=KONG_NGINX_HTTP_INCLUDE=/path/to/your/my-server.kong.conf
```

