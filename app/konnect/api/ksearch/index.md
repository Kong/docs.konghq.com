---
title: Konnect Search API
content_type: reference
description: Learn how to use the Konnect Search API to search through all Konnect entities.
beta: true
---

The {{site.konnect_short_name}} Search API allows you to search through all {{site.konnect_short_name}} entities. It is designed to cater to a wide range of search requirements, enabling you to find the information you need across different areas of the product.

Here are a few example use cases where you can use the {{site.konnect_short_name}} Search API in your automation:
* Find entities that are "not compliant". For example, you can use search to find all routes that don't have a path that starts with `/api`.
* Select from a list of available entities. For example, if you are attaching a route to a service, you can use search to find and identify which service to attach the route to. Or when you're adding members to a team, you can search for the user.

{{site.konnect_short_name}} Search includes the following features:

* **Global and regional access:** The {{site.konnect_short_name}} Search API is available in global and regional locations with regional-awareness. This ensures that returned entities are relevant to their geographical location, improving response times and conforming to data residency expectations.
* **Comprehensive response:** The responses of the search query are uniform and contain a fixed number of standard attributes: `id`, `type`, `labels/tags` and `name`. In addition, entity-specific attributes are returned in a general attributes object.
* **Security and accessibility:** The {{site.konnect_short_name}} Search API will only return entities that the user has permissions to access. If a user is able to retrieve the entity in the [list endpoint](/konnect/api/search/latest/), then the user will be able to see the entity in the search response.
* **Advanced query language:** The {{site.konnect_short_name}} Search API supports an advanced query language with selectors, reserved characters, and logical operators.

## Supported search entities

- Users
- Teams
- System Accounts
- Developers
- Developer Teams

Additional entities will be added in future releases. You can view a list of all the supported entities by sending the following API request:

```bash
curl -X 'GET' \
  'https://global.api.konghq.com/v0/search/types' \
  -H 'accept: application/json'
```

## Query Syntax

The {{site.konnect_short_name}} Search API provides selectors, reserved characters, and logical operators that you can use to narrow your entity search. By combining these selectors, reserved characters, and logical operators, you can construct complex and precise queries to effectively use the {{site.konnect_short_name}} Search API.

### Selectors

Selectors are used to define the criteria of the search. The following table describes the different selectors and their functions:

| Selector    | Function     |
|---------------------------|----------------------|
| `type:{entity_type}`      | Searches for a specific entity type.  |
| `{value}` | Searches for a match in `{value}` on any all searchable attributes. |
| `name:{value}` | Searches for an exact match for a `name`. |
| `description:{value}` | Searches for an exact match for a `description`. |

### Reserved Characters

The following table describes the characters with special meanings in the query syntax:

| Character | Function                                     |
|-----------|----------------------------------------------|
| `*`       | Use as a wildcard.                           |
| `""`      | Denotes an exact match. This is case insensitive and includes spaces. |

### Logical Operators

Logical operators are used to combine multiple criteria in a search query. Operators are case-sensitive. The following table describes each operator and how it functions in the query syntax:

| Operator    | Function                           |
|-------------|------------------------------------|
| `AND`       | Searches for entities that are in all of the listed fields. |
| `OR`        | Searches for entities that are in one or more of the listed fields.       |
| `NOT`       | Searches for entities are not in a field.               |

## Example search queries

The following table describes different example search queries:

| Search type | Query | Description |
| ----------- | ------ | ---------- |
| Simple | `Dana` | This query searches for entities with the a searchable attribute containing the value "Dana". |
| Simple | `name:Dana` | This query searches for entities with the name "Dana". |
| Simple | `name:"Dana H"` | This query searches for entities with the name "Dana H". The quotes around "Dana H" indicate an exact match, including spaces. |
| Logical | `type:team AND label.department:qa AND name:*_qa` | This query finds teams in the QA department. It combines multiple selectors: `type:team` limits the search to the "teams" entity type, `label.department:qa` exactly matches the "department" label, and `name:*_qa` filters for teams that have a `_qa` suffix. |
| Logical | `name:*dev* OR name:*qa* OR name:*test` | This query finds any entities that contain `dev` or `qa` or `test` in its name. It combines multiple `name:` selectors to limit the results to entities that match one of these terms. |
| Exclusion | `type:system_account AND NOT *temp*` | This query finds system accounts that don't contain `temp` in their name and description. The `NOT` logical operator is used to exclude entities. |
| Exclusion | `type:team AND NOT name:team-blue AND NOT description:*blue*` | This query finds teams that are not named `team-blue` and don't contain "blue" in its description. The `NOT` logical operator is used to exclude entities. |
| Wildcards | `name:Project*` | This query uses a wildcard to find entities starting with the prefix "Project". The `*` serves as a wildcard. |
| Wildcards | `description:*_prod` | This query uses a wildcard to find entities ending with the description "_prod". The `*` serves as a wildcard. |
