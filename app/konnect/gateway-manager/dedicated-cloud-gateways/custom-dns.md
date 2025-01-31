---
title: Custom Domains for Dedicated Cloud Gateways
---

{{site.konnect_short_name}} integrates domain name management and configuration with [managed data planes](/konnect/gateway-manager/dedicated-cloud-gateways/).


## {{site.konnect_short_name}} configuration

1. Open {% konnect_icon runtimes %} **Gateway Manager**, choose a control plane to open the **Overview** dashboard, then click **Connect**.
    
    The **Connect** menu will open and display the URL for the **Public Edge DNS**. Save this URL.

2. Select **Custom Domains** from the side navigation, then **New Custom Domain**, and enter your domain name.

    Save the values that appear under **CNAME** and **Content**. 


## Domain registrar configuration

3. Log in to your domain registrar's dashboard.
4. Navigate to the DNS settings section. This area might be labeled differently depending on your registrar.
5. Locate the option to add a new CNAME record and create the following records using the values saved in the [{{site.konnect_short_name}} configuration](#konnect-configuration) section. For example, in AWS Route 53, it would look like this: 

| Host Name                       | Record Type | Routing Policy | Alias | Evaluate Target Health | Value                                                | TTL |
|---------------------------------|-------------|----------------|-------|------------------------|------------------------------------------------------|-----|
| `_acme-challenge.example.com` | CNAME       | Simple         | No    | No                     | `_acme-challenge.9e454bcfec.acme.gateways.konghq.com`| 300 |
| `example.com`             | CNAME       | Simple         | No    | No                     | `9e454bcfec.gateways.konghq.com`                     | 300 |


  {:.note}
  > **Note:** DNS validation statuses for Dedicated Cloud Gateways are refreshed every 5 minutes.


## Delete a custom domain {#delete-url}

1. In {{site.konnect_short_name}}, open {% konnect_icon runtimes %} **Gateway Manager**, choose a control plane to open the **Overview** dashboard, then click **Custom Domains**.

2. Click the action menu on the end of the row you want to delete and click **Delete**.

## Custom Domain Attachment & CAA Record Issue

If your custom domain attachment fails, check if your domain has a CAA record restricting certificate issuance. Dedicated Cloud Gateways uses GCP Public CA to provision SSL/TLS certificates. If your CAA record does not include the required CA, certificate issuance will fail.

Steps to Fix:
1. Check existing CAA records
    * Run: dig CAA yourdomain.com +short
    * If a CAA record exists but doesn't allow GCP Public CA (pki.goog), update it.   
2. Update the CAA record (if needed)
    * yourdomain.com.    CAA    0 issue "pki.goog"
3. Wait for DNS propagation and retry attaching your domain.

If no CAA record exists, no changes are needed. More details: [Let's Encrypt CAA Guide](https://letsencrypt.org/docs/caa/)  
