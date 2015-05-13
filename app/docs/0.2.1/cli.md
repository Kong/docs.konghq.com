---
title: CLI Reference
alias: /docs/latest/cli
---

# CLI Reference

Kong comes with a ***CLI*** *(Command Line Interface)* which provides you with an interface to manage your Kong nodes. Each command is run in the context of a single node, since Kong has no cluster awareness yet.

Almost every command requires access to your configuration file in order to be aware of where the NGINX working directory is located (known as the *prefix path* for those familiar with NGINX) referenced as `nginx_working_dir` in the Kong configuration file.

**Note:** If you haven't already, we recommend you read the [configuration reference][configuration-guide].

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

> For more informations regarding the NGINX signals, consult their [documentation][nginx-signals].

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

> For more informations regarding the NGINX signals, consult their [documentation][nginx-signals].

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


[configuration-guide]: /docs/{{page.kong_version}}/configuration
[nginx-signals]: http://nginx.org/en/docs/control.html
[nginx-reload]: http://wiki.nginx.org/CommandLine#Loading_a_New_Configuration_Using_Signals
