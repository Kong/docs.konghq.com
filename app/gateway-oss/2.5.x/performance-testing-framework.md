---
title: Performance Testing Framework
---

## Introduction

Kong codebase includes a performance testing framework (hereinafter called the “framework").
It allows Kong developers and users to evaluate performance of Kong itself,
bundled or custom plugins, as well as plot framegraphs to debug performance bottleneck.
The framework collects RPS (request per second) and latencies of Kong processing the request
to represent performance metrics under different workloads.

The framework is implemented as an extension to Kong's intergration test suite.

## Installation

The frameworks uses [busted](https://olivinelabs.com/busted/) and some
Lua development dependencies of Kong. To setup the environment,
run `make dev` under Kong repository to install all Lua dependencies.

[Back to top](#introduction)

## Drivers

Three "drivers" are implemented depending on different environment, accuracy
requirement and difficulty to setup.

| Driver   | Test between git commits | Test between binary releases | Flamegraph | Test unreleased version |
|----------|--------------------------|------------------------------|------------|-------------------------|
| local    | yes                      |                              | yes        | yes                     |
| docker   | yes                      | yes                          |            |                         |
|terraform | yes                      | yes                          | yes        |                         |

- **local** driver reuses users' local environment, it's faster to run.
But the RPS and latency number may be influenced by other local programs and thus inaccurate.

    * Requires Lua development dependencies of Kong, OpenResty and wrk to be installed.
    * Requires SystemTap, kernel headers and build chain to be installed if generating flamegraph.

- **docker** driver is solely based on Docker images, it's most convenient to setup
as it requires less dependency. But it may also influenced by other local programs
and docker network performance. And it doesn't support flamegraph generation.

- **terraform** driver runs in remote VM or bare metal machine, it's thus most accurate.
But it requires terraform knowledge to operate and setup.

    * Requires [terraform](https://www.terraform.io/downloads.html) binary to be installed.
    * Requires git binary if testing between git commits. When testing between git commits,
    the framework assumes the current directory is Kong's repo. It will stash your working
    directory and unstash after test is finished. When using docker or terraform driver,
    the framework derives the base version of each commit and uses matching Docker image or
    Kong binary package and pours local source code inside.

[Back to top](#introduction)

## Workflow

Like Kong's integration tests, the performance test is written in Lua. Several
test cases can share the same Lua file.

Following code demonstrates a basic workflow for defining a workload and load test Kong.

```
local perf = require("spec.helpers.perf")

perf.use_driver("docker")

local versions = { "git:master", "2.4.0" }

for _, version in ipairs(versions) do
  describe("perf test for Kong " .. version .. " #simple #no_plugins", function()
    local bp
    lazy_setup(function()
      local helpers = perf.setup()

      bp = helpers.get_db_utils("postgres", {
        "routes",
        "services",
      })

      local upstream_uri = perf.start_upstream([[
      location = /test {
        return 200;
      }
      ]])

      local service = bp.services:insert {
        url = upstream_uri .. "/test",
      }

      bp.routes:insert {
        paths = { "/s1-r1" },
        service = service,
        strip_path = true,
      }
    end)

    before_each(function()
      perf.start_kong(version, {
        --kong configs
      })
    end)

    after_each(function()
      perf.stop_kong()
    end)

    lazy_teardown(function()
      perf.teardown()
    end)

    it("#single_route", function()
      local results = {}
      for i=1,3 do
        perf.start_load({
          path = "/s1-r1",
          connections = 1000,
          threads = 5,
          duration = 10,
        })

        ngx.sleep(10)

        local result = assert(perf.wait_result())

        print(("### Result for Kong %s (run %d):\n%s"):format(version, i, result))
        results[i] = result
      end

      print(("### Combined result for Kong %s:\n%s"):format(version, assert(perf.combine_results(results))))

      perf.save_error_log("output/" .. version:gsub("[:/]", "#") .. "-single_route.log")
    end)
  end)
end
```

The test can be ran just as a normal busted based test. Run it with bin/busted path/to/this_file_spec.lua.

More examples can be found at [spec/04-perf](https://github.com/Kong/kong/tree/master/spec/04-perf) of Kong
respository.

[Back to top](#introduction)

## API

### perf.use_driver

*syntax: perf.use_driver(name, options?)*

Use driver of name, which must be one of "local", "docker"  or  "terraform". Additional
parameters for driver can be specified in options as a Lua table. Throws error if any.

Only terraform driver expect options parameter, which contains following keys:

- **provider** the service provider name, right now only "equinix-metal"
- **tfvars** Terraform variables as a Lua table; for `equinix-metal` provider,
`packet_project_id` and `packet_auth_token` is required.

[Back to top](#introduction)

### perf.set_log_level

*syntax: perf.set_log_level(level)*

Set the log level, expect one of `"debug"`, `"info"`, `"notice"`, `"warn"`, `"error"` and
`"crit"`. The default log level is `"info"`.

[Back to top](#introduction)

### perf.set_retry_count

*syntax: perf.set_retry_count(count)*

Set retry time for each “driver" operation. By default every operation is retried 3 times.

[Back to top](#introduction)

### perf.setup

*syntax: helpers = perf.setup()*

Prepare environment and returns the spec.helpers module. Throws error if any.

The framework setup some environment variables before importing spec.helpers modules.
The returned helpers is just a nomal spec.helpers module, user can use same pattern
in integration tests to setup entities in Kong. DB-less mode is currently not implemented.

[Back to top](#introduction)

### perf.start_upstream

*syntax: upstream_uri = perf.start_upstream(nginx_conf_blob)*

Start upstream (Nginx/OpenResty) with given nginx_conf_blob. Returns the upstream
URI accessible from Kong's view. Throws error if any.

[Back to top](#introduction)

### perf.start_kong

*syntax: perf.start_kong(version, kong_configs?)*

Start Kong with given version and Kong configurations in kong_configs as a Lua table.
Throws error if any.

To select a git hash or tag, use `"git:<hash>"` as version. Otherwise, the framework
will treat the `version` as a release version and will download binary packages from
Kong's distribution website.

[Back to top](#introduction)

### perf.stop_kong

*syntax: perf.stop_kong()*

Stops Kong. Throws error if any.

[Back to top](#introduction)

### perf.teardown

*syntax: perf.teardown(full?)*

Teardown. Throws error if any. With terraform driver, set full to true terminates
all infrastructure while by default it does cleanup only to speed up successive runs.

[Back to top](#introduction)

### perf.start_stapxx

*syntax: perf.start_stapxx(stapxx_file_name, arg?)*

Start the Stap++ script with stapxx_file_name exists in   and addtional CLI args args. Throws error if any.

This function blocks until the SystemTap module is fully prepared and inserted into
kernel. It should be called before perf.start_load.

[Back to top](#introduction)

### perf.start_load

*syntax: perf.start_load(options?)*

Start to send load to Kong using wrk. Throws error if any. options is a Lua table that may contains:

- **path** string request path, default to / 
- **uri** base URI except path, default to http://kong-ip:kong-port/
- **connections** connection count, default to 1000
- **threads** request thread count, default to 5 
- **duration** number perf test duration in seconds, default to 10 
- **script** content of wrk script as string, default to nil

[Back to top](#introduction)

### perf.wait_result

*syntax: result = perf.start_load(options?)*

Wait the load test to finish and return the result as string. Throws error if any.

Currently this function waits indefintely until both wrkand stap++ process to exit.

[Back to top](#introduction)

### perf.combine_results

*syntax: combined_result = perf.combine_results(results, …)*

Calculate multiple results returned by perf.wait_result and return their average and min/max.
Throws error if any.

[Back to top](#introduction)

### perf.generate_flamegraph

*syntax: perf.generate_flamegraph(path, title?)*

Generate a flamegraph with title and save to path. Throws error if any.

[Back to top](#introduction)

### perf.save_error_log

*syntax: perf.save_error_log(path)*

Save Kong error log to path. Throws error if any.

[Back to top](#introduction)

## Customization

### Add new test suite

All tests are stored in `spec/04-perf/01-rps` and `spec/04-perf/02-flamegraph` of Kong repository.
Add a new file under one of the directory and put `#tags` in test description.

[Back to top](#introduction)

### Add new provider in terraform

Users can use the terraform driver in most major service providers as long as
it's supported by terraform. The following contracts are made between the framework and terraform module:

The terraform files are stored in `spec/fixtures/perf/terraform/<provider>`

Two instances are provisioned, one for running Kong and another for running upstream
and load (worker). Firewall allows bidirectional traffic between the two instances
and from public internet. Both instances run Ubuntu 20.04/focal.

An SSH key to login into both instances exists or will be created
`spec/fixtures/perf/terraform/<provider>/id_rsa`. The logged-in user has root privilege.

Following terraform output variables:

- **kong-ip** Kong node public IP
- **kong-internal-ip** Kong node internal IP (if unavailable, provide kong-ip)
- **worker-ip** Worker node public IP
- **worker-internal-ip** Worker node internal IP (if unavailable, provide worker-ip)

[Back to top](#introduction)
