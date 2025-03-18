---
title: Import existing Konnect {{site.mesh_product_name}} deployment to Terraform
---

## Introduction

This guide explains how to import an existing Konnect {{site.mesh_product_name}} deployment into Terraform.
It covers setup, importing resources, running Terraform commands, and automating the import process using a provided script.

## Setup

Make sure you completed "Setup" from [Deploy {{site.mesh_product_name}} using Terraform and Konnect](/mesh/{{page.release}}/guides/deploy-kong-mesh-using-terraform-and-konnect).

## Import existing Konnect {{site.mesh_product_name}} deployment to Terraform

In order to import an existing Konnect {{site.mesh_product_name}} deployment to Terraform, you need to add each resource name and ID to the Terraform configuration file.

Below is an example of how to import:
- Mesh Control Plane
- Mesh called `another-name`
- MeshTrafficPermission named `allow-all`
- MeshTrafficPermission named `example-with-tags`

```hcl
import {
  provider = "konnect-beta"
  to = konnect_mesh_control_plane.my_meshcontrolplane
  id = "c9fd8f76-6460-45fb-9a64-a981d8a512d7"
}

import {
    provider = "konnect-beta"
    to = konnect_mesh.another-name
    id = "{ \"cp_id\": \"c9fd8f76-6460-45fb-9a64-a981d8a512d7\", \"name\": \"another-name\"}"
}

import {
  provider = "konnect-beta"
  to = konnect_mesh_traffic_permission.allow-all
  id = "{ \"cp_id\": \"c9fd8f76-6460-45fb-9a64-a981d8a512d7\", \"mesh\": \"another-name\", \"name\": \"allow-all\" }"
}

import {
  provider = "konnect-beta"
  to = konnect_mesh_traffic_permission.example-with-tags
  id = "{ \"cp_id\": \"c9fd8f76-6460-45fb-9a64-a981d8a512d7\", \"mesh\": \"another-name\", \"name\": \"example-with-tags\" }"
}
```

