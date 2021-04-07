<!-- Shared between Konnect gateway runtime config topics: Docker, Kubernetes, and kong.conf -->
1. In Konnect, from the left navigation menu, select **Runtimes**.

    For the first runtime, the page opens to a **Configure New Runtime** form.

    Once configured, this page lists all runtimes associated with the
    {{site.konnect_short_name}} SaaS account.

2. (Optional) If this is not the first runtime configuration, click
**Configure New Runtime**.

3. Click **Generate Certificate**.

    Three new fields appear: a certificate, a private key, and a root CA
    certificate. The contents of these fields are unique to each
    runtime configuration.

4. Save the contents of each field into a separate file in a safe location:

    * Certificate: `cluster.crt`
    * Private key: `cluster.key`
    * Root CA Certificate: `ca.crt`

    <div class="alert alert-warning">
    <b>Important:</b> Do not navigate away from this page while saving the
    certificate and key files. They are unique and won't display again.</div>

5. Store the files on your runtime's local filesystem.

Next, configure a {{site.base_gateway}} runtime using the
certificate, the private key, and the remaining configuration details on the
**Configure Runtime** page.
