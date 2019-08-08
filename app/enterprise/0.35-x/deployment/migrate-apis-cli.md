---
title: Migrating APIs to Services and Routes
---

## Overview

The command `kong migrations migrate-apis` will, by default, migrate APIs
with bundled plugins to Routes and Services, but it will skip migrating
any API with a custom plugin. To migrate APIs with custom plugins you can
add the `-f` or `--force` option. The verbose (debug) option, `--vv`, will also
output each SQL transaction when executing migrations with Postgres.


### Prerequisites for Migrating APIs to Services and Routes

* You must be on Kong Enterprise 0.34-X

### kong migrations command usage

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

Options:
 -y,--yes                           Assume "yes" to prompts and run
                                    non-interactively.

 -q,--quiet                         Suppress all output.

 -f,--force                         Run migrations even if database reports
                                    as already executed.

                                    With 'migrate-apis' command, it also forces
                                    migration of APIs that have custom plugins
                                    applied, and which are otherwise skipped.

 --db-timeout     (default 60)      Timeout, in seconds, for all database
                                    operations (including schema consensus for
                                    Cassandra).

 --lock-timeout   (default 60)      Timeout, in seconds, for nodes waiting on
                                    the leader node to finish running
                                    migrations.

 -c,--conf        (optional string) Configuration file.
 --v              verbose
 --vv             debug

```

See more `kong` commands in the [Enterprise CLI reference](/enterprise/{{page.kong_version}}/cli/)
