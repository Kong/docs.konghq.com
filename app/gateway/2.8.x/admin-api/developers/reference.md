---
title: Developers Reference
badge: enterprise
---

{:.note}
> **Note:** The `/developers` API is part of the Kong Admin API, and is meant
for bulk developer administration.
This is not the same as the Dev Portal API [`/developer`](/gateway/{{page.kong_version}}/developer-portal/portal-api/#/operations/get-developer) endpoints,
which return data on the logged-in developer.

## Developers

### List all developers

**Endpoint**

<div class="endpoint get">/developers</div>

**Response**

```
HTTP/1.1 200 OK
```

```json
{
    "data": [
        {
            "consumer": {
                "id": "3f0ad41f-39b5-4fd0-ad1e-0b779fcee35c"
            },
            "created_at": 1644615612,
            "email": "some-email@example.com",
            "id": "3c6d4d8c-db86-4236-800b-8911e788425b",
            "meta": "{\"full_name\":\"Barry\"}",
            "roles": [
                "application developer"
            ],
            "status": 0,
            "updated_at": 1644615612
        },
        {
            "consumer": {
                "id": "9dbd764c-9548-4c9f-a4d1-6ea11e32a803"
            },
            "created_at": 1644615583,
            "email": "some-other-email@example.com",
            "id": "5f60930a-ad12-4303-ac5a-59d121ad4942",
            "meta": "{\"full_name\":\"Diana\"}",
            "roles": [
                "application developer"
            ],
            "status": 0,
            "updated_at": 1644615583
        }
    ],
    "next": null,
    "total": 2
}
```

---

### Create a developer account

**Endpoint**

<div class="endpoint post">/developers</div>

**Request body**

Attribute                     | Description
---------:                    | --------   
`meta`                        | Metadata for the account in JSON format. Accepts fields defined in the Dev Portal settings. <br><br> By default, the meta attribute requires a `full_name` field. You can remove this requirement, or add other fields as neccessary. <br><br> For example: `meta: {"full_name":"<NAME>"}`.
`email` <br>*required*        | The email of the developer to create. This becomes their login username.
`password`<br>*semi-optional* | Create a password for the developer. Required if basic authentication is enabled.
`key` <br>*semi-optional*     | Assign an API key to the developer. Required is key authentication is enabled.
`id`                          | A consumer UUID to associate this developer account with. [TO DO: figure out what this actually does.]

Example request:

```sh
http POST :8001/developers \
  email=example@example.com \
  meta="{\"full_name\":\"Wally\"}" \
  password=mypass \
  id=62d17e63-0628-43a3-b936-97b8dcbd366f
```

**Response**

```
HTTP/1.1 200 OK
```

```json
{
    "consumer": {
        "id": "62d17e63-0628-43a3-b936-97b8dcbd366f"
    },
    "created_at": 1644616521,
    "email": "example@example.com",
    "id": "a82f9477-1a24-45b9-827c-23f1c1a7ebb3",
    "meta": "{\"full_name\":\"Wally\"}",
    "status": 0,
    "updated_at": 1644616521
}
```

---

### Invite a developer

**Endpoint**

<div class="endpoint post">/developers/invite</div>

**Request body**

Attribute                     | Description
---------:                    | --------   
`emails`                      | A comma-separated array of emails. SMTP must be enabled to send invite emails.

Example request:
```sh
http POST :8001/developers/invite emails:='["example@example.com", "example2@example.com"]'
```

**Response**

```
HTTP/1.1 200 OK
```

```json
{
    "error": {
        "count": 0,
        "emails": {}
    },
    "sent": {
        "count": 2,
        "emails": {
            "example@example.com": true,
            "example2@example.com": true
        }
    },
    "smtp_mock": true
}
```

---

### Inspect a developer

**Endpoint**

<div class="endpoint get">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}</div>


Attribute                     | Description
---------:                    | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of the developer you want to inspect.


**Response**

```
HTTP/1.1 200 OK
```

```json
{
    "consumer": {
        "id": "855fe098-3bb3-4041-8a3d-149a9e5462c6"
    },
    "created_at": 1644617754,
    "email": "example@example.com",
    "id": "f94e4fbd-c30b-41d7-b349-13c8f4fc23ca",
    "rbac_user": {
        "id": "7d40540b-4b65-4fa6-b04e-ffe6c2c40b0d"
    },
    "roles": [
        "QA"
    ],
    "status": 0,
    "updated_at": 1644619493
}
```

