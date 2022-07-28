---
title: Performance Testing Framework
badge: oss
---

The {{site.base_gateway}} codebase includes a performance testing framework. It allows Kong developers and users to evaluate the performance of Kong itself as well as 
bundled or custom plugins, and plot frame graphs to debug performance bottlenecks.
The framework collects RPS (request per second) and latencies of Kong processing the request
to represent performance metrics under different workloads.

The framework is implemented as an extension to Kong's integration test suite.

## Installation

The framework uses [busted](https://olivinelabs.com/busted/) and some
Lua development dependencies of Kong. To set up the environment,
run `make dev` on your Kong repository to install all Lua dependencies.

## Usage

### Basic usage

Install Lua development dependencies of Kong being installed and invoke each test file with `busted`. The following runs the simple RPS and latency
test using `docker` driver.

```shell
PERF_TEST_USE_DAILY_IMAGE=true PERF_TEST_VERSIONS=git:master,git:perf/your-other-branch bin/busted -o gtest spec/04-perf/01-rps/01-simple_spec.lua
```

User can also run the performance test framework inside a Kong container from scratch, from other development tools
like [gojira](https://github.com/kong/gojira) or [pongo](https://github.com/kong/kong-pongo), if they don't have development environment.
Note to use the `docker` driver inside a container, the Docker daemon socket `/var/run/docker.sock` needs to be mounted inside the container.

### Terraform managed instances

By default, terraform doesn't teardown instances after each test in `lazy_teardown`; this allows user
to run multiple tests consecutively without rebuilding the infrastructure each time.

This behaviour can be changed by setting `PERF_TEST_TEARDOWN_ALL` environment variable to true. User can
also manually teardown the infrastructure by running:

```
PERF_TEST_TEARDOWN_ALL=1 PERF_TEST_DRIVER=terraform PERF_TEST_TERRAFORM_PROVIDER=your-provider bin/busted -o gtest -t single spec/04-perf/99-teardown/
```

### AWS

When using `terraform` driver and `aws-ec2` as provider, AWS credentials can be provided by environment variables.
It's common to pass `AWS_PROFILE` to point a stored AWS credentials profile, or `AWS_ACCESS_KEY_ID` and
`AWS_SECRET_ACCESS_KEY` to use credential directly. Please refer to the
[Terraform AWS provider document](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration)
for further information.

### Charts

Charts are not rendered by default. There's a reference implementation to draw graphs on all JSON
data stored in the `output` directory. Use the following commands to draw graphs:

```shell
cwd=$(pwd)
cd spec/helpers/perf/charts/
pip install -r requirements.txt
for i in $(ls ${cwd}/output/*.data.json); do
  python ./charts.py $i -o "${cwd}/output/"
done
```


## Drivers

Three "drivers" are implemented depending on different environments, accuracy
requirements, and setup complexity.

| Driver   | Test between git commits | Test between binary releases | Flame Graph | Test unreleased version    |
|----------|--------------------------|------------------------------|------------|----------------------------|
| docker   | yes                      | yes                          |            | yes (`use_daily_image` = true) |
|terraform | yes                      | yes                          | yes        | yes (`use_daily_image` = true) |

Using either of the driver requires Lua development dependencies of Kong being installed.

- **docker** Driver is solely based on Docker images. It's the most convenient driver to setup
as it requires less dependencies. But it may also be influenced by other local programs
and Docker network performance. And it doesn't support FlameGraph generation.

- **terraform** Driver runs in remote VM or bare metal machine. It's most accurate,
but it requires Terraform knowledge to operate and setup.

    * Requires the [Terraform](https://www.terraform.io/downloads.html) binary be installed.
    * Requires git binary if testing between git commits. When testing between git commits,
    the framework assumes the current directory is Kong's repo. It will stash your working
    directory and remove the stash after the test is finished. When using the docker or Terraform driver,
    the framework derives the base version of each commit and uses the matching Docker image or
    Kong binary package and puts local source code inside.

## Workflow

Like Kong's integration tests, the performance test is written in Lua. Several
test cases can share the same Lua file.

The following code snippet demonstrates a basic workflow for defining a workload and load testing Kong.

```lua
local perf = require("spec.helpers.perf")

perf.use_defaults()

local versions = { "git:master", "3.0.0" }

for _, version in ipairs(versions) do
  describe("perf test for Kong " .. version .. " #simple #no_plugins", function()
    local bp
    lazy_setup(function()
      local helpers = perf.setup_kong(version)

      bp = helpers.get_db_utils("postgres", {
        "routes",
        "services",
      })

      local upstream_uri = perf.start_worker([[
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
      perf.start_kong({
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
### Test Suite: git:origin/master~10 #simple #hybrid #no_plugins #single_route
### Result for Kong git:origin/master~10 (run 1):
Running 30s test @ http://172.17.0.50:8000/s1-r1
  5 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     3.53ms    3.35ms  87.02ms   89.65%
    Req/Sec     6.42k     1.33k   10.53k    67.29%
  Latency Distribution
     50%    2.65ms
     75%    4.35ms
     90%    6.99ms
     99%   16.86ms
  960330 requests in 30.10s, 228.96MB read
Requests/sec:  31904.97
Transfer/sec:      7.61MB
### Result for Kong git:origin/master~10 (run 2):
Running 30s test @ http://172.17.0.50:8000/s1-r1
  5 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     4.56ms    6.55ms 236.87ms   91.95%
    Req/Sec     5.79k     1.54k   10.50k    66.18%
  Latency Distribution
     50%    2.82ms
     75%    5.31ms
     90%    9.72ms
     99%   26.33ms
  863963 requests in 30.07s, 206.00MB read
Requests/sec:  28730.72
Transfer/sec:      6.85MB
### Result for Kong git:origin/master~10 (run 3):
Running 30s test @ http://172.17.0.50:8000/s1-r1
  5 threads and 100 connections
  Thread Stats   Avg      Stdev     Max   +/- Stdev
    Latency     3.79ms    3.81ms  82.25ms   89.60%
    Req/Sec     6.14k     1.43k   12.59k    66.49%
  Latency Distribution
     50%    2.77ms
     75%    4.69ms
     90%    7.71ms
     99%   18.88ms
  917366 requests in 30.08s, 218.72MB read
Requests/sec:  30499.09
Transfer/sec:      7.27MB
### Combined result for Kong git:origin/master~10:
RPS     Avg: 30378.26
Latency Avg: 3.94ms    Max: 236.87ms
   P90 (ms): 6.99, 9.72, 7.71
   P99 (ms): 16.86, 26.33, 18.88
```

With samples in [spec/04-perf](https://github.com/Kong/kong/tree/master/spec/04-perf), the RPS and latency
results, Kong error logs, charts and Flame Graph files are saved to the `output` directory in the current directory.

## API

### perf.use_defaults()

*syntax: perf.use_defaults()*

Use default parameters. This function sets the following:
- Looks up `PERF_TEST_DRIVER` environment variable and invokes `perf.use_driver`.
- Looks up `PERF_TEST_TERRAFORM_PROVIDER` if `PERF_TEST_DRIVER` is `terraform`; please see `perf.use_driver` for 
environment variables that can be passed to each provider.
- Invokes `perf.set_log_level` and sets level to `"debug"`.
- Set retry count to 3.
- Looks up `PERF_TEST_USE_DAILY_IMAGE` environment variable and passes the variable to driver options.

### perf.use_driver

*syntax: perf.use_driver(name, options?)*

Uses driver name, which must be one of "local", "docker"  or  "terraform". Additional
parameters for the driver can be specified in options as a Lua table. Throws error if any.

The Docker and Terraform driver expect an options parameter to contain the following keys :

- **use_daily_image**: a boolean to decide whether to use daily image or not; useful when testing
unreleased commits on master branch; downloading Enterprise daily images requires a valid Docker
login.

The Terraform driver expects options to contain the following optional keys:

- **provider** The service provider name, right now only "equinix-metal".
- **tfvars** Terraform variables as a Lua table as follows; environment variables are only used if `perf.use_defaults()` is called.

|Provider   |  tfvars key | environment variable key  |  description  | default |
|---|---|---|---|---|
|equinix-metal | metal_project_id | PERF_TEST_METAL_PROJECT_ID  | The project ID that instances belong to.  | <required> |
|^^   |  metal_auth_token | PERF_TEST_METAL_AUTH_TOKEN  | Equinix authentication token.  | <required> |
|^^   |  metal_plan | PERF_TEST_METAL_PLAN  | Instance size. | `"c3.small.x86"`  |
|^^   |  metal_os | PERF_TEST_METAL_OS | Operating system image name. | `"ubuntu_20_04"`  |
| digitalocean | do_project_name | PERF_TEST_DIGITALOCEAN_PROJECT_NAME | The project name that instances belong to; will create one if not exist. | `"Benchmark"` |
|^^   | do_token  | PERF_TEST_DIGITALOCEAN_TOKEN  |  Digitalocean authentication token. | <required> |
|^^   | do_size  |  PERF_TEST_DIGITALOCEAN_SIZE | Droplet size.  | `"s-1vcpu-1gb"` |
|^^   | do_region  | PERF_TEST_DIGITALOCEAN_REGION  | Region to deploy droplet.  |  `"sfo3"`  |
|^^   | do_os  | PERF_TEST_DIGITALOCEAN_OS  | Operation system image name.  |  `"ubuntu-20-04-x64"` |
|aws-ec2   |  aws_region | PERF_TEST_AWS_REGION  | AWS region to deploy EC2 instances.  | `"us-east-2"`  |
|^^   | ec2_instance_type  | PERF_TEST_EC2_INSTANCE_TYPE  | EC2 instance type.  | `"c4.4xlarge"`  |
|^^   | ec2_os  | PERF_TEST_EC2_OS  | Operation system image pattern.  | `"ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"`  |

### perf.set_log_level

*syntax: perf.set_log_level(level)*

Sets the log level; expect one of `"debug"`, `"info"`, `"notice"`, `"warn"`, `"error"` and
`"crit"`. The default log level is `"info"` unless `perf.use_defaults` is called and set
to `"debug"`.

### perf.set_retry_count

*syntax: perf.set_retry_count(count)*

Sets retry time for each “driver" operation. By default every operation is retried 3 times.

### perf.setup

*syntax: helpers = perf.setup()*

Prepares base environment, except for {{site.base_gateway}}, and returns the `spec.helpers` module. Throws error, if any.

The framework sets up some environment variables before importing `spec.helpers` modules.
The returned helper is just a normal `spec.helpers` module. Users can use the same pattern
in integration tests to setup entities in Kong. DB-less mode is currently not implemented.

### perf.setup_kong

*syntax: helpers = perf.setup_kong(version)*

Prepares base environment and installs {{site.base_gateway}} with `version`, then returns the `spec.helpers` module.
Throws error, if any. Calling this function also invokes `perf.setup()`.

To select a git hash or tag, use `"git:<hash>"` as the version. Otherwise, the framework
treats the `version` as a release version and downloads binary packages from
Kong's distribution website.

The framework sets up some environment variables before importing `spec.helpers` modules.
The returned helper is just a normal `spec.helpers` module. Users can use the same pattern
in integration tests to setup entities in Kong. DB-less mode is currently not implemented.

### perf.start_worker

*syntax: `upstream_uri` = perf.start_worker(`nginx_conf_blob`, `port_count`?)*

Starts upstream (Nginx/OpenResty) with given `nginx_conf_blob`. Returns the upstream
URI accessible from {{site.base_gateway}}'s view. Throws an error, if any.

If `port_count` is set and larger than one, the framework starts upstreams with multiple ports
and returns them in a table.

### perf.start_kong

*syntax: perf.start_kong(`kong_configs`?, `driver_configs`?)*

Starts {{site.base_gateway}} with the configurations in `kong_configs` as a Lua table.
Throws an error, if any.

`driver_configs` is a Lua table that may contain following keys:
- `name`: A string that distinguishes different {{site.base_gateway}} instances. It's not required if only one {{site.base_gateway}} instance is started. It can be used as DNS name to access one {{site.base_gateway}} instance over another.
- `ports`: A table to setup exposed ports. This is only honored by the `docker` driver.
### perf.stop_kong

*syntax: perf.stop_kong()*

Stops all Kong instances. Throws error if any.

### perf.teardown

*syntax: perf.teardown(full?)*

Teardown. Throws error if any. With the terraform driver, setting full to true terminates
all infrastructure, while by default it does cleanup only to speed up successive runs.

### perf.start_stapxx

*syntax: perf.start_stapxx(`stapxx_file_name`, `arg`?, `driver_configs`?)*

Starts the Stap++ script with `stapxx_file_name` exists in
[available stapxx scripts](https://github.com/Kong/stapxx/tree/kong/samples)
and additional CLI arguments. Throws error if any.

This function blocks test execution until the `SystemTap` module is fully prepared and inserted into the
kernel. It should be called before `perf.start_load`.

`driver_configs` is a Lua table that contains the following keys:
- `name`: A string to distinguish different {{site.base_gateway}} instances to probe one.

### perf.start_load

*syntax: perf.start_load(options?)*

Starts to send load to Kong using `wrk`. Throws error if any. Options is a Lua table that may contain the following:

- **path** String request path; defaults to `/ `.
- **uri** Base URI exception path; defaults to `http://kong-ip:kong-port/`.
- **connections** Connection count; defaults to 1000.
- **threads** Request thread count; defaults to 5. 
- **duration** Number of performance tests duration in seconds; defaults to 10. 
- **script** Content of `wrk` script as string; defaults to nil.
- **wrk2** Boolean to use `wrk2` instead of `wrk`. Defaults to false.
- **rate** Number of requests per second to send. This is required if using `wrk2` but invalid if using `wrk`.
- **kong_name** The `name` specified by `driver_confs` when starting {{site.base_gateway}} to send load to. When this is unspecified, the framework picks the first {{site.base_gateway}} instance that exposes the proxy port.

### perf.get_admin_uri

*syntax: perf.get_admin_uri(kong_name?)*

Return the Admin API URL. The URL may only be accessible from
the load generator and not publicly available. The framework picks the first
{{site.base_gateway}} instance that exposes the admin port. `kong_name` must be set to choose the {{site.base_gateway}}
instance with matching `name` specified by `driver_confs` when starting {{site.base_gateway}}. 
### perf.wait_result

*syntax: result = perf.wait_result(options?)*

Waits for the load test to finish and returns the result as a string. Throws error if any.

Currently, this function waits indefinitely, or until both `wrk` and Stap++ processes exit.

### perf.combine_results

*syntax: `combined_result` = perf.combine_results(results, suite?)*

Calculates multiple results returned by `perf.wait_result` and returns their average and min/max.
Throws an error, if any. The `suite` string identifies the test suite to display in the charts and
is used as the X-axis labels. If the suite is not specified, the framework will use the test name.

If results in the same file are correlated, the user can set `suite` to a number and add the following options
to draw a line chart with a trend line:

```lua
local charts = require "spec.helpers.perf.charts"
charts.options({
  suite_sequential = true,
  xaxis_title = "Upstreams count",
})
```

Otherwise, the chart will treat results in same test file as independent tests
and draws a bar chart.

### perf.generate_flamegraph

*syntax: perf.generate_flamegraph(path, title?)*

Generates a FlameGraph with title and saves to path. Throws error if any.

### perf.save_error_log

*syntax: perf.save_error_log(path)*

Saves Kong error log to path. Throws error if any.

### perf.enable_charts

*syntax: perf.enable_charts(on?)*

Enable charts generation, throws error if any.

Charts are enabled by default; the data of charts are fed by `perf.combine_results`.
The generated JSON results for creating charts are stored under the `output` directory.

### perf.save_pgdump

*syntax: perf.save_pgdump(path)*

After setting up Kong using Blueprint, saves the PostgreSQL database dump to a path. Throws error if any.

### perf.load_pgdump

*syntax: perf.load_pgdump(path, `dont_patch_service`)*

Loads the pgdump from the path and replaces the Kong database with the loaded data; this function
will also patch a services address to the upstream unless `dont_patch_service` is set to false,
it must be called after `perf.start_upstream`. Throws error if any.

## Customization

### Add new test suite

All tests are stored in `spec/04-perf/01-rps` and `spec/04-perf/02-flamegraph` of the Kong repository.
Add a new file under one of the directories and put `#tags` in the test description.

### Add new provider in terraform

Users can use the terraform driver in most major service providers as long as
it's supported by Terraform. The following contracts are made between the framework and terraform module:

The terraform files are stored in `spec/fixtures/perf/terraform/<provider>`.

Three instances are provisioned, one for running Kong, one for running PostgreSQL
database and another for running an upstream and load (worker).
A firewall allows bidirectional traffic between the three instances
and from the public internet. Both instances run Ubuntu 20.04/focal.

An SSH key to login into both instances exists or will be created in
`spec/fixtures/perf/terraform/<provider>/id_rsa`. The logged-in user has root privilege or sudo privilege.

The following are terraform output variables:

- **kong-ip** Kong node public IP.
- **kong-internal-ip** Kong node internal IP (if unavailable, provide `kong-ip`).
- **worker-ip** Worker node public IP.
- **worker-internal-ip** Worker node internal IP (if unavailable, provide `worker-ip`).
- **db-ip** Database node public IP.
- **db-internal-ip** Database node internal IP (if unavailable, provide `db-ip`).
