<!-- These steps are used to install Kong Gateway on Docker and
are used in the install section of the enterprise deployment docs
and in the vitals on influxdb docs. -->

{{ include.heading }}Pull the Kong Gateway Docker image {#pull-image}

Pull the following Docker image:

```bash
docker pull kong/kong-gateway:{{page.kong_versions[11].version}}-alpine
```
{:.important}
> Some [older {{site.base_gateway}} images](https://support.konghq.com/support/s/article/Downloading-older-Kong-versions)
are not publicly accessible. If you need a specific patch version and can't
find it on Kong's public Docker Hub page, contact
[Kong Support](https://support.konghq.com/).


You should now have your {{site.base_gateway}} image locally.

Verify that it worked, and find the image ID matching your repository:

```bash
docker images
```

Tag the image ID for easier use:

<pre><code>docker tag <div contenteditable="true">{IMAGE_ID}</div> kong-ee</code></pre>

{:.note}
> **Note:** Replace `{IMAGE_ID}` with the one matching your repository.

{{ include.heading1 }}Create a Docker network {#create-network}

Create a custom network to allow the containers to discover and communicate with each other.

```bash
docker network create kong-ee-net
```

{{ include.heading2 }}Start a database

Start a PostgreSQL container:

```bash
docker run -d --name kong-ee-database \
  --network=kong-ee-net \
  -p 5432:5432 \
  -e "POSTGRES_USER=kong" \
  -e "POSTGRES_DB=kong" \
  -e "POSTGRES_PASSWORD=kong" \
  postgres:9.6
```

{{ include.heading3 }}Prepare the Kong database

<pre><code>docker run --rm --network=kong-ee-net \
  -e "KONG_DATABASE=postgres" \
  -e "KONG_PG_HOST=kong-ee-database" \
  -e "KONG_PG_PASSWORD=kong" \
  -e "KONG_PASSWORD=<div contenteditable="true">{PASSWORD}</div>" \
  kong-ee kong migrations bootstrap </code></pre>

{:.note}
> **Note:** For `KONG_PASSWORD`, replace `{PASSWORD}`
with a valid password that only you know.
