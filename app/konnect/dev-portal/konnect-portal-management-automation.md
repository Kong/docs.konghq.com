---
title: Manage Approval and Assignment with the Portal Management API
purpose: This doc helps portal administrators and developers understand how to integrate the API into their workflow for tasks like automating approvals, assigning permissions, and monitoring developer activity. 
---

The {{site.konnect_short_name}} Portal Management API helps {{site.konnect_short_name}} users manage their Developer Portals. 
Users can manage their portal settings, appearance, and handle application registration. 
This enables streamlined automation of tasks such as approving developer and application requests, configuring appearance settings, and managing custom domain details using the API. 

This guide uses the {{site.konnect_short_name}} Portal Management API via cURL to create examples that can be adapted into your existing automation workflow.


## Streamlining developer approval and assignment

Imagine you are tasked with managing developers across several partner soccer teams. In this scenario, you need to ensure that those teams' developers are approved quickly and given the appropriate permissions. 
Rather than manually approving developer sign ups using {{site.konnect_short_name}}, you can use the API to approve developer sign ups that come from trusted partner domains.

To check the approval status of developers, you can use the [List Portal Developers](/konnect/api/portal-management/latest/#/Portal%20Developers/list-portal-developers) endpoint to return a list of all registered developers with the following cURL command:
```sh
curl -X GET https://{region}.api.konghq.com/v2/portals/{portalId}/developers \
  --header 'Authorization: <your-kpat>' \
  --header 'Content-Type: application/json'
```

This request returns a JSON object containing developer information, including their `status`:

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

If you want to return only the developers who had a pending status, you can use a tool like [`jq`](https://jqlang.github.io/jq/) to filter out developers who have a status of `pending`: 

```shell
curl -X GET https://{region}.api.konghq.com/v2/portals/{portalId}/developers \
  --header 'Authorization: <your-kpat>' \
  --header 'Content-Type: application/json' | \
  jq '.data | map(select(.status == "pending"))'
```

This request returns a JSON object containing developer information for developers whose `status` is `pending`:

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

Once you have obtained a list of pending developers, you can begin the approval process by comparing the email address of the developer with the addresses of the developers from your trusted partner domains. 
Using the [Update Developer](/konnect/api/portal-management/latest/#/Portal%20Developers/update-developer) endpoint, you can use a PATCH request to change their status to `approved` (or, `revoked`, `rejected`, and `pending`): 

```shell
curl -X PATCH https://{region}.api.konghq.com/v2/portals/{portalId}/developers/{developerId} \
  --header 'Authorization: <your-kpat>' \
  --header 'Content-Type: application/json' \
  --data '{"status": "approved"}'
```
You can use this request in combination with a list of trusted domains:
```
trusted_domains = ["manchestercity.com", "liverpoolfc.com", "arsenal.com"]
```

By setting trusted domains, you can make sure that eligible developers are given the correct access, and can access your portal's resources and services.

Assigning developers to teams works in a similar way. 
Using the [Update Team Mapping](/konnect/api/portal-management/latest/#/Portal%20Team%20Membership/add-developer-to-portal-team) endpoint, you can issue a POST request and add a developer to a specific team:

```shell
curl -X POST https://{region}.api.konghq.com/v2/portals/{portalId}/teams/{teamId}/developers \
  --header 'Authorization: <your-kpat>' \
  --header 'Content-Type: application/json' \
  --data '{
  "id": "{developerId}"
}'
```

### Automation

The examples above are simplified to illustrate the concept of developer access management. 
In reality, your organization may need to verify and approve developers in large quantities. 
You can use the API as part of your automation strategy to manage exponentially large quantities of developers who want to use your portal. 
Here are some recommendations on how to integrate this workflow into your developer onboarding process:

* **Continuous Integration/Continuous Deployment (CI/CD) Pipelines:**

   Integrate the developer approval and assignment workflow into your CI/CD pipelines. This ensures that every time a new developer signs up, they are automatically processed without manual intervention.
   
   **Example**: Trigger the approval process when a new developer account is created within your CI/CD pipeline. Issue requests to check and approve the developer's status based on their email domain.

* **Identity and Access Management (IAM) Systems:**

   Integrate with your IAM system to automatically approve and assign developers based on their roles and permissions within your organization.
   
   **Example**: When a developer is granted specific IAM roles, use the automation workflow to update their status to `approved` and assign them to the relevant teams.

* **Custom Developer Registration Portals:**

   If you have a custom developer registration portal, implement the automation workflow to handle developer approvals and team assignments.
   
   **Example:** When developers sign up through your custom portal, use the workflow to process their registrations and assign them to predefined teams.

In summary, you can significantly reduce manual overhead by using the [Konnect Portal Management API](/konnect/api/portal-management/latest/).
