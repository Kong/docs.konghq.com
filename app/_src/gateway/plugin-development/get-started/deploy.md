---
title: Deploy Plugins 
book: plugin_dev_getstarted
chapter: 6
---

Once you have a functional custom plugin, you need to deploy it to 
{{site.base_gateway}} in order to use it. There are multiple 
methods for deploying custom plugins, which one you choose will largely
depend on your particular {{site.base_gateway}} environment and other technology
choices. This section will cover popular deployment options and provide
a reference to further instructions.

## Prerequisites

This page is the fifth chapter in the [Getting Started](/gateway/{{page.gateway_release}}/plugin-development/get-started/index) 
guide for developing custom plugins. These instructions refer to the previous chapters in the guide and require the same
developer tool prerequisites.

## Step by Step

A very popular choice for running {{site.base_gateway}} is using container
runtime systems. Kong builds and verifies Docker images for use in your 
deployments and provides [detailed instructions](/gateway/{{page.gateway_release}}/install/docker/)
on Docker deployments. Let's look at a few options for running your custom plugin 
in a {{site.base_gateway}} container.

One popular option is building a Docker image that adds your custom plugin code
and sets the necessary environment directly in the image. This solution requires
more steps in the build stage of your deployment pipeline, but simplifies the data plane deployment 
as configuration and custom code is shipped directly in the data plane image. 

### Create a `Dockerfile`

Create a new file at the root of the `my-plugin` project named `Dockerfile` with the
following contents

```dockerfile
{% if page.release.label == "unreleased" -%}
FROM kong/kong-gateway-dev:latest
{% else -%}
FROM kong/kong-gateway:{{page.release.tag}}
{% endif -%}

# Ensure any patching steps are executed as root user
USER root

# Add custom plugin to the image
COPY ./kong/plugins/my-plugin /usr/local/share/lua/5.1/kong/plugins/my-plugin
ENV KONG_PLUGINS=bundled,my-plugin

# Ensure kong user is selected for image execution
USER kong

# Run kong
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE 8000 8443 8001 8444
STOPSIGNAL SIGQUIT
HEALTHCHECK --interval=10s --timeout=10s --retries=10 CMD kong health
CMD ["kong", "docker-start"]
```

### Build Docker image

When building a Docker image you will give it a tag to help identify it. We suggest
you tag the image to include information specifying the {{site.base_gateway}} version 
and a version for the plugin. For example, the following will build the custom image,
labeling the `my-plugin` portion of the version as `0.0.1`:

```sh
docker build -t kong-gateway_my-plugin:{{ page.release.tag }}-0.0.1 .
```

### Run the custom image

You can now use the {{site.base_gateway}} quickstart script to run the
custom image and further test the plugin. The quickstart script supports
flags that allow for overriding the docker 
repository (`-r`), image (`-i`) and tag (`-t`). Here is an example command:

```sh
curl -Ls https://get.konghq.com/quickstart | \
  bash -s -- -r "" -i kong-gateway_my-plugin -t {{ page.release.tag }}-0.0.1
```

### Test the deployed `my-plugin` plugin

Once the {{site.base_gateway}} is running with the custom image, you 
can manually test the plugin and validate the behavior.

Add a test service:

```sh
curl -i -s -X POST http://localhost:8001/services \
    --data name=example_service \
    --data url='http://httpbin.org'
```

Associate the custom plugin with the `example_service` service:

```sh
curl -is -X POST http://localhost:8001/services/example_service/plugins \
    --data 'name=my-plugin'
```

Add a new route you can use to send requests through:

```sh
curl -i -X POST http://localhost:8001/services/example_service/routes \
    --data 'paths[]=/mock' \
    --data name=example_route
```

Test the behavior by proxying a request to the test route and asking 
`curl` to show the response headers with the `-i` flag:

```sh
curl -i http://localhost:8000/mock/anything
```

`curl` should report `HTTP/1.1 200 OK` and show us the response headers from the gateway. Included
in the set of headers, should be the `X-MyPlugin` 

For example: 

