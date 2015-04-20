---
title: CLI Reference
---

# CLI Reference

Kong comes with a ***Command Line Interface*** (refered to as "CLI") which lets you perform operations such as starting and stopping a node. Each command is run in the context of a single node, since Kong as no cluster awareness yet.

Almost every CLI command needs access to your configuration file in order to be aware of what is your node's NGiNX working directory, (known as the "prefix path" for those familiar with NGiNX), and referenced as `nginx_working_dir` in your Kong configuration file.

**Note:** If you haven't already, we recommand you to read the [configuration guide][configuration-guide].

---

## kong

The CLI's entry point is the `kong` command. Print its help message by invoking:

```bash

$ kong --help
```

Like many other CLI tools, the second parameter will be the command you want to perform:

```bash
$ kong <command>
```

To print the help message of any command, execute:

```bash
$ kong <command> --help
```

---

## start

  The first command you are likely to execute will be `start`. As you would expect, it starts a Kong node on your current machine using a configuration file.

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
  4. The NGiNX configuration specified in Kong's configuration (`nginx` property) will be used to spawn NGiNX workers, and those will use the working directory specified in your configuration (`nginx_working_directory`).

  If everything went well, you should see a successful message (`[OK] Started`).

##### Specifying a configuration

  To override the default configuration, either place one at `/etc/kong/kong.yml`, or specify a file as an argument, like this:

  ```bash
  $ kong start -c <path_to_config>
  ```

##### Congrats!

  Kong is now running and listening on two ports, which are by default:

  - `8000`, that will be used to process the API requests.
  - `8001`, called admin port, provides the Kong's internal RESTful API that you can use to operate Kong, and should be private and firewalled.

---

## stop

  This command executes a fast shutdown of Kong. It is actually a wrapper aroung the NGiNX `stop` signal:

  ```bash
  $ kong stop
  ```

  In order to stop an instance, the CLI needs to know what is the working directory of your process. If you started Kong with a certain configuration file, you must stop it with the same one. Thus, the stop command also accepts a configuration option:

  ```bash
  $ kong stop -c <path_to_config>
  ```

  If Kong stopped successfully, you should see a successful message (`[OK] Stopped`).

  > For more informations regarding the NGiNX signals, consult their [documentation][nginx-signals].

---

## quit

  `quit` performs a graceful shutdown of Kong. Like `stop`, it is a wrapper arround the NGiNX `quit` signal:

  ```bash
  $ kong quit
  ```

  And for the same reasons as `stop`, it also accepts a configuration option:

  ```bash
  $ kong quit -c <path_to_config>
  ```

  > For more informations regarding the NGiNX signals, consult their [documentation][nginx-signals].

---

## restart

  This command simply sends Kong a `stop` signal, followed by a `start` signal. If Kong was not running prior to the command, it will simply start it:

  ```bash
  $ kong restart [-c path_to_config]
  ```

---

## reload

  Very handy, this command will allow you to change your configuration at runtime, without any downtime. It takes advantage of NGiNX's [reload](http://wiki.nginx.org/CommandLine#Loading_a_New_Configuration_Using_Signals) signal to spawn new workers with the new configuration, while killing the old ones.

  ```bash
  $ kong reload [-c path_to_config]
  ```

[configuration-guide]: /docs/{{page.kong_version}}/configuration
[nginx-signals]: http://nginx.org/en/docs/control.html
