---
nav_title: Detect boolean-based blind SQL injection with a custom regex
title: Detect boolean-based blind SQL injection with a custom regex
---

You can use the custom regex configuration of the Injection Protection plugin to detect additional regex patterns in injection attacks. 

In this example, you'll configure the Injection Protection plugin to detect a boolean-based blind SQL injection in a URL using custom regex. This custom regex would detect injections in a URL like the following: `https://example.com/products?id=1'`

## Set up the Injection Protection plugin

Enable the Injection Protection plugin on a route.

1. Create a service:
    ```sh
    curl -i -s -X POST http://localhost:8001/services \
        --data name=ip_example_service \
        --data url='http://httpbin.org'
    ```

2. Create a route:
    ```sh
    curl -i -X POST http://localhost:8001/services/ip_example_service/routes \
        --data 'paths[]=/ip_mock' \
        --data name=ip_route
    ```

3. Enable the Injection Protection plugin on the route:
    ```sh
    curl -X POST http://localhost:8001/routes/ip_route/plugins \
        --header "accept: application/json" \
        --header "Content-Type: application/json" \
        --data '
        {
            "name": "injection-protection",
            "config": {
                "custom_injections": [
                    {
                        "name": "boolean_based_sql_injection",
                        "regex": "(\\b(OR|AND)\\s+\\d{1,3}=\\d{1,3}\\s*(--|#|\\b))|(\\b(OR|AND)\\s+1=1\\s*(--|#|\\b))|(\\b(OR|AND)\\s+1=0\\s*(--|#|\\b))"
                    }
                ],
                "enforcement_mode": "block",
                "error_message": "Bad Request",
                "error_status_code": 400,
                "injection_types": [
                    "sql"
                ],
                "locations": [
                    "path_and_query"
                ]
            }
        }
        '
    ```

## Validate

Verify that the Injection Protection plugin detects the boolean-based SQL injection attacks:

```sh
curl -X GET "http://httpbin.org/ip_route?id=1%27%20OR%201=1%20--" \
     --header "accept: application/json"
```

If the plugin custom regex config is configured correctly, you should get a `400 Bad Request`.
