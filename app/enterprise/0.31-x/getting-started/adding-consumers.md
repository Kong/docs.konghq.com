---
title: Adding Consumers
---

## Introduction

In the last section, we learned how to add plugins to Kong Enterprise Edition
(EE) - in this section
we're going to learn how to add [Consumers][consumers] to Kong. Consumers are
associated to individuals or applications using your API, and can be used
for tracking, access management, and more.

**Note:** This section assumes you have [enabled][enabling-plugins] the
[key-auth][key-auth] plugin. If you haven't, you can either
[enable the plugin][enabling-plugins] or skip steps two and three.

## 1. Create a Consumer

If you'd like to use the Admin API, issue the following cURL request to
create your first Consumer, named `Jason`:

```bash
$ curl -i -X POST \
  --url http://localhost:8001/consumers/ \
  --data "username=Jason"
```

You should see a response similar to the one below:

```http
HTTP/1.1 201 Created
Content-Type: application/json
Connection: keep-alive

{
  "username": "Jason",
  "created_at": 1428555626000,
  "id": "bbdf1c48-19dc-4ab7-cae0-ff4f59d87dc9"
}
```
Or, add your first Consumer via the Admin GUI:

<video width="100%" autoplay loop controls>
  <source src="https://konghq.com/wp-content/uploads/2018/03/add-consumer-ee0.31.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

Congratulations! You've just added your first Consumer to Kong.

**Note:** Kong also accepts a `custom_id` parameter when
[creating Consumers][API-consumers] to associate a Consumer with your existing user
database.

## 2. Provision key credentials for your Consumer

Now, we can create a key for our recently created Consumer `Jason` by
issuing the following request:

```bash
$ curl -i -X POST \
  --url http://localhost:8001/consumers/Jason/key-auth/ \
  --data 'key=ENTER_KEY_HERE'
```

## 3. Verify that your Consumer credentials are valid

We can now issue the following request to verify that the credentials of
our `Jason` Consumer is valid:

```bash
$ curl -i -X GET \
  --url http://localhost:8000 \
  --header "Host: example.com" \
  --header "apikey: ENTER_KEY_HERE"
```

# Next Steps

Now that we've covered the basics of adding APIs, Consumers and enabling
Plugins, feel free to read more on Kong in one of the following documents:

- [Configuration file Reference][configuration]
- [CLI Reference][CLI]
- [Proxy Reference][proxy]
- [Admin API Reference][API]
- [Clustering Reference][cluster]


[key-auth]: /plugins/key-authentication
[API-consumers]: /0.12.x/admin-api#create-consumer
[consumers]: /0.12.x/admin-api#consumer-object
[enabling-plugins]: /enterprise/{{page.kong_version}}/getting-started/enabling-plugins
[configuration]: /0.12.x/configuration
[CLI]: /0.12.x/cli
[proxy]: /0.12.x/proxy
[API]: /0.12.x/admin-api
[cluster]: /0.12.x/clustering
