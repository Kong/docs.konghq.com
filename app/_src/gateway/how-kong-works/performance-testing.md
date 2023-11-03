---
title: Kong Gateway Performance Testing
content_type: explanation
---

{:.important}
> **Note**: As of {{site.base_gateway}} 3.5.x, this feature has been deprecated. It is not supported past 3.4.x.

The {{site.base_gateway}} codebase includes a performance testing framework. It allows Kong developers and users to evaluate the performance of Kong itself as well as 
bundled or custom plugins, and plot frame graphs to debug performance bottlenecks.
The framework collects RPS (request per second) and latencies of Kong processing the request
to represent performance metrics under different workloads.

The framework is implemented as an extension to Kong's integration test suite.

## Installation

The framework uses [busted](https://github.com/lunarmodules/busted) and some
Lua development dependencies of Kong. To set up the environment,
run `make dev` on your Kong repository to install all Lua dependencies.

## Usage

### Basic usage

Install Lua development dependencies of Kong being installed and invoke each test file with `busted`. The following runs the RPS and latency
test using the `docker` driver.

```shell
PERF_TEST_USE_DAILY_IMAGE=true PERF_TEST_VERSIONS=git:master,git:perf/your-other-branch bin/busted -o gtest spec/04-perf/01-rps/01-simple_spec.lua
```


### Terraform managed instances

By default, Terraform doesn't teardown instances after each test in `lazy_teardown`, allowing users
to run multiple tests consecutively without rebuilding the infrastructure each time.

This behavior can be changed by setting the `PERF_TEST_TEARDOWN_ALL` environment variable to true. Users can
also manually teardown the infrastructure by running:

```
PERF_TEST_TEARDOWN_ALL=1 PERF_TEST_DRIVER=terraform PERF_TEST_TERRAFORM_PROVIDER=your-provider bin/busted -o gtest -t single spec/04-perf/99-teardown/
```

### AWS

When using the `terraform` driver and `aws-ec2` as the provider, AWS credentials can be provided using environment variables.
It's common to pass the `AWS_PROFILE` variable to point to a stored AWS credentials profile, or `AWS_ACCESS_KEY_ID` and
`AWS_SECRET_ACCESS_KEY` to use credentials directly. See the
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
| Docker   | yes                      | yes                          |            | yes (`use_daily_image` = true) |
|Terraform | yes                      | yes                          | yes        | yes (`use_daily_image` = true) |

You must install the following Lua development dependencies to use either of the drivers:

- **Docker** Driver is based on Docker images.
It requires fewer dependencies.
And it doesn't support FlameGraph generation.

- **terraform** Driver runs in a remote VM or on a bare metal machine. It's most accurate,
but it requires Terraform knowledge to operate and setup.

    * Requires the [Terraform](https://www.terraform.io/downloads.html) binary be installed.
    * Requires git binary if testing between git commits. When testing between git commits,
    the framework assumes the current directory is Kong's repo. It will stash your working
    directory and remove the stash after the test is finished. When using the Docker or Terraform driver,
    the framework derives the base version of each commit and uses the matching Docker image or
    Kong binary package and puts the local source code inside.

## Workflow

Multiple
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

The test can be run as a normal Busted test, using `bin/busted path/to/this_file_spec.lua`.

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
