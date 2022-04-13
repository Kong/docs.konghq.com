---
name: Demo
publisher: Kong Inc.

desc: Short description here
description: |
  This is a longer description

type: plugin
categories:
  - traffic-control

kong_version_compatibility:
    community_edition:
      compatible:
        - 0.14.x
        - 0.13.x
        - 0.12.x
        - 0.11.x
        - 0.10.x
        - 0.9.x
        - 0.8.x
        - 0.7.x
        - 0.6.x
        - 0.5.x
    enterprise_edition:
      compatible:
        - 0.34-x
        - 0.33-x
        - 0.32-x
        - 0.31-x

params:
  name: demo
  api_id: true
  service_id: true
  route_id: true
  consumer_id: false
  config:
    - name: field_one
      required: true
      default:
      value_in_examples: value_one
      description: |
        We simplified and now there's only one field

---

### Usage

Documentation for the 2.x line
