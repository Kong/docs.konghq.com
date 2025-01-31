---
title: Custom Domains for Serverless Gateways
---

{{site.konnect_short_name}} integrates domain name management and configuration with [Serverless](/konnect/gateway-manager/serverless-gateways/) gateways. 


## {{site.konnect_short_name}} configuration

1. Open {% konnect_icon runtimes %} **Gateway Manager**, choose a control plane to open the **Overview** dashboard, then click **Connect**.
    
    The **Connect** menu will open and display the URL for the **Public Edge DNS**. Save this URL.

1. Select **Custom Domains** from the side navigation, then **New Custom Domain**, and enter your domain name.

    Save the value that appears under **CNAME**. 


## Domain registrar configuration

1. Log in to your domain registrar's dashboard.
1. Navigate to the DNS settings section. This area might be labeled differently depending on your registrar.
1. Locate the option to add a new CNAME record and create the following record using the value saved in the [{{site.konnect_short_name}} configuration](#konnect-configuration) section. For example, in AWS Route 53, it would look like this: 

| Host Name                       | Record Type | Routing Policy | Alias | Evaluate Target Health | Value                                                | TTL |
|---------------------------------|-------------|----------------|-------|------------------------|------------------------------------------------------|-----|
| `my.example.com`             | CNAME       | Simple         | No    | No                     | `9e454bcfec.kongcloud.dev`                     | 300 |


  {:.note}
  > **Note:** Once a Serverless Gateway custom DNS record has been validated, it will _not_ be refreshed or re-validated. Remove and re-add the custom domain in {{site.konnect_short_name}} to force a re-validation.


## Delete a custom domain {#delete-url}

1. In {{site.konnect_short_name}}, open {% konnect_icon runtimes %} **Gateway Manager**, choose a control plane to open the **Overview** dashboard, then click **Custom Domains**.

2. Click the action menu on the end of the row you want to delete and click **Delete**.

## Custom Domain Attachment & CAA Record Issue

If your custom domain attachment fails, check if your domain has a CAA record restricting certificate issuance. Serverless Gateways uses Let's Encrypt CA to provision SSL/TLS certificates. If your CAA record does not include the required CA, certificate issuance will fail.

Steps to Fix:
1. Check existing CAA records
    * Run: dig CAA yourdomain.com +short
    * If a CAA record exists but doesn't allow Let's Encrypt (letsencrypt.org), update it.   
2. Update the CAA record (if needed)
    * yourdomain.com.    CAA    0 issue "letsencrypt.org"
3. Wait for DNS propagation and retry attaching your domain.

If no CAA record exists, no changes are needed. More details: [Let's Encrypt CAA Guide](https://letsencrypt.org/docs/caa/)  

