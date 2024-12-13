---
nav_title: Setting rate limits on multiple entities
title: Setting rate limits on multiple entities
---

A common use case for the Service Protection plugin is to use it in conjunction with other rate limiting plugins. 
This lets you set granular protections on your services, routes, and so on.

The follow examples show you how you could use the Service Protection plugin and the Rate Liming Advanced plugin together to apply
different rate limits to different services.

## Set up the Rate Limiting Advanced plugin

Enable the Rate Limiting Advanced plugin on a route.

1. Create a service:
    ```sh
    curl -i -s -X POST http://localhost:8001/services \
        --data name=rla_example_service \
        --data url='http://httpbin.org'
    ```

2. Create a route
    ```sh
    curl -i -X POST http://localhost:8001/services/rla_example_service/routes \
        --data 'paths[]=/rla_mock' \
        --data name=rla_route
    ```

3. Enable the Rate Limiting Advanced plugin on the route:
    ```sh
    curl -X POST http://localhost:8001/routes/rla_route/plugins \
        --header "accept: application/json" \
        --header "Content-Type: application/json" \
        --data '{
                "name": "rate-limiting-advanced",
                "config": {
                    "limit": [
                    5
                    ],
                    "window_size": [
                    30
                    ],
                    "identifier": "consumer",
                    "sync_rate": -1,
                    "namespace": "rla_example_namespace",
                    "strategy": "local",
                    "hide_client_headers": false
            }
        }'
    ```


## Set up the Service Protection plugin

Create another service and route, and attach the Service Protection plugin to the service.

1. Create a service:
    ```sh
    curl -i -s -X POST http://localhost:8001/services \
        --data name=sp_example_service \
        --data url='http://httpbin.org'
    ```

2. Create a route:
    ```sh
    curl -i -X POST http://localhost:8001/services/sp_example_service/routes \
    --data 'paths[]=/sp_mock' \
    --data name=sp_route
    ```

3. Enable the Service Protection plugin:
    ```sh
    curl -X POST http://localhost:8001/services/sp_example_service/plugins/ \
        --header "accept: application/json" \
        --header "Content-Type: application/json" \
        --data '
            {
            "name": "service-protection",
            "config": {
                "limit": [
                10
                ],
                "window_size": [
                45
                ],
                "sync_rate": -1,
                "namespace": "sp_example_namespace",
                "strategy": "local",
                "hide_client_headers": false
        }
        }'
    ```
    
## Validate

Verify that the Rate Limiting Advanced plugin and the Service Protection plugin are applying separate limits.

1. Verify the Rate Limiting Advanced plugin:
    ```sh
    curl -i http://localhost:8000/rla_mock/anything

    for _ in {1..6}; do curl -s -i localhost:8000/rla_mock/anything; echo; sleep 1; done
    ```

2. Verify the Service Protection plugin:
    ```sh
    curl -i http://localhost:8000/sp_mock/anything

    for _ in {1..10}; do curl -s -i localhost:8000/sp_mock/anything; echo; sleep 1; done
    ```