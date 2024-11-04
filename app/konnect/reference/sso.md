---
title: IdP SSO attribute mapping reference
---

This reference doc contains provider specific information and attribute mapping tables necessary for configuring SSO.

{% navtabs %}
{% navtab Azure %}
* When adding an enterprise application, note that OIDC uses app registration.
* Remove the namespace from the claim name in Azure. You can do this by checking **Customize** on the group claim.
* Using groups maps to the Group ID by default.

Attribute mapping for Azure configuration:

| Azure                                       | Konnect                  |
|---------------------------------------------|--------------------------|
| Identifier (Entity ID)                      | `sp_entity_id`           |
| Reply URL (Assertion Consumer Service URL)  | `callback_url`           |
| App Federation Metadata Url                 | `idp_metadata_url`       |
| `user.email`                                | `email`                  |
| `user.givenname`                            | `firstname`              |
| `user.surname`                              | `lastname`               |
| `user.groups`                               | `groups`                 |
| `user.principalname`                        | Unique user identifier   |

{% endnavtab %}
{% navtab Oracle Cloud %}

* When configuring the Name ID format in Oracle Cloud, make sure to set it to `transient`.
* You will need to manually upload the signing certificate from `sp_metadata_url`.
   - `cert.pem` must use the `X509Certificate` value for signing.

Attribute mapping for Oracle Cloud configuration:

| Oracle Cloud                                | Konnect                  |
|---------------------------------------------|--------------------------|
| Entity ID                                   | `sp_entity_id`           |
| Assertion consumer URL                      | `callback_url`           |
| App Federation Metadata Url                 | `idp_metadata_url`       |

{% endnavtab %}
{% navtab KeyCloak %}

* You will need to manually upload the signing certificate from `sp_metadata_url`.
   - `cert.pem` must use the `X509Certificate` value for signing.
* Go to **Realm Settings** in Keycloak to locate your metadata endpoint. The `sp_metadata_url` for {{site.konnect_short_name}} will be:`http://<keycloak-url>/realms/konnect/protocol/saml/descriptor`

Attribute mapping for KeyCloak configuration:

| KeyCloak                                    | Konnect                  |
|---------------------------------------------|--------------------------|
| Client ID                                   | `sp_entity_id`           |
| Valid redirect URI                          | `callback_url`           |
| App Federation Metadata Url                 | `idp_metadata_url`       |

{% endnavtab %}
{% endnavtabs %}

## Related links

* [Configure generic SSO for a Konnect Org](/konnect/org-management/sso/)
* [Configure generic SSO for Dev Portal](/konnect/dev-portal/sso/)