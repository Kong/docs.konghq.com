---
title: Configuring API Product Versions with App Reg v2
---



With App Reg v2, developers gain the ability to configure and manage multiple authentication strategies across various API products and their versions, allowing you to apply distinct authentication scopes for different API versions.

This guide will introduce you to using App Reg v2's API endpoints to create Dynamic Client Registration (DCR) within the scenario of managing two different APIs: the Air Traffic API and the Maps API, publishing the latest version to the Flights Dev Portal and configuring different DCR strategies for each API. The examples in the guide serve as templates for your actual requests.


## Configure DCR

To begin, let's set up a DCR provider. This provider will be used to authenticate APIs, including the Air Traffic API we'll configure. If your setup already uses OIDC or Key Auth, you can skip this step. 

To configure a DCR Provider, execute a `POST` request to [v2/dcr-providers](https://kong-platform-api.netlify.app/konnect/application-auth-strategies/v2/openapi.yaml/#tag/DCR-Providers/operation/create-dcr-provider) with the necessary DCR configuration details. The same DCR Provider can be shared across multiple APIs. For example: 

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

A succesful response will an `id` field, that field represents the DCR ID and will look similar to:  `93f8380e-7798-4566-99e3-2edf2b57d289`, save it because it will be used in another step. 


## Configure the auth strategy

To set up our application authentication strategies, make a `POST` request to [`v2/application-auth-strategies](https://kong-platform-api.netlify.app/konnect/application-auth-strategies/v2/openapi.yaml/#tag/App-Auth-Strategies/operation/create-app-auth-strategy) that includes:

* A display name that clearly identifies the configuration for developers using the Flight Portal.
* Claims, scopes, and authentication methods tailored to each API's specific access requirements.
* The DCR ID to link the authentication strategy directly to the DCR Provider.

{:.note}
>**Note**: If you are using Key OpenIDConnect without DCR you do not need to add a DCR Id. If you are using Key Auth, configure the strategy by passing a name and the key names.

Create the application auth strategy for the Air Traffic API: 

```sh
curl --request POST \
  --url https://us.api.konghq.tech/v2/application-auth-strategies \
  --header 'Authorization: $KPAT' \
  --header 'content-type: application/json' \
  --data '{
  "name": "Auth0 Air Traffic Auth",
  "display_name": "Air Traffic Auth",
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

And for the Maps API: 
```
curl --request POST \
  --url https://us.api.konghq.tech/v2/application-auth-strategies \
  --header 'Authorization: $KPAT' \
  --header 'content-type: application/json' \
  --data '{
  "name": "Auth0 Maps Auth",
  "display_name": "Maps Auth",
  "strategy_type": "https://my-issuer.auth0.com/api/v2/",
  "configs": {
    "openid-connect": {
      "issuer": "https://oidc.example.com",
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

## Applying authentication strategies to API products

Using the [`v2/portals/{portalId}/product-versions`](https://kong-platform-api.netlify.app/konnect/application-auth-strategies/v2/openapi.yaml/#tag/Portal-Product-Versions/operation/create-portal-product-version) endpoint we can link the authentication strategies created previously with our API products. Before making a request to this endpoint, ensure you have gathered the following details from earlier steps:

* `PortalId`
* `product_version_ids`:
    * Air Traffic API v2
    * Maps API v2
* `auth_strategy_id`
    * Air Traffic API 
    * Maps API

Apply the auth strategy to the Air Traffic API making sure to replace `your_product_version_id` and `your_auth_strategy_id` with the actual IDs you intend to use. 

```
curl --request POST \
  --url https://us.api.konghq.tech/v2/portals/aa8219fa-aaea-4a89-a780-638eaee20349/product-versions/ \
  --header 'Authorization: $KPAT' \
  --header 'content-type: application/json' \
  --data '{
  "product_version_id": "your_product_version_id_",
  "auth_strategy_ids": [
    "your_auth_strategy_id"
  ],
  "publish_status": "published",
  "application_registration_enabled": true,
  "auto_approve_registration": true,
  "deprecated": false
}

```

and to the Maps API: 
```
curl --request POST \
  --url https://us.api.konghq.tech/v2/portals/aa8219fa-aaea-4a89-a780-638eaee20349/product-versions/ \
  --header 'Authorization: $KPAT' \
  --header 'content-type: application/json' \
  --data '{
  "product_version_id": "your_product_version_id",
  "auth_strategy_ids": [
    "your_auth_strategy_id"
  ],
  "publish_status": "published",
  "application_registration_enabled": true,
  "auto_approve_registration": true,
  "deprecated": false
}

```

Executing these requests accomplishes several things: 

* Published API Product Versions: Version v3 of both the Air Traffic and Maps APIs are now accessible through our Flight Portal. This makes the latest iterations of these APIs available to developers.

* Enabled Application Registration: Developers can now register for access to v3 of the Air Traffic API and Maps API. This allows them to integrate these APIs into their own apps.

* Configured Authentication Strategies: We've applied specific Auth0 authentication strategies to each API version within the Flight Portal. For Air Traffic v3, the Air Traffic auth strategy is in place, and for Maps v3, the Maps auth strategy is applied. This ensures that each API enforces the correct authentication requirements, including credentials and claims, tailored to its own specific use case.

{:.note}
>**Note**: if your API Products are not yet published, you will need to publish the API Product itself in order for the API Product versions to be published to your portal.



## Confirm API publication and authentication status

Air Traffic v3 and Maps v3 APIs are now published to the Flight Portal and each is configured with their respective authentication settings. To ensure everything is correctly set up, query the[`v2/portals/{portalId}/product-versions`](https://kong-platform-api.netlify.app/konnect/application-auth-strategies/v2/openapi.yaml/#tag/Portal-Product-Versions/operation/list-portal-product-versions) to verify. 


A successful response will contain the following fields:

* **Timestamps**: Both the creation (`created_at`) and last update (`updated_at`) timestamps indicate when each product version was configured and published.
* **Id**: Each product version is assigned a unique id, distinguishing them within the system for management and reference purposes.
* **Publish Status**: The` publish_status` field marked as "published" confirms that both API versions are officially live and accessible on the Flight Portal.
* **Registration and Approval**:  `auto_approve_registration` and `application_registration_enabled` flags are set to `true`, indicating that applications can automatically register to use these API versions without manual approval, streamlining developer access.
* **Product version ID**: The product_version_id specifies the unique identifier for each version of the API products, linking them to their specific configurations and versions within the portal.

