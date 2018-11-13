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

---

## Stopping Kong gracefully

Stopping kong can be achieved with a simple `kong stop` command. Yet, depending
on the environment Kong is running in, a more controlled shutdown might be
desired. To understand the differences in the many ways you can shut down Kong
we need to have a look at how the mechanism works.

The related Kong CLI commands operate by sending Unix signals to the Kong
master process (generally there is no need to interact with the worker processes
in this way). The signals used are:

  - `SIGTERM` will gracefully exit the master process, but master will in turn
    forcefully shut down the workers. So workers will abruptly close any open
    connections and exit. Yet master will properly clean up (PID files etc.).
  - `SIGQUIT` for a graceful shutdown of both the workers and master, the
    workers will finish their active connections and timers before exiting.
    Note: while exiting the workers will no longer accept new connections.
  - `SIGKILL` will forcefully exit the master process (workers may remain). None
    of the kong CLI commands will actually use this signal.

The Kong CLI commands will:

  - [`stop`](#kong-stop) will send `SIGTERM`, and hence will be forcefully
    closing active connections.
  - [`quit`](#kong-quit) will send `SIGQUIT`, and after a timeout, it will send
    `SIGTERM`. So it will complete active connections, but forcefully close (too)
    long running ones.
  - [`restart`](#kong-restart) is a combination of [`stop`](#kong-stop) and
    [`start`](#kong-start), and hence will have the [`stop`](#kong-stop)
    behavior of forcefully closing active connections.

To stop Kong without dropping any connections the following sequence can be used:

  1. Update any load balancers to no longer send any traffic to the Kong node to
     tear down.
  2. Wait for the change to be effectuated.
  3. Send a `SIGQUIT` signal to the Kong master process.
  4. Wait for Kong to exit.
  5. If step 4 takes too long to complete, send a `SIGTERM` signal to force an
     exit (this will drop the remaining active connections).

[Back to TOC](#table-of-contents)

---

### Controlled stop using the Kong CLI

When controlling Kong through the CLI, make sure you have stopped traffic from
being routed to the Kong node to tear down (steps 1 and 2 above).

Now to actually stop the Kong node steps 3 to 5 can be executed at once by the
`kong quit` command. Assuming a 10-second wait for connections to close,
execute:

```
kong quit --timeout=10
```

The output will be either `Kong stopped (gracefully)` or
`Timeout, Kong stopped forcefully`, depending on whether the timeout was hit.

[Back to TOC](#table-of-contents)

---

### Controlled stop using Docker commands

Similar to working with the CLI, make sure you have stopped traffic from
being routed to the Kong container to tear down (steps 1 and 2 above).

When using `docker stop` to stop a container, Docker will by default use the
`SIGTERM` signal, and an addition `SIGKILL` after a timeout. Since this will drop
active connections when used with Kong we have
to use a different way to send `SIGQUIT` (step 3). This can be done with the
`docker kill` command:

```
docker kill ----signal=SIGQUIT [container id]
```

Now, if after the timeout (step 4), the container hasn't exited yet, use the
following command to forcefully shut it down:

```
docker kill [container id]
```

Note: You can also execute the Kong CLI commands inside the docker container of
course. Execute `docker exec -it [container id] kong quit --timeout=10`. See
[Controlled stop using the Kong CLI](#controlled-stop-using-the-kong-cli).

[Back to TOC](#table-of-contents)

---

### Controlled stop using orchestration tools (eg. Kubernetes)

For the purpose of explaining it, we'll assume Kubernetes as the orchestration
tool, but other tools act similarly.

The first problem is that Kubernetes will send a `SIGTERM` signal to the
container to instruct it to exit. This will cause workers to forcefully exit
and drop connections.

An additional problem is that when removing a workload (Pod) from a Kubernetes
cluster, we do not control the load balancers. So when we delete a Pod,
Kubernetes will update it datastore and start tearing down the Pod right away.
Because of the eventual-consistent nature of Kubernetes, chances are pretty high
the Pod gets torn down before the load balancers, services, etc. have been
updated. Hence this might lead to dropped connections, as Kong will not accept
those last connections send its way (after it received the `SIGTERM` or
`SIGQUIT` signal).

Here's what we have to work with:

  - the [`terminationGracePeriodSeconds`](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/)
    property contains the Kubernetes timeout
    after which it will forcefully tear down the container.
  - Kubernetes will send a `SIGTERM` to the container to instruct it to exit.
  - Before sending `SIGTERM` it will run the [`PreStop`](https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/)
    hook (synchronously, so the signal will be sent after the `PreStop` hook
    completed) 

In the `PreStop` hook, we can inject the additional required delay (step 2) as
well as send the `SIGQUIT` signal (or run `kong quit`) to gracefully exit Kong.

So add a simple script like this (`/graceful-exit.sh`) to the container:

```
#!/bin/sh

sleep 3
kong quit --timeout=10
```

With this in place we can define a `PreStop` hook for our container like this:

```
            preStop:
              exec:
                command: ["/graceful-exit.sh"]
```

This will now wait for 3 seconds for the Kubernetes load balancers and services
to catch up, and then do a graceful shutdown for 10 seconds before forcefully
stopping Kong.

One thing to keep in mind here is that the combined timeout (13 seconds in the
example above), should be less than the Kubernetes timeout defined in
`terminationGracePeriodSeconds`. If not, Kubernetes will forcefully tear down
the container, and hence close the last active connections earlier than expected.

[Back to TOC](#table-of-contents)

[configuration-reference]: /{{page.kong_version}}/configuration
