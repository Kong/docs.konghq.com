<!-- Shared between Konnect gateway runtime config topics: Docker, Kubernetes, and kong.conf -->
1. In Konnect, from the left navigation menu, select **Runtimes**.

    For the first runtime, the page opens to a **Configure New Runtime** form.

    Once configured, this page lists all runtimes associated with the
    {{site.konnect_saas}} account.

2. (Optional) If this is not the first runtime configuration, click
**Configure New Runtime**.

2. Open the tab that suits your environment: **Linux** or **Kubernetes**.

    For an advanced **Docker** setup, use either tab. Do not use the
    **Quick Setup** tab.

3. Click **Generate Certificate**.

    Three new fields appear: a certificate, a private key, and a root CA
    certificate. The contents of these fields are unique to each
    runtime configuration.

5. Save the contents of each field into a separate file in a safe location:

    * Certificate: `tls.crt`
    * Private key: `tls.key`
    * Root CA Certificate: `ca.crt`

    If you navigate away from this page before saving all of the
    certificate and key files, you will need to regenerate them.

6. Store the files on your runtime's local filesystem.

{:.important}
> **Important:** Certificates expire every six (6) months and must be renewed.
See [Renew Certificates](/konnect/runtime-manager/renew-certificates).

Keep the configuration page open for the next section, as you'll need to refer
back to it for the configuration parameters.
