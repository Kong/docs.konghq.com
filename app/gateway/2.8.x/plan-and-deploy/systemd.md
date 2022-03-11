---
title: Control Kong Gateway through systemd
---

This document includes instructions on how to integrate {{site.base_gateway}}
with systemd for Debian and RPM based packages.

Note that some of the supported GNU/Linux distributions for {{site.base_gateway}}
may not have adopted systemd as their default init system
(for example, CentOS 6 and RHEL 6). For the following instructions, it is
assumed that {{site.base_gateway}} has already been
[installed and configured](/gateway/{{page.kong_version}}/install-and-run) on a
systemd-supported GNU/Linux distribution.

## systemd commands for working with {{site.base_gateway}}

### Start {{site.base_gateway}}

```bash
# For {{site.base_gateway}}
sudo systemctl start kong-enterprise-edition

# For {{site.ce_product_name}}
sudo systemctl start kong
```

### Stop {{site.base_gateway}}

```bash
# For {{site.base_gateway}}
sudo systemctl stop kong-enterprise-edition

# For {{site.ce_product_name}}
sudo systemctl stop kong
```

### Start {{site.base_gateway}} at system boot

**Enable starting {{site.base_gateway}} automatically at system boot**

```bash
# For {{site.base_gateway}}
sudo systemctl enable kong-enterprise-edition

# For {{site.ce_product_name}}
sudo systemctl enable kong
```

**Disable starting {{site.base_gateway}} automatically at system boot**

```bash
# For {{site.base_gateway}}
sudo systemctl disable kong-enterprise-edition

# For {{site.ce_product_name}}
sudo systemctl disable kong
```

### Restart {{site.base_gateway}}

```bash
# For {{site.base_gateway}}
sudo systemctl restart kong-enterprise-edition

# For {{site.ce_product_name}}
sudo systemctl restart kong
```

### Query {{site.base_gateway}} status

```bash
# For {{site.base_gateway}}
sudo systemctl status kong-enterprise-edition

# For {{site.ce_product_name}}
sudo systemctl status kong
```

## Customize the {{site.base_gateway}} unit file

The official systemd service is located at at `/lib/systemd/system/kong-enterprise-edition.service` for
{{site.base_gateway}}, or at `/lib/systemd/system/kong.service` for {{site.ce_product_name}}.

For scenarios where customizations are needed (for example, configuring Kong
or modifying the service file behavior), we recommend creating another service
at `/etc/systemd/system/kong-enterprise-edition.service` for
{{site.base_gateway}}, or at `/etc/systemd/system/kong.service` for
{{site.ce_product_name}}, to avoid conflicts upon reinstalling or upgrading Kong.

All environment variables prefixed with `KONG_` and capitalized will override the settings specified in the `/etc/kong/kong.conf.default` file. For example: `log_level = debug` in the .conf file translates to the `KONG_LOG_LEVEL=debug` environment variable.

You can also choose use a configuration file instead of environment variables. In this case, modify the `ExecStartPre` systemd directive to execute `kong prepare` with the `-c` argument to point to your configuration file. For example, if you have a custom configuration file at `/etc/kong/kong.conf`, modify the `ExecStartPre` directive as follows:

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

```bash
# For {{site.base_gateway}}
journalctl -u kong-enterprise-edition

# For {{site.ce_product_name}}
journalctl -u kong
```

To view the syslog logs:

```bash
tail -F /var/log/syslog
```

### Customize Kong's Nginx instance using the Nginx directive injection system

To use the [injection system](/gateway/{{page.kong_version}}/reference/configuration/#injecting-individual-nginx-directives) with environment variables, add the below `Environment` systemd directive to your custom service at `/etc/systemd/system/kong-enterprise-edition.service` ({{site.base_gateway}}) or `/etc/systemd/system/kong.service` ({{site.ce_product_name}}). Note the quoting rules defined by systemd to specify an environment variable containing spaces:

```
Environment="KONG_NGINX_HTTP_OUTPUT_BUFFERS=4 64k"
```

### Customize Kong's Nginx instance using &ndash;&ndash;nginx-conf

To use the [`--nginx-conf`](/gateway/{{page.kong_version}}/reference/configuration/#custom-nginx-templates) argument, modify the `ExecStartPre` systemd directive to execute `kong prepare` with the `--nginx-conf` argument. For example, if you have a custom template at `/usr/local/kong/custom-nginx.template`, modify the `ExecStartPre` directive as follows:

```
ExecStartPre=/usr/local/bin/kong prepare -p /usr/local/kong --nginx-conf /usr/local/kong/custom-nginx.template
```

### Customize Kong's Nginx instance including files via the injected Nginx directives

To [include files via the injected Nginx directives](/gateway/{{page.kong_version}}/reference/configuration/#including-files-via-injected-nginx-directives) with environment variables, add the below `Environment` systemd directive to your custom service at `/etc/systemd/system/kong-enterprise-edition.service` ({{site.base_gateway}}) or `/etc/systemd/system/kong.service` ({{site.ce_product_name}}):

```
Environment=KONG_NGINX_HTTP_INCLUDE=/path/to/your/my-server.kong.conf
```
