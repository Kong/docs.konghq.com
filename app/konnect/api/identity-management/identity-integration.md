---
title: End-to-End Identity Integration
content-type: how-to
---


## Create a custom team

Custom teams serve as a primary way for organizations to provision access of users to different entities in the organization. Custom teams are used to mirror the organizational structure in an organization, any user who is a member of a custom team will inherit all of the roles of this team.

You must authenticate with the API, for information about authentication read the [API authentication](/konnect/api/index/#authentication) instructions.
Create a custom team by sending a `POST` request containing the `name` and `description` of your team in the response body: 
```
curl --request POST \
  --url https://global.api.konghq.tech/v2/teams \
  --header 'Content-Type: application/json' \
  --data '{
  "name": "IDM - Developers",
  "description": "The Identity Management (IDM) team."}'
```

You will receive a `201` response code, and a response body containing information about your team: 

```
{
"id": "a1d5c35a-3c71-4d95-ae4b-438fa9bd1059",
"name": "IDM - Developers",
"description": "The Identity Management (IDM) team.",
"system_team": false,
"created_at": "2022-10-25T16:39:27Z",
"updated_at": "2022-10-25T16:39:27Z"
}
```

Save the `id` value, so that you can reference this team throughout the guide.


### Assign a role to a custom team

You must assign roles to a custom team to use the team. Roles define a set of permissions or actions that a user is allowed to perform on a {{site.konnect_short_name}} entity. All custom teams start with no roles and each role must be added to the team for members of the team to inherit the roles. 

1. Obtain a list of available roles by issuing a `GET` request:

        curl --request GET \
        --url https://global.api.konghq.tech/v2/roles

   The response body will contain a list of available roles: 

    ```
{
      "runtime_groups": {
        "name": "Runtime Groups",
        "roles": {
          "admin": {
            "name": "Admin",
            "description": "This role grants full write access to all entities within a runtime group."
          },
          "certificate_admin": {
            "name": "Certificate Admin",
            "description": "This role grants full write access to administer certificates."
          },
          ...
        }
	}
    ```

2. Assign a role to a team by issuing  a `POST` request:
    
    The request must contain a `TEAM_ID` parameter in the URL. This request requires a JSON body that contains `role_name`, `entity_id`, `entity_type_name`, and `entity_region`. 

        curl --request POST \
             --url https://global.api.konghq.tech/v2/teams/TEAM_ID/assigned-roles \
             --header 'Content-Type: application/json' \
             --data '{
             "role_name": "Admin",
             "entity_id": "e67490ce-44dc-4cbd-b65e-b52c746fc26a",
             "entity_type_name": "Runtime Groups",
             "entity_region": "eu"
             }'
         If the information in the request was correct, the response will return a `200` and the `id` of the new assigned role. 

    {:.note}
    > `entity_id` can be found in the {{site.konnect_short_name}} in the **Runtime Instances** section. 

## Assign a user to a custom team

For a user to access the roles assigned to a custom team, the user must become a member of the team. A user may be a part of multiple teams and will inherit all of the roles from the teams they belong to.

1. Obtain a list of users by issuing a `GET` request:

        curl --request GET \
        --url https://global.api.konghq.tech/v2/users
    
    The response body will contain a list of users:
    
        {
        "meta": {
            "page": {
                "number": 1,
                "size": 10,
                "total": 22
            }
        },
        "data": [
            {
                "id": "69c60945-d42a-4757-a0b2-c18500493949",
                "email": "user.email@konghq.com",
                "full_name": "user",
                "preferred_name": "User2",
                "active": true,
                "created_at": "2022-10-12T16:22:53Z",
                "updated_at": "2022-10-19T15:18:11Z"
        },

2. Using the `id` field from the desired user and the `id` field from the team construct and issue a `POST` request: 

        curl --request POST \
        --url https://global.api.konghq.tech/v2/teams/TEAM_ID/users \
        --header 'Content-Type: application/json' \
        --data '{
        "id": "USER_ID"
        }'

You will receive a `201` with no response body confirming that the user was added to the custom team. 


## Mapping IdP groups to teams

If [single sign on](/konnect/org-management/okta-idp/) is enabled, an organization can optionally enable groups to team mappings. This mapping allows {{site.konnect_short_name}} to automatically map a user to a team according to the group claims provided by the IdP upon login.

Update the team mappings by issuing a `PUT` request containing `team_ids` in the request body: 

    curl --request PUT \
    --url https://global.api.konghq.com/v2/identity-provider/team-mappings \
    --header 'Content-Type: application/json' \
    --data '{
    "mappings": [
        {
        "group": "team-idm",
        "team_ids": [
            "af91db4c-6e51-403e-a2bf-33d27ae50c0a",
            "bc46c7ca-f300-41fe-a9b6-5dbc1257208e"
        ]
    }]}

If you were successful, you will receive a `200` response code, and the response body will contain a `data` object reflecting the new mappings: 

    "data": [
    {
        "group": "Service Developers",
        "team_ids": [
            "af91db4c-6e51-403e-a2bf-33d27ae50c0a",
            "bc46c7ca-f300-41fe-a9b6-5dbc1257208e"
        ]
    }]}
    


## More information

* [IdP API documentation](/konnect/api/identity-management/v2/)
* [Filtering Reference](/konnect/api/filtering/)
