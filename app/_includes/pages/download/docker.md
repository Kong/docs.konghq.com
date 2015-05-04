### Docker

Details about how to use Kong in Docker can be found on the Dockerhub repo hosting the image: [mashape/kong](https://registry.hub.docker.com/u/mashape/kong/).

Here is a quick setup linking Kong to a Cassandra container:

1. **Start Cassandra:**

	```bash
	$ docker run -p 9042:9042 -d --name cassandra mashape/cassandra
	```

2. **Start Kong:**

    ```bash
    $ docker run -p 8000:8000 -p 8001:8001 -d --name kong --link cassandra:cassandra mashape/kong
    ```

3. **Kong is running:**

    ```bash
    $ curl http://127.0.0.1:8001
    ```

4. **Start using Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/{{site.data.kong_latest.version}}/getting-started/quickstart).
