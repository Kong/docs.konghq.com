---
id: page-plugin
title: Plugins - Nginx Plus Live Monitoring
header_title: Nginx Plus Live Monitoring
header_icon: /assets/images/icons/plugins/nginx-plus-monitoring.png
breadcrumbs:
  Plugins: /plugins
---

Live server activity monitoring of NGINX Plus that provides key load and performance server metrics.

---

## Dependencies

This plugin requries some dependencies to work:

* [NGINX Plus][nginx-plus] with the [nginx-plus-extras][nginx-plus-extras] package installed.
* [LuaJIT 2.x][luajit] installed
* Enabling LuaJIT support by executing the following commands:

```bash
$ sudo mkdir -p /etc/nginx/ld-overrides
$ cp /usr/local/lib/libluajit-5.1.so /etc/nginx/ld-overrides/liblua5.1.so.0
$ sed -i '1 aexport LD_LIBRARY_PATH="/etc/nginx/ld-overrides"' /usr/local/bin/kong
```

Make sure to execute the above commands on every server in your cluster.

## Installation

To enable the plugin set the following configuration entry on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file

```yaml
nginx_plus_status: true
```

## Usage

To retrieve the stats, you can navigate to:

```bash
$ curl http://kong:8001/status/
```

[luajit]: http://luajit.org/
[nginx-plus]: http://nginx.com/products/
[nginx-plus-extras]: http://nginx.com/products/technical-specs/#nginx-plus-extras
[configuration]: /docs/{{site.data.kong_latest.version}}/configuration
