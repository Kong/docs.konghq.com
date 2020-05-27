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
* Kong Enterprise 1.5.x or later installed on Docker.
* The Docker Compose file of your purchased version of Brain and Immunity, which displays in Bintray as *kong/kong-brain-immunity-base*.
* A valid Kong Enterprise License JSON file.
  - The license file can be found in your Bintray account. See [Accessing Your License](/enterprise/latest/deployment/access-license)


## Configure the Collector App and Collector Plugin
To enable Brain and Immunity, you must first configure the Collector App and the Collector Plugin. This includes:
* Deploying the Collector Plugin to Kong Enterprise. The plugin captures and sends traffic to the Collector App for data collection and processing.
* Deploying the Collector App on your Docker-aware platform.
* Configuring the Collector Plugin and the Collector App to talk to each other.
* Testing the configuration to confirm everything is up and running.


## Step 1. Set up the Collector App
Access release-script files to run and install Brain and Immunity from Bintray.
**Note:** You should receive your Bintray credentials with your purchase of Kong Enterprise. If you need Bintray credentials, contact from **Kong Support**.
1. Log in to **Bintray** and retrieve your BINTRAY_USERNAME and BINTRAY_API_KEY.
2. Click your **username** to get the dropdown menu.
3. Click **Edit Profile** to get your BINTRAY_USERNAME.
4. Click **API Key** to get your BINTRAY_API_KEY.

The release-scripts include:
* **docker-compose.yml** - Sets up the Collector App.
* **with-db.yml** - Creates a PostgreSQL container that the Collector App will use if a database instance has not already been provided.
* **with-redis.yml** - Creates a Redis instance that the Collector App will use if a Redis instance has not already been provided.

### Collector App Environment Variables
The Collector App relies on several environment variables that need to be configured for proper function. These should be specified to match the overall Kong Enterprise deployment.

The provided `docker-compose.yml` file has these variables set to defaults that assume deployment with Docker Compose on the same network that Kong Enterprise is deployed. However, if this is not the case for your planned deployment of Collector App, please adjust the variables in the `docker-compose.yml` file, or specify the values of the variables with `docker-compose up`:
```
ENVVAR=somevalue ENVVAR=anothervalue docker-compose up
```

