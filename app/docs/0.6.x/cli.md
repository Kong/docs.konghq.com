---
title: CLI Reference
---

# CLI Reference

Kong comes with a ***CLI*** *(Command Line Interface)* which provides you with an interface to manage your Kong nodes. Each command is run in the context of a single node, since Kong has no cluster awareness yet.

Almost every command requires access to your configuration file in order to be aware of where the NGINX working directory is located (known as the *prefix path* for those familiar with NGINX) referenced as `nginx_working_dir` in the Kong configuration file. If you haven't already, we recommend you read the [configuration reference][configuration-guide].

## Summary

- 1. [kong][1]
- 2. [start][2]
- 3. [stop][3]
- 4. [quit][4]
- 5. [restart][5]
- 6. [reload][6]
- 7. [status][7]
- 8. [migrations][8]
- 9. [cluster][9]

[1]: #kong
[2]: #start
[3]: #stop
[4]: #quit
[5]: #restart
[6]: #reload
[7]: #status
[8]: #migrations
[9]: #cluster

---

## kong

```bash
$ kong [options] <command> [parameters]
```

**Note** For help information on a specific command use the `--help` parameter: `kong <command> --help`

### Options

* `--help` - Outputs help information
* `--version` - Outputs kong version

---

## start

Starts a Kong instance.

```bash
$ kong start [parameters]
```

### Parameters

#### -c \<configuration file path>

Kong Configuration File

When no configuration file is provided as an argument, Kong by default will attempt to load the a configuration file at `/etc/kong/kong.yml`.
Should no configuration file exist at that location Kong will load the default configuration stored internally.

This file contains configuration for plugins, the datastore, and NGINX. You can read more about this file in the [configuration guide][configuration-guide].

---

## stop

Terminates a Kong instance by firing the NGINX `stop` signal. This will execute a fast shutdown.

```bash
$ kong stop [parameters]
```

> For more information regarding the NGINX signals, consult their [documentation][nginx-signals].

### Parameters

#### -c \<configuration file path>

Kong Configuration File

Passing the Kong configuration file path *allows the termination of specific instance*, should you not pass the configuration file location, the command will
default to the configuration at `/etc/kong/kong.yml` or its internal default configuration.

---

## quit

Gracefully stops a Kong instance by firing the NGINX `quit` signal.

```bash
$ kong quit [parameters]
```

> For more information regarding the NGINX signals, consult their [documentation][nginx-signals].

### Parameters

#### -c \<configuration file path>

Kong Configuration File

Passing the Kong configuration file path *allows the termination of specific instance*, should you not pass the configuration file location, the command will
default to the configuration at `/etc/kong/kong.yml` or its internal default configuration.

---

## restart

This command sends NGINX a `stop` signal, followed by a `start` signal. If Kong was not running prior to the command, it will attempt to start it:

```bash
$ kong restart [parameters]
```

### Parameters

#### -c \<configuration file path>

Kong Configuration File

When no configuration file is provided as an argument, Kong by default will attempt to load the a configuration file at `/etc/kong/kong.yml`.
Should no configuration file exist at that location Kong will load the default configuration stored internally.

This file contains configuration for plugins, the datastore, and NGINX. You can read more about this file in the [configuration guide][configuration-guide].

---

## reload

Reloads the NGINX configuration at runtime and avoids potential downtime by leveraging the NGINX [reload][nginx-reload] signal.

```bash
$ kong reload [parameters]
```

### Parameters

#### -c \<configuration file path>

Kong Configuration File

---

## status

When Kong is started, also third-party services required by Kong are started along with it (like dnsmasq). This command checks that all the services required by Kong are running.

If one of these services fails, it will bring Kong to an unstable state and a [`kong restart`](#restart) is recommended to be executed.

```bash
$ kong status
```

### Parameters

#### -c \<configuration file path>

Kong Configuration File

When no configuration file is provided as an argument, Kong by default will attempt to load the a configuration file at `/etc/kong/kong.yml`.
Should no configuration file exist at that location Kong will load the default configuration stored internally.

This file contains configuration for plugins, the datastore, and NGINX. You can read more about this file in the [configuration guide][configuration-guide].

---

## migrations

Run the datastore migrations (incremental changes to the datastore's schema).

It can either run Kong core's migrations, plugin by plugin, or all at the same time. Migrations can either run "up" or "down". Up means it will prepare the datastore (create necessary tables, etc...). Down means it will revert any previous "up" step.

```bash
$ kong migrations [parameters] [list|up|down|reset]
```

### Parameters

#### -c \<configuration file path>

Kong Configuration File

When no configuration file is provided as an argument, Kong by default will attempt to load the a configuration file at `/etc/kong/kong.yml`.
Should no configuration file exist at that location Kong will load the default configuration stored internally.

This file contains configuration for plugins, the datastore, and NGINX. You can read more about this file in the [configuration guide][configuration-guide].

#### -t \<type>

Default: `all`

When running the `up` or `down` commands, specify `core` or `plugin_name` to only run specific migrations.

### Commands

- **list**: list migrations already executed (for which the datastore has been prepared).
- **up**: execute all migrations for the given type.
- **down**: revert the latest executed migration for the given type. **This operation is desctructive**.
- **reset**: reset your keyspace. **This operation is desctructive**.

---

## cluster

Manage the Kong cluster.

```bash
$ kong cluster [parameters] [members|force-leave|reachability|keygen]
```

### Parameters

#### -c \<configuration file path>

Kong Configuration File

When no configuration file is provided as an argument, Kong by default will attempt to load the a configuration file at `/etc/kong/kong.yml`.
Should no configuration file exist at that location Kong will load the default configuration stored internally.

This file contains configuration for plugins, the datastore, and NGINX. You can read more about this file in the [configuration guide][configuration-guide].

#### -t \<type>

### Commands

- **members**: shows a list of members in the cluster and their state.
- **force-leave [node_name]**: when a node is in a `failed` state, this operation forcebly removes the node from the cluster. Remembers to use the `node_name` and not its address.
- **reachability**: performs a basic network reachability test. The local node will gossip out a "ping" message and request that all other nodes acknowledge delivery of the message.
- **keygen**: generates an encryption key that can be used for Kong intracluster traffic encryption with other nodes (see `encrypt` property in the [cluster settings][cluster]). The keygen command uses a cryptographically strong pseudo-random number generator to generate the key.

[configuration-guide]: /docs/{{page.kong_version}}/configuration
[nginx-signals]: http://nginx.org/en/docs/control.html
[nginx-reload]: http://wiki.nginx.org/CommandLine#Loading_a_New_Configuration_Using_Signals
[cluster_listen]: /docs/{{page.kong_version}}/configuration/#cluster_listen
[cluster]: /docs/{{page.kong_version}}/configuration/#cluster
