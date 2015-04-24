---
sitemap: true
id: page-plugin
title: Plugins - Nginx Plus Live Monitoring
header_title: Nginx Plus Live Monitoring
header_icon: /assets/images/icons/plugins/nginx-plus-monitoring.png
header_btn_text: Report Bug
header_btn_href: https://github.com/Mashape/kong/issues/new
header_btn_target: _blank
breadcrumbs:
  Plugins: /plugins
---

Live server activity monitoring of NGINX Plus that provides key load and performance server metrics

---

## Dependencies

This plugin requries some dependencies to work:

* [NGINX Plus](http://nginx.com/products/) with the [nginx-plus-extras](http://nginx.com/products/technical-specs/#nginx-plus-extras) package installed.
* [LuaJIT 2.x](http://luajit.org/) installed
* Enabling LuaJIT support by executing the following commands:

```bash
sudo mkdir -p /etc/nginx/ld-overrides
cp /usr/local/lib/libluajit-5.1.so /etc/nginx/ld-overrides/liblua5.1.so.0
sed -i '1 aexport LD_LIBRARY_PATH="/etc/nginx/ld-overrides"' /usr/local/bin/kong
```

Make sure to execute the above commands on every server in your cluster.

## Installation

To enable the plugin set the following configuration entry on every Kong server in your cluster by editing the [kong.yml](/docs/{{site.latest}}/getting-started/configuration) configuration file

```yaml
# Nginx Plus Status
nginx_plus_status: true
```

## Usage

To retrieve the stats, you can navigate to:

```
curl http://kong:8001/status/
```