* **KONG_PROTOCOL**: The protocol that the Kong Admin API can be reached at. The possible values are `http` or `https`.
* **KONG_HOST**: The hostname that the Kong Admin API can be reached at. If deploying with Docker Compose, this is the name of the Kong container specified in the Compose file. If the Kong Admin API has been exposed behind a web address, `KONG_HOST` must be that web address.
* **KONG_PORT**: The port where the Kong Admin API can be found.  The Collector App requires this setting, along with `KONG_PROTOCOL` and `KONG_HOST`, to communicate with Kong.
* **KONG_ADMIN_TOKEN**: The authentication token used to validate requests for the Kong Admin API, if configured.
* **SQLALCHEMY_DATABASE_URI**: The SQLAlchemy formatted URI that points to the PostgreSQL database that the Collector App is using as a backend. The format is: `postgresql://<USER>:<PASSWORD>@<POSTGRES-HOST>:<POSTGRES-PORT>/collector`.
* **SLACK_WEBHOOK_URL**: The URL of the Slack channel that Immunity alert notifications should be sent to. This URL will be the default channel for alerts, but you can also add more channels and rules configuring which alerts to send to which channel. See [Adding a Slack Configuration](#adding-a-slack-configuration).

### Setting up Collector App via Docker Compose
#### Docker login
To download from Bintray you will first need to `docker login` to the Kong Brain/Immunity repository:
```
docker login -u BINTRAY_USERNAME -p BINTRAY_API_KEY kong-docker-kong-brain-immunity-base.bintray.io
```

Log in to Docker:
```
docker login
```

Then follow the login steps when prompted.

### Bringing up the Collector App with Redis and PostgreSQL
To bring up the full Collector App with its own database and Redis, run:
```
KONG_HOST={KONG HOST URL} KONG_PORT={KONG PORT} KONG_MANAGER_PORT={KONG MANAGER PORT} KONG_MANAGER_URL={KONG MANAGER URL} docker-compose -f docker-compose.yml -f with-db.yml -f with-redis.yml up -d
```

### Bringing up the Collector App alone
If you already have an outside database and would not like to bring up PostgreSQL with the Collector App, first make sure you have a collector database.
```
psql -U user -c "CREATE DATABASE collector;"
```

Then you can bring up the Collector App with:
```
SQLALCHEMY_DATABASE_URI=postgres://{POSTGRES USER}:{POSTGRES PASSWORD}@{POSTGRES HOST}:{POSTGRES POST}/collector CELERY_BROKER_URL={REDIS URI} docker-compose -f docker-compose.yml up -d
```


## Step 2. Set up the Collector Plugin and Kong GUI
Enable Brain and Immunity GUI changes on Kong Manager by editing the `kong.conf` file to have:
```
admin_gui_flags={"IMMUNITY_ENABLED":true}
```
Then restart Kong to see the changes take effect.

### Enable the Collector Plugin using the Admin API
Next, enable the Collector Plugin using the Admin API:

>(Optional) It is possible to set up the Collector Plugin to only be applied to specific routes or services. To apply the Collector Plugin to a Workspace, make this HTTPie request:

```
$ http --form POST http://<KONG_HOST>:8001/<workspace>/plugins name=collector \
    config.http_endpoint=<COLLECTOR_APP_ENDPOINT> \
```

To apply the Collector Plugin to a Service, make this cURL request:

```
$ http --form POST http://<KONG_HOST>:8001/<workspace>/plugins/<service_id> name=collector \
    config.http_endpoint=<COLLECTOR_APP_ENDPOINT>
```

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

## Step 3: Set up with Docker Compose
>Note: Using Docker Compose is recommended to deploy Brain and Immunity, as documented in this guide. You can also use Docker Swarm or Kubernetes for deployment, although steps are not currently included in this guide.

The information you need to run the Collector App, Brain and/or Immunity is included in the Docker Compose files. The steps in this section will start several Docker containers, including a collector, a worker, and a scheduler.

Kong provides a private Docker image that is used by the Compose files. This image is distributed via Bintray, and the following is required for access:
* Your Bintray User ID
* Your Bintray API key
* A server where you want to run Brain and Immunity with Docker installed.

Your Bintray credentials are provided to you with your purchase of Kong Enterprise. If you do not have these credentials, contact **Kong Support**.

1. SSH/PuTTY into your running instance where you want to install Brain and Immunity.

2. Log into Docker, and enter the repo you have access to. For example, `kong-docker-kong-brain-immunity-base`.

    ```
    docker login -u <BINTRAY_USERNAME> -p <BINTRAY_API_KEY> <enter your repo here>.bintray.io
    ```

3. Pull down the files for Docker Compose.

    ```
    wget https://<BINTRAY_USERNAME>:<BINTRAY_API_KEY>@kong.bintray.com/<kong-brain-immunity-base>/docker-compose.zip
    ```
    If successful, you should see `docker-compose.zip` in your current directory.

4. Unzip the package into the directory of your choice.

5. Run Docker Compose using the files to start Brain and Immunity.

    ```
    KONG_HOST=<KONG HOST> KONG_PORT=<8001> SQLALCHEMY_DATABASE_URI=<postgres://kong@localhost:5432/collector> docker-compose -f docker-compose.yml -f with-redis.yml up
    ```

    * Replace `KONG_HOST` and `KONG_PORT` with the host and port of your Kong Admin API:
       * `KONG_HOST`: the public IP address or Hostname of the system which is running Brain
       * `KONG_PORT`: Usually 8001, but may be set otherwise
    * `SQLALCHEMY_DATABASE_URI`:  The SQLAlchemy formatted URI that points to the PostgreSQL database that the Collector App is using as a backend.


## Step 4. (Advanced Configuration) Opt-Out of HAR Redaction
**Note**: You must specifically opt-out, or turn off, HAR Redaction in order to store all of your data. The default setting is to redact.

The Collector App default does not store body data values and attachments in traffic data. In the `Har['postData']['text']` field, all values are replaced with the value's type. This does not affect the performance of Brain or Immunity, however, this can impact your ability to investigate some Immunity related alerts by looking at the offending HARs that created those alerts.

If you want to store body data in the Collector App, you can do so by setting the Collector’s `REDACT_BODY_DATA` by updating the environment variable in `docker-compose.yml` or declaring it in your `docker-compose up` command as follows:

```
$ REDACT_BODY_DATA=False docker-compose -f docker-compose.yml -f with-redis.yml up
```


## Step 5. (Optional) Using a different Redis instance
To use your own instance of Redis instead of the one provided by the container, change the command to use your database, Redis, or both.

```
$ REDIS_URI=<redis://localhost:6379/> KONG_HOST=<KONG HOST> KONG_PORT=<8001> docker-compose -f docker-compose.yml up
```


## Step 6. Confirm the Collector App is working
Requests to the status endpoint will confirm the Collector App is up and running in addition to providing Brain and Immunity status and version number.

```
curl http://<COLLECTOR_HOST>:<COLLECTOR_PORT>/status
```

## Summary
The Collector App and Kong Enterprise are up and ready to analyze incoming traffic for [alerts](/enterprise/{{page.kong_version}}/brain-immunity/alerts), [auto-generate specs](/enterprise/{{page.kong_version}}/brain-immunity/auto-generated-specs), and display your traffic visually in a [Service Map](/enterprise/{{page.kong_version}}/brain-immunity/service-map).

For any problems encountered while setting up Collector App, Collector Plugin, or configuring other aspects of Brain and Immunity, go to [troubleshooting](/enterprise/{{page.kong_version}}/brain-immunity/troubleshooting) for help debugging common problems.
