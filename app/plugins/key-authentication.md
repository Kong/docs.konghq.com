---
id: page-plugin
title: Plugins - Key Authentication
header_title: Key Authentication
header_icon: /assets/images/icons/plugins/key-authentication.png
breadcrumbs:
  Plugins: /plugins
---

Add query authentication like API-Keys to your APIs, either in a header, in querystring parameter, or in a form parameter.

---

## Installation

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml][configuration] configuration file

```yaml
plugins_available:
  - keyauth
```

Every node in the Kong cluster should have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API][api-object] (or [Consumer][consumer-object]) by executing the following request on your Kong server:

```bash
$ curl -X POST http://kong:8001/plugins_configurations/ \
    --data "name=keyauth" \
    --data "api_id=API_ID" \
    --data "value.key_names=key_name1,key_name2"
```

parameter                               | description
 ---                                    | ---
`name`                                  | The name of the plugin to use, in this case: `keyauth`
`api_id`                                | The API ID that this plugin configuration will target
`consumer_id`<br>*optional*             | The CONSUMER ID that this plugin configuration will target
`value.key_names`                       | Describes an array of comma separated parameter names where the plugin will look for a valid credential. The client must send the authentication key in one of those key names, and the plugin will try to read the credential from a header, the querystring, a form parameter (in this order). For example: `apikey`
`value.hide_credentials`<br>*optional*  | Default `false`. An optional boolean value telling the plugin to hide the credential to the final API server. It will be removed by Kong before proxying the request

## Usage

### Create a Consumer

You need to associate a credential to an existing [Consumer][consumer-object] object, that represents a user consuming the API. To create a [Consumer][consumer-object] you can execute the following request:

```bash
$ curl -X POST http://kong:8001/consumers/ \
    --data "username=user123" \
    --data "custom_id=SOME_CUSTOM_ID"
```

parameter                       | description
 ---                            | ---
`username`<br>*semi-optional*   | The username of the consumer. Either this field or `custom_id` must be specified.
`custom_id`<br>*semi-optional*  | A custom identifier used to map the consumer to another database. Either this field or `username` must be specified.

A [Consumer][consumer-object] can have many credentials.

### Create a Key Authentication credential

Then you can finally provision new key credentials by making the following HTTP request:

```bash
$ curl -X POST http://kong:8001/keyauth_credentials/ \
    --data "key=some_key" \
    --data "consumer_id=CONSUMER_ID"
```

parameter               | description
 ---                    | ---
`key`                   | The key to use to authenticate the consumer.
`consumer_id`           | The [Consumer][consumer] entity to associate the credentials to.

[api-object]: /docs/{{site.data.kong_latest.version}}/admin-api/#api-object
[configuration]: /docs/{{site.data.kong_latest.version}}/configuration
[consumer-object]: /docs/{{site.data.kong_latest.version}}/admin-api/#consumer-object
