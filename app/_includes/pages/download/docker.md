### Docker

1. **Start Cassandra:**

	```bash
	docker run -p 9042:9042 -d --name cassandra mashape/docker-cassandra
	```

2. **Start Kong:**

    ```bash
    docker run -p 8000:8000 -p 8001:8001 -d --name kong --link cassandra:cassandra mashape/docker-kong:{{site.data.kong_latest.version}}
    ```

3. **Kong is running:**

    ```bash
    curl http://127.0.0.1:8001
    ```

4. **Start using Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/{{site.data.kong_latest.version}}/getting-started/quickstart).