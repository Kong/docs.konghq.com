---
title: Plugins - Basic Authentication
show_faq: true
id: page-plugin
header_title: Basic Authentication
header_icon: /assets/images/icons/plugins/basic-authentication.png
header_caption: authentication
breadcrumbs:
  Plugins: /plugins
  Basic Authentication: /plugins/basic-authentication/
---

---

#### Add Basic Authentication to your APIs, with username and password protection.

---

## Installation

<!---
Make sure every Kong server in your cluster has the required dependency by executing:

```bash
$ kong install basicauth
```
-->

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml](/docs/{{site.latest}}/getting-started/configuration) configuration file

```yaml
plugins_available:
  - basicauth
```

Every node in the Kong cluster must have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API](/docs/{{site.latest}}/api/#api-object) (or [Consumer](/docs/{{site.latest}}/api/#consumer-object)) by executing the following request on your Kong server:

```bash
curl -d "name=basicauth&api_id=API_ID&value.hide_credentials=true" http://kong:8001/plugins_configurations/
```

| parameter                    | description                                                |
|------------------------------|------------------------------------------------------------|
| name                         | The name of the plugin to use, in this case: `basicauth`   |
| api_id                       | The API ID that this plugin configuration will target             |
| *consumer_id*             | Optionally the CONSUMER ID that this plugin configuration will target |
| `value.hide_credentials`           | Default `false`. An optional boolean value telling the plugin to hide the credential to the final API server. It will be removed by Kong before proxying the request |

## Usage

You can provision new username/password credentials by making the following HTTP request:

```bash
curl -d "username=user123&password=secret&consumer_id=CONSUMER_ID" http://kong:8001/basicauth_credentials/
```

| parameter                    | description                                                |
|------------------------------|------------------------------------------------------------|
| username                         | The username to use in the Basic Authentication   |
| password                       | The password to use in the Basic Authentication             |
| consumer_id             | The [Consumer](/docs/{{site.latest}}/api/#consumer-object) entity to associate the credentials to |

To create a [Consumer](/docs/{{site.latest}}/api/#consumer-object) you can execute the following request:

```bash
curl -d "username=user123&custom_id=SOME_CUSTOM_ID" http://kong:8001/basicauth_credentials/
```

| parameter                    | description                                                |
|------------------------------|------------------------------------------------------------|
| username                         | The username of the consumer   |
| custom_id                       | A custom ID that you can use to map the consumer to another database |

A [Consumer](/docs/{{site.latest}}/api/#consumer-object) can have many credentials.
