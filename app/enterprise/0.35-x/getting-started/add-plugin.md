
## 1. Configure the Basic Auth Plugin for your API

Issue the following cURL request on the previously created API named
`example-api`:

```bash
$ curl -i -X POST \
  --url http://localhost:8001/apis/example-api/plugins/ \
  --data 'name=basic-auth'
  --data "config.hide_credentials=true"
```

Or, add your first plugin via Kong Manager on the "Plugins" page:

<video width="100%" autoplay loop controls>
 <source src="https://konghq.com/wp-content/uploads/2019/02/add-basic-auth-ent-34.mov" type="video/mp4">
 Your browser does not support the video tag.
</video>


## 2. Verify that the Plugin is Properly Configured

Issue the following cURL request to verify that the [basic-auth][basic-auth]
plugin was properly configured on the API:

```bash
$ curl -i -X GET \
  --url http://localhost:8000/ \
  --header 'Host: example.com'
```

Since you did not specify the required header or parameter, the response should 
be `401 Unauthorized`:

```http
HTTP/1.1 401 Unauthorized
...

{
  "message": "No API key found in request"
}
```