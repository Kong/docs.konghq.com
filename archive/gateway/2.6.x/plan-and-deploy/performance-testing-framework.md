---
title: Performance Testing Framework
badge: oss
---

The Kong Gateway codebase includes a performance testing framework. It allows Kong developers and users to evaluate the performance of Kong itself as well as 
bundled or custom plugins, and plot frame graphs to debug performance bottlenecks.
The framework collects RPS (request per second) and latencies of Kong processing the request
to represent performance metrics under different workloads.

The framework is implemented as an extension to Kong's integration test suite.

## Installation

The framework uses [busted](https://olivinelabs.com/busted/) and some
Lua development dependencies of Kong. To set up the environment,
run `make dev` on your Kong repository to install all Lua dependencies.

## Drivers

Three "drivers" are implemented depending on different environments, accuracy
requirements, and setup complexity.

| Driver   | Test between git commits | Test between binary releases | Flamegraph | Test unreleased version |
|----------|--------------------------|------------------------------|------------|-------------------------|
| local    | yes                      |                              | yes        | yes                     |
| docker   | yes                      | yes                          |            |                         |
|terraform | yes                      | yes                          | yes        |                         |

- **local** Driver reuses users' local environment. It's faster to run,
but the RPS and latency number may be influenced by other local programs and thus inaccurate.

    * Requires Lua development dependencies of Kong, OpenResty, and `wrk` be installed.
    * Requires SystemTap, kernel headers, and build chain to be installed if generating FlameGraph.

- **docker** Driver is solely based on Docker images. It's the most convenient driver to setup
as it requires less dependencies. But it may also be influenced by other local programs
and Docker network performance. And it doesn't support FlameGraph generation.

- **terraform** Driver runs in remote VM or bare metal machine. It's most accurate,
but it requires Terraform knowledge to operate and setup.

    * Requires the [Terraform](https://www.terraform.io/downloads.html) binary be installed.
    * Requires git binary if testing between git commits. When testing between git commits,
    the framework assumes the current directory is Kong's repo. It will stash your working
    directory and unstash after test is finished. When using the docker or terraform driver,
    the framework derives the base version of each commit and uses the matching Docker image or
    Kong binary package and puts local source code inside.

## Workflow

Like Kong's integration tests, the performance test is written in Lua. Several
test cases can share the same Lua file.

The following code snippet demonstrates a basic workflow for defining a workload and load testing Kong.

```lua
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

The test can be run as a normal busted-based test. Run it with `bin/busted path/to/this_file_spec.lua`.

More examples can be found in the [spec/04-perf](https://github.com/Kong/kong/tree/master/spec/04-perf) folder in the Kong
repository.

## Sample Output

```
### Result for Kong git:96326b894f712b5d03bb1bf7ac02d531f6128cd1 (run 1):
Running 10s test @ http://10.88.145.9:8000/s1-r1
  5 threads and 1000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    17.51ms   61.46ms   1.04s    98.99%
    Req/Sec    14.31k     2.61k   20.80k    82.59%
  672831 requests in 10.07s, 154.07MB read
  Socket errors: connect 0, read 0, write 0, timeout 246
Requests/sec:  66803.45
Transfer/sec:     15.30MB
### Result for Kong git:96326b894f712b5d03bb1bf7ac02d531f6128cd1 (run 2):
Running 10s test @ http://10.88.145.9:8000/s1-r1
  5 threads and 1000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    14.71ms   10.66ms  96.77ms   66.18%
    Req/Sec    14.45k     1.79k   20.19k    70.80%
  718942 requests in 10.08s, 164.70MB read
Requests/sec:  71337.25
Transfer/sec:     16.34MB
### Result for Kong git:96326b894f712b5d03bb1bf7ac02d531f6128cd1 (run 3):
Running 10s test @ http://10.88.145.9:8000/s1-r1
  5 threads and 1000 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency    14.47ms   10.13ms  82.81ms   66.57%
    Req/Sec    14.60k     1.64k   22.98k    72.00%
  726452 requests in 10.07s, 166.42MB read
Requests/sec:  72141.41
Transfer/sec:     16.53MB
### Combined result for Kong git:96326b894f712b5d03bb1bf7ac02d531f6128cd1:
RPS     Avg: 70094.04
Latency Avg: 15.52ms    Max: 1040.00ms
```

With samples in [spec/04-perf](https://github.com/Kong/kong/tree/master/spec/04-perf), the RPS and latency
results, Kong error logs and FlameGraph files are saved to `output` directory under current directory.

## API

### perf.use_driver

*syntax: perf.use_driver(name, options?)*

Uses driver name, which must be one of "local", "docker"  or  "terraform". Additional
parameters for the driver can be specified in options as a Lua table. Throws error if any.

Only the terraform driver expects an options parameter, which contains following keys:

- **provider** The service provider name, right now only "equinix-metal".
- **tfvars** Terraform variables as a Lua table; for `equinix-metal` provider,
`packet_project_id` and `packet_auth_token` is required.

### perf.set_log_level

*syntax: perf.set_log_level(level)*

Sets the log level; expect one of `"debug"`, `"info"`, `"notice"`, `"warn"`, `"error"` and
`"crit"`. The default log level is `"info"`.

### perf.set_retry_count

*syntax: perf.set_retry_count(count)*

Sets retry time for each “driver" operation. By default every operation is retried 3 times.

### perf.setup

*syntax: helpers = perf.setup()*

Prepares environment and returns the `spec.helpers` module. Throws error if any.

The framework sets up some environment variables before importing `spec.helpers` modules.
The returned helper is just a normal `spec.helpers` module. Users can use the same pattern
in integration tests to setup entities in Kong. DB-less mode is currently not implemented.

### perf.start_upstream

*syntax: upstream_uri = perf.start_upstream(nginx_conf_blob)*

Starts upstream (Nginx/OpenResty) with given `nginx_conf_blob`. Returns the upstream
URI accessible from Kong's view. Throws error if any.

### perf.start_kong

*syntax: perf.start_kong(version, kong_configs?)*

Starts Kong with given version and Kong configurations in `kong_configs` as a Lua table.
Throws error if any.

To select a git hash or tag, use `"git:<hash>"` as version. Otherwise, the framework
will treat the `version` as a release version and will download binary packages from
Kong's distribution website.

### perf.stop_kong

*syntax: perf.stop_kong()*

Stops Kong. Throws error if any.

### perf.teardown

*syntax: perf.teardown(full?)*

Teardown. Throws error if any. With the terraform driver, setting full to true terminates
all infrastructure, while by default it does cleanup only to speed up successive runs.

### perf.start_stapxx

*syntax: perf.start_stapxx(stapxx_file_name, arg?)*

Starts the Stap++ script with `stapxx_file_name` exists in
[available stapxx scripts](https://github.com/Kong/stapxx/tree/kong/samples)
and additional CLI args. Throws error if any.

This function blocks test execution until the `SystemTap` module is fully prepared and inserted into the
kernel. It should be called before `perf.start_load`.

### perf.start_load

*syntax: perf.start_load(options?)*

Starts to send load to Kong using `wrk`. Throws error if any. Options is a Lua table that may contain the following:

- **path** String request path; defaults to `/ `.
- **uri** Base URI exception path; defaults to `http://kong-ip:kong-port/`.
- **connections** Connection count; defaults to 1000.
- **threads** Request thread count; defaults to 5. 
- **duration** Number of performance tests duration in seconds; defaults to 10. 
- **script** Content of `wrk` script as string; defaults to nil.

### perf.wait_result

*syntax: result = perf.start_load(options?)*

Waits for the load test to finish and returns the result as a string. Throws error if any.

Currently, this function waits indefinitely, or until both `wrk` and Stap++ processes exit.

### perf.combine_results

*syntax: combined_result = perf.combine_results(results, …)*

Calculates multiple results returned by `perf.wait_result` and returns their average and min/max.
Throws error if any.

### perf.generate_flamegraph

*syntax: perf.generate_flamegraph(path, title?)*

Generates a FlameGraph with title and saves to path. Throws error if any.

### perf.save_error_log

*syntax: perf.save_error_log(path)*

Saves Kong error log to path. Throws error if any.

## Customization

### Add new test suite

All tests are stored in `spec/04-perf/01-rps` and `spec/04-perf/02-flamegraph` of the Kong repository.
Add a new file under one of the directories and put `#tags` in the test description.

### Add new provider in terraform

Users can use the terraform driver in most major service providers as long as
it's supported by Terraform. The following contracts are made between the framework and terraform module:

The terraform files are stored in `spec/fixtures/perf/terraform/<provider>`.

Two instances are provisioned, one for running Kong and another for running an upstream
and load (worker). A firewall allows bidirectional traffic between the two instances
and from the public internet. Both instances run Ubuntu 20.04/focal.

An SSH key to login into both instances exists or will be created in
`spec/fixtures/perf/terraform/<provider>/id_rsa`. The logged-in user has root privilege.

The following are terraform output variables:

- **kong-ip** Kong node public IP.
- **kong-internal-ip** Kong node internal IP (if unavailable, provide kong-ip).
- **worker-ip** Worker node public IP.
- **worker-internal-ip** Worker node internal IP (if unavailable, provide worker-ip).
