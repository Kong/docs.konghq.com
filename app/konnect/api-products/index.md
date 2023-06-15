---
title: About API Products
content_type: explanation
---

API Products makes internal APIs discoverable, consumable, and reusable for internal development teams. By leveraging API Products, your application developers can search, discover, and consume existing API products to accelerate their time-to-market, while enabling a more consistent end-user experience across the organization’s applications.

**[Access {{site.konnect_short_name}} API Products](https://cloud.konghq.com/us/apiproducts).**

![{{site.konnect_short_name}} API Products](/assets/images/docs/konnect/konnect-servicehub.png)

## API Products Dashboard

The API Products Dashboard is the place to manage API products, versions, and documentation. The dashboard is available by clicking any API product in API Products. 

Here are some of the things you can do from the API Products Dashboard: 

* Configure an API product
* Publish a service to the Dev Portal
* Manage API product versions. 
* View traffic, error, and latency data. 


![{{site.konnect_short_name}} API Products](/assets/images/docs/konnect/image.png)


Number | Item | Description
-------|------|------------
1 | **API Product Versions** | This section displays the status of an API product version. From the context menu you can **Delete** an API product version, or use the **View Details** button to navigate to that version's dashboard. 
2 | **Analytics** | Analytics data for the API product. You can configure the analytics options using the [**Analytics tool**](/konnect/analytics/)
3 | **Documentation** | You can add markdown documentation for your API product, as well as an API specification for each version of the API product. You can control the individual publishing status of each document you upload to a API product.


### API product versions

A {{site.konnect_short_name}} API product version is associated with a [runtime group](/konnect/runtime-manager/runtime-groups/). As such, the configurations, plugins, specific implementations that are associated with the runtime group are also associated with the API product version. 

API products can have multiple API product versions, and each version can be associated with a different runtime group. API products can be made available in multiple environments by creating API product versions in different runtime groups.

A common use case is environment specialization.
For example, if you have three runtime groups for `development`, `staging`, and
`production`, you can manage which environment the API product is available in by
assigning a version to that group at creation time. You might have v1 running
in `production`, and be actively working on v2 in `development`. Once it's
ready to test, you'd create v2 in `staging` before finally creating v2 in
`production` alongside v1.


### Analytics

The analytics dashboard shown in the API product **Overview** is a high level overview of **traffic**, **error**, and **latency** for the API product. These reports are generated automatically based on the traffic to the API product. 

Learn more: 

* [Analytics overview](/konnect/analytics/)
* [How to analyze services and routes](/konnect/analytics/services-and-routes/)
* [How to generate reports](/konnect/analytics/generate-reports/)

### Documentation

The API product **Documentation** can be used to manage documentation for your API product. Documentation can be either an API spec, or Markdown documentation for the API product. Once the documentation is uploaded it can be edited from the dashboard. The documentation can be accessed once the API product is published.

Learn more: 

* [Manage service documentation](/konnect/api-products/service-documentation/)

### {{site.base_gateway}} deployments

When configuring a {{site.base_gateway}} deployment of an API product, you'll
need to specify a route. Routes determine how successful requests are sent to
their services after they reach the API gateway. A single API product version
can have only one deployment, but potentially many routes.

{:.important}
> **Important**: Starting with {{site.base_gateway}} 3.0.0.0, the router supports logical expressions.
Regex routes must begin with a `~` character. For example: `~/foo/bar/(?baz\w+)`.
Learn more in the [route configuration guide](/gateway/latest/key-concepts/routes/expressions/).

After configuring the API product, version, implementation, and at least one route,
you’ll be able to start making requests through {{site.konnect_saas}}.

## More information

* [Deploy and Test a Service](/getting-started/implement-service/) - Learn how to deploy and test a service with Runtime Manager.
* [Productize a Service](/getting-started/configure-service/) - Learn how to productize a service with API Products.