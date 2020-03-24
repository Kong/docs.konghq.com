---
title: Add a Consumer
---

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
