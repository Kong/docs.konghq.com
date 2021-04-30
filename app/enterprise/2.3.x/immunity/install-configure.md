---
title: Kong Immunity Installation and Configuration
toc: true
redirect_from:
  - /enterprise/2.2.x/brain-immunity/install-configure
---

## Introduction
Kong Immunity (Immunity) is installed on Kong Enterprise, either on Kubernetes or Docker, as defined below. Immunity uses the Collector App and Collector Plugin to communicate with Kong Enterprise.

{% include /md/enterprise/download/immunity.md version='>2.1' %}

### Step 2. Confirm the Kong EE Docker Network is available
Confirm the Kong Enterprise network is available, which is the network you set up when installing Kong Enterprise on Docker named `kong-ee-net`.

1. Run the the Docker `ls` command to list available networks. The list should show `kong-ee-net`.
```bash
$ docker network ls
```

2. If the results do not show `kong-ee-net`, create the network:
```bash
$ docker network create kong-ee-net
```

### Step 3. Start a Postgres Database
Start a PostgreSQL database:
```bash
$ docker run -d --name collector-database \
  --hostname collector-database \
  --network=kong-ee-net \
  -e "POSTGRES_USER=collector" \
  -e "POSTGRES_DB=collector" \
  -e "POSTGRES_PASSWORD=collector" \
  postgres:12
```

### Step 4. Start a Redis Database
Start a Redis database:
```bash
$ docker run -d --name redis \
  --hostname redis \
  --network=kong-ee-net \
  -p 6379 \
  redis:5.0-alpine
```

### Step 5. Prepare the Collector Database
Prepare the Collector database:
```bash
docker run --rm --network=kong-ee-net \
  -e "SQLALCHEMY_DATABASE_URI=postgres://collector:collector@collector-database:5432/collector" \
  kong-immunity \
  flask db upgrade
```

### Step 6. Start Kong Collector App
Start Kong Collector:

```bash
$ docker run -d --name collector \
  --hostname collector \
  --network=kong-ee-net \
  -p 5000:5000 \
  -e "CELERY_BROKER_URL=redis://redis:6379/0" \
  -e "SQLALCHEMY_DATABASE_URI=postgres://collector:collector@collector-database:5432/collector" \
  -e "KONG_HOST=kong-ee" \
  -e "KONG_PORT=8001" \
  kong-immunity
```

### Step 7. Start the Scheduler and Worker
Start the scheduler and worker.

1. Start `celery-beat`:
```bash
$ docker run -d --name celery-beat \
  --network=kong-ee-net \
  -e "CELERY_BROKER_URL=redis://redis:6379/0" \
  kong-immunity \
  celery beat -l info -A collector.scheduler.celery
```

2. Start `celery-worker`:
```bash
$ docker run -d --name celery-worker \
  --network=kong-ee-net \
  -e "CELERY_BROKER_URL=redis://redis:6379/0" \
  -e "SQLALCHEMY_DATABASE_URI=postgres://collector:collector@collector-database:5432/collector" \
  -e "KONG_HOST=kong-ee" \
  -e "KONG_PORT=8001" \
  kong-immunity \
  celery worker -l info -A collector.scheduler.celery --concurrency=1
```

### Step 8. Validate the Collector App Installation
To complete the Collector App installation, validate the Collector App is working:
```bash
curl -i -X GET --url http://localhost:5000/status
```
You should receive an HTTP/1.1 200 OK message.


### Step 9. Enable and Configure the Collector Plugin

{% navtabs %}
{% navtab Using Kong Manager %}

Using Kong Manager, enable the Collector Plugin. To enable the plugin:
1. Navigate to the **Workspaces** page.
2. Click the workspace you want to use. For example, the **default** workspace.
3. Click **Plugins** in the API Gateway section of the left navigation bar.
4. Click **New Plugin** which opens a page of plugin options.
5. Scroll to the Analytics and Monitoring section, and click **Enable** on the
**Collector** tile.
6. The **Create new collector plugin** dialog displays. To **minimally**
configure the Collector Plugin:

    * In the **Config.Http Endpoint** field, enter the Collector App endpoint
    that Kong Enterprise can communicate with. For example,
    `http://collector:5000`.
    * The default values populating the remaining fields are valid for a
    minimal configuration.

7. Click **Create**. The Collector Plugin is configured.

{% endnavtab %}
{% navtab Using Kong Admin API %}

Using a cURL command, enter:
```bash
$ curl -X POST localhost:8001/default/plugins \
    -d name=collector \
    -d config.http_endpoint=http://collector:5000
```

Substitute `default` for your own workspace name.

{% endnavtab %}
{% endnavtabs %}

### Step 10. Confirm the Collector Plugin is Enabled and Configured

{% navtabs %}
{% navtab Using Kong Manager %}

Click **Alerts** in the left navigation pane. The Alerts page should say
**Collector is connected**.

{% endnavtab %}
{% navtab Using Kong Admin API %}

Using a cURL command, enter:
```bash
$ curl localhost:8001/default/collector/status
```

Substitute `default` for your own workspace name.

{% endnavtab %}
{% endnavtabs %}

## Summary
The Collector App is installed and the Collector Plugin is enabled on Kong Enterprise. You are now ready to analyze incoming traffic for [alerts](/enterprise/{{page.kong_version}}/immunity/alerts).

For any issues encountered when setting up Collector App, Collector Plugin, or configuring other aspects of Immunity, see [troubleshooting](/enterprise/{{page.kong_version}}/immunity/troubleshooting) for help debugging common problems.
