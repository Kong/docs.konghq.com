---
title: Configure Auth0 for Dynamic Client Registration
breadcrumb: Auth0
content_type: how-to
---


## Prerequisites

* Enterprise {{site.konnect_short_name}} account.
* An [Auth0 account](https://auth0.com/)

{:.note}
> **Note:** When using Auth0 DCR for Dev Portal, each application in Auth0 will have the following metadata. This can be viewed via the auth0 dashboard, or accessed from the Auth0 API.
>
> * `konnect_portal_id`: ID of the Portal the application belongs to
> * `konnect_developer_id`: ID of the developer in the Dev Portal that this application belongs to
> * `konnect_org_id`: ID of the Konnect Organization the application belongs to
> * `konnect_application_id`: ID of the application in the Dev Portal

## Configure Auth0

To use dynamic client registration (DCR) with Auth0 as the identity provider (IdP), there are two important configurations to prepare in Auth0. First, you must authorize an Auth0 application so {{site.konnect_short_name}} can use the Auth0 Management API on your behalf. Next, you will create an API audience that {{site.konnect_short_name}} applications will be granted access to.

To get started configuring Auth0, log in to your Auth0 dashboard and complete the following:

### Configure access to the Auth0 Management API

{{site.konnect_short_name}} will use a client ID and secret from an Auth0 application that has been authorized to perform specific actions in the Auth0 Management API.

1. From the sidebar, select **Applications > Applications**.

2. Click the **Create Application** button.

3. Give the application a memorable name, like "{{site.konnect_short_name}} Portal DCR Admin."

4. Select the application type **Machine to Machine Applications** and click **create**.

5. Authorize the application to access the Auth0 Management API by selecting it from the dropdown. Its URL will follow the pattern: `https://AUTH0_TENANT_SUBDOMAIN.REGION.auth0.com/api/v2/`.

6. In the **Permissions** section, select the following permissions to grant access, then click **Authorize**.
   * `read:client_grants`
   * `create:client_grants`
   * `delete:client_grants`
   * `update:client_grants`
   * `read:clients`
   * `create:clients`
   * `delete:clients`
   * `update:clients`
   * `update:client_keys`
  
   {:.note}
   > **Note:** If you’re using Developer Managed Scopes, add `read:resource_servers` to the permissions for your initial client application.

7. On the application's **Settings** tab, locate the values for **Client ID** and **Client Secret** – you will need them in a later step.

### Configure the API audience

{:.note}
> **Note:** You can use an existing API entity if there is one already defined in Auth0 that represents the audience you are/will be serving with {{site.konnect_short_name}}  Dev Portal applications.
In most cases, it is a good idea to create a new API that is specific to your Konnect Portal applications.

To create a new API audience:

1. In the sidebar, navigate to **Applications > APIs**.

2. Click **Create API**.

3. Enter a **Name**, such as `{{site.konnect_short_name}} Portal Applications`.

4. Set the **Identifier** to a value that represents the audience your API will serve.

5. Click **Create**.

6. Make a note of the **Identifier** value (also known as the **Audience**); you will need it when configuring the authentication strategy in `{{site.konnect_short_name}}`.

## Configure the Dev Portal

Once you have configured Auth0, you can set up the Dev Portal to use Auth0 for Dynamic Client Registration (DCR). This process involves two steps: creating the DCR provider and establishing the authentication strategy.

DCR providers are reusable configurations, meaning that once you've set up the Auth0 DCR provider, you can use it across multiple authentication strategies without needing to configure it again.

{% navtabs %}
{% navtab Konnect UI %}

1. Sign in to {{site.konnect_short_name}}, then select {% konnect_icon dev-portal %} **Dev Portal** from the menu.

2. Navigate to **Application Auth** to access the authentication settings for your API products.

3. Open **DCR providers** to view all configured DCR providers.

4. Select **New DCR provider** to create an Auth0 configuration. Provide a name for internal use in {{site.konnect_short_name}}. The name and provider type information will not be exposed to Dev Portal developers.

5. Enter the **Issuer URL** of your Auth0 tenant, formatted as: `https://AUTH0_TENANT_SUBDOMAIN.us.auth0.com`. *Do not* include a trailing slash at the end of the URL.

   {:.note}
   > **Note:** You can find the value for your `AUTH0_TENANT_SUBDOMAIN` by checking the **Tenant Name** under **Settings** > **General**.

6. Choose Auth0 as the **Provider Type**.

7. Enter the **Client ID** of the previously created admin application in Auth0 into the **Initial Client ID** field. Then, enter the **Client Secret** of the same application into the **Initial Client Secret** field.

8. If you're using a custom domain for Auth0, enter the audience of the initial client as the **Client Audience**. Otherwise, leave this field blank.

9. **Optional**: If you're using developer-managed scopes, select the **Use Developer Managed Scopes** checkbox.

10. Save the DCR provider. It will now appear in the list of DCR providers.

11. Click the **Auth Strategy** tab to view all available authentication strategies. Select **New Auth Strategy** to create an auth strategy that uses the DCR provider you created.

12. Enter a name for internal use in `{{site.konnect_short_name}}`, and a display name that will be shown in the Dev Portal. In the **Auth Type** dropdown, select **DCR**. In the **DCR Provider** dropdown, choose the name of the DCR provider configuration you created. The **Issuer URL** will be prepopulated with the URL you added to the DCR provider.

13. Enter the required `openid` scope in the **Scopes** field, along with any other scopes your developers may need (e.g., `openid, read:account_information, write:account_information`). If you are using developer-managed scopes, these will be the scopes your developers can select from in the Dev Portal.

14. Enter `azp` in the **Credential Claims** field. This will match the client ID of each Auth0 application.

15. Enter the **Audience** value from your associated Auth0 API in the **Audience** field. If you're using developer-managed scopes, the scopes selected by the developer should belong to this audience.

16. Choose the required **Auth Methods** (`client_credentials`, `bearer`, `session`) and **save**.
{% endnavtab %}
{% navtab API %}

1. Start by creating the DCR provider. Send a `POST` request to the [`dcr-providers`](/konnect/api/application-auth-strategies/latest/#/DCR%20Providers/create-dcr-provider) endpoint with your DCR configuration details:

```sh
   curl --request POST \
   --url https://us.api.konghq.com/v2/dcr-providers \
   --header 'Authorization: $KPAT' \
   --header 'content-type: application/json' \
   --data '{
   "name": "Auth0 DCR Provider",
   "provider_type": "auth0",
   "issuer": "https://my-issuer.auth0.com/api/v2/",
   "dcr_config": {
      "initial_client_id": "abc123",
      "initial_client_secret": "abc123xyz098!",
      "initial_client_audience": "https://my-custom-domain.com/api/v2/"
   }
   }'
```

You will receive a response that includes a `dcr_provider` object similar to the following:

   ```sh
   {
      "created_at": "2024-02-29T23:38:00.861Z",
      "updated_at": "2024-02-29T23:38:00.861Z",
      "id": "93f8380e-7798-4566-99e3-2edf2b57d289",
      "name": "Auth0 DCR Provider",
      "provider_type": "auth0",
      "issuer": "https://my-issuer.auth0.com/api/v2/",
      "dcr_config": {
         "initial_client_id": "abc123",
         "initial_client_audience": "https://my-custom-domain.com/api/v2/"
      },
      "active": false
   }

   ```

Save the `id` value for creating the authentication strategy.

2. Using the `dcr_id` from the previous step, create an authentication strategy by sending a `POST` request to the [`create-auth-strategies`](/konnect/api/application-auth-strategies/latest/#/App%20Auth%20Strategies/create-app-auth-strategy) endpoint, detailing the authentication strategy.

```sh
   curl --request POST \
   --url https://us.api.konghq.com/v2/application-auth-strategies \
   --header 'Authorization: $KPAT' \
   --header 'content-type: application/json' \
   --data '{
   "name": "Auth0 Auth",
   "display_name": "Auth0 Auth",
   "strategy_type": "openid_connect",
   "configs": {
      "openid-connect": {
         "issuer": "https://my-issuer.auth0.com/api/v2/",
         "credential_claim": [
         "client_id"
         ],
         "scopes": [
         "openid",
         "email"
         ],
         "auth_methods": [
         "client_credentials",
         "bearer"
         ]
      }
   },
   "dcr_provider_id": "93f8380e-7798-4566-99e3-2edf2b57d289"
   }'
```

{% endnavtab %}
{% endnavtabs %}

## Create an application with DCR

From the **My Apps** page in the Dev Portal, follow these steps:

1. Click **New App**.

2. Fill out the **Create New Application** form with your application name, authentication strategy, and description.

3. Click **Create** to save your application.

4. After your application is created, you will see the **Client ID** and **Client Secret**.
   Store the Client Secret, it will only be shown once.  

5. Click **Proceed** to continue to the application's details page.

## Make a successful request

In the previous steps, you obtained the **Client ID** and **Client Secret**. To authorize the request, include the client secret pair in the header. You can do this using any API client, such as [Insomnia](https://insomnia.rest/), or directly from the command line:

```sh
curl example.com/REGISTERED_ROUTE -H "Authorization: Basic CLIENT_ID:CLIENT_SECRET"
```

Where `example.com` is the address of the runtime instance you are running.

## Using Auth0 actions

[Auth0 actions](https://auth0.com/docs/customize/actions) allow you to customize your application in Auth0. With Auth0 actions, you can configure a custom application name in Auth0, rather than using the default name set by the developer in the Dev Portal. For example, you can set the application name to be a combination of `konnect_portal_id`, `konnect_developer_id`, and `konnect_application_id`. For certain other actions, changes can be made directly via the API object passed to `onExecuteCredentialsExchange`.

1. Follow the [Auth0 documentation](https://auth0.com/docs/customize/actions/write-your-first-action#create-an-action) to create a custom action on the "Machine to Machine" flow.

2. Use the following code as an example for what your action could look like. Update the initial `const` variables with the values from the when you configured DCR.

   ```js

   const axios = require("axios");

   const INITIAL_CLIENT_AUDIENCE = 
   const INITIAL_CLIENT_ISSUER = 
   const INITIAL_CLIENT_ID = 
   const INITIAL_CLIENT_SECRET = 

   exports.onExecuteCredentialsExchange = async (event, api) => {
      const metadata = event.client.metadata
      if (!metadata.konnect_portal_id) {
         return
      }
      const newClientName = `${metadata.konnect_portal_id}+${metadata.konnect_developer_id}+${metadata.konnect_application_id}`
      await updateApplication(event.client.client_id, {
         name: newClientName
      })
   };

   async function getShortLivedToken() {
      const tokenEndpoint = new URL('/oauth/token', INITIAL_CLIENT_ISSUER).href
      const headers = {
         'Content-Type': 'application/json',
      }

      const payload = {
         client_id: INITIAL_CLIENT_ID,
         client_secret: INITIAL_CLIENT_SECRET,
         audience: INITIAL_CLIENT_AUDIENCE,
         grant_type: 'client_credentials'
      }

      const result = await
      axios.post(`${tokenEndpoint}`, payload, {
         headers
      })
      .then(x => x.data)
      .catch(e => {
         const msg = 'Unable to create one time access token'
         throw new Error(msg)
      })

      if (!result.access_token) {
         const msg = 'Unable to find one time access token from result'
         throw new Error(msg)
      }

      return result.access_token
   }

   async function updateApplication(clientId, update) {
      const shortLivedToken = await getShortLivedToken()
      const getApplicationEndpoint = new URL(`/api/v2/clients/${clientId}`, INITIAL_CLIENT_ISSUER).href
      const headers = makeHeaders(shortLivedToken)


      return await axios.patch(getApplicationEndpoint,
         update,
         { headers })
         .catch(e => {
            const msg = `Unable to update Application from auth0 ${e}`
            throw new Error(msg)
         })
   }

   function makeHeaders(token) {
      return {
         Authorization: `Bearer ${token}`,
         accept: 'application/json',
         'Content-Type': 'application/json'
      }
   }
   ```

3. Make sure to apply this action to the "Machine to Machine" flow. It will run each time a `client_credentials` request is made. After a request is made, you can view the updated application name in the Auth0 dashboard.
