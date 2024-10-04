---
title: Performance Testing Framework Reference
badge: oss
content_type: reference
---

{:.important}
> **Note**: As of {{site.base_gateway}} 3.5.x, this feature has been deprecated. It is not supported past 3.4.x.

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
|equinix-metal | `metal_project_id` | PERF_TEST_METAL_PROJECT_ID  | The project ID that instances belong to.  | <required> |
|equinix-metal   |  `metal_auth_token` | PERF_TEST_METAL_AUTH_TOKEN  | Equinix authentication token.  | <required> |
|equinix-metal   |  `metal_plan` | PERF_TEST_METAL_PLAN  | Instance size. | `"c3.small.x86"`  |
|equinix-metal   |  `metal_os` | PERF_TEST_METAL_OS | Operating system image name. | `"ubuntu_20_04"`  |
| digitalocean | `do_project_name` | PERF_TEST_DIGITALOCEAN_PROJECT_NAME | The project name that instances belong to; will create one if not exist. | `"Benchmark"` |
|digitalocean   | `do_token`  | PERF_TEST_DIGITALOCEAN_TOKEN  |  DigitalOcean authentication token. | <required> |
|digitalocean   | `do_size`  |  PERF_TEST_DIGITALOCEAN_SIZE | Droplet size.  | `"s-1vcpu-1gb"` |
|digitalocean   | `do_region`  | PERF_TEST_DIGITALOCEAN_REGION  | Region to deploy droplet.  |  `"sfo3"`  |
|digitalocean   | `do_os`  | PERF_TEST_DIGITALOCEAN_OS  | Operation system image name.  |  `"ubuntu-20-04-x64"` |
|aws-ec2   |  `aws_region` | PERF_TEST_AWS_REGION  | AWS region to deploy EC2 instances.  | `"us-east-2"`  |
|aws-ec2   | `ec2_instance_type`  | PERF_TEST_EC2_INSTANCE_TYPE  | EC2 instance type.  | `"c4.4xlarge"`  |
|aws-ec2   | `ec2_os`  | PERF_TEST_EC2_OS  | Operation system image pattern.  | `"ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"`  |

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

If this option is not set, the chart treats results in same test file as independent tests
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

### Add new provider in Terraform

Users can use the Terraform driver in most major service providers as long as
it's supported by Terraform. The following contracts are made between the framework and terraform module:

The terraform files are stored in `spec/fixtures/perf/terraform/<provider>`.

Three instances are provisioned, one for running Kong, one for running PostgreSQL
database and another for running an upstream and load (worker).
A firewall allows bidirectional traffic between the three instances
and from the public internet. Both instances run Ubuntu 20.04/focal.

An SSH key to login into both instances exists or will be created in
`spec/fixtures/perf/terraform/<provider>/id_rsa`. The logged-in user has root privilege or sudo privilege.

The following are terraform output variables:

- **kong-ip**: Kong node public IP.
- **kong-internal-ip**: Kong node internal IP (if unavailable, provide `kong-ip`).
- **worker-ip**: Worker node public IP.
- **worker-internal-ip**: Worker node internal IP (if unavailable, provide `worker-ip`).
- **db-ip**: Database node public IP.
- **db-internal-ip**: Database node internal IP (if unavailable, provide `db-ip`).
