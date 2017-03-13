---
id: page-install-method
title: Install - Kong on DCOS
header_title: Kong deployment on DC/OS cluster
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
links:
  mesos-aws: "https://dcos.io/docs/1.8/administration/installing/cloud/aws/"
  mesos-cli: "https://docs.mesosphere.com/1.8/usage/cli/"
  mesos-gui: "https://docs.mesosphere.com/1.8/usage/webinterface/"
  marathon: "https://mesosphere.github.io/marathon/"
  marthon-lb: "https://docs.mesosphere.com/1.7/usage/service-discovery/marathon-lb/usage/"
  dcos: "https://docs.mesosphere.com/1.8/overview/"
---

Kong can easily be provisioned on a Mesosphere DC/OS cluster using following
steps:

The following steps use AWS for provisioning the DC/OS cluster and assumes you 
have basic knowledge of [DC/OS]({{ page.links.dcos }}), 
[Marathon]({{ page.links.marathon }}), and
[Marathon-lb]({{ page.links.marathon-lb }}). 

1. **Initial setup**

    Download or clone the following repo:

    ```bash
    $ git clone git@github.com:Mashape/kong-dist-mesos.git
    $ cd kong-dist-mesos
    ```

    Skip to step 3 if you have already provisioned a DC/OS cluster.

2. **Deploy a DC/OS cluster**

    Following the DC/OS
    [AWS documentation]({{ page.links.mesos-aws }}), deploy a DC/OS cluster on
    which Kong will be provisioned
    
    Once your cluster is ready, Kong can be deployed using the
    [DC/OS CLI]({{ page.links.mesos-cli }}) or the
    [DC/OS GUI]({{ page.links.mesos-gui }}).      

3. **Deploy Marathon-lb**

    Using the `marathon-lb-internal.json` file included in the kong-dist-mesos
    repo, deploy Marathon-lb for internal and external service discovery
    support:

    ```bash
    $ dcos package install marathon-lb
    $ dcos package install --options=marathon-lb-internal.json marathon-lb
    ```

4. **Deploy a Kong supported database**
  
    Before deploying Kong, you need to provision a Cassandra or PostgreSQL
    instance.

    For Cassandra, use the `cassandra.json` file from the kong-dist-mesos 
    repo to deploy a Cassandra instance in the cluster:

    ```bash
    $ dcos package install cassandra
    ```

    For PostgreSQL, use the `postgres.json` file from the kong-dist-mesos 
    repo to deploy a PostgreSQL instance in the cluster:

    ```bash
    $ dcos marathon app add postgres.json
    ```

5. **Deploy Kong**

    Using the `kong_<postgres|cassandra>.json` file from the
    kong-dist-mesos repo, deploy Kong in the cluster:

    ```bash
    $ dcos marathon app add kong_<postgres|cassandra>.json
    ```

6. **Verify your deployments**

    If you followed the [AWS documentation]({{ page.links.mesos-aws }}) to
    create the cluster, then you have to expose your Kong service ports on the
    public ELB to access the Kong services externally.
    
    You can also log into the public slave agent and test Kong by making the
    following requests: 

    ```bash
    $ curl marathon-lb.maraton.mesos:10001
    $ curl marathon-lb.maraton.mesos:10002
    ```

7. **Using Kong**

    Quickly learn how to use Kong with the 
    [5-minute Quickstart](/docs/latest/getting-started/quickstart/).
