---
name: Mocking
publisher: Kong Inc.
desc: Provide mock endpoints to test your APIs against your services
description: |
  Provide mock endpoints to test your APIs in development against your services.
  The Mocking plugin leverages standards based on the Open API Specification (OAS)
  for sending out mock responses to APIs. Mocking supports both Swagger 2.0 and OpenAPI 3.0.

  Benefits of service mocking with the Kong Mocking plugin:

  - Conforms to a design-first approach since mock responses are within OAS.
  - Accelerates development of services and APIs.
  - Promotes parallel development of APIs across distributed teams.
  - Provides an enhanced full lifecycle API development experience with Dev Portal
    integration.
  - Easily enable and disable the Mocking plugin for flexibility when
    testing API behavior.

  This plugin can mock `200`, `201`, and `204` responses.

enterprise: true
plus: true
type: plugin
kong_version_compatibility:
  enterprise_edition:
    compatible: true
---
