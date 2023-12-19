---
title: Konnect Search API
content_type: reference
---

The {{site.konnect_short_name}} Search API [Beta] offers a powerful and flexible way to search through all {{site.konnect_short_name}} entities. It is designed to cater to a wide range of search requirements, enabling users to quickly find the information they need across different areas of the product.

## Features

**Global and Regional Access:** The {{site.konnect_short_name}} Search API is available in global and regional locations with regional awareness. This ensures that entities returned are entities that are relevant to their geographical location, improving response times and conform to data residency expectations.

**Comprehensive Response:** The responses of the search query are uniform and contain a fixed number of standard attributes: “id”, “type”, “labels/tags” and “name”. In addition, entity specific attributes are returned in a general attributes object.

**Security and Accessibility** The {{site.konnect_short_name}} Search API will only return entities that the user has permissions to access. If a user is able to retrieve the entity in the list endpoint, then the user will be able to see the entity in the search response.

**Advanced Query Language**
The {{site.konnect_short_name}} Search API supports an advanced query language with the selectors, reserved characters and logical operators.


## Supported Entities
- Users
- Teams
- System Accounts
- Developers
- Developer Teams
- _More added soon._ (See `GET /search/type` for the latest entity types supported.)

## Query Syntax

### Selectors

Selectors are used to define the criteria of the search. The table below summarizes the different selectors and their meanings:

| Selector                  | Meaning                                          |
|---------------------------|--------------------------------------------------|
| `@{attr.sub_attr}:{value}`| "Fuzzy" match for an attribute and its value     |
| `type:{entity_type}`      | Limits search results to a specific entity type  |
| `labels.{name}:{value}`   | Exact match for a label's value                  |
| `{value}`                 | "Fuzzy" match equivalent to `@*:{value}`         |
| `{value}*`                | Matches any value starting with `{value}`        |

### Reserved Characters

Certain characters have special meanings in the query syntax:

| Character | Meaning                                      |
|-----------|----------------------------------------------|
| `*`       | Wildcard character                           |
| `@`       | Indicates "Fuzzy" matching for attributes    |
| `""`      | Denotes an exact match, is case insensitive and includes spaces |

### Logical Operators

Logical operators are used to combine multiple criteria in a search query:

| Operator                          | Function                           |
|-----------------------------------|------------------------------------|
| `AND`                             | Intersection of one or more fields |
| `OR`                              | Union of one or more fields        |
| `NOT`                             | Exclusion of a field               |

By combining these selectors, reserved characters, and logical operators, users can construct complex and precise queries to effectively use the {{site.konnect_short_name}} Search API.

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