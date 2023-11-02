This directory stores API specs for the creation of the "Run on Insomnia" buttons found on the [API docs page](https://docs.konghq.com/api/). This directory is also the source of truth for the beta Kong Gateway Enterprise and Open Source Admin API specs. 

The latest consumable versions of the API spec are available at https://docs.konghq.com/api/


## How to update Gateway admin API documentation

While we are in beta the process is as follows:

If you have to add/delete an endpoint, edit parameters, add parameter descriptions, add examples, and so on, **edit the spec directly** in its source location.


## Update non-admin API specs

The source of truth for all other specs is the [platform-api](https://github.com/Kong/platform-api) repo. Open a PR against a spec to update it.
