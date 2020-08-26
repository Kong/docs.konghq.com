---
title: Kong Brain & Kong Immunity Installation and Configuration
---

**Kong Brain** (Brain) and **Kong Immunity** (Immunity) help automate the entire API and service development life cycle. By automating processes for configuration, traffic analysis and the creation of documentation, Brain and Immunity help organizations improve efficiency, governance, reliability and security. Brain automates API and service documentation and Immunity uses advanced machine learning to analyze traffic patterns to diagnose and improve security.

![Kong Brain and Kong Immunity](/assets/images/docs/ee/brain_immunity_overview.png)

Brain and Immunity are installed on Kong Enterprise, either on Kubernetes or Docker, as defined below. The Collector App and Collector Plugin enable Brain and Immunity to communicate with Kong Enterprise. The diagram above illustrate how the components work together.

## Install Brain and Immunity on Kubernetes
Set up the Collector App via Helm. Use the public helm chart for setting up the Collector App and all its dependencies on Kubernetes. Instructions for setup can be found on the public repo at: [https://github.com/Kong/kong-collector-helm/blob/master/README.md](https://github.com/Kong/kong-collector-helm/blob/master/README.md).

## Install Brain and Immunity on Docker
Install Brain and Immunity by downloading, installing and starting the Collector App on Docker, as defined in this section.

### Prerequisites
To complete this installation you will need:
* A valid *Bintray* account. You will need your *username*, account *password* and account *API Key*.
  - Example:
    * Bintray Access key = `john-company`
    * Bintray username = `john-company@kong`
    * Bintray password = `12345678`
    * Bintray API key = `12234e314356291a2b11058591bba195830`
  - The API Key can be obtained by visiting [https://bintray.com/profile/edit](https://bintray.com/profile/edit) and selecting *API Key*
* A Docker-enabled system with proper Docker access.
* Kong Enterprise 2.1.x or later is installed on Docker.
* A valid Kong Enterprise License JSON file, including a license for Kong Brain and Kong Immunity.
**Note**: You should receive your Bintray credentials with your purchase of Kong Enterprise. If you need Bintray credentials, contact from Kong Support.


## Step 1. Add the Kong Docker Repository and Pull the Kong Brain and Kong Immunity Docker Image

1. In a terminal window, add the Kong Docker Repository:
```
$ docker login -u <your_username_from_bintray> -p <your_apikey_from_bintray> kong-docker-kong-brain-immunity-base.bintray.io
```
2. Pull the Kong Brain and Kong Immunity Docker image.
```
$ docker pull kong-docker-kong-brain-immunity-base.bintray.io/kong-brain-immunity:latest
```
You should now have your Kong Brain and Kong Immunity image locally.

3. Verify that you have the Docker image. Find the image ID matching your repository:
```
$ docker images
```
4. Tag the image ID as `kong-ee` for easier use. Replace `<IMAGE_ID>` with the image ID matching your repository.
```
$ docker tag <IMAGE_ID> kong-ee
```

## Step 2. Confirm the Kong EE Docker Network is available
Confirm the Kong Enterprise network is available, which is the network you set up when installing Kong Enterprise on Docker named `kong-ee-net`.

1. Run the the Docker `ls` command to list available networks. The list should show `kong-ee-net`.

```
$ docker network ls
```

2. If the results do not show `kong-ee-net`, create the network:
```
$ docker network create kong-ee-net
```

## Step 3. Start a Database
Start a PostgreSQL database:
```
$ docker run -d --name collector-database \
  --hostname collector-database \
  --network=kong-ee-net \
  -e "POSTGRES_USER=kong" \
  -e "POSTGRES_DB=kong" \
  -e "POSTGRES_PASSWORD=kong" \
  postgres:12
```

## Step 4. Start a Redis Database
Start a Redis database:
```
$ docker run -d --name redis \
  --hostname redis \
  --network=kong-ee-net \
  -p 6379 \
  redis:5.0-alpine
```

## Step 5. Prepare the Collector Database
Prepare the Collector database:
```
docker run --rm --network=kong-ee-net \
  -e "SQLALCHEMY_DATABASE_URI=postgres://collector:collector@collector-database:5432/collector" \
  kong-docker-kong-brain-immunity-base.bintray.io/kong-brain-immunity:latest \
  flask db upgrade
```

## Step 6. Start Kong Collector
Start Kong Collector. For `KONG_HOST`, replace `<DNSorIP>` with the DNS name or IP of the Docker host. The DNS or IP address for `KONG_HOST` should not be preceded with a protocol, for example `http://`.
```
$ docker run -d --name collector \
  --hostname collector \
  --network=kong-ee-net \
  -p 5000:5000 \
  -e "CELERY_BROKER_URL=redis://redis:6379/0" \
  -e "SQLALCHEMY_DATABASE_URI=postgres://collector:collector@collector-database:5432/collector" \
  -e "KONG_HOST=<DNSorIP>" \
  -e "KONG_PORT=8001" \
  kong-docker-kong-brain-immunity-base.bintray.io/kong-brain-immunity:latest
```
  
## Step 7. Start the Scheduler and worker
Start the scheduler and worker. For `KONG_HOST`, replace `<DNSorIP>` with the DNS name or IP of the Docker host. The DNS or IP address for `KONG_HOST` should not be preceded with a protocol, for example `http://`.

1. Start celery-beat
```
$ docker run -d --name celery-beat \
  --network=kong-ee-net \
  -e "CELERY_BROKER_URL=redis://redis:6379/0" \
  kong-docker-kong-brain-immunity-base.bintray.io/kong-brain-immunity:latest \
  celery beat -l info -A collector.scheduler.celery
```

2. Start celery-worker
```
$ docker run -d --name celery-worker \
  --network=kong-ee-net \
  -e "CELERY_BROKER_URL=redis://redis:6379/0" \
  -e "SQLALCHEMY_DATABASE_URI=postgres://collector:collector@collector-database:5432/collector" \
  -e "KONG_HOST=<DNSorIP>" \
  -e "KONG_PORT=8001" \
  kong-docker-kong-brain-immunity-base.bintray.io/kong-brain-immunity:latest \
  celery worker -l info -A collector.scheduler.celery --concurrency=1
```

## Step 8. Complete the Configuration and Validate the Collector App installation
```
$ curl -i -X GET --url http://localhost:5000/status
```

You should receive an HTTP/1.1 200 OK message.


### Enable the Collector Plugin using Kong Manager
The Collector Plugin can be enabled using Kong Manager. To enable the plugin:
1. Navigate to the **Workspace** page.
2. Click on **Plugins** in the left navigation bar.
3. On the Plugin page, click **Add Plugin** which opens a page of plugin options.
4. Scroll down to the Analytics and Monitoring section, and click the **Collector** tile.

The Collector Plugin page contains the variables that are configurable for the Collector Plugin. To minimally configure the Collector Plugin:
1. In the **Config.Http Endpoint** field, enter the Collector App endpoint that Kong Enterprise can communicate with.
2. Click **Create**. The Collector Plugin is configured.

### Logging HTTP Body Content
The Collector Plugin gives users the option to opt-in or out of logging HTTP request bodies with the `config.log_bodies` configuration variable. When set to `false`, the Collector Plugin will not send body content in HTTP requests to the Collector App. This is useful to prevent sensitive personal information in the request body content from being stored long term in the Collector App. The cost of not sending the request body information is that its contents will not appear in generated Swagger, nor be used for anomaly detection.  When set to `true`, the Collector Plugin will send request body content to the Collector App where it can be stored in the Collector App's database.

### Check the Collector Plugin
The port and host are configurable, but must match the Collector App.
To confirm this step, hit one of the URLs mapped through the Collector App. For example,
```
/<workspace name>/collector/alerts
```

## (Advanced Configuration) Opt-Out of HAR Redaction
**Note**: You must specifically opt-out, or turn off, HAR Redaction in order to store all of your data. The default setting is to redact.

The Collector App default does not store body data values and attachments in traffic data. In the `Har['postData']['text']` field, all values are replaced with the value's type. This does not affect the performance of Brain or Immunity, however, this can impact your ability to investigate some Immunity related alerts by looking at the offending HARs that created those alerts.

If you want to store body data in the Collector App, you can do so by setting the Collector’s `REDACT_BODY_DATA` by updating the environment variable in `docker-compose.yml` or declaring it in your `docker-compose up` command as follows:

```
$ REDACT_BODY_DATA=False docker-compose -f docker-compose.yml -f with-redis.yml up
```


## (Optional) Using a different Redis instance
To use your own instance of Redis instead of the one provided by the container, change the command to use your database, Redis, or both.

```
$ REDIS_URI=<redis://localhost:6379/> KONG_HOST=<KONG HOST> KONG_PORT=<8001> docker-compose -f docker-compose.yml up
```


## Confirm the Collector App is working
Requests to the status endpoint will confirm the Collector App is up and running in addition to providing Brain and Immunity status and version number.

```
curl http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/status
```

## Summary
The Collector App and Kong Enterprise are up and ready to analyze incoming traffic for [alerts](/enterprise/{{page.kong_version}}/brain-immunity/alerts), [auto-generate specs](/enterprise/{{page.kong_version}}/brain-immunity/auto-generated-specs), and display your traffic visually in a [Service Map](/enterprise/{{page.kong_version}}/brain-immunity/service-map).

For any problems encountered while setting up Collector App, Collector Plugin, or configuring other aspects of Brain and Immunity, go to [troubleshooting](/enterprise/{{page.kong_version}}/brain-immunity/troubleshooting) for help debugging common problems.
