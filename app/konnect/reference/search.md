---
title: Konnect Search
content_type: reference
description: Learn how to use the Konnect Search to search through all Konnect entities.
---

The {{site.konnect_short_name}} Search feature allows you to perform simple and advanced searches across all {{site.konnect_short_name}} entities within an organization. You can access search using the search bar (_Command+K_) at the top of every page in {{site.konnect_short_name}} or using the [{{site.konnect_short_name}} Search API](/konnect/api/search/latest/).

The {{site.konnect_short_name}} Search API is available in global and regional locations with regional-awareness, ensuring that returned entities are relevant to their geographical location. 

Here are a few example use cases where you can use the {{site.konnect_short_name}} Search capabilities:

| You want to... | Then use... |
| -------------- | ----------- |
| Navigate to a specific entity that you know exists. | You search for the name or key words of the entity in the Konnect search bar to quickly navigate the various pages in Konnect. |
| Find entities that are "not compliant" | You can use search to find all entities that don't comply with your rules, such as all routes that don't have a path that starts with `/api` |

## Query Syntax

The {{site.konnect_short_name}} Search API provides selectors, reserved characters, and logical operators that you can use to narrow your entity search. By combining these selectors, reserved characters, and logical operators, you can construct complex and precise queries to effectively use the {{site.konnect_short_name}} Search API.

To perform a simple search, you can just search by the name of an entity, like a service, API product, or name of a team. You can also perform an advanced search using {{site.konnect_short_name}}'s query syntax to get more granular results.

The following is an example advanced search query syntax:

```
type:team AND NOT label.department:eng AND name:*_qa
```
The following provides more details about the different components of the query syntax in the example:
* Selectors: `type`, `label`, and `name`. They define what you are searching by. 
* Entity type: `team`. These define what {{site.konnect_short_name}} entity you want to search for.
* Logical operator: `AND NOT` and `AND`. These are used to combine multiple criteria in a query.
* Wildcard: `*` to denote any a suffix match.
* Search values: `eng` and `_qa`. These are the values that the search service is matching for.

### Entity types

The following {{site.konnect_short_name}} entity types are supported: 

- `api_product`  
- `api_product_version`  
- `application`  
- `ca_certificate`  
- `certificate`  
- `consumer`  
- `consumer_group`  
- `control_plane`
- `data_plane`  
- `developer`  
- `developer_team`  
- `gateway_service`  
- `key`  
- `key_set`   
- `mesh`  
- `mesh_control_plane`  
- `plugin`  
- `portal`  
- `report`  
- `route`  
- `sni`  
- `system_account`  
- `target`  
- `team`  
- `upstream`  
- `user`  
- `vault`  
- `zone`  

Additional entities may be added in future releases. You can view a list of all the supported entities by sending the following API request:

```bash
curl -X 'GET' \
  'https://global.api.konghq.com/v1/search/types' \
  -H 'accept: application/json'
```

#### Searchable attributes
For each entity type, there is a list of entity specific attributes that are searchable. These attributes are returned in the attributes object in the search response while the schema of the searchable attributes can be found in the `/types` endpoint.

### Selectors

Selectors are used to define the criteria of the search. The following table describes the different selectors and their functions:

| Selector    | Function     | Example |
|---------------------------|----------------------|---|
| `type:{entity_type}`      | Searches for a specific entity type.  |`type:control_plane`|
| `{value}` | Searches for a match in `{value}` on any all searchable attributes. |`foobar`|
| `id:{value}` | Searches for a match on `id`. |`id:df968c45-3f20-4b80-8980-e223b250dec5`|
| `name:{value}` | Searches for a match on `name`. |`name:default`|
| `description:{value}` | Searches for a match on `description`. |`description:temporary`|
| `labels.{label_key}:{label_value}` | Searches for an exact match for a labeled entity. |`labels.env:prod`|
| `@public_labels.{label_key}:{label_value}` | Searches for an exact match for a labeled entity in Dev Portal. |`@public_labels.env:prod`|
| `@{attribute_key}:{attribute_value}` | Searches for an exact match for an entity specific attribute. |`@email:"admin@domain.com"`|

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
| Logical | `type:team AND name:*_qa` | This query finds teams in the QA department. It combines multiple selectors: `type:team` limits the search to the "teams" entity type and `name:*_qa` filters for teams that have a `_qa` suffix. |
| Logical | `name:*dev* OR name:*qa* OR name:*test` | This query finds any entities that contain `dev` or `qa` or `test` in its name. It combines multiple `name:` selectors to limit the results to entities that match one of these terms. |
| Exclusion | `type:system_account AND NOT *temp*` | This query finds system accounts that don't contain `temp` in their name and description. The `NOT` logical operator is used to exclude entities. |
| Exclusion | `type:team AND NOT name:team-blue AND NOT description:*blue*` | This query finds teams that are not named `team-blue` and don't contain "blue" in its description. The `NOT` logical operator is used to exclude entities. |
| Wildcards | `name:Project*` | This query uses a wildcard to find entities starting with the prefix "Project". The `*` serves as a wildcard. |
| Wildcards | `description:*_prod` | This query uses a wildcard to find entities ending with the description "_prod". The `*` serves as a wildcard. |
