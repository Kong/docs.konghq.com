---
title: Konnect Search API
content_type: reference
description: Learn how to use the Konnect Search API to search through all Konnect entities.
---

The {{site.konnect_short_name}} Search API (Beta) offers a powerful and flexible way to search through all {{site.konnect_short_name}} entities. It is designed to cater to a wide range of search requirements, enabling users to quickly find the information they need across different areas of the product.

{{site.konnect_short_name}} Search provides the following features:

* **Global and Regional Access:** The {{site.konnect_short_name}} Search API is available in global and regional locations with regional awareness. This ensures that entities returned are entities that are relevant to their geographical location, improving response times and conform to data residency expectations.
* **Comprehensive Response:** The responses of the search query are uniform and contain a fixed number of standard attributes: “id”, “type”, “labels/tags” and “name”. In addition, entity specific attributes are returned in a general attributes object.
* **Security and Accessibility:** The {{site.konnect_short_name}} Search API will only return entities that the user has permissions to access. If a user is able to retrieve the entity in the list endpoint, then the user will be able to see the entity in the search response.
* **Advanced Query Language:** The {{site.konnect_short_name}} Search API supports an advanced query language with the selectors, reserved characters and logical operators.

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

the {{site.konnect_short_name}} Search API provides selectors, reserved characters, and logical operators that you can use to narrow your entity search. By combining these selectors, reserved characters, and logical operators, you can construct complex and precise queries to effectively use the {{site.konnect_short_name}} Search API.

### Selectors

Selectors are used to define the criteria of the search. The following table describes the different selectors and their functions:

| Selector    | Function     |
|---------------------------|----------------------|
| `@{attr.sub_attr}:{value}`| Searches for a fuzzy match for an attribute and its value. |
| `type:{entity_type}`      | Searches for a specific entity type.  |
| `labels.{name}:{value}` | Searches for an exact match for a label's value. |
| `{value}` | Searches for a fuzzy match equivalent to `@*:{value}`. |
| `{value}*`  | Searches for any value starting with `{value}`. |

### Reserved Characters

The following table describes the characters with special meanings in the query syntax:

| Character | Function                                     |
|-----------|----------------------------------------------|
| `*`       | Use as a wildcard.                           |
| `@`       | Indicates that fuzzy matching should be used for the attributes.    |
| `""`      | Denotes an exact match. This is case insensitive and includes spaces. |

### Logical Operators

Logical operators are used to combine multiple criteria in a search query. The following table describes each operator and how it functions in the query syntax:

| Operator    | Function                           |
|-------------|------------------------------------|
| `AND`       | Searches for entities that are in all of the listed fields. |
| `OR`        | Searches for entities that are in one or more of the listed fields.       |
| `NOT`       | Searches for entities are not in a field.               |

## Example Queries

1. Simple Search

    This query searches for entities with the name "John".
    
    **Query:** `name:John`

    This query searches for entities with the name "John Doe". The quotes around "John Doe" indicate an exact match to include spaces.
    
    **Query:** `name:"John Doe"`

1. Complex Search
    
    This query is for finding teams in the QA department. It combines multiple selectors: `type:team` to limit the search to teams entity type, `label.department:qa` for an exact match on the department label, and `name:*_qa` to filter for teams that are have a `_qa` suffix.
    
    **Query:** `type:team AND label.department:qa AND name:*_qa`

    This query is for finding users or teams with a `_qa` suffix in the name. It combines multiple `type:` selectors to limit the search to team or developer entity types and `name:*_qa` to filter for teams that are have a `_qa` suffix.
    
    **Query:** `type:user OR type:developer AND name:*_qa`

1. Excluding Certain System Accounts

    This query looks for system accounts that do not contain `temp` in it's name and description. The NOT logical operator is used to exclude entities.
    
    **Query:** `type:system_account AND NOT *temp*`

1. Searching with Wildcards

    This query uses a wildcard to find entities with names starting with "Project". The @ symbol indicates a "fuzzy" match on the name attribute, and the * serves as a wildcard.
    
    **Query:** `name:Project*`

1. Fuzzy Match Across All Attributes

    This query performs a fuzzy match for the term "Beta" across all attributes. The @*: selector allows for searching across all available attributes.
    
    **Query:** `@description:Beta`