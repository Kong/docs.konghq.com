---
title: Konnect Search
content_type: reference
description: Learn how to use the Konnect Search to search through all Konnect entities.
---

The {{site.konnect_short_name}} Search feature allows you to perform a search across all {{site.konnect_short_name}} entities within an organization. It is designed to cater to a wide range of search requirements, enabling you to find the information you need across different areas of the product. Search can be accessed via the search bar (_⌘+k_) on the top of every page or via the {{site.konnect_short_name}} Search API.

Here are a few example use cases where you can use the {{site.konnect_short_name}} Search API in your automation:
* Find entities that are "not compliant". For example, you can use search to find all routes that don't have a path that starts with `/api`.
* Select from a list of available entities. For example, if you are attaching a route to a service, you can use search to find and identify which service to attach the route to. Or when you're adding members to a team, you can search for the user.

{{site.konnect_short_name}} Search includes the following features:

* **Global and regional access:** The {{site.konnect_short_name}} Search API is available in global and regional locations with regional-awareness. This ensures that returned entities are relevant to their geographical location, improving response times and conforming to data residency expectations.
* **Comprehensive response:** The responses of the search query are uniform and contain a fixed number of standard attributes: `name`, `id`, `type`, `labels/tags` and `description`. In addition, entity-specific attributes are returned in the general `attributes` object.
* **Security and accessibility:** The {{site.konnect_short_name}} Search API will only return entities that the user has permissions to access. If a user is able to retrieve the entity in the [list endpoint](/konnect/api/search/latest/), then the user will be able to see the entity in the search response.
* **Advanced query language:** The {{site.konnect_short_name}} Search API supports an advanced query language with selectors, reserved characters, and logical operators.

## Query Syntax

The {{site.konnect_short_name}} Search API provides selectors, reserved characters, and logical operators that you can use to narrow your entity search. By combining these selectors, reserved characters, and logical operators, you can construct complex and precise queries to effectively use the {{site.konnect_short_name}} Search API.

<!--add example query syntax here-->

### Supported entity types

- `api_product`  
- `api_product_version`  
- `application`  
- `ca_certificate`  
- `certificate`  
- `consumer`  
- `consumer_group`  
- `control_plane`  
- `control_plane`  
- `data_plane`  
- `developer`  
- `developer_team`  
- `key`  
- `key_set`   
- `mesh`  
- `mesh_control_plane`  
- `plugin`  
- `portal`  
- `report`  
- `route`  
- `service`  
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

### Searchable attributes
For each entity type, there is a list of entity specific attributes that are searchable. These attributes are returned in the attributes object in the search response while the schema of the searchable attributes can be found in the types endpoint.

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
| Logical | `type:team AND label.department:qa AND name:*_qa` | This query finds teams in the QA department. It combines multiple selectors: `type:team` limits the search to the "teams" entity type, `label.department:qa` exactly matches the "department" label, and `name:*_qa` filters for teams that have a `_qa` suffix. |
| Logical | `name:*dev* OR name:*qa* OR name:*test` | This query finds any entities that contain `dev` or `qa` or `test` in its name. It combines multiple `name:` selectors to limit the results to entities that match one of these terms. |
| Exclusion | `type:system_account AND NOT *temp*` | This query finds system accounts that don't contain `temp` in their name and description. The `NOT` logical operator is used to exclude entities. |
| Exclusion | `type:team AND NOT name:team-blue AND NOT description:*blue*` | This query finds teams that are not named `team-blue` and don't contain "blue" in its description. The `NOT` logical operator is used to exclude entities. |
| Wildcards | `name:Project*` | This query uses a wildcard to find entities starting with the prefix "Project". The `*` serves as a wildcard. |
| Wildcards | `description:*_prod` | This query uses a wildcard to find entities ending with the description "_prod". The `*` serves as a wildcard. |
