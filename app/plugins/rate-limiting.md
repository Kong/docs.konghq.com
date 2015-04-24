---
sitemap: true
id: page-plugin
title: Plugins - Rate Limiting
header_title: Rate Limiting
header_icon: /assets/images/icons/plugins/rate-limiting.png
header_btn_text: Report Bug
header_btn_href: mailto:support@mashape.com?subject={{ page.header_title }} Plugin Bug
breadcrumbs:
  Plugins: /plugins
---

Rate limit how many HTTP requests a developer can make in a given period of seconds, minutes, hours, days months or years. If the API has no authentication layer, the **Client IP** address will be used, otherwise the consume will be used if an authentication plugin has been configured.

---

## Installation

<!---
Make sure every Kong server in your cluster has the required dependency by executing:

```bash
$ kong install ratelimiting
```
-->

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml](/docs/{{site.data.kong_latest}}/getting-started/configuration) configuration file

```yaml
plugins_available:
  - ratelimiting
```

Every node in the Kong cluster should have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API](/docs/{{site.data.kong_latest}}/api/#api-object) (or [Consumer](/docs/{{site.data.kong_latest}}/api/#consumer-object)) by executing the following request on your Kong server:

```bash
curl -d "name=ratelimiting&api_id=API_ID&value.limit=1000&value.period=hour" http://kong:8001/plugins_configurations/
```

parameter                               | description
 ---                                    | ---
`name`                                  | The name of the plugin to use, in this case: `ratelimiting`
`api_id`                                | The API ID that this plugin configuration will target
`consumer_id`<br>*optional*             | The CONSUMER ID that this plugin configuration will target
`value.limit`                           | The amount of HTTP requests the developer can make in the given period of time
`value.period`                          | Can be one between: `second`, `minute`, `hour`, `day`, `month`, `year`