```sh
HTTP/1.1 200 OK
Content-Type: application/json
Connection: keep-alive
Content-Length: 529
Access-Control-Allow-Credentials: true
Date: Tue, 12 Mar 2024 14:44:22 GMT
Access-Control-Allow-Origin: *
Server: gunicorn/19.9.0
X-MyPlugin: http://httpbin.org/anything
X-Kong-Upstream-Latency: 97
X-Kong-Proxy-Latency: 1
Via: kong/3.6.1
X-Kong-Request-Id: 8ab8c32c4782536592994514b6dadf55
```

## Other deployment options

Building a custom Docker image is not the only option for deploying a custom plugin. 

### Kubernetes deployments

Many users choose to run {{site.base_gateway}} on Kubernetes. {{site.base_gateway}} can 
be deployed on Kubernetes directly or by using [{{site.kic_product_name}}](/kubernetes-ingress-controller/latest/).
In either case, deploying custom plugins on Kubernetes is achieved by adding the custom plugin 
code to the cluster in a ConfigMap or Secret, which is then mounted into the {{site.base_gateway}} proxy
pod by the Helm chart.

The [Custom Plugins](/kubernetes-ingress-controller/latest/plugins/custom/) documentation
page provides instructions on deploying custom plugins using the 
[Kong Helm chart](/kubernetes-ingress-controller/latest/install/helm/) or directly with 
standard Kubernetes manifests.

### Overriding package path

When running {{site.base_gateway}} in bare metal or virtual machine environments, overriding the 
location that the Lua VM looks for packages to include is a common strategy for deploying a custom plugin.
Following the same file structure as shown above, you can distribute the source files on the 
host machines and modify the `lua_package_path` configuration value to point to this path.
This configuration can also be modified using the `KONG_LUA_PACKAGE_PATH` environment variable. 

See the custom plugin [installation documentation](/gateway/{{page.release}}/plugin-development/distribution/) 
for more details on this option. 

{:.note}
> **Note**: In addition to bare metal or virtual machine environments, this strategy can work for 
volume mounts on containerized systems. 

### Building a LuaRocks package

LuaRocks is a package manager for Lua modules. It allows you to create and install Lua modules
as self-contained packages called _rocks_. In order to create a _rock_ package you author
a _rockspec_ file that specifies various information about your package. Using the `luarocks` tooling,
you build an archive from the rockspec file and deliver and extract it to your data planes. 

See the [Packaging sources](/gateway/{{page.release}}/plugin-development/distribution/#packaging-sources) 
section of the custom plugin installation page for details on this distribution option.

## Custom Plugins on {{site.konnect_product_name}}

[{{site.konnect_product_name}}](/konnect/) is Kong's unified API platform as a service. {{site.konnect_short_name}}
supports custom plugins with some limitations. With an on-premise deployment, users manage {{site.base_gateway}}
data planes as well as the control plane and, optionally, the backing database. In {{site.konnect_product_name}},
the control plane and database are fully managed for you which limits support for custom data entities and 
Admin API extensions in your plugin. 

The [Manage Plugins](/konnect/gateway-manager/plugins/) section of the
{{site.konnect_short_name}} documentation provides more information on deploying custom plugins to {{site.konnect_product_name}}.

## What's Next

Building custom plugins is a great way to extend {{site.base_gateway}}'s behavior and enable your
business logic at the API gateway layer. However, custom plugin development is best 
used as a method of last resort. {{site.base_gateway}} supports a large number of pre-built plugins that
cover many common use cases including [serverless](/hub/?category=serverless) 
plugins that allow for custom business logic programming directly into a pre-built and supported plugin. 
See the Kong [Plugin Hub](/hub/) for the full catalog of supported plugins. 

The best way to run {{site.base_gateway}} is on {{site.konnect_product_name}}, Kong's unified API platform as a service. 
Getting started with {{site.konnect_product_name}} is quick and free, [login](https://cloud.konghq.com/login) 
or [sign up](https://konghq.com/products/kong-konnect/register?utm_medium=referral&utm_source=docs&utm_campaign=gateway-konnect&utm_content=custom-plugins) 
today.

