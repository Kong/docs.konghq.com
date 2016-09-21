---
id: page-install-method mesos
title: Install - Kong deployment on DC/OS cluster
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

Provision Kong on Mesosphere DC/OS cluster using following steps.

Following guide use AWS for provisioning the DC/OS Cluster and assumes you have basic knowledge of [DC/OS]({{ page.links.dcos }}), [Marathon]({{ page.links.marathon }}) and [Marathon-lb]({{ page.links.marathon-lb }}). 
You can spawn Cluster on any supported Platform or on a local machine 


1. **Initial setup**:

    Deploy a cluster following the DC/OS [AWS documentation]({{ page.links.mesos-aws }}).
    Once you have cluster ready, Application can deployed using DC/OS [CLI]({{ page.links.mesos-cli }}) or DCOS [GUI]({{ page.links.mesos-gui }}).      

2. **Deploy Marathon-lb**

    Download or clone the repo

    ```bash
    $ git clone git@github.com:Mashape/kong-dist-mesos.git
    $ cd kong-dist-mesos
    ```

    Deploy Marathon-lb for internal and external Service discovery support

    ```bash
    $ dcos package install marathon-lb
    $ dcos package install --options=marathon-lb-internal.json marathon-lb
    ```
3. **Deploy Kong supported Database**

    ```bash
    $ dcos marathon app add postgres.json
    ```

4. **Deploy Kong**

    ```bash
    $ dcos marathon app add kong.json
    ```

5. **Using Kong:**

    If you used [AWS documentation]({{ page.links.mesos-aws }}) to create the cluster then you have to expose Kong service ports on Public ELB to access the kong Services externally. You can also log into the Public Slave agent and curl Kong services.  

    ```bash
    $ curl marathon-lb.maraton.mesos:10001
    $ curl marathon-lb.maraton.mesos:10002
    ```

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/latest/getting-started/quickstart).

## Enterprise Support

Support, Demo, Training, API Certifications and Consulting available at http://getkong.org/enterprise.
