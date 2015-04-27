---
sitemap: true
id: page-plugin
title: Plugins - Basic Authentication
header_title: Basic Authentication
header_icon: /assets/images/icons/plugins/basic-authentication.png
header_btn_text: Report Bug
header_btn_href: https://github.com/Mashape/kong/issues/new
header_btn_target: _blank
breadcrumbs:
  Plugins: /plugins
---

Add Basic Authentication to your APIs, with username and password protection.

---

## Installation

<!---
Make sure every Kong server in your cluster has the required dependency by executing:

```bash
$ kong install basicauth
```
-->

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml](/docs/{{site.data.kong_latest.version}}/getting-started/configuration) configuration file

```yaml
plugins_available:
  - basicauth
```

Every node in the Kong cluster must have the same `plugins_available` property value.

---

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API](/docs/{{site.data.kong_latest.version}}/api/#api-object) (or [Consumer](/docs/{{site.data.kong_latest.version}}/api/#consumer-object)) by executing the following request on your Kong server:

```bash
curl -d "name=basicauth&api_id=API_ID&value.hide_credentials=true" http://kong:8001/plugins_configurations/
```

parameter                    | description
 ---                         | ---
`name`                       | The name of the plugin to use, in this case: `basicauth`
`api_id`                     | The API ID that this plugin configuration will target
`consumer_id`<br>*optional*  | The CONSUMER ID that this plugin configuration will target
`value.hide_credentials`     | Default `false`. An optional boolean value telling the plugin to hide the credential to the final API server. It will be removed by Kong before proxying the request

---

## Usage

### Create a Consumer

You need to associate a credential to an existing [Consumer](/docs/{{site.data.kong_latest.version}}/api/#consumer-object) object, that represents a user consuming the API. To create a [Consumer](/docs/{{site.data.kong_latest.version}}/api/#consumer-object) you can execute the following request:

```bash
curl -d "username=user123&custom_id=SOME_CUSTOM_ID" http://kong:8001/consumers/
```

parameter                       | description
 ---                            | ---
`username`<br>*semi-optional*   | The username of the consumer. Either this field or `custom_id` must be specified.
`custom_id`<br>*semi-optional*  | A custom identifier used to map the consumer to another database. Either this field or `username` must be specified.

A [Consumer](/docs/{{site.data.kong_latest.version}}/api/#consumer-object) can have many credentials.

### Create a Basic Authentication credential

You can provision new username/password credentials by making the following HTTP request:

```bash
curl -d "username=user123&password=secret&consumer_id=CONSUMER_ID" http://kong:8001/basicauth_credentials/
```

parameter                  | description
 ---                       | ---
`username`                 | The username to use in the Basic Authentication
`password`                 | The password to use in the Basic Authentication
`consumer_id`              | The [Consumer](/docs/{{site.data.kong_latest.version}}/api/#consumer-object) entity to associate the credentials to
