---
title: Filtering
content-type: reference
---



The Konnect API supports the ability to filter over selected collections and
only return results that you are interested in.
This reference document explains how filtering works in {{site.konnect_short_name}} APIs.

### Available fields

* **Users**: `id`, `email`, `full_name`, `active`
* **Teams**: `id`, `name`, `system_team`
* **Assigned Roles**: `role`,`entity_type`, `entity_region`, `entity_id`

### Numeric and timestamp fields

When matching against both numeric and timestamp fields, you can filter in the following formats:

* **Equal**: `?filter[field][eq]=value` or `?filter[field]=value`
* **Contains**: `?filter[field][contains]=value`
* **Less Than**: `?filter[field][lt]=value`
* **Less Than or Equal**: `?filter[field][lte]=value`
* **Greater Than**: `?filter[field][gt]=value`
* **Greater Than or Equal**: `?filter[field][gte]=value`

If the qualifier is omitted, `?filter[field]=value` for example, the filtering behavior will perform an **exact** style
equal match.

## Examples

Given a response schema of:

```json
{
  "data": [
    {
      "id": "500d74f4-37e1-4f59-b51a-8cf7c7903692",
      "email": "CharlieCruz@konghq.com",
      "name": "Charlie",
      "full_name": "Charlie Cruz",
      "active": true,
      "created_at": "2022-05-10T15:10:25Z"
    },
    {
      "id": "500d74f4-37e1-4b13-b51a-8cf7c7903692",
      "email": "AlexCruz@konghq.com",
      "name": "Alex",
      "full_name": "Alex Cruz",
      "active": true,
      "created_at": "2022-05-10T15:10:25Z",
      "updated_at": "2022-10-19T15:33:02Z"
    },
    {
      "id": "500d74f4-37e1-4d13-b51a-8cf7c7903692",
      "email": "AlexGarcia@konghq.com",
      "name": "Alex",
      "full_name": "Alex Garcia",
      "active": true,
      "created_at": "2022-05-10T15:10:25Z",
      "updated_at": "2022-10-19T15:33:02Z"
    }
  ]
}
```

### Single Filter

With a single filter parameter, `?filter[name][contains]=Charlie`, the expected
results are:

```json
{
  "data": [
    {
      "id": "500d74f4-37e1-4f59-b51a-8cf7c7903692",
      "email": "CharlieCruz@konghq.com",
      "name": "Charlie",
      "full_name": "Charlie Cruz",
      "active": true,
      "created_at": "2022-05-10T15:10:25Z"
    }
  ]
}
```

A single filter parameter can return multiple results. Using `?filter[name][contains]=Cruz`, 

```json
{
  "data": [
    {
      "id": "500d74f4-37e1-4f59-b51a-8cf7c7903692",
      "email": "CharlieCruz@konghq.com",
      "name": "Charlie",
      "full_name": "Charlie Cruz",
      "active": true,
      "created_at": "2022-05-10T15:10:25Z"
    },
    {
      "id": "500d74f4-37e1-4b13-b51a-8cf7c7903692",
      "email": "AlexCruz@konghq.com",
      "name": "Alex",
      "full_name": "Alex Cruz",
      "active": true,
      "created_at": "2022-05-10T15:10:25Z",
      "updated_at": "2022-10-19T15:33:02Z"
    }
  ]
}
```

With a single filter parameter, `?filter[full_name]=Charlie%20Cruz`, the expected
results are the same:

```json
{
  "data": [
    {
      "id": "500d74f4-37e1-4f59-b51a-8cf7c7903692",
      "email": "CharlieCruz@konghq.com",
      "name": "Charlie",
      "full_name": "Charlie Cruz",
      "active": true,
      "created_at": "2022-05-10T15:10:25Z"
    }
  ]
}
```

### Multiple Filters

With multiple filter parameters,
`?filter[name][contains]=Cruz&filter[full_name]=Alex%Cruz`, the expected
results are:

```json
{
  "data": [
     {
      "id": "500d74f4-37e1-4f59-b51a-8cf7c7903692",
      "email": "AlexCruz@konghq.com",
      "name": "Alex",
      "full_name": "Alex Cruz",
      "active": true,
      "created_at": "2022-05-10T15:10:25Z",
      "updated_at": "2022-10-19T15:33:02Z"
    }
  ]
}
```

### Key Existence Filter

To verify a key in the schema is present, you can provide the following
filter parameters, `?filter[updated_at]&filter[full_name][contains]=Cruz`. The
expected results are:

```json
{
  "data": [
     {
      "id": "500d74f4-37e1-4f59-b51a-8cf7c7903692",
      "email": "AlexCruz@konghq.com",
      "name": "Alex",
      "full_name": "Alex Cruz",
      "active": true,
      "created_at": "2022-05-10T15:10:25Z",
      "updated_at": "2022-10-19T15:33:02Z"
    }
  ]
}
```

## API reference documentation

* [Identity Management API Documentation](https://developer.konghq.com/spec/5175b87f-bfae-40f6-898d-82d224387f9b/d0e13745-db5c-42d5-80ae-ef803104f5ce) - Interface for managing users, teams, team memberships and role assignments.

* [Runtime Groups API Documentation](https://developer.konghq.com/spec/cd849478-4628-4bc2-abcd-5d8a83d3b5f2/24c1f98b-ea51-4277-9178-ca28a6aa85d9/) - Interface for managing runtime groups and certificates.