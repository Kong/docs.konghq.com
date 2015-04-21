---
title: CLI Reference
---

# CLI Reference

Kong comes with a ***Command Line Interface*** *(CLI)* which lets you perform operations such as starting and stopping Kong. Each command is run in the context of a single node, since Kong has no cluster awareness yet.

Almost every CLI command requires access to your configuration file in order to be aware of where the NGINX working directory is located (known as the "prefix path" for those familiar with NGINX), and referenced as `nginx_working_dir` in the Kong configuration file.

**Note:** If you haven't already, we recommand you to read the [configuration guide][configuration-guide].

---

## kong

The CLI's entry point is the `kong` command. View the usage info by typing:

```bash

$ kong --help
```

Like many other CLI tools, the second parameter will be the command you want to perform:

```bash
$ kong <command>
```

To print the usage info of any command, execute:

```bash
$ kong <command> --help
```

---

## start

Starts a Kong instance.

```bash
$ kong start
```

> **This command deserves a little more explanations about what happens when it's being run:**
>
1. First, if no configuration was provided as an argument (as in our example above) it will simply try to load a configuration at `/etc/kong/kong.yml`.
>
2. If you did not put a configuration at `/etc/kong/kong.yml`, you will be fine! Kong will load a default configuration.
>
3. Kong will try to connect to your configured datastore (most likely your Cassandra instance). If the connection is successful, Kong will prepare your database and make itself at home.
>
4. The NGINX configuration specified in Kong's configuration (`nginx` property) will be used to spawn NGINX workers, and those will use the working directory specified in your configuration (`nginx_working_directory`).

If everything went well, you should see a successful message (`[OK] Started`).

##### Specifying a configuration

To override the default configuration, either place one at `/etc/kong/kong.yml`, or specify a file as an argument, like this:

```bash
$ kong start -c <path_to_config>
```

##### Congrats!

Kong is now running and listening on two ports, which are by default:

- `8000`, that will be used to process the API requests.
- `8001`, called admin port which provides the Kong's internal RESTful API that you can use to operate Kong.

---

## stop

Terminates a Kong instance by firing the NGINX `stop` signal. This will execute a fast shutdown.

```bash
$ kong stop
```

To stop a specific instance, the CLI requires knowledge of the instances working directory. You can do this referencing the configuration file you used to start your Kong instance:

```bash
$ kong stop -c <path_to_config>
```

If Kong stopped successfully, you should see a successful message (`[OK] Stopped`).

> For more informations regarding the NGINX signals, consult their [documentation][nginx-signals].

---

## quit

Gracefully stops a Kong instance by firing the NGINX `quit` signal.

```bash
$ kong quit
```

For the same reasons as `stop`, it also accepts a configuration option:

```bash
$ kong quit -c <path_to_config>
```

> For more informations regarding the NGINX signals, consult their [documentation][nginx-signals].

---

## restart

This command simply sends NGINX a `stop` signal, followed by a `start` signal. If Kong was not running prior to the command, it will simply start it:

```bash
$ kong restart [-c path_to_config]
```

---

## reload

Reloads the NGINX configuration at runtime and avoids potential downtime by leveraging the NGINX [reload](http://wiki.nginx.org/CommandLine#Loading_a_New_Configuration_Using_Signals) signal.

```bash
$ kong reload [-c path_to_config]
```

[configuration-guide]: /docs/{{page.kong_version}}/configuration
[nginx-signals]: http://nginx.org/en/docs/control.html
