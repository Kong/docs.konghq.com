---
title: KSearch
content_type: reference
---

The {{site.konnect_short_name}} Search API [Beta] offers a powerful and flexible way to search through all {{site.konnect_short_name}} entities. It is designed to cater to a wide range of search requirements, enabling users to quickly find the information they need across different areas of the product.

## Features

**Global and Regional Access:** The KSearch API is available in global and regional locations with regional awareness. This ensures that entities returned are entities that are relevant to their geographical location, improving response times and conform to data residency expectations.

**Comprehensive Response:** The responses of the search query are uniform and contain a fixed number of standard attributes: “id”, “type”, “labels/tags” and “name”. In addition, entity specific attributes are returned in a general attributes object.

**Security and Accessibility** The KSearch API will only return entities that the user has permissions to access. If a user is able to retrieve the entity in the list endpoint, then the user will be able to see the entity in the search response.

**Advanced Query Language**
The KSearch API supports an advanced query language with the selectors, reserved characters and and logical operators.


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
| `label.{name}:{value}`    | Exact match for a label's value                  |
| `tag:{value}`             | Exact match for a tag value                      |
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
| `AND` or `&&`                     | Intersection of one or more fields |
| `OR` or <code>&#124;&#124;</code> | Union of one or more fields        |
| `NOT` or `-`                      | Exclusion of a field               |
| `()`                              | Grouping of one or more fields     |

By combining these selectors, reserved characters, and logical operators, users can construct complex and precise queries to effectively utilize the KSearch API.

## Example Queries

1. Simple Search

    This query searches for users with the name "John Doe". The type:user selector restricts the search to user entities, and the quotes around "John Doe" indicate an exact match.
    
    **Query:** `type:user AND name:*smith*`

1. Complex Search
    
    This query is for finding active developer teams in the Engineering department. It combines multiple selectors: type:developer_team to limit the search to developer teams, label.department:Engineering for an exact match on the department label, and tag:active to filter for teams that are currently active.
    
    **Query:** `type:developer_team AND label.department:Engineering`

1. Excluding Certain System Accounts

    This query looks for system accounts that are not labeled as inactive. The NOT logical operator is used to exclude entities with the label.status:inactive.
    
    **Query:** `type:system_account NOT label.status:inactive`

1. Searching with Wildcards

    This query uses a wildcard to find entities with names starting with "Project". The @ symbol indicates a "fuzzy" match on the name attribute, and the * serves as a wildcard.
    
    **Query:** `@name:Project*`

1. Grouped Logical Conditions

    This query searches for either users or teams that have been tagged as urgent. The use of parentheses groups the types together, allowing for a combined search with the AND operator.
    
    **Query:** `(type:users OR type:teams) AND tag:urgent`

1. Fuzzy Match Across All Attributes

    This query performs a fuzzy match for the term "Beta" across all attributes. The @*: selector allows for searching across all available attributes.
    
    **Query:** `@*:Beta`