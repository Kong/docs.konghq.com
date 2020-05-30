---
title: Control Kong Enterprise through systemd
---

### Introduction

This document includes instructions on how to integrate Kong Enterprise with systemd for Debian and RPM based packages. Note that some of the supported GNU/Linux distributions for Kong Enterprise may not have adopted systemd as their default init system (for example, CentOS 6 and RHEL 6). For the following instructions, it is assumed that Kong Enterprise has already been [installed and configured](https://docs.konghq.com/enterprise/latest/deployment/installation/overview/) on a systemd-supported GNU/Linux distribution.

## Start Kong Enterprise

```
$ sudo systemctl start kong-enterprise-edition
```

## Stop Kong Enterprise

```
$ sudo systemctl stop kong-enterprise-edition
```

## Start Kong Enterprise automatically at system boot

To enable Kong Enterprise to automatically start at system boot:

```
$ sudo systemctl enable kong-enterprise-edition
```

To disable Kong Enterprise from automatically starting at system boot:

```
$ sudo systemctl disable kong-enterprise-edition
```

## Restart Kong Enterprise

```
$ sudo systemctl restart kong-enterprise-edition
```

## Query Kong Enterprise status

```
$ sudo systemctl status kong-enterprise-edition
```

## Customize the Kong Enterprise unit file

Once the Kong Enterprise installation is finished, the official systemd service will be located at `/etc/kong/kong-enterprise-edition.service`. By default, this file will be copied to `/lib/systemd/system/kong-enterprise-edition.service`.

For scenarios where customizations are needed (for example, configuring Kong or modifying the service file behavior), we recommend creating another service at `/etc/systemd/system/kong-enterprise-edition.service` to avoid conflicts upon reinstalling or upgrading Kong Enterprise.

All environment variables prefixed with `KONG_` and capitalized will override the settings specified in the `/etc/kong/kong.conf.default` file. For example: `log_level = debug` in the .conf file translates to the `KONG_LOG_LEVEL=debug` environment variable.

There is also the possibility of opting to _not_ use environment variables in the service file but instead use a configuration file. In this case, modify the `ExecStartPre` systemd directive to execute `kong prepare` with the `-c` argument to point to your configuration file. For example, if you have a custom configuration file at `/etc/kong/kong.conf`, modify the `ExecStartPre` directive as follows:

```
ExecStartPre=/usr/local/bin/kong prepare -p /usr/local/kong -c /etc/kong/kong.conf
```

When linking non environment files using the `EnvironmentFile` systemd directive, note that the systemd parser will only recognize environment variables assignments. For example, if one of the Kong's default configuration files are linked (`/etc/kong/kong.conf.default` and `/etc/kong.conf`), non environment variables assignments in the file could lead to systemd errors. In this case, systemd will not allow the Kong service to be started. For this reason, we recommend specifying an `EnvironmentFile` other than the default ones:

```
EnvironmentFile=/etc/kong/kong_env.conf
```

### Logging to syslog and journald

In this case, adding the below `Environment` systemd directives to your customized systemd service file at `/etc/systemd/system/kong-enterprise-edition.service` will do it:

```
Environment=KONG_PROXY_ACCESS_LOG=syslog:server=unix:/dev/log
Environment=KONG_PROXY_ERROR_LOG=syslog:server=unix:/dev/log
Environment=KONG_ADMIN_ACCESS_LOG=syslog:server=unix:/dev/log
Environment=KONG_ADMIN_ERROR_LOG=syslog:server=unix:/dev/log
```

To view the journald logs:
   `journalctl -u kong-enterprise-edition`

To view the syslog logs:
   `tail -F /var/log/syslog`

### Customize Kong's Nginx instance [using the Nginx directive injection system](https://docs.konghq.com/latest/configuration/#injecting-individual-nginx-directives)

To use the injection system, add the below `Environment` systemd directive to your custom service at `/etc/systemd/system/kong-enterprise-edition.service` if environment variables are preferred. Note the quoting rules defined by systemd to specify an environment variable containing spaces:

```
Environment="KONG_NGINX_HTTP_OUTPUT_BUFFERS=4 64k"
```

### Customize Kong's Nginx instance [using `--nginx-conf`](https://docs.konghq.com/latest/configuration/#custom-nginx-templates)

To use the `--nginx-conf` argument, modify the `ExecStartPre` systemd directive to execute `kong prepare` with the `--nginx-conf` argument. For example, if you have a custom template at `/usr/local/kong/custom-nginx.template`, modify the `ExecStartPre` directive as follows:

```
ExecStartPre=/usr/local/bin/kong prepare -p /usr/local/kong --nginx-conf /usr/local/kong/custom-nginx.template
```

### Customize Kong's Nginx instance [including files via the injected Nginx directives](https://docs.konghq.com/1.0.x/configuration/#including-files-via-injected-nginx-directives)

To include files via the injected Nginx directives, add the below `Environment` systemd directive to your custom service at `/etc/systemd/system/kong-enterprise-edition.service` if environment variables are preferred:

```
Environment=KONG_NGINX_HTTP_INCLUDE=/path/to/your/my-server.kong.conf
```
