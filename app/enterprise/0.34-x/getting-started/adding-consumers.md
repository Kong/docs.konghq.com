---
title: Adding Consumers
---

## Introduction

In the last section, we learned how to add plugins to Kong Enterprise. 
In this section, we're going to learn how to add [Consumers][consumers] to 
Kong. Consumers are associated to individuals or applications using your 
API. As an entity, they can be used for tracking, access management, and more.

**Note:** This section assumes you have [enabled][enabling-plugins] the
[Basic Authentication][basic-auth] plugin. If you haven't, you can either
[enable the plugin][enabling-plugins] or skip steps two and three.

## 1. Create a Consumer

If you'd like to use the Admin API, issue the following cURL request to
create your first Consumer, named `Aladdin`:

```bash
$ curl -i -X POST \
  --url http://localhost:8001/consumers/ \
  --data "username=Aladdin"
```

You should see a response similar to the one below:

```http
HTTP/1.1 201 Created
Content-Type: application/json
Connection: keep-alive

{
  "username": "Aladdin",
  "created_at": 1428555626000,
  "id": "bbdf1c48-19dc-4ab7-cae0-ff4f59d87dc9"
}
```
Or, add your first Consumer via Kong Manager:

<video width="100%" autoplay loop controls>
  <source src="https://konghq.com/wp-content/uploads/2019/02/create-consumer-ent-34.mov" type="video/mp4">
  Your browser does not support the video tag.
</video>

Congratulations! You've just added your first Consumer to Kong.

**Note:** Kong also accepts a `custom_id` parameter when
[creating Consumers][API-consumers] to associate a Consumer with your existing 
user database.

## 2. Provision Credentials for Your Consumer

Now, we can create credentials for our recently created Consumer `Aladdin` by
issuing the following request:

```bash
$ curl -i -X POST \
  --url http://localhost:8001/consumers/Aladdin/basic-auth/ \
  --data "username=Aladdin" \
  --data "password=OpenSesame"
```

## 3. Verify Validity of Consumer Credentials 

The authorization header must be base64 encoded. For example, if the credential 
uses Aladdin as the username and OpenSesame as the password, then the field’s 
value is the base64-encoding of Aladdin:OpenSesame, or QWxhZGRpbjpPcGVuU2VzYW1l.

Then the Authorization (or Proxy-Authorization) header must appear as:

```
Authorization: Basic QWxhZGRpbjpPcGVuU2VzYW1l
```

To verify our new Consumer has access, make a request with the header:

```bash
$ curl http://kong:8000/{path matching a configured Route} \
    -H 'Authorization: Basic QWxhZGRpbjpPcGVuU2VzYW1l'
```

# Next Steps

Now that we've covered the basics of adding APIs, Consumers and enabling
Plugins, feel free to read more on Kong in one of the following documents:

- [Configuration Reference for Kong][configuration]
- [Configuration Property Reference for Kong Enterprise][enterprise-conf]
- [CLI Reference][CLI]
- [Proxy Reference][proxy]
- [Admin API Reference][API]
- [Clustering Reference][cluster]


[basic-auth]: /hub/kong-inc/basic-auth
[API-consumers]: /0.13.x/admin-api#create-consumer
[consumers]: /0.13.x/admin-api#consumer-object
[enabling-plugins]: /enterprise/{{page.kong_version}}/getting-started/enabling-plugins
[enterprise-conf]: /enterprise/{{page.kong_version}}/property-reference
[configuration]: /0.13.x/configuration
[CLI]: /0.13.x/cli
[proxy]: /0.13.x/proxy
[API]: /0.13.x/admin-api
[cluster]: /0.13.x/clustering
