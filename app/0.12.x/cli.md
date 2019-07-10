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

[Back to TOC](#table-of-contents)

## Available commands

### kong check

```
Usage: kong check <conf>

Check the validity of a given Kong configuration file.

<conf> (default /etc/kong.conf or /etc/kong/kong.conf) configuration file
```

[Back to TOC](#table-of-contents)

---

### kong prepare

This command prepares the Kong prefix folder, with its sub-folders and files.

```
Usage: kong prepare [OPTIONS]

Prepare the Kong prefix in the configured prefix directory. This command can
be used to start Kong from the nginx binary without using the 'kong start'
command.

Example usage:
  kong prepare -p /usr/local/kong -c kong.conf && kong migrations up &&
    nginx -p /usr/local/kong -c /usr/local/kong/nginx.conf

Options:
 -c,--conf    (optional string) configuration file
 -p,--prefix  (optional string) override prefix directory
 --nginx-conf (optional string) custom Nginx configuration template
```

[Back to TOC](#table-of-contents)

---

### kong health

```
Usage: kong health [OPTIONS]

Check if the necessary services are running for this node.

Options:
  -p,--prefix (optional string) prefix at which Kong should be running
```

[Back to TOC](#table-of-contents)

---

### kong migrations

```
Usage: kong migrations COMMAND [OPTIONS]

Manage Kong's database migrations.

The available commands are:
  list   List migrations currently executed.
  up     Execute all missing migrations up to the latest available.
  reset  Reset the configured database (irreversible).

Options:
  -c,--conf (optional string) configuration file
```

[Back to TOC](#table-of-contents)

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
  -p,--prefix  (optional string) prefix Kong is running at
  -t,--timeout (default 10) timeout before forced shutdown
```

[Back to TOC](#table-of-contents)

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
  -c,--conf    (optional string) configuration file
  -p,--prefix  (optional string) prefix Kong is running at
  --nginx-conf (optional string) custom Nginx configuration template
```

[Back to TOC](#table-of-contents)

---

### kong restart

```
Usage: kong restart [OPTIONS]

Restart a Kong node in the given prefix directory.

This command is equivalent to doing both 'kong stop' and
'kong start'.

Options:
  -c,--conf        (optional string)   configuration file
  -p,--prefix      (optional string)   prefix at which Kong should be running
  --nginx-conf     (optional string)   custom Nginx configuration template
  --run-migrations (optional boolean)  optionally run migrations on the DB
```

[Back to TOC](#table-of-contents)

---

### kong start

```
Usage: kong start [OPTIONS]

Start Kong (Nginx and other configured services) in the configured
prefix directory.

Options:
  -c,--conf        (optional string)   configuration file
  -p,--prefix      (optional string)   prefix at which Kong should be running
  --nginx-conf     (optional string)   custom Nginx configuration template
  --run-migrations (optional boolean)  optionally run migrations on the DB
```

[Back to TOC](#table-of-contents)

---

### kong stop

```
Usage: kong stop [OPTIONS]

Stop a running Kong node (Nginx and other configured services) in given
prefix directory.

This command sends a SIGTERM signal to Nginx.

Options:
  -p,--prefix (optional string) prefix Kong is running at
```

[Back to TOC](#table-of-contents)

---

### kong version

```
Usage: kong version [OPTIONS]

Print Kong's version. With the -a option, will print
the version of all underlying dependencies.

Options:
  -a,--all    get version of all dependencies
```

[Back to TOC](#table-of-contents)

[configuration-reference]: /{{page.kong_version}}/configuration
