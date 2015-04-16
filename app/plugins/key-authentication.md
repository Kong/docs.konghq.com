---
layout: plugin
title: Plugins - Key Authentication
header_title: Key Authentication
header_icon: /assets/images/icons/plugins/key-authentication.png
---

Add query authentication like API-Keys to your APIs, either in a header, in querystring parameter, or in a form parameter.

---

## Installation

<!---
Make sure every Kong server in your cluster has the required dependency by executing:

```bash
$ kong install keyauth
```
-->

Add the plugin to the list of available plugins on every Kong server in your cluster by editing the [kong.yml](/docs/{{site.data.kong_latest}}/getting-started/configuration) configuration file

```yaml
plugins_available:
  - keyauth
```

Every node in the Kong cluster should have the same `plugins_available` property value.

## Configuration

Configuring the plugin is straightforward, you can add it on top of an [API](/docs/{{site.data.kong_latest}}/api/#api-object) (or [Consumer](/docs/{{site.data.kong_latest}}/api/#consumer-object)) by executing the following request on your Kong server:

```bash
curl -d "name=keyauth&api_id=API_ID&value.key_names=key_name1,key_name2" http://kong:8001/plugins_configurations/
```

| parameter                    | description                                                |
|------------------------------|------------------------------------------------------------|
| name                         | The name of the plugin to use, in this case: `keyauth`   |
| api_id                       | The API ID that this plugin configuration will target             |
| *consumer_id*             | Optionally the CONSUMER ID that this plugin configuration will target |
| `value.key_names`                  | Describes an array of comma separated parameter names where the plugin will look for a valid credential. The client must send the authentication key in one of those key names, and the plugin will try to read the credential from a header, the querystring, a form parameter (in this order). For example: *apikey*  |
| `value.hide_credentials`           | Default `false`. An optional boolean value telling the plugin to hide the credential to the final API server. It will be removed by Kong before proxying the request |

## Usage

### Create a Consumer

You need to associate a credential to an existing [Consumer](/docs/{{site.data.kong_latest}}/api/#consumer-object) object, that represents a user consuming the API. To create a [Consumer](/docs/{{site.data.kong_latest}}/api/#consumer-object) you can execute the following request:

```bash
curl -d "username=user123&custom_id=SOME_CUSTOM_ID" http://kong:8001/consumers/
```

| parameter                    | description                                                |
|------------------------------|------------------------------------------------------------|
| username                         | The username of the consumer   |
| custom_id                       | A custom ID that you can use to map the consumer to another database |

A [Consumer](/docs/{{site.data.kong_latest}}/api/#consumer-object) can have many credentials.

### Create a Key Authentication credential

Then you can finally provision new key credentials by making the following HTTP request:

```bash
curl -d "key=some_key&consumer_id=CONSUMER_ID" http://kong:8001/keyauth_credentials/
```

| parameter                    | description                                                |
|------------------------------|------------------------------------------------------------|
| key                         | The key to use to authenticate the consumer.   |
| consumer_id             | The [Consumer](/docs/{{site.data.kong_latest}}/api/#consumer-object) entity to associate the credentials to |