---

### Inspect a developer's consumer object

[TO DO: What exactly is the purpose of this consumer? Is it an internal mapping? It doesn't appear in lists of consumers anywhere]

**Endpoint**

<div class="endpoint get">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/consumer</div>


Attribute                     | Description
---------:                    | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of the developer you want to inspect.


**Response**

```
HTTP/1.1 200 OK
```

```json
{
    "created_at": 1644616521,
    "custom_id": null,
    "id": "62d17e63-0628-43a3-b936-97b8dcbd366f",
    "tags": null,
    "type": 1,
    "username": "example@example.com",
    "username_lower": "example@example.com"
}
```

---

### Update a developer

**Endpoint**

<div class="endpoint patch">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}</div>

Attribute                     | Description
---------:                    | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of the developer you want to update.


**Request Body**

Attribute                     | Description
---------:                    | --------   
`meta`                        | Metadata for the account in JSON format. Accepts fields defined in the Dev Portal settings. <br><br> By default, the meta attribute requires a `full_name` field. You can remove this requirement, or add other fields as neccessary. <br><br> For example: `meta: {"full_name":"<NAME>"}`.
`email`       | The email of the developer to create. This becomes their login username.


**Response**

```
HTTP/1.1 200 OK
```

```json
{
    "developer": {
        "consumer": {
            "id": "855fe098-3bb3-4041-8a3d-149a9e5462c6"
        },
        "created_at": 1644617754,
        "email": "example@example.com",
        "id": "f94e4fbd-c30b-41d7-b349-13c8f4fc23ca",
        "rbac_user": {
            "id": "7d40540b-4b65-4fa6-b04e-ffe6c2c40b0d"
        },
        "roles": [
            "QA"
        ],
        "status": 0,
        "updated_at": 1644621148
    }
}
```

---

### Delete a developer

**Endpoint**

<div class="endpoint delete">/developers/{DEVELOPER_ID}</div>

Attribute                     | Description
---------:                    | --------   
`{DEVELOPER_ID}`  | The UUID of the developer you want to delete.

**Response**

```
HTTP/1.1 204 No Content
```

## Export developer metadata

Export a list of developers and their metadata into a CSV file.

Creates a file named `developers.csv` in the present working directory.

<div class="endpoint get">/developers/export</div>

**Response**

```
HTTP/1.1 200 OK
```

```json
something
```

## Roles

### List all Dev Portal roles

**Endpoint**

<div class="endpoint get">/developers/roles</div>

**Response**

```
HTTP/1.1 200 OK
```

```json
{
    "data": [
        {
            "created_at": 1644615388,
            "id": "525694de-776c-43ad-a940-769295d0c54e",
            "name": "Application Developer"
        },
        {
            "created_at": 1644619493,
            "id": "c8535760-e37f-4578-921f-04e781a3f8f1",
            "name": "QA"
        }
    ],
    "next": null,
    "total": 2
}
```

### Create a Dev Portal role

When you create a role, by default, the role has access to all content in Dev Portal.

**Endpoint**

<div class="endpoint post">/developers/roles</div>

**Request body**

