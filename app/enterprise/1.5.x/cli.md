---
title: CLI Reference
---

## Introduction

The provided CLI (*Command Line Interface*) allows you to start, stop, and
manage your Kong instances. The CLI manages your local node (as in, on the
current machine).

If you haven't yet, we recommend you read the [configuration reference][configuration-reference].

## Global flags

All commands take a set of special, optional flags as arguments:

* `--help`: print the command's help message
* `--v`: enable verbose mode
* `--vv`: enable debug mode (noisy)

[Back to top](#introduction)

## Available commands


### kong check

```
Usage: kong check <conf>

Check the validity of a given Kong configuration file.

<conf> (default /etc/kong/kong.conf) configuration file

```

[Back to top](#introduction)

---



### kong config

```
Usage: kong config COMMAND [OPTIONS]

Use declarative configuration files with Kong.

The available commands are:
  init                                Generate an example config file to
                                      get you started.

  db_import <file>                    Import a declarative config file into
                                      the Kong database. db_import supports
                                      most Admin API entities except for Admins,
                                      RBAC users, roles, and permissions.

  parse <file>                        Parse a declarative config file (check
                                      its syntax) but do not load it into Kong.

Options:
 -c,--conf        (optional string)   Configuration file.
 -p,--prefix      (optional string)   Override prefix directory.

```

*Note:* `db_export` is not currently supported in Kong Enterprise.

[Back to top](#introduction)

---


### kong health

```
Usage: kong health [OPTIONS]

Check if the necessary services are running for this node.

Options:
 -p,--prefix      (optional string) prefix at which Kong should be running

```

[Back to top](#introduction)

---


### kong migrations

```
Usage: kong migrations COMMAND [OPTIONS]

Manage database schema migrations.

The available commands are:
  bootstrap                         Bootstrap the database and run all
                                    migrations.

  up                                Run any new migrations.

  finish                            Finish running any pending migrations after
                                    'up'.

  list                              List executed migrations.

  reset                             Reset the database.

  migrate-apis                      Migrates API entities to Routes and
                                    Services.

  migrate-community-to-enterprise   Migrates Kong Community entities to Kong Enterprise in the default
                                    workspace

Options:
 -y,--yes                           Assume "yes" to prompts and run
                                    non-interactively.

 -q,--quiet                         Suppress all output.

 -f,--force                         Run migrations even if database reports
                                    as already executed.

 --db-timeout     (default 60)      Timeout, in seconds, for all database
                                    operations (including schema consensus for
                                    Cassandra).

 --lock-timeout   (default 60)      Timeout, in seconds, for nodes waiting on
                                    the leader node to finish running
                                    migrations.

 -c,--conf        (optional string) Configuration file.


```

[Back to top](#introduction)

---


### kong prepare

This command prepares the Kong prefix folder, with its sub-folders and files.

```
Usage: kong prepare [OPTIONS]

Prepare the Kong prefix in the configured prefix directory. This command can
be used to start Kong from the nginx binary without using the 'kong start'
command.

Example usage:
 kong migrations up
 kong prepare -p /usr/local/kong -c kong.conf
 nginx -p /usr/local/kong -c /usr/local/kong/nginx.conf

Options:
 -c,--conf       (optional string) configuration file
 -p,--prefix     (optional string) override prefix directory
 --nginx-conf    (optional string) custom Nginx configuration template

```

[Back to top](#introduction)

---


### kong quit

```
Usage: kong quit [OPTIONS]

Gracefully quit a running Kong node (Nginx and other
configured services) in given prefix directory.

This command sends a SIGQUIT signal to Nginx, meaning all
requests will finish processing before shutting down.
If the timeout delay is reached, the node will be forcefully
stopped (SIGTERM).

Options:
 -p,--prefix      (optional string) prefix Kong is running at
 -t,--timeout     (default 10) timeout before forced shutdown
 -w,--wait        (default 0) wait time before initiating the shutdown

```

[Back to top](#introduction)

---


### kong reload

```
Usage: kong reload [OPTIONS]

Reload a Kong node (and start other configured services
if necessary) in given prefix directory.

This command sends a HUP signal to Nginx, which will spawn
new workers (taking configuration changes into account),
and stop the old ones when they have finished processing
current requests.

Options:
 -c,--conf        (optional string) configuration file
 -p,--prefix      (optional string) prefix Kong is running at
 --nginx-conf     (optional string) custom Nginx configuration template

```

[Back to top](#introduction)

---


### kong restart

```
Usage: kong restart [OPTIONS]

Restart a Kong node (and other configured services like Serf)
in the given prefix directory.

This command is equivalent to doing both 'kong stop' and
'kong start'.

Options:
 -c,--conf        (optional string)   configuration file
 -p,--prefix      (optional string)   prefix at which Kong should be running
 --nginx-conf     (optional string)   custom Nginx configuration template
 --run-migrations (optional boolean)  optionally run migrations on the DB
 --db-timeout     (default 60)
 --lock-timeout   (default 60)

```

[Back to top](#introduction)

---

### kong runner

```
Usage: kong runner [file] [args]

Execute a lua file in a kong node. the `kong` variable is available to
reach the DAO, PDK, etc. The variable `args` can be used to access all
arguments (args[1] being the lua filename bein run).

Example usage:
  kong runner file.lua arg1 arg2
  echo 'print("foo")' | kong runner

```
[Back to top](#introduction)


### kong start

```
Usage: kong start [OPTIONS]

Start Kong (Nginx and other configured services) in the configured
prefix directory.

Options:
 -c,--conf        (optional string)   Configuration file.

 -p,--prefix      (optional string)   Override prefix directory.

 --nginx-conf     (optional string)   Custom Nginx configuration template.

 --run-migrations (optional boolean)  Run migrations before starting.

 --db-timeout     (default 60)        Timeout, in seconds, for all database
                                      operations (including schema consensus for
                                      Cassandra).

 --lock-timeout   (default 60)        When --run-migrations is enabled, timeout,
                                      in seconds, for nodes waiting on the
                                      leader node to finish running migrations.

```

[Back to top](#introduction)

---


### kong stop

```
Usage: kong stop [OPTIONS]

Stop a running Kong node (Nginx and other configured services) in given
prefix directory.

This command sends a SIGTERM signal to Nginx.

Options:
 -p,--prefix      (optional string) prefix Kong is running at

```

[Back to top](#introduction)

---


### kong version

```
Usage: kong version [OPTIONS]

Print Kong's version. With the -a option, will print
the version of all underlying dependencies.

Options:
 -a,--all         get version of all dependencies

```

[Back to top](#introduction)

---


[configuration-reference]: /enterprise/{{page.kong_version}}/property-reference/
