---
title: Kong Brain & Kong Immunity Installation and Configuration Guide
---


**Kong Brain** and **Kong Immunity** help automate the entire API and service development life cycle. By automating processes for configuration, traffic analysis and the creation of documentation, Kong Brain and Kong Immunity help organizations improve efficiency, governance, reliability and security. Kong Brain automates API and service documentation and Kong Immunity uses advanced machine learning to analyze traffic patterns to diagnose and improve security.

![Kong Brain and Kong Immunity](/assets/images/docs/ee/brain_immunity_overview.png)

## Overview
Kong Brain and Kong Immunity are installed as add-ons on Kong Enterprise, using a Collector App and a Collector Plugin to communicate with Kong Enterprise. The diagram illustrates how the Kong components work together, and are described below:
* **Kong Enterprise**
* **Kong Brain** (Brain) and **Kong Immunity** (Immunity).
* **Collector App** enables communication between Kong Enterprise and Brain and Immunity. The Kong Collector App comes with your purchase of Bran and Immunity.
* **Collector Plugin** enables communication between Kong Enterprise and Kong Collector App. The Kong Collector Plugin comes with your purchase of Brain and Immunity.

## Prerequisites
Prerequisites for installing and configuring Brain and Immunity with Kong Enterprise include:
* **Kong Enterprise** version 0.35.3+ or later, with a minimum of one Kong node and a working datastore (PostgreSQL).
* Access to a platform for the Collector App with Docker installed. This system must be networked to communicate with the Kong Enterprise system where you have the Collector Plugin installed.
* Access to Kong Bintray repository (https://bintray.com/kong), including your access credentials supplied by Kong. (BINTRAY_USERNAME, BINTRAY_API_KEY)
* Docker Compose file of your purchased version of Brain and Immunity, which display in Bintray as `kong/kong-brain-immunity-base`. 
* Redis instance, which is included with Brain and Immunity.
* Swagger, which is included with Brain and Immunity.

## Configure the Collector App and Collector Plugin
To enable Kong Brain (Brain) and Kong Immunity (Immunity), you must first configure the Collector App and the Collector Plugin. This includes:
* Deploying the Collector Plugin, which captures and sends traffic to the Collector App for data collection and processing.
* Deploying the Collector App on your Docker aware platform.
* Configuring the Collector Plugin and the Collector App to talk to each other.
* Testing the configuration to confirm everything is up and running.

Steps are:
- [Step 1. Set up the Collector App](#step-1-set-up-the-collector-app)
- [Step 2. Set up the Collector Plugin and Kong GUI](#step-2-set-up-the-collector-plugin-and-kong-gui)
- [Step 3: Set up with Docker Compose](#step-3-set-up-with-docker-compose)
- [Step 4. (Advanced Configuration) Opt-Out of HAR Redaction](#step-4-advanced-configuration-opt-out-of-har-redaction)
- [Step 5. (Optional) Using a different Redis instance](#step-5-optional-using-a-different-redis-instance)
- [Step 6. Confirm the Collector App is working](#step-6-confirm-the-collector-app-is-working)


## Step 1. Set up the Collector App
Access release-script files to run and install Brain and Immunity from Bintray.
**Note:** You should receive your Bintray credentials with your purchase of Kong Enterprise. If you need Bintray credentials, contact from **Kong Support**.
1. Log in to **Bintray** and retrieve your BINTRAY_USERNAME and BINTRAY_API_KEY.
2. Click your **username** to get the dropdown menu.
3. Click **Edit Profile** to get your BINTRAY_USERNAME.
4. Click **API Key** to get your BINTRAY_API_KEY.

The release-scripts given are:
1. **docker-compose.yml** - sets up collector app
2. **with-db.yml** - creates postgres container that collector app will use if database instance not already provided.
3. **with-redis.yml** - creates redis instance that collector app will use if redis instance not already provided.


### Collector App Environment Variables
The Collector App relies on several environment variables that need to be configured well for proper function. These are the most impactful environment variables that should be specified to match the overall Kong and deployment environment, and what impact the variable has on Collector App.

The provided `docker-compose.yml` file has these variables set to defaults that assume deployment with `docker-compose` on the same network that Kong is deployed. However, if this is not the case for your planned deployment of Collector App, please adjust the variables in the `docker-compose.yml` file, or specify the values of the variables with `docker-compose up`:
```ENVVAR=somevalue ENVVAR=anothervalue docker-compose up```

1. **KONG_PROTOCOL**: The protocol that the Kong Admin API can be reached at. The possible values are http or https.
2. **KONG_HOST**: The hostname that the Kong Admin API can be reached at. If deploying with Docker Compose, this is the name of the Kong container specified in the compose file. If Kong Admin has been exposed behind a web address, KONG_HOST must be that web address.
3. **KONG_PORT**: The port where Kong Admin can be found. Collector App requires this setting, along with KONG_PROTOCOL and KONG_HOST, to communicate with Kong Admin.
4. **KONG_ADMIN_TOKEN**: The authentication token used to validate requests for Kong Admin API, if configured.
5. **SQLALCHEMY_DATABASE_URI**: The SQLAlchemy formatted URI that points to the Postgres Database that Collector App is using as a backend. The format is: `postgresql://<USER>:<PASSWORD>@<POSTGRES-HOST>:<POSTGRES-PORT>/collector`.
6. **SLACK_WEBHOOK_URL**: The URL of the Slack channel that Immunity alert notifications should be sent to. This URL will be the default channel for alerts, but you can also add more channels and rules configuring which alerts to send to which channel. See [Adding a Slack Configuration](#adding-a-slack-configuration).


### Setting up Collector App via Docker-Compose
### Docker login
To download the bintray you will first need to docker login to Bintray to the Brain/Immunity repo
```docker login -u BINTRAY_USERNAME -p BINTRAY_API_KEY kong-docker-kong-brain-immunity-base.bintray.io```

Also login to Docker:
```docker login```
Then follow the login steps when prompted.

### Bringing up Collector App with Redis and Db
To bring up the full Collector app with its own database and Redis, run:
```
KONG_HOST={KONG HOST URL} KONG_PORT={KONG PORT} KONG_MANAGER_PORT={KONG MANAGER PORT} KONG_MANAGER_URL={KONG MANAGER URL} docker-compose -f docker-compose.yml -f with-db.yml -f with-redis.yml up -d
```

### Bringing up Collector App alone
If you already have an outside database and would not like to bring up Postgres with the Collector up, first make sure you have a Collector table in the database
```psql -U user -c "CREATE DATABASE collector;"```

If the Postgres and Redis instances are
Then you can bring up collector with:
```
SQLALCHEMY_DATABASE_URI=postgres://{POSTGRES-USER}:{POSTGRES-PASSWORD}@{POSTGRES HOST}:{POSTGRES POST}/collector CELERY_BROKER_URL={REDIS URI} docker-compose -f docker-compose.yml up -d
```

### Setting up Collector App via Helm
There is a public helm chart for setting up Collector App and all its dependencies on Kubernetes. Instructions for setup can be found on the public repo at: [https://github.com/Kong/kong-collector-helm/blob/master/README.md](https://github.com/Kong/kong-collector-helm/blob/master/README.md)

## Step 2. Set up the Collector Plugin and Kong GUI
Enable Brain and Immunity GUI changes on Kong Manager by editing the kong.conf file to have:
```
admin_gui_flags={"IMMUNITY_ENABLED":true}
```
Then restart Kong to see the changes take effect.

### Enable the Collector Plugin using the Admin API
Next, enable the Collector Plugin using the Admin API:

>(Optional) It is possible to set up the Collector Plugin to only be applied to specific routes or services. To apply the Collector Plugin to a Workspace, make this cURL request:

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
The Collector Plugin gives users the option to opt-in or out of logging HTTP request bodies with the ```config.log_bodies``` configuration variable. When set to **false**, the collector plugin will not send body content in HTTP requests to the Collector App. This is useful to prevent sensitive personal information in the request body content from being stored long term in the Collector App. The cost of not sending the request body information is that its contents will not appear in generated Swagger, nor be used for anomaly detection.  When set to **true**, the Collector Plugin will send request body content to the Collector App where it can be stored in Collector App's datastore.

### Check the Collector Plugin

The port and host are configurable, but must match the Collector App.
To confirm this step, hit one of the URLs mapped through the Collector App. For example,
```
/<workspace name>/collector/alerts
```

## Step 3: Set up with Docker Compose
>Note: Using Docker Compose is recommended to deploy Brain and Immunity, as documented in this guide. You can also use Docker Swarm or Kubernetes for deployment, although steps are not currently included in this guide.

The information you need to run the Collector App, Brain and Immunity is included in the docker-compose files. The steps in this section will start several Docker containers, including a collector, a worker, and a scheduler.

Kong provides a private Docker image that is used by the compose files. This image is distributed by Bintray, and the following is required for access:
* Your Bintray User ID
* Your Bintray API key
* A server where you want to run Brain and Immunity with Docker installed.

Your Bintray credentials are provided to you with your purchase of Kong Enterprise. If you do not have these credentials, contact **Kong Support**.

1. SSH/PuTTY into your running instance where you want to install Brain and Immunity.

2. Log into Docker, and enter the repo you have access to. For example, ```kong-docker-kong-brain-immunity-base```.

```
docker login -u <BINTRAY_USERNAME> -p <BINTRAY_API_KEY> <enter your repo here>.bintray.io
```

3. Pull down the files for Docker Compose.

```
wget https://<BINTRAY_USERNAME>:<BINTRAY_API_KEY>@kong.bintray.com/<kong-brain-immunity-base>/docker-compose.zip
```
* If successful, you should see docker-compose.zip in your current directory.

4. Unzip the package into the directory of your choice.

5. Run Docker Compose using the files to start Brain and Immunity.

```
KONG_HOST=<KONG HOST> KONG_PORT=<8001> SQLALCHEMY_DATABASE_URI=<postgres://kong@localhost:5432/collector> docker-compose -f docker-compose.yml -f with-redis.yml up
```
* If successful, you should see `docker-compose.zip` in your current directory.

* Replace KONG_HOST and KONG_PORT with the host and port of your kong admin api
   * ```KONG_HOST```: the public IP address or Hostname of the system which is running Brain
   * ```KONG_PORT```: Usually 8001, but may be set otherwise
* You are adding A postgres database


## Step 4. (Advanced Configuration) Opt-Out of HAR Redaction
**Note**: You must specifically opt-out, or turn off, HAR Redaction in order to store all of your data. The Default setting is to redact.

The Collector App default does not store body data values and attachments in traffic data. In the ```Har['postData']['text']``` field, all values are replaced with the value's type. This does not affect the performance of Brain or Immunity, however, this can impact your ability to investigate some Immunity related alerts by looking at the offending HARs that created those alerts.

If you want to store body data in the Collector App, you can do so by setting the Collector’s REDACT_BODY_DATA by updating the environment variable in docker-compose.yml or declaring it in your docker-compose up command as follows:

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
The Collector App and Kong Enterprise are up and ready to analyze incoming traffic for [alerts](/enterprise/{{page.kong_version}}/brain-immunity/alerts), [auto-generate specs](/enterprise/{{page.kong_version}}/brain-immunity/auto-generated-specs), and display your traffic visually in [Service-Map](/enterprise/{{page.kong_version}}/brain-immunity/service-map).

For any problems encountered while setting up Collector App, Collector Plugin, or configuring other aspects of Brain and Immunity, go to [troubleshooting](/enterprise/{{page.kong_version}}/brain-immunity/troubleshooting) for help debugging common problems.
