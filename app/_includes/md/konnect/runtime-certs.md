<!-- Shared between Konnect gateway runtime config topics: Docker, Kubernetes, and kong.conf -->
1. In Konnect, from the left navigation menu, select **Runtimes**.

    For the first runtime, the page opens to a **Configure New Runtime** form.

    Once configured, this page lists all runtimes associated with the
    {{site.konnect_short_name}} SaaS account.

2. (Optional) If this is not the first runtime configuration, click
**Configure New Runtime**.

2. Open the **Advanced** tab.

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

<div class="alert alert-ee warning">
<b>Important:</b> Certificates expire after six months and must be renewed. See
<a href="/konnect/runtime-manager/renew-certificates">Renew Certificates</a>.
</div>

Keep the configuration page open for the next section, as you'll need to refer
back to it for the configuration parameters.
