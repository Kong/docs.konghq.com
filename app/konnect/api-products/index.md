---
title: API Products
content_type: explanation
---

API Products in {{site.konnect_short_name}} are collections of API product versions, documentation and API specs. Each API product consists of at least one API product version, and each API product version is composed to an existing Gateway service. 

## API Products Dashboard

The API Products Dashboard is the place to manage API products, versions, and documentation. The dashboard is available by clicking any API product in API Products. 

Here are some of the things you can do from the API Products Dashboard: 

* Configure an API product
* Publish an API product to the Dev Portal
* Manage API product versions. 
* View traffic, error, and latency data. 


![{{site.konnect_short_name}} API Products](/assets/images/products/konnect/api-products/api-products-manage.png)


| Item | Description
-------|------|------------
**Overview** | Analytics data for the API product. You can configure the analytics options using the [**Analytics tool**](/konnect/analytics/).
**Product Versions** | This section displays the status of an API product version. From the context menu you can **Delete** an API product version, or use the **View Details** button to navigate to that version's dashboard. 
**Documentation** | In this section you can manage documentation for your API product, this includes API specs and comprehensive markdown documentation.


### API product versions

A {{site.konnect_short_name}} API product version is linked to a Gateway service inside a [control plane](/konnect/gateway-manager/#control-planes). As such, the configurations or plugins that are associated with the Gateway service are also associated with the API product version. 

API products can have multiple API product versions, and each version can be linked to a Gateway service. API products can be made available in multiple environments by linking API product versions to Gateway services in different control planes. You can also associate an API spec with a product version and make the spec accessible in the Dev Portal.

A common use case is environment specialization.
For example, if you have three control planes for `development`, `staging`, and
`production`, you can manage which environment the API product version is available in by
linking an API product version to a Gateway service in that control plane. You might have v1 running
in `production`, and be actively working on v2 in `development`. Once it's
ready to test, you'd create v2 in `staging` before finally creating v2 in
`production` alongside v1.


### Analytics

The analytics dashboard shown in the API product **Overview** is a high level overview of **traffic**, **error**, and **latency** for the API product. These reports are generated automatically based on the traffic to the API product. 

Learn more: 

* [Analytics overview](/konnect/analytics/)
* [How to generate reports](/konnect/analytics/generate-reports/)

### Documentation

{{site.konnect_short_name}} enhances API product management by offering comprehensive documentation capabilities within the {{site.konnect_short_name}} manager and hosting it on the Dev Portal for consumption. The editor utilizes rich markdown rendering offering built-in syntax highlighting, support for Mermaid.js and PlantUML. 

Learn more: 

* [Manage service documentation](/konnect/api-products/service-documentation/)

## More information

* [Deploy and Test a Service](/konnect/getting-started/deploy-service/) - Learn how to deploy and test a service with Gateway Manager.
* [Productize a Service](/konnect/getting-started/productize-service/) - Learn how to productize a service with API Products.