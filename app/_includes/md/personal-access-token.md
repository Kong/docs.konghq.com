<!-- Shared with Manage Control Planes with decK and Import Kong Gateway Entities into Konnect -->

You can generate a personal access token (PAT) in {{site.konnect_short_name}} for authentication with decK commands. This is more secure than basic authentication, and can be useful for organizations with CI pipelines that can't use the standard username and password authentication. 

There are two types of PATs available for {{site.konnect_short_name}}: 
* Personal access tokens associated with user accounts
* System account access tokens associated with system accounts

Learn more about system accounts in the [{{site.konnect_short_name}} System Accounts documentation](/konnect/org-management/system-accounts/).

Before you generate a PAT, keep the following in mind:

* A PAT is granted all of the permissions that the user has access to via their most up-to-date role assignment.
* The PAT has a maximum duration of 12 months.
* There is a limit of 10 personal access tokens per user.
* Unused tokens are deleted and revoked after 12 months of inactivity.

{% navtabs %}
{% navtab User Account Token %}

To generate a PAT for a user account in {{site.konnect_short_name}}, select your user icon to open the context menu 
 and click **Personal access tokens**, then click **Generate token**. 

{% endnavtab %}
{% navtab System Account Token %}

[Create a system account token](/konnect/org-management/system-accounts/#generate-a-system-account-access-token) through the {{site.konnect_short_name}} API.

{% endnavtab %}
{% endnavtabs %}

{:.important}
> **Important**: The access token is only displayed once, so make sure you save it securely. 