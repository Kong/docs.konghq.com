---
id: page-install-method heroku
title: Install - Heroku
header_title: Heroku
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
links:
  app: https://github.com/heroku/heroku-kong
  buildpack: https://github.com/heroku/heroku-buildpack-kong
  deploy: https://heroku.com/deploy?template=https://github.com/heroku/heroku-kong
---

Official [Heroku Kong]({{ page.links.app}}) app using the [Kong buildpack]({{ page.links.buildpack}}):

- [Deploy to Heroku]({{ page.links.deploy }})

----

### Usage:

Get started by cloning heroku-kong and deploying it to a new Heroku app.

The `serf` command must be installed locally to generate the cluster's shared secret. [Download Serf](https://www.serfdom.io/downloads.html)

```bash
git clone https://github.com/heroku/heroku-kong.git
cd heroku-kong

# Create app in Common Runtime:
heroku create my-proxy-app --buildpack https://github.com/heroku/heroku-buildpack-multi.git
# …or in a Private Space:
heroku create my-proxy-app --buildpack https://github.com/heroku/heroku-buildpack-multi.git --space my-private-space

heroku config:set KONG_CLUSTER_SECRET=`serf keygen`

# If you want to try Instaclustr Cassandra, a paid add-on
heroku addons:create instaclustr:production-light

git push heroku master
# …the first build will take approximately ten minutes; subsequent builds approx two-minutes.
```

The [Procfile](Procfile) uses [runit](http://smarden.org/runit/) to supervise all of Kong's processes defined in [Procfile.web](Procfile.web).

### Commands

To use Kong CLI in a console:

```bash
$ heroku run bash

# Run Kong in the background, so you can issue commands:
$ kong start -c $KONG_CONF
# …Kong will start & continue running in the background of this interactive console.

# Example commands:
$ kong --help
$ kong migrations list -c $KONG_CONF
$ curl http://localhost:8001/status
```

### Notes:

1. **Configuration**:

    Revise [`config/kong.yml.etlua`](config/kong.yml.etlua) to suit your application.

    See: [Kong 0.7 Configuration Reference](https://getkong.org/docs/0.7.x/configuration/)

2. **Cassandra**:

    You may connect to any Cassandra datastore accessible to your Heroku app using the `CASSANDRA_URL` config var as [documented in the buildpack](https://github.com/heroku/heroku-buildpack-kong#usage).

    Once Cassandra is attached to the app, Kong will automatically create the keyspace and run migrations.

3. **Access via [console](#commands)**:

    Make API requests to localhost with curl.

    ```bash
    $ heroku run bash
    > kong start -c $KONG_CONFIG
    > curl http://localhost:8001
    ```

4. **Kong plugins & additional Lua modules**:

    Included Plugins:

    1. [ndfd-xml-as-json](https://github.com/heroku/heroku-kong/blob/master/lib/kong/plugins/ndfd-xml-as-json): API translation, XML as JSON for [The National Digital Forecast Database](http://graphical.weather.gov/xml/)
    2. [librato-analytics](https://github.com/heroku/heroku-kong/blob/master/lib/kong/plugins/librato-analytics): Collect per-API metrics, explore, and set alerts on them with [Librato](https://elements.heroku.com/addons/librato)

5. **Using Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/latest/getting-started/quickstart).
