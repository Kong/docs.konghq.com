---
title: AWS ECS
---

To install and run Kuma on AWS ECS execute the following steps:

- [1. Setup the environment](#_1-setup-the-environment)
- [2. Run Kuma CP](#2-run-kuma-cp)
- [3. Run Kuma DP](#_3-run-kuma-dp)
- [4. Use Kuma](#_4-use-kuma)

Before continuing with the next steps, make sure to have [AWS CLI installed](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html) and [configured](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html).

{% tip %}
The AWS CloudFormation scripts described in this page are parametrized, and we suggest to take a deeper look at those parameters before deploying Kuma.

Also, the scripts are leveraging **AWS Fargate** on top of AWS ECS.
{% endtip %}

### 1. Setup the environment

First we need to download the scripts that will setup our environment. The scripts are stored in the main GitHub repository of Kuma in the [examples folders](https://github.com/kumahq/kuma/tree/1.1.6/examples/ecs).

To download the scripts locally:

```shell
curl --location --output - https://github.com/kumahq/kuma/archive/1.1.6.tar.gz | tar -z --strip 3 --extract --file=- "./kuma-1.1.6/examples/ecs/*yaml"
```

Then we can proceed to install a `kuma` VPC:

```shell
aws cloudformation deploy \
    --capabilities CAPABILITY_IAM \
    --stack-name kuma-vpc \
    --template-file kuma-vpc.yaml
```

### 2. Run Kuma CP

We can run Kuma in either **standalone** or **multi-zone** mode:

{% tabs ecs-run useUrlFragment=false %}
{% tab ecs-run Standalone %}

To deploy the `kuma-cp` stack in standalone mode we can execute:

```shell
aws cloudformation deploy \
    --capabilities CAPABILITY_IAM \
    --stack-name kuma-cp \
    --template-file kuma-cp-standalone.yaml \
    --parameter-overrides AllowedCidr=0.0.0.0/0
```

To learn more, read about the [deployment modes available](/docs/{{ page.version }}/documentation/deployments).

{% endtab %}
{% tab ecs-run Multi-Zone %}

Multi-zone mode is perfect when running one deployment of Kuma that spans across multiple Kubernetes clusters, clouds and VM environments under the same Kuma deployment. This mode also supports hybrid Kubernetes + VMs deployments.

To run Kuma in multi-zone mode, we must install our **global** control plane first:

```shell
aws cloudformation deploy \
    --capabilities CAPABILITY_IAM \
    --stack-name kuma-cp-global \
    --template-file kuma-cp-global.yaml \
    --parameter-overrides AllowedCidr=0.0.0.0/0
```

And as many **remote** control planes as the number of zones we want to support:

```shell
aws cloudformation deploy \
    --capabilities CAPABILITY_IAM \
    --stack-name kuma-cp \
    --template-file kuma-cp-remote.yaml \
    --parameter-overrides AllowedCidr=0.0.0.0/0
```

A Kuma [`ingress` data plane proxy](/docs/{{ page.version }}/documentation/dps-and-data-model/#ingress) is needed in each zone to enable cross-zone communication. Like every other data plane proxy type, it also needs a [data plane proxy token](/docs/{{ page.version }}/installation/ecs/#generate-the-dp-token) if the data plane proxy and control plane communication is secured. Learn more about [DP and CP security](/docs/{{ page.version }}/documentation/security/#data-plane-proxy-to-control-plane-communication).

We can provision a token with the following command:

```shell
ssh root@<kuma-cp-remote-ip> "wget --header='Content-Type: application/json' --post-data='{\"mesh\": \"default\", \"type\": \"ingress\"}' -qO- http://localhost:5681/tokens"
```

And finally deploy the ingress data plane proxy:

```shell
aws cloudformation deploy \
    --capabilities CAPABILITY_IAM \
    --stack-name ingress \
    --template-file remote-ingress.yaml \
    --parameter-overrides \
      DPToken="<token>"
```

To learn more, read the [multi-zone installation instructions](/docs/{{ page.version }}/documentation/deployments).

{% endtab %}
{% endtabs %}

{% warning %}
The examples described above will allow access to the `kuma-cp` to all IPs. In production we should change `--parameter-overrides AllowedCidr=0.0.0.0/0` to point to a more restricted subnet that will be used to administer the Kuma control plane.
{% endwarning %}

#### Security Note

Explore `kuma-cp.yaml` and `kuma-cp-remote.yaml` to set the appropriate `ServerCert` and `ServerKey` parameters. The examples above include pre-generated server certificate and key that are not suitable for production usage, therefore we recommend overriding these values with properly generated certificates with the DNS name in place.

#### Removing the Kuma control plane

To remove the `kuma-cp` stack use (similarly for `kuma-cp-global` and `kuma-cp-remote`) we can execute:

```shell
aws cloudformation delete-stack --stack-name kuma-cp
```

Before moving forward with the next steps, please write down the `kuma-cp` IP address accordingly as we will need its value to continue with the installation.

#### Kuma DNS

The services within the Kuma mesh are exposed through their names (as defined in the `kuma.io/service` tag) in the [`.mesh` DNS zone](/docs/{{ page.version }}/documentation/networking/#kuma-dns). In the default workload example presented in these instructions, our services will be available on `httpbin.mesh`.

Run the following command to create the necessary forwarding rules in AWS Route53 and to leverage the integrated service discovery in `kuma-cp`:

```shell
aws cloudformation deploy \
    --capabilities CAPABILITY_IAM \
    --stack-name kuma-dns \
    --template-file kuma-dns.yaml \
    --parameter-overrides \
      DNSServer=<kuma-cp-ip>
```

The `<kuma-cp-ip>` value (retrieved from the AWS ECS web console or CLI) can be either the public or the private IP of `kuma-cp`. In multi-zone deployments, we will use the remote control plane IP address.

{% tip %}
We strongly recommend exposing the `kuma-cp` instances behind a load balancer, and use the IP of the load balancer as the `DNSServer` parameter value. This will ensure a more robust operation during upgrades, restarts and re-configurations.
{% endtip %}

### 3. Run Kuma DP

While we have installed the Kuma control plane successfully, we still need to start `kuma-dp` alongside our workloads. The `workload.yaml` file provided in the examples is an AWS CloudFormation template that showcases how we can `kuma-dp` as a sidecar container alongside an arbitrary, single port, service container in AWS ECS.

#### Generate the DP token

In order to run the `kuma-dp` container, we have to issue an access token. The latter can be generated using the Admin API of the Kuma CP. Learn more about [DP and CP security](/docs/{{ page.version }}/documentation/security/#data-plane-proxy-to-control-plane-communication).

In this example we'll show the simplest way to generate a new data plane proxy token by executing the following command on the same machine where `kuma-cp` is running (although this is only one of many ways to generate the data plane proxy token):

```shell
ssh root@<kuma-cp-ip> "wget --header='Content-Type: application/json' --post-data='{\"mesh\": \"default\"}' -qO- http://localhost:5681/tokens"
```

Where `<kuma-cp-ip>` is the IP address of `kuma-cp` as it shows in AWS ECS. When asked, supply the default password `root`.

The generated token is valid for all data plane proxies in the `default` mesh. Kuma also allows to generate data plane proxy token in a more restrictive way and [bound to its name or tags](https://kuma.io/docs/1.1.6/documentation/security/#data-plane-proxy-authentication).

{% tip %}
Kuma allows much more advanced and secure ways to expose the `/tokens` endpoint. The full procedure is described in the following security documentation: [data plane proxy authentication](https://kuma.io/docs/1.1.6/documentation/security/#data-plane-proxy-to-control-plane-communication), [user to control plane communication](https://kuma.io/docs/1.1.6/documentation/security/#user-to-control-plane-communication).
{% endtip %}

### 4. Use Kuma

Finally, retrieve the data plane proxy token generated in the previous step and use it in the following `<token>` placeholder:

{% tabs ecs-use useUrlFragment=false %}
{% tab ecs-use Standalone %}

```shell
aws cloudformation deploy \
    --capabilities CAPABILITY_IAM \
    --stack-name workload \
    --template-file workload.yaml \
    --parameter-overrides \
      DesiredCount=2 \
      DPToken="<token>"
```

{% endtab %}
{% tab ecs-use Multi-zone %}

```shell
aws cloudformation deploy \
    --capabilities CAPABILITY_IAM \
    --stack-name workload \
    --template-file workload.yaml \
    --parameter-overrides \
    DesiredCount=2 \
    DPToken="<token>" \
    CPAddress="https://zone-1-controlplane.kuma.io:5678"
```

The `CPAddress` value is the default value provided in the examples, however this should be changed to whatever matches your deployment.

{% endtab %}
{% endtabs %}

By doing so, we are deploying two instances of the `httpbin` container with a `kuma-dp` sidecar running alongside each one of them.

The `workload` template has many parameters so that it can be customized with different workload images, service name and port, and more. You can find more information by looking at the template itself.

### 4. Quickstart

Congratulations! You have successfully installed Kuma on AWS ECS 🚀.

In order to start using Kuma, it's time to check out the [quickstart guide for Universal](/docs/{{ page.version }}/quickstart/universal/) deployments. If you are using Docker you may also be interested in checking out the [Kubernetes quickstart](/docs/{{ page.version }}/quickstart/kubernetes/) as well.
