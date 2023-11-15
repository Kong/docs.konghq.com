---
title: Konnect Portal Management API Automation Guide
content_type: how-to
purpose: This doc helps portal administrators and developers understand how to integrate the API into their workflow for tasks like automating approvals, assigning permissions, and monitoring developer activity. 
---

The Konnect Portal Management API helps Konnect user’s manage their Developer Portals. Users can manage their portal settings, appearance, and handle application registration. This enables streamlined automation of tasks such as approving developer and application requests, configuring appearance settings, and managing custom domain details using the API. In this guide, we delve into practical use-cases that demonstrate the API's flexibility. These examples can be adapted to your unique requirements, illustrating the API's flexibility and utility.


## Streamlining developer approval and assignment

Imagine you are tasked with managing developers across several partner soccer teams and need to ensure that those team's developers are approved quickly and given the appropriate permissions. 
Rather than manually approving developer signups using Konnect, we can use the API to approve developer signups that come from trusted partner domains.

To check the approval status of developers, you can use the [List Portal Developers](https://docs.konghq.com/konnect/api/portal-management/latest/#/Portal%20Developers/list-portal-developers) endpoint to return a list of all registered developers with the following cURL command:
```
curl --request GET \
  --url https://us.api.konghq.com/v2/portals/{portal-id}/developers \
  --header 'Authorization: kpat \
  --header 'Content-Type: application/json'
```

This request will return a JSON object containing developer information, including their `status`:

```json
{
    "data": [
        {
            "created_at": "2023-07-21T22:58:36.739Z",
            "updated_at": "2023-07-24T15:56:23.980Z",
            "id": "32d49c89-8c1b-49bf-8294-d359942d36b0",
            "email": "james@manchestercity.com",
            "full_name": "James",
            "status": "approved",
            "application_count": 1
        },
        {
            "created_at": "2023-08-02T17:05:06.047Z",
            "updated_at": "2023-08-02T17:05:06.047Z",
            "id": "77a3da77-2b95-4b28-96ad-6112415f9620",
            "email": "john@liverpoolfc.com",
            "full_name": "John",
            "status": "pending",
            "application_count": 1
        },
        ...
}
```

If you wanted to return only the developers who had a pending status, you could use a tool like `jq` to filter out developers who have a status of `pending`: 

```shell
curl --request GET \
  --url https://us.api.konghq.com/v2/portals/{portal-id}/developers \
  --header 'Authorization: kpat' \
  --header 'Content-Type: application/json' | \
  jq '.data | map(select(.status == "pending"))'
```

This request will return a JSON object containing developer information for developers who's `status`==`pending`:

```json
{
    "data": [
        {
            "created_at": "2023-08-02T17:05:06.047Z",
            "updated_at": "2023-08-02T17:05:06.047Z",
            "id": "77a3da77-2b95-4b28-96ad-6112415f9620",
            "email": "john@liverpoolfc.com",
            "full_name": "John",
            "status": "pending",
            "application_count": 1
        },
        {
            "created_at": "2023-08-03T23:45:50.042Z",
            "updated_at": "2023-08-03T23:45:50.042Z",
            "id": "b5f13fcb-190f-4418-a051-79c163770050",
            "email": "peter@arsenal.com",
            "full_name": "Arsenal",
            "status": "pending",
            "application_count": 0
        }
        ...
}

```

Once you have obtained a list of pending developers you can begin the approval process by comparing the email address of the developer with the addresses of the developers from your trusted partner domains. Using the [Update Developer](https://docs.konghq.com/konnect/api/portal-management/latest/#/Portal%20Developers/update-developer) endpoint, you can use a PATCH request to change their status to 'approved' (or, `revoked`, `rejected`, and `pending`): 

```shell
curl --request PATCH \
  --url https://us.api.konghq.com/v2/portals/{portal-id}/developers/{developer-id} \
  --header 'Authorization: kpat \
  --header 'Content-Type: application/json' \
  --data '{"status": "approved"}'
```
This request can be use in combination with a list of domains from trusted partners: 

```
trusted_domains = ["manchestercity.com", "liverpoolfc.com", "arsenal.com"]
```

To make sure that developers who are eligible can access your portals resources and services are given the correct access.

Assigning developers to teams works in a similar way using the [Update Team Mapping](https://docs.konghq.com/konnect/api/portal-management/latest/#/Portal%20Team%20Membership/add-developer-to-portal-team) endpoint, where you can issue a POST request and add a developer to a specific team. 

```shell
curl --request POST \
  --url https://us.api.konghq.com/v2/portals/{portal-id}/teams/{team-id}/developers \
  --header 'Authorization: kpat \
  --header 'Content-Type: application/json' \
  --data '{
  "id": "{developer-id}"
}'

```

### Automation

In practice, organizations need to verify and approve developers in quantities exponentially larger than this example. To efficiently manage this process and ensure that developers are onboarded and assigned to the appropriate teams, you can implement automation. Here are some recommendations on how to integrate this workflow to your developer onboarding process:

1. **Continuous Integration/Continuous Deployment (CI/CD) Pipelines:**
   - Integrate the developer approval and assignment workflow into your CI/CD pipelines. This ensures that every time a new developer signs up, they are automatically processed without manual intervention.
   - Example: Trigger the approval process when a new developer account is created within your CI/CD pipeline. Issue a requests to check and approve the developer's status based on their email domain.

2. **Identity and Access Management (IAM) Systems:**
   - Integrate with your IAM system to automatically approve and assign developers based on their roles and permissions within your organization.
   - Example: When a developer is granted specific IAM roles, use the automation workflow to update their status to `approved` and assign them to the relevant teams.

3. **Custom Developer Registration Portals:**
   - If you have a custom developer registration portal, implement the automation workflow to seamlessly handle developer approvals and team assignments.
   - Example: When developers sign up through your custom portal, use the workflow to process their registrations and assign them to predefined teams.

Using the [Konnect Portal Management API](https://docs.konghq.com/konnect/api/portal-management) you can significantly reduce manual overhead....





## Automating Developer Permissions and Service Consumption Tracking

The Developer Portal Management API can be used to discover which developers have not consumed any services. 


Using the [List Applications](https://docs.konghq.com/konnect/api/portal-management/latest/#/Portal%20Applications/list-applications) endpoint you can return a list of all developer applications:

```
curl --request GET \
  --url https://us.api.konghq.com/v2/portals/{portal-id}/applications \
  --header 'Authorization: kpat' \
  --header 'Content-Type: application/json'
```

If you want to return developers who have no applications

```
curl --request GET \
  --url https://us.api.konghq.com/v2/portals/{portal-id}/applications \
  --header 'Authorization: kpat' \
  --header 'Content-Type: application/json' | jq '.data | map(select(.registration_count == 0))'
```