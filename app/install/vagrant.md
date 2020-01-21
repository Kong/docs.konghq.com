---
id: page-install-method
title: Install - Vagrant
header_title: Vagrant Installation
header_icon: /assets/images/icons/icn-installation.svg
breadcrumbs:
  Installation: /install
toc: false
---

Vagrant can be used to create an isolated environment for Kong and its
dependencies.

You can use the Vagrant box either as an all-in-one Kong installation for
testing purposes, or you can link it up with source code and start developing
on Kong or on custom plugins.

Here is a quick example showing how to build a (disposable) test setup:

1. **Get the Vagrantfile and start the VM**

    ```bash
    $ git clone https://github.com/Kong/kong-vagrant
    $ cd kong-vagrant/
    $ vagrant up
    ```

2. **Start Kong**

    The default Vagrantfile will install both PostgreSQL and Cassandra. PostgreSQL is the default:


    ```bash
    # specify migrations flag to initialise the datastore
    $ vagrant ssh -c "kong start --run-migrations"
    ```

    Cassandra is available via a setting:

    ```bash
    $ vagrant ssh -c "KONG_DATABASE=cassandra kong start --run-migrations"
    ```

    To start Kong in DB-less mode, use this:

    ```bash
    $ vagrant ssh -c "KONG_DATABASE=off kong start"
    ```

    If you want to include a [declarative configuration file](/{{site.data.kong_latest.release}}/db-less-and-declarative-config/),
    put it inside a `./kong/kong.yml` folder, and it will be available through the `/kong/kong.yml` path in Vagrant:

    ```bash
    $ vagrant ssh -c "KONG_DECLARATIVE_CONFIG=/kong/kong.yml KONG_DATABASE=off kong start"
    ```

    The host ports `8000`, `8001`, `8443`, and `8444` will be forwarded to the Vagrant box.

    <div class="alert alert-warning">
      <div class="text-center">
        <strong>Note</strong>: Check out the <a href="{{ site.repos.vagrant }}">kong-vagrant</a> repository for further details on customizations and development.
      </div>
    </div>

3. **Use Kong**

    Kong is running:

    ```bash
    $ curl http://127.0.0.1:8001
    ```

    Quickly learn how to use Kong with the [5-minute Quickstart](/latest/getting-started/quickstart).
