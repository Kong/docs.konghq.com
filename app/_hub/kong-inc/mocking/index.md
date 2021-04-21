---
name: Mocking
publisher: Kong Inc.
version: 0.1.x
beta: true
# internal handler v 0.1.0

desc: Provide mock endpoints to test your APIs against your services
description: |
  Mock your services.
  This plugins reads the API specification file loaded from the Kong DB and presents
  with response extracted from examples provided in the specification. Swagger v2 and OpenAPI
  v3 specifications are supported.

  Benefits of service mocking:

  - Conforms to design-first approach since mock responses are within OAS.
  - Accelerates development of services and APIs.
  - Promotes parallel development of APIs across distributed teams.
  - Provides an enhanced full lifecycle API development experience with Dev Portal
    integration.

  <div class="alert alert-ee blue"><strong>Note:</strong> The Mocking plugin is compatible with
  the Kong Gateway (Enterprise) beta version 2.4.x.
  </div>

enterprise: true
type:
  plugin
categories:
  - traffic control

kong_version_compatibility:
  enterprise_edition:
    compatible:
    - 2.4.x

params:
  name: mocking
  service_id: true
  consumer_id: true
  route_id: true
  protocols: ["http", "https", "grpc", "grpcs"]
  dbless_compatible: yes
  dbless_explanation: |
    Use the `api_specification` config for DB-less mode. Attach the spec contents directly
    instead of uploading to the Dev Portal. The API spec is configured directly in the plugin.
  yaml_examples: false
  k8s_examples: false
  examples: true

  config:
    - name: api_specification_filename
      required: semi
      default:
      datatype: string
      value_in_examples: myspec.yaml
      description: |
        The name of the specification file loaded into Kong DB. Do not
        use this option for DB-less mode.
    - name: api_specification
      required: semi
      default:
      datatype: string
      value_in_examples:
      description: |
        The name of the specification file. Use this option for DB-less mode.
    - name: random_delay
      required: false
      default: false
      datatype: boolean
      value_in_examples: true
      description: |
        Enables random delay in the mocked response. Introduces delays to simulate
        real-time response times by APIs.
    - name: max_delay_time
      required: semi
      default: 1
      datatype: number
      value_in_examples: 1
      description: |
        The maximum value in seconds of delay time. Set this value when `random_delay` is enabled
        and you want to adjust the default. The value must be greater than the
        `min_delay_time`.
    - name: min_delay_time
      required: semi
      default: 0.001
      datatype: number
      value_in_examples: 0.001
      description: |
        The minimum value in seconds of delay time. Set this value when `random_delay` is enabled
        and you want to adjust the default. The value must be less than the
        `max_delay_time`.

  extra: |

    Either the `api_specification_filename` or the `api_specification` must be specified for the
    plugin according to the Kong Gateway (Enterprise) deployment mode.
---

## Prerequisites

- {{site.ee_product_name}} environment with the Dev Portal enabled on at least one workspace
  (not applicable to DB-less).
- Enable the Mocking plugin.
- An Open API Specification (`yaml` or `json`) that has at least one API method with an
  example response. Multiple examples within a spec are supported.
- Configure the specification depending on your mode:
  - Upload and deploy the spec to the Dev Portal using either Kong Manager or Insomnia. Specify
    the spec with the `api_specification_filename` config.
  - Or, if using hybrid mode/DB-less, directly attach the spec contents by configuring it in the plugin.
    Indicate the specification with the `api_specification` config.
- Enable the [CORS](/hub/kong-inc/cors/) plugin.

## Enable the Mocking plugin



## See also

To view a video demonstration of the Mocking plugin used in conjunction with the Dev Portal,
see the [Service Mocking](https://www.youtube.com/watch?v=l8uKbgkK6_I) video available on YouTube.
