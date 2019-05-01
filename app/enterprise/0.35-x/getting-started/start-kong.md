---
title: How to Start Kong Enterprise
toc: false
---
A **Super Admin** account is required to secure the Admin API with RBAC or Kong 
Manager with an authentication plugin. 

The **Super Admin** account is created 
during database migrations. 

To set up the first account:

1. Set a password for the **Super Admin**. This environment variable must
    be present in the environment where database migrations will run. 

    ```
    $ export KONG_PASSWORD=<password-only-you-know>
    ```

    This creates a user, `kong_admin`, and a password that can be used to
    log in to Kong Manager or to make Admin API requests when RBAC is enabled.

2. Issue the following command to prepare your datastore by running the Kong
    migrations:

    ```bash
    $ kong migrations bootstrap [-c /path/to/kong.conf]
    ```

    You should see a message that tells you Kong has successfully migrated your
    database. If not, you probably incorrectly configured your database
    connection settings in your configuration file.

3. Now let's [start][CLI] Kong:

    ```bash
    $ kong start [-c /path/to/kong.conf]
    ```

**Note:** the CLI accepts a configuration option (`-c /path/to/kong.conf`)
allowing you to point to [your own configuration](/1.0.x/configuration/#configuration-loading).
