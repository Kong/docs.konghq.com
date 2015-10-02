---
id: page-install-method
title: Install - Vagrant
header_title: Vagrant Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
---

{% capture cassandra_version %}{{site.data.kong_latest.dependencies.cassandra}}{% endcapture %}

### Starting the Environment:

1. **Clone Kong:**

    ```bash
    $ git clone https://github.com/Mashape/kong
    ```

2. **Get the Vagrantfile:**

    ```bash
    $ git clone https://github.com/Mashape/kong-vagrant
    $ cd kong-vagrant/
    ```

3. **Start Vagrant:**

    ```bash
    $ KONG_PATH=/path/to/kong/clone/ vagrant up
    ```
    <br/>
    This will tell Vagrant to mount your local Kong repository under the guest's /kong folder.

    The startup process will install all the dependencies necessary for developing (including Cassandra). The kong source code is mounted at `/kong`. The host ports `8000` and `8001` will be forwarded to the Vagrant box.

    <div class="alert alert-warning">
      <div class="text-center">
        <strong>Note</strong>: Check out the <a href="{{ site.repos.vagrant }}">kong-vagrant</a> repository for further details.
      </div>
    </div>

4. **Use Kong:**

    Quickly learn how to use Kong with the [5-minute Quickstart](/docs/latest/getting-started/quickstart).