You can find the names and IDs of the resources by navigating the [Mesh Manager UI](https://cloud.konghq.com/us/mesh-manager).
The `id` field in the import block is a JSON string that contains the necessary information to identify the resource.

Next run:

```bash
terraform plan -generate-config-out="generated_resources.tf"
```

Next review the "generated_resources.tf" file and make sure the resources are imported correctly.
Add all the necessary references like `cp_id`, `depends_on`.
After that you can run `terraform apply` to import the resources.

## Automating the import process

{{site.mesh_product_name}} API provides an endpoint to list all resources of a certain type in a specific Mesh Control Plane.
You can use this endpoint to automate the import process.
Below is an example of how to list all `HostnameGenerators` in a Mesh called `another-name` for a Control Plane with id `c9fd8f76-6460-45fb-9a64-a981d8a512d7`:

```bash
curl -s https://us.api.konghq.com/v1/mesh/control-planes/c9fd8f76-6460-45fb-9a64-a981d8a512d7/api/meshes/another-name/hostnamegenerators
```

Below is a script that automates the import process for all resources in a Mesh Control Plane.
It takes the Control Plane ID and region as arguments and uses the [KPAT](/konnect/org-management/access-tokens/) environment variable to authenticate with the Konnect API.
The script is provided as best effort and may need to be adjusted.

Example invocation:

```bash
./import.sh c9fd8f76-6460-45fb-9a64-a981d8a512d7 us
```

<details>
  <summary>import.sh</summary>

  ```bash
#!/bin/bash

set -euo pipefail  # Exit on error, undefined variables, and failed pipes

# Ensure script is run with required arguments
if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <cp_id> <region>" >&2
  exit 1
fi

# Capture arguments
CP_ID="$1"
REGION="$2"

# Ensure KPAT is set
if [ -z "${KPAT:-}" ]; then
  echo "Error: KPAT environment variable is not set." >&2
  exit 1
fi

# Define API base URL with dynamic cp_id
BASE_URL="https://${REGION}.api.konghq.com/v1/mesh/control-planes/${CP_ID}/api"
AUTH_HEADER="Authorization: Bearer ${KPAT}"

# Resources that are not mesh-scoped
RESOURCE_TYPES=(
  hostnamegenerators
)

# Resources that are mesh-scoped
MESH_RESOURCE_TYPES=(
  meshexternalservices
  meshmultizoneservices
  meshservices
  meshaccesslogs
  meshcircuitbreakers
  meshfaultinjections
  meshhealthchecks
  meshhttproutes
  meshloadbalancingstrategies
  meshmetrics
  meshpassthroughs
  meshproxypatches
  meshratelimits
  meshretries
  meshtcproutes
  meshtimeouts
  meshtlses
  meshtraces
  meshtrafficpermissions
)

# Print import block for the Control Plane itself
cat <<EOF

import {
  provider = "konnect-beta"
  to = konnect_mesh_control_plane.my_meshcontrolplane
  id = "${CP_ID}"
}

EOF

# Fetch all meshes first
MESHES=$(curl -s "$BASE_URL/meshes" -H "$AUTH_HEADER" | jq -r '.items[].name' || true)

# Function to convert PascalCase to snake_case
pascal_to_snake() {
  echo "$1" | perl -pe 's/([a-z0-9])([A-Z])/\1_\L\2/g' | tr '[:upper:]' '[:lower:]' | tr -d '\n'
}

# Loop over each non-mesh-scoped resource
for RESOURCE in "${RESOURCE_TYPES[@]}"; do
  OUTPUT=$(curl -s "$BASE_URL/$RESOURCE" -H "$AUTH_HEADER")
  NAMES=()  # Initialize NAMES as an empty array
  NAMES=$(echo "$OUTPUT" | jq -r '.items[].name' || true)
  TYPE=$(echo "$OUTPUT" | jq -r '.items[0].type' || true)
  TYPE_SNAKE=$(pascal_to_snake "$TYPE")

  # Generate and print import blocks
  for NAME in $NAMES; do
    cat <<EOF

import {
  provider = "konnect-beta"
  to = konnect_mesh_${TYPE_SNAKE}.${NAME}
  id = "{ \"cp_id\": \"${CP_ID}\", \"name\": \"$NAME\" }"
}

EOF
  done
done

# Loop over each mesh
for MESH in $MESHES; do
  # Print mesh import block separately
  cat <<EOF

import {
  provider = "konnect-beta"
  to = konnect_mesh.${MESH}
  id = "{ \"cp_id\": \"${CP_ID}\", \"name\": \"$MESH\"}"
}

EOF

  # Loop over each mesh-scoped resource type
  for RESOURCE in "${MESH_RESOURCE_TYPES[@]}"; do
    RESOURCES_OUTPUT=$(curl -s "$BASE_URL/meshes/${MESH}/$RESOURCE" -H "$AUTH_HEADER")
    NAMES=()  # Initialize NAMES as an empty array
    NAMES=$(echo "$RESOURCES_OUTPUT" | jq -r '.items[].name' || true)
    TYPE=$(echo "$RESOURCES_OUTPUT" | jq -r '.items[0].type' || true)
    TYPE_SNAKE=$(pascal_to_snake "$TYPE")

    # Generate and print import blocks for mesh-specific resources
    for NAME in $NAMES; do
      cat <<EOF

import {
  provider = "konnect-beta"
  to = konnect_${TYPE_SNAKE}.${NAME}
  id = "{ \"cp_id\": \"${CP_ID}\", \"mesh\": \"$MESH\", \"name\": \"$NAME\" }"
}

EOF
    done
  done
done
  ```

</details>

## Next steps

Explore all policies that are available in the [{{site.mesh_product_name}} Policy Catalog](/mesh/{{page.release}}/policies/introduction).