Attribute                   | Description
---------:                  | --------   
`name` <br>*required*       | A name for the role.
`comment`                   | A description of the role.
`permissions`               | [_Note: I couldn't figure out how to make this work_] Permissions to assign to the role, in JSON format. If you don't provide any specific permissions, the role has access to all applications and specs by default. <br><br> Example: `permissions={"specs/petstore.yaml"}`

**Response**

```
HTTP/1.1 201 Created
```

```json
{
    "comment": "Billing services team",
    "created_at": 1644620475,
    "id": "b7794758-394e-46f1-a9a1-f495f2e97a68",
    "name": "Billing",
    "permissions": {}
}
```

### Inspect a role

**Endpoint**

<div class="endpoint get">/developers/roles/{ROLE_NAME|ROLE_ID}</div>

Attribute                   | Description
---------:                  | --------   
`{ROLE_NAME|ROLE_ID}` <br>*required*       | The name or UUID of the role you are inspecting.

**Response**

```
HTTP/1.1 200 OK
```

```json
{
    "comment": "Billing services team",
    "created_at": 1644620475,
    "id": "b7794758-394e-46f1-a9a1-f495f2e97a68",
    "name": "Billing",
    "permissions": {}
}
```


### Update a role

**Endpoint**

<div class="endpoint patch">/developers/roles/{ROLE_NAME|ROLE_ID}</div>

Attribute                   | Description
---------:                  | --------   
`{ROLE_NAME|ROLE_ID}` <br>*required*       | The name or UUID of the role you are inspecting.

**Request body**

Attribute                   | Description
---------:                  | --------   
`name`                      | A name for the role.
`comment`                   | A description of the role.

**Response**

```
HTTP/1.1 200 OK
```

```json
{
    "comment": "Billing services team",
    "created_at": 1644620475,
    "id": "b7794758-394e-46f1-a9a1-f495f2e97a68",
    "name": "Billing",
    "permissions": {}
}
```



### Delete a role

**Endpoint**

<div class="endpoint delete">/developers/roles/{ROLE_NAME|ROLE_ID}</div>

Attribute                   | Description
---------:                  | --------   
`{ROLE_NAME|ROLE_ID}` <br>*required*       | The name or UUID of the role you are inspecting.

**Response**

```
HTTP/1.1 204 No Content
```


## Applications

### List all applications for a developer

**Endpoint**

<div class="endpoint get">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/applications</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.


**Response**
```
HTTP/1.1 200 OK
```

```json
{
    "data": [
        {
            "consumer": {
                "id": "6e31bf1e-dbcb-4a31-bac9-a192fa24f088"
            },
            "created_at": 1644963627,
            "developer": {
                "id": "5f60930a-ad12-4303-ac5a-59d121ad4942"
            },
            "id": "5ff48aaf-3951-4c99-a636-3b682081705c",
            "name": "example_app",
            "redirect_uri": "http://mockbin.org",
            "updated_at": 1644963627
        },
        {
            "consumer": {
                "id": "2390fd02-bbcd-48f1-b32f-89c262fa68a8"
            },
            "created_at": 1644963657,
            "developer": {
                "id": "5f60930a-ad12-4303-ac5a-59d121ad4942"
            },
            "id": "94e0f633-e8fd-4647-a0cd-4c3015ff2722",
            "name": "example_app2",
            "redirect_uri": "http://mockbin.org",
            "updated_at": 1644963657
        }
    ],
    "next": null,
    "total": 2
}

```

### Inspect an application

**Endpoint**

<div class="endpoint get">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/applications/{APPLICATION_ID}</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{APPLICATION_ID}`  | The application UUID.

**Response**
```
HTTP/1.1 200 OK
```

```json
{
    "consumer": {
        "id": "d5ea9628-f359-4b96-9f76-61562aaf4300"
    },
    "created_at": 1644965555,
    "custom_id": "billing",
    "developer": {
        "id": "5f60930a-ad12-4303-ac5a-59d121ad4942"
    },
    "id": "ca0d62bd-4616-4b87-b947-43e33e5418f0",
    "name": "testapp",
    "redirect_uri": "http://mockbin.org",
    "updated_at": 1644965555
}
```


### Create an application

**Endpoint**

<div class="endpoint post">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/applications</div>


Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.

**Request body**

Attribute                    | Description
---------:                   | --------   
`name`<br>*required*         | A name for the application.
`redirect_uri`<br>*required* | The application's URI.
`custom_id`                  | A custom description for the application. <br>*Not actually sure what this does*
`developer` | *Can't tell what this does, kind of looks like it didn't do anything; probably don't want to document?*

**Response**

```
HTTP/1.1 201 Created
```

```json
{
    "consumer": {
        "id": "d5ea9628-f359-4b96-9f76-61562aaf4300"
    },
    "created_at": 1644965555,
    "custom_id": "billing-app",
    "developer": {
        "id": "5f60930a-ad12-4303-ac5a-59d121ad4942"
    },
    "id": "ca0d62bd-4616-4b87-b947-43e33e5418f0",
    "name": "testapp",
    "redirect_uri": "http://mockbin.org",
    "updated_at": 1644965555
}
```


### Update an application

**Endpoint**

<div class="endpoint patch">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/applications/{APPLICATION_ID}</div>


Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{APPLICATION_ID}`  | The application UUID.

**Request body**

Attribute                    | Description
---------:                   | --------   
`name`                       | A name for the application.
`redirect_uri`               | The application's URI.
`custom_id`                  | A custom description for the application. <br>*Not actually sure what this does*

### Delete an application

**Endpoint**
<div class="endpoint delete">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/applications/{APPLICATION_ID}</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{APPLICATION_ID}`  | The application UUID.

**Response**

```
HTTP/1.1 204 No Content
```

### View all instances of an application

View all application instances that are connected to a Service in the Kong Gateway.


**Endpoint**

<div class="endpoint get">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/applications/{APPLICATION_ID}/application_instances</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{APPLICATION_ID}`  | The application UUID.

**Response**
```
HTTP/1.1 200 OK
```

```json
{
    "data": [
        {
            "application": {
                "consumer": {
                    "id": "a4e8f835-e5bb-498c-8b6a-73a21c82776d"
                },
                "created_at": 1644965487,
                "developer": {
                    "consumer": {
                        "id": "9dbd764c-9548-4c9f-a4d1-6ea11e32a803"
                    },
                    "created_at": 1644615583,
                    "email": "example@example.com",
                    "id": "5f60930a-ad12-4303-ac5a-59d121ad4942",
                    "meta": "{\"full_name\":\"Wally\"}",
                    "rbac_user": {
                        "id": "431cae60-5d60-40be-8636-1b349a70a88d"
                    },
                    "status": 0,
                    "updated_at": 1644615874
                },
                "id": "645682ae-0be6-420a-bcf3-0e711a391546",
                "name": "testapp",
                "redirect_uri": "http://mockbin.org",
                "updated_at": 1644965487
            },
            "composite_id": "645682ae-0be6-420a-bcf3-0e711a391546_212a758a-810b-4226-9175-b1b44eecebec",
            "created_at": 1644968368,
            "id": "13fdfd32-8412-4479-b04f-a83d155e5de5",
            "service": {
                "id": "212a758a-810b-4226-9175-b1b44eecebec"
            },
            "status": 0,
            "suspended": false,
            "updated_at": 1644968411
        }
    ],
    "next": null,
    "total": 1
}

```

### Create an application instance

Connect an application to a Service in the Kong Gateway.

**Endpoint**

<div class="endpoint post">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/applications/{APPLICATION_ID}/application_instances</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{APPLICATION_ID}`  | The application UUID.

**Request body**

Attribute                    | Description
---------:                   | --------   
`service.id` | The UUID of the service to connect the application to.

**Response**

```
HTTP/1.1 201 Created
```

```json
something
```

### Inspect an application instance

Get information about a specific instance of an application.

**Endpoint**

<div class="endpoint get">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/applications/{APPLICATION_ID}/application_instances/{APPLICATION_INSTANCE_ID}</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{APPLICATION_ID}`  | The application UUID.
`{APPLICATION_INSTANCE_ID}`  | The application instance UUID.

**Response**

```
HTTP/1.1 200 OK
```

```json
{
    "application": {
        "id": "645682ae-0be6-420a-bcf3-0e711a391546"
    },
    "composite_id": "645682ae-0be6-420a-bcf3-0e711a391546_212a758a-810b-4226-9175-b1b44eecebec",
    "created_at": 1644968368,
    "id": "13fdfd32-8412-4479-b04f-a83d155e5de5",
    "service": {
        "id": "212a758a-810b-4226-9175-b1b44eecebec"
    },
    "status": 0,
    "suspended": false,
    "updated_at": 1644968411
}
```


### Update an application instance

**Endpoint**

<div class="endpoint patch">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/applications/{APPLICATION_ID}/application_instances/{APPLICATION_INSTANCE_ID}</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{APPLICATION_ID}`  | The application UUID.
`{APPLICATION_INSTANCE_ID}`  | The application instance UUID.

**Request body**

Attribute                    | Description
---------:                   | --------   
`service id` | [Don't know how to pass this]

**Response**

```
HTTP/1.1 201 OK
```

```json
{
    "application": {
        "id": "645682ae-0be6-420a-bcf3-0e711a391546"
    },
    "composite_id": "645682ae-0be6-420a-bcf3-0e711a391546_212a758a-810b-4226-9175-b1b44eecebec",
    "created_at": 1644968368,
    "id": "13fdfd32-8412-4479-b04f-a83d155e5de5",
    "service": {
        "id": "212a758a-810b-4226-9175-b1b44eecebec"
    },
    "status": 0,
    "suspended": false,
    "updated_at": 1644968411
}
```


### Delete an application instance

Disconnect an application from a Service.

**Endpoint**

<div class="endpoint delete">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/applications/{APPLICATION_ID}/application_instances/{APPLICATION_INSTANCE_ID}</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{APPLICATION_ID}`  | The application UUID.
`{APPLICATION_INSTANCE_ID}`  | The application instance UUID.

**Response**

```
HTTP/1.1 204 No Content
```

## Plugins

### List all plugins

List all plugins for a developer.

**Endpoint**

<div class="endpoint get">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/plugins</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.

**Response**

```
HTTP/1.1 200 OK
```

The exact response depends on the plugins that this developer has configured.
For example, if there is a `proxy-cache` plugin enabled:

```json
{
    "config": {
        "cache_control": false,
        "cache_ttl": 300,
        "content_type": [
            "text/plain",
            "application/json"
        ],
        "memory": {
            "dictionary_name": "kong_db_cache"
        },
        "request_method": [
            "GET",
            "HEAD"
        ],
        "response_code": [
            200,
            301,
            404
        ],
        "strategy": "memory"
    },
    "consumer": {
        "id": "bc504999-b3e5-4b08-8544-86962c969335"
    },
    "created_at": 1645564279,
    "enabled": true,
    "id": "d5f70fe4-58e6-4153-8569-07a1f901e751",
    "name": "proxy-cache",
    "protocols": [
        "grpc",
        "grpcs",
        "http",
        "https"
    ]
}
```

### Apply a plugin

Configure a plugin and apply it to a developer.

**Endpoint**

<div class="endpoint post">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/plugins</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.


**Request body**

Attribute                    | Description
---------:                   | --------   
`name`<br>*required* | The name of a plugin to enable. You can use any plugin that can be enabled on a Consumer.
Plugin configuration fields | Any configuration parameters for the plugin that you are enabling. See the plugin's reference on the [Plugin Hub](/hub/) to find the parameters for a specific plugin.

Example request:

```sh
http POST :8001/developers/example@example.com/plugins \
  name=proxy-cache \
  config.strategy=memory
```

**Response**

```
HTTP/1.1 201 Created
```

The exact response depends on the plugin. For example, for `proxy-cache`:

```json
{
    "config": {
        "cache_control": false,
        "cache_ttl": 300,
        "content_type": [
            "text/plain",
            "application/json"
        ],
        "memory": {
            "dictionary_name": "kong_db_cache"
        },
        "request_method": [
            "GET",
            "HEAD"
        ],
        "response_code": [
            200,
            301,
            404
        ],
        "strategy": "memory"
    },
    "consumer": {
        "id": "bc504999-b3e5-4b08-8544-86962c969335"
    },
    "created_at": 1645564279,
    "enabled": true,
    "id": "d5f70fe4-58e6-4153-8569-07a1f901e751",
    "name": "proxy-cache",
    "protocols": [
        "grpc",
        "grpcs",
        "http",
        "https"
    ]
}
```

### Inspect a developer plugin

Inspect a plugin that is applied to a developer.

**Endpoint**

<div class="endpoint get">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/plugins/{PLUGIN_ID}</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{PLUGIN_ID}` | The UUID of the plugin to inspect.

**Response**
```
HTTP/1.1 200 OK
```

The exact response depends on the plugin. For example, for `proxy-cache`:

```json
{
    "config": {
        "cache_control": false,
        "cache_ttl": 300,
        "content_type": [
            "text/plain",
            "application/json"
        ],
        "memory": {
            "dictionary_name": "kong_db_cache"
        },
        "request_method": [
            "GET",
            "HEAD"
        ],
        "response_code": [
            200,
            301,
            404
        ],
        "strategy": "memory"
    },
    "consumer": {
        "id": "bc504999-b3e5-4b08-8544-86962c969335"
    },
    "created_at": 1645564279,
    "enabled": true,
    "id": "d5f70fe4-58e6-4153-8569-07a1f901e751",
    "name": "proxy-cache",
    "protocols": [
        "grpc",
        "grpcs",
        "http",
        "https"
    ]
}
```

### Update a developer plugin

Edit a plugin that is applied to a developer.

**Endpoint**

<div class="endpoint patch">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/plugins/{PLUGIN_ID}</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{PLUGIN_ID}` | The UUID of the plugin to update.

**Request body**

Attribute                    | Description
---------:                   | --------   
Plugin configuration fields | Any configuration parameters for the plugin that you are editing. See the plugin's reference on the [Plugin Hub](/hub/) to find the parameters for a specific plugin.


Example request to update an instance of the `proxy-cache` plugin:

```sh
http PATCH :8001/developers/91a1fb59-d90f-4f07-b609-4c2a1e3d847e/plugins/d5f70fe4-58e6-4153-8569-07a1f901e751 \
  config.response_code:='[200, 301, 400, 404]'
```

**Response**

```
HTTP/1.1 200 OK
```

The exact response depends on the plugin. For example, if you change accepted
response codes for `proxy-cache` to add `400`:

```json
{
    "config": {
        "cache_control": false,
        "cache_ttl": 300,
        "content_type": [
            "text/plain",
            "application/json"
        ],
        "memory": {
            "dictionary_name": "kong_db_cache"
        },
        "request_method": [
            "GET",
            "HEAD"
        ],
        "response_code": [
            200,
            301,
            400,
            404
        ],
        "strategy": "memory"
    },
    "consumer": {
        "id": "bc504999-b3e5-4b08-8544-86962c969335"
    },
    "created_at": 1645564279,
    "enabled": true,
    "id": "d5f70fe4-58e6-4153-8569-07a1f901e751",
    "name": "proxy-cache",
    "protocols": [
        "grpc",
        "grpcs",
        "http",
        "https"
    ]
}
```


### Delete a developer plugin

Remove an authentication plugin from a developer.

**Endpoint**

<div class="endpoint delete">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/plugins/{PLUGIN_ID}</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{PLUGIN_ID}` | The UUID of the plugin to delete.

**Response**

```
HTTP/1.1 204 No Content
```

## Developer authentication

### Get all credentials

Get a list of all configured credentials for a specific type of authentication
plugin.

**Endpoint**

<div class="endpoint get">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/credentials/{PLUGIN_NAME}</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{PLUGIN_NAME}` | The name of a supported authentication plugin. Can be one of: <br> &#8226; `basic-auth` <br> &#8226; `oauth2` <br> &#8226; `hmac-auth` <br> &#8226; `jwt` <br> &#8226; `key-auth` <br> &#8226; `openid-connect`

**Response**
```
HTTP/1.1 200 OK
```

The exact response depends on the plugin. For example, if you have two `key-auth`
credentials:

```json
{
    "data": [
        {
            "consumer": {
                "id": "bc504999-b3e5-4b08-8544-86962c969335"
            },
            "created_at": 1645566606,
            "id": "1a86d7eb-53ce-4a29-b573-a545e602fc05",
            "key": "testing"
        },
        {
            "consumer": {
                "id": "bc504999-b3e5-4b08-8544-86962c969335"
            },
            "created_at": 1645567499,
            "id": "1b0ba8f4-dd9f-4f68-8108-c81952e05b8e",
            "key": "wpJqvsTFRjgQstL16pQTYKtlHfkzdJpb"
        }
    ],
    "next": null,
    "total": 2
}
```

### Create a credential

**Endpoint**

<div class="endpoint post">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/credentials/{PLUGIN_NAME}</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{PLUGIN_NAME}` | The name of a supported authentication plugin. Can be one of: <br> &#8226; `basic-auth` <br> &#8226; `oauth2` <br> &#8226; `hmac-auth` <br> &#8226; `jwt` <br> &#8226; `key-auth` <br> &#8226; `openid-connect`

**Request body**

Attribute                    | Description
---------:                   | --------   
Plugin configuration fields | Any authentication credentials for the plugin that you are configuring. See the plugin's reference on the [Plugin Hub](/hub/) to find the parameters for a specific plugin.


Example request for creating a `key-auth` credential:
```sh
http POST :8001/developers/91a1fb59-d90f-4f07-b609-4c2a1e3d847e/credentials/key-auth
```

**Response**
```
HTTP/1.1 201 Created
```

The exact response depends on the plugin. For example, if you add a `key-auth`
credential:

```json
{
    "consumer": {
        "id": "bc504999-b3e5-4b08-8544-86962c969335"
    },
    "created_at": 1645567499,
    "id": "1b0ba8f4-dd9f-4f68-8108-c81952e05b8e",
    "key": "wpJqvsTFRjgQstL16pQTYKtlHfkzdJpb"
}

```

### Inspect a credential

Retrieve information about a credential using its ID.

**Endpoint**

<div class="endpoint get">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/credentials/{PLUGIN_NAME}/{CREDENTIAL_ID}</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{PLUGIN_NAME}` | The name of a supported authentication plugin. Can be one of: <br> &#8226; `basic-auth` <br> &#8226; `oauth2` <br> &#8226; `hmac-auth` <br> &#8226; `jwt` <br> &#8226; `key-auth` <br> &#8226; `openid-connect`
`{CREDENTIAL_ID}` | The UUID of a credential for the plugin.

**Response**
```
HTTP/1.1 200 OK
```

The exact response depends on the plugin. For example, if you inspect a `key-auth`
credential:

```json
{
    "consumer": {
        "id": "bc504999-b3e5-4b08-8544-86962c969335"
    },
    "created_at": 1645567499,
    "id": "1b0ba8f4-dd9f-4f68-8108-c81952e05b8e",
    "key": "wpJqvsTFRjgQstL16pQTYKtlHfkzdJpb"
}
```

### Update a credential

**Endpoint**

<div class="endpoint patch">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/credentials/{PLUGIN_NAME}/{CREDENTIAL_ID}</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{PLUGIN_NAME}` | The name of a supported authentication plugin. Can be one of: <br> &#8226; `basic-auth` <br> &#8226; `oauth2` <br> &#8226; `hmac-auth` <br> &#8226; `jwt` <br> &#8226; `key-auth` <br> &#8226; `openid-connect`
`{CREDENTIAL_ID}` | The UUID of a credential for the plugin.

**Request body**

Attribute                    | Description
---------:                   | --------   
Plugin configuration fields | Any authentication credentials for the plugin that you are configuring. See the plugin's reference on the [Plugin Hub](/hub/) to find the parameters for a specific plugin.

Example request to update a `key-auth` key:
```
http PATCH :8001/developers/91a1fb59-d90f-4f07-b609-4c2a1e3d847e/credentials/key-auth/1b0ba8f4-dd9f-4f68-8108-c81952e05b8e \
  key=apikey
```

**Response**
```
HTTP/1.1 200 OK
```

The exact response depends on the plugin. For example, if you update a `key-auth`
credential to use a custom key instead of a UUID:

```json
{
    "consumer": {
        "id": "bc504999-b3e5-4b08-8544-86962c969335"
    },
    "created_at": 1645567499,
    "id": "1b0ba8f4-dd9f-4f68-8108-c81952e05b8e",
    "key": "apikey"
}
```

### Delete a credential

**Endpoint**

<div class="endpoint delete">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/credentials/{PLUGIN_NAME}/{CREDENTIAL_ID}</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{PLUGIN_NAME}` | The name of a supported authentication plugin. Can be one of: <br> &#8226; `basic-auth` <br> &#8226; `oauth2` <br> &#8226; `hmac-auth` <br> &#8226; `jwt` <br> &#8226; `key-auth` <br> &#8226; `openid-connect`
`{CREDENTIAL_ID}` | The UUID of a credential for the plugin.

**Response**
```
HTTP/1.1 204 No Content
```

## Application authentication

### Inspect all credentials for an application

Get a list of all application credentials for a specific type of authentication
plugin.

**Endpoint**

<div class="endpoint get">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/applications/{APPLICATION_ID}/credentials/{PLUGIN_NAME}</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{APPLICATION_ID}`  | The application UUID.
`{PLUGIN_NAME}` | The authentication strategy in use for application registration. Can be one of: <br>&#8226; `oauth2` <br> &#8226; `key-auth` <br> &#8226; `openid-connect`

**Response**
```
HTTP/1.1 200 OK
```

The exact response depends on the authentication strategy being used for
application registration. For example, if you have an application secured with
OAuth2:

```json
{
    "data": [
        {
            "client_id": "3psqvdiojUKoJudqCh1U5P5mvR9k3zFF",
            "client_secret": "HUbYpUw8sNrEZGqyCs19HmRo08l9shC0",
            "client_type": "confidential",
            "consumer": {
                "id": "6e31bf1e-dbcb-4a31-bac9-a192fa24f088"
            },
            "created_at": 1644963627,
            "hash_secret": false,
            "id": "e22760bc-c6d4-4572-9814-132825286618",
            "name": "example_app",
            "redirect_uris": [
                "http://mockbin.org"
            ]
        }
    ],
    "next": null,
    "total": 1
}
```

### Create a credential for an application

**Endpoint**

<div class="endpoint post">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/applications/{APPLICATION_ID}/credentials/{PLUGIN_NAME}</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{APPLICATION_ID}`  | The application UUID.
`{PLUGIN_NAME}` | The authentication strategy in use for application registration. Can be one of: <br>&#8226; `oauth2` <br> &#8226; `key-auth` <br> &#8226; `openid-connect`

**Request body**

Attribute                    | Description
---------:                   | --------   
Plugin configuration fields | Any authentication credentials for the plugin that you are configuring. See the plugin's reference on the [Plugin Hub](/hub/) to find the parameters for a specific plugin.

Example request for creating an `oauth2` credential:

```sh
http POST :8001/developers/5f60930a-ad12-4303-ac5a-59d121ad4942/applications/5ff48aaf-3951-4c99-a636-3b682081705c/credentials/oauth2
```

**Response**
```
HTTP/1.1 201 Created
```

The exact response depends on the plugin. For example, if you add an `oauth2`
credential:

```json
{
    "client_id": "t2vTlxxV1ANi9jFq2U1rlR1yp03Mi6uf",
    "client_secret": "EdKxXDD97LSe45lG5G5f6CBn5G9gXcp4",
    "client_type": "confidential",
    "consumer": {
        "id": "6e31bf1e-dbcb-4a31-bac9-a192fa24f088"
    },
    "created_at": 1645569439,
    "hash_secret": false,
    "id": "2dc8ee2a-ecfd-4ca5-a9c1-db371480e2cf",
    "name": "example_app",
    "redirect_uris": [
        "http://mockbin.org"
    ]
}
```


### Inspect a credential for an application

**Endpoint**

<div class="endpoint get">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/applications/{APPLICATION_ID}/credentials/{PLUGIN_NAME}/{CREDENTIAL_ID}</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{APPLICATION_ID}`  | The application UUID.
`{PLUGIN_NAME}` | The authentication strategy in use for application registration. Can be one of: <br>&#8226; `oauth2` <br> &#8226; `key-auth` <br> &#8226; `openid-connect`
`CREDENTIAL_ID` | The UUID of a credential.

**Response**
```
HTTP/1.1 200 OK
```

The exact response depends on the authentication strategy being used for
application registration. For example, if you have an application secured with
OAuth2:

```json
{
    "client_id": "3psqvdiojUKoJudqCh1U5P5mvR9k3zFF",
    "client_secret": "HUbYpUw8sNrEZGqyCs19HmRo08l9shC0",
    "client_type": "confidential",
    "consumer": {
        "id": "6e31bf1e-dbcb-4a31-bac9-a192fa24f088"
    },
    "created_at": 1644963627,
    "hash_secret": false,
    "id": "e22760bc-c6d4-4572-9814-132825286618",
    "name": "example_app",
    "redirect_uris": [
        "http://mockbin.org"
    ]
}
```

### Delete a credential from an application

**Endpoint**

<div class="endpoint delete">/developers/{DEVELOPER_EMAIL|DEVELOPER_ID}/applications/{APPLICATION_ID}/credentials/{PLUGIN_NAME}/{CREDENTIAL_ID}</div>

Attribute                         | Description
---------:                        | --------   
`{DEVELOPER_EMAIL|DEVELOPER_ID}`  | The email or UUID of a developer.
`{PLUGIN_NAME}` | The name of a supported authentication plugin. Can be one of: <br> &#8226; `basic-auth` <br> &#8226; `oauth2` <br> &#8226; `hmac-auth` <br> &#8226; `jwt` <br> &#8226; `key-auth` <br> &#8226; `openid-connect`
`{CREDENTIAL_ID}` | The UUID of a credential for the plugin.

**Response**
```
HTTP/1.1 204 No Content
```
