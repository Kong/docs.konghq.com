<!-- Shared with Using decK with Konnect, Manage Runtime Groups with decK, and Import Kong Gateway Entities into Konnect -->

You can generate a personal access token (PAT) in {{site.konnect_short_name}} for authentication with decK commands. This is more secure than basic authentication, and can be useful for organizations with CI pipelines that can't use the standard username and password authentication. 

Before you generate a PAT, keep the following in mind:

* A PAT is granted all of the permissions that the user has access to via their most up-to-date role assignment.
* The PAT has a maximum duration of 12 months.
* There is a limit of 10 personal access tokens per user.
* Unused tokens are deleted and revoked after 12 months of inactivity.

To generate a PAT in {{site.konnect_short_name}}, select your name to open the context menu 
 and click **Personal access tokens**, then click **Generate token**. After configuring the name and expiration date, make sure you copy the token to a secure location. 