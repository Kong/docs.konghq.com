---
title: Using the Konnect API
no_search: true
no_version: true
---
## Introduction

{{site.konnect_product_name}} provides a RESTful admin API for administration.

This API is designed for internal use and provides full control over a Konnect
organization and its entities, so care should be taken when setting up
[user permissions](/konnect/reference/org-management/#role-definitions).

See the [Konnect API Swagger](https://khcp.konghq.com/docs) documentation for a
list of all endpoints.

## Making a Request to the Konnect API

Requests to the Konnect API must be authenticated. A request without
authentication will fail.

1. Try to access `/api/control_planes` without any authentication, where [`<proxy-url>`](/konnect/reference/proxy-traffic) is in the format
    `https://myorg.khcp.konghq.com`:

    ```sh
    $ curl -i -X GET --url <proxyurl>/api/control_planes
    ```

    Since you didn't specify any authentication, the request should fail with a
    `401 Unauthorized` error.

2. Fetch the authentication token to be used in future requests using an
authorized Konnect user's email and password:

    ```sh
    $ curl -i -X POST --url <proxyurl>/api/auth \  
      --data 'username=example@email.com' \   
      --data 'password=somepwd'
    ```

    This request prints an access token to the console:
    ```sh
    {"access_token":"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InVzZXIxQGVtYWlsLmNvbSIsInN1YiI6ImZhNGVkOGFmLWE0NjEtNDdjNS05ODYwLTQyNTJkNTg5ZGQ5ZiIsIm9yZyI6eyJpZCI6ImMzMDBmMWIzLTEyYzQtNDI1ZS1iNzczLTYzZmY5NWM0ZGMwMSJ9LCJpYXQiOjE2MDEwNDIxNjQsImV4cCI6MTYwMTA0NTc2NH0.dC7g82ebZQFIA97hXtC1HnnOF-f0R76aO954FZrgB_0"}
    ```

3. Copy the access token and use it to fetch `/api/control_planes` again:

    ```sh
    $ curl -i -X GET --url <proxy-url>/api/control_planes \
      -H 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6InVzZXIxQGVtYWlsLmNvbSIsInN1YiI6ImZhNGVkOGFmLWE0NjEtNDdjNS05ODYwLTQyNTJkNTg5ZGQ5ZiIsIm9yZyI6eyJpZCI6ImMzMDBmMWIzLTEyYzQtNDI1ZS1iNzczLTYzZmY5NWM0ZGMwMSJ9LCJpYXQiOjE2MDEwNDIxNjQsImV4cCI6MTYwMTA0NTc2NH0.dC7g82ebZQFIA97hXtC1HnnOF-f0R76aO954FZrgB_0'{"data":[{"id": "221f2635-d7f8-467f-b487-a16bc319bbe2", "name":"khcp-kong-service" ...}]}
    ```
    > **Note:** The `access_token` is valid for 24 hours. It does not currently
    refresh with active usage, so a new token will need to be regenerated after it
    expires.
