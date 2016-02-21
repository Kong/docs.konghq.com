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

    The Heroku app must have several [config vars, as defined in the buildpack](https://github.com/heroku/heroku-buildpack-kong#usage).

    Kong is automatically configured at runtime with the `.profile.d/kong-12f.sh` script, which:
      
    1. renders the `config/kong.yml` file
    2. exports environment variables (see: `.profile.d/kong-env` in a running dyno)

    Revise [`config/kong.yml.etlua`](config/kong.yml.etlua) to suite your application.

    See: [Kong 0.6 Configuration Reference](https://getkong.org/docs/0.6.x/configuration/)

2. **Cassandra**:

    You may connect to any Cassandra datastore accessible to your Heroku app using the `CASSANDRA_URL` config var as [documented in the buildpack](https://github.com/heroku/heroku-buildpack-kong#usage).

    Once Cassandra is attached to the app, Kong will automatically create the keyspace and run migrations.

    If you find that initial keyspace setup is required. Use [`cqlsh`](http://docs.datastax.com/en/cql/3.1/cql/cql_reference/cqlsh.html) to run [CQL](https://cassandra.apache.org/doc/cql3/CQL-2.1.html) queries:

    ```bash
    $ CQLSH_HOST={SINGLE_IC_CONTACT_POINT} cqlsh --cqlversion 3.2.1 -u {IC_USER} -p {IC_PASSWORD}
    > CREATE KEYSPACE IF NOT EXISTS kong WITH replication = {'class':'NetworkTopologyStrategy', 'US_EAST_1':3};
    > GRANT ALL ON KEYSPACE kong TO iccassandra;
    > exit
    ```

    Then, initialize DB schema [using a console](#commands):

    ```bash
    $ kong migrations reset -c $KONG_CONF
    ```

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
