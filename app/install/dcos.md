---
id: page-install-method
title: Install - Kong on DCOS
header_title: Kong deployment on DC/OS cluster
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
links:
  mesos-aws: "https://dcos.io/docs/1.9/installing/cloud/aws/"
  mesos-cli: "https://dcos.io/docs/1.9/cli/"
  mesos-gui: "https://dcos.io/docs/1.9/gui/"
  marathon: "https://mesosphere.github.io/marathon/"
  marathon-lb: "https://dcos.io/docs/1.9/networking/marathon-lb/"
  vips: "https://dcos.io/docs/1.9/networking/load-balancing-vips/virtual-ip-addresses/"
  dcos: "https://dcos.io/docs/1.9/"
  hello-app: "https://hub.docker.com/r/mashape/node-web-app/"
---

Kong can be provisioned on a Mesosphere DC/OS cluster using following
steps:

The following steps use AWS for provisioning the DC/OS cluster and assume you 
have basic knowledge of [DC/OS]({{ page.links.dcos }}), 
[Marathon]({{ page.links.marathon }}), [VIPs]({{ page.links.vips }}), and
[Marathon-LB]({{ page.links.marathon-lb }}). 

1. **Initial setup**

    Download or clone the following repo:

    ```bash
    $ git clone git@github.com:Mashape/kong-dist-dcos.git
    $ cd kong-dist-dcos
    ```

    Skip to step 3 if you have already provisioned a DC/OS cluster.

2. **Deploy a DC/OS cluster**

    Following the DC/OS
    [AWS documentation]({{ page.links.mesos-aws }}), deploy a DC/OS cluster on
    which Kong will be provisioned
    
    Once your cluster is ready, Kong can be deployed using the
    [DC/OS CLI]({{ page.links.mesos-cli }}) or the
    [DC/OS GUI]({{ page.links.mesos-gui }}).      

3. **Deploy Marathon-LB**

    We will use the `marathon-lb` package to deploy
    [Marathon-LB]({{ page.links.marathon-lb }}) for load balancing external
    traffic to cluster and [VIPs]({{page.links.vips}}) for load balancing
    internal traffic:

    ```bash
    $ dcos package install marathon-lb
    ```

4. **Deploy a Kong-supported database**
  
    Before deploying Kong, you need to provision a Cassandra or PostgreSQL
    instance.

    For Cassandra, use the `cassandra` package to deploy 3 nodes of Cassandra
    in the DC/OS cluster:

    ```bash
    $ dcos package install cassandra
    ```

    For PostgreSQL, use the `postgres.json` file from the kong-dist-dcos 
    repo to deploy a PostgreSQL instance in the cluster:

    ```bash
    $ dcos marathon app add postgres.json
    ```

5. **Deploy Kong**

    Using the `kong_<postgres|cassandra>.json` file from the kong-dist-dcos
    repo, deploy Kong in the cluster. Template registers Kong's `proxy` and
    `admin` ports on Marathon-LB as service ports `10001` and `10002`
    respectively:

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
    $ curl marathon-lb.marathon.mesos:10001
    $ curl marathon-lb.marathon.mesos:10002
    ```

7. **Deploy an upstream server**

    For this demo, we will use an [app]({{ page.links.hello-app }}) which
    returns `Hello world` on port `8080`. Using the `my_app.json` file from the
    kong-dist-dcos repo, deploy the app in the cluster which will act as a
    backend server to process requests received from Kong:

    ```bash
    $ dcos marathon app add my_app.json
    ```

8. **Using Kong**
    
    Create an API on Kong:

    ```bash
    $ curl -i -X POST marathon-lb.marathon.mesos:10002/apis \
        --data "name=myapp" \
        --data "hosts=myapp.com" \
        --data "upstream_url=http://myapp.marathon.l4lb.thisdcos.directory:8080"
    HTTP/1.1 201 Created
    ...

    ```

    Make a request to the API:

    ```bash
    $ curl -i -X GET marathon-lb.marathon.mesos:10001 \
        --header "Host:myapp.com"
    HTTP/1.1 200 OK
    ...

    Hello world
    ```

    Quickly learn how to use Kong with the 
    [5-minute Quickstart](/docs/latest/getting-started/quickstart/).
