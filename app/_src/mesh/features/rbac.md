---
title: Role-Based Access Control
badge: enterprise
---

Role-Based Access Control (RBAC) lets you restrict access to resources and actions to specified users or groups, based on user roles.

## How it works

{{site.mesh_product_name}} provides two resources to implement RBAC:

- `AccessRole` specifies kinds of access and resources to which access is granted. Note that access is defined only for write operations. Read access is available to all users.
- `AccessRoleBinding` lists users and the access roles that are assigned to them.

### AccessRole

`AccessRole` defines a role that is assigned separately to users.
It is global-scoped, which means it is not bound to a mesh.

{% navtabs %}
{% navtab "targetRef" selectors %}
For policies using the `targetRef` selector. You can specify which `targetRef` kinds users should have access to.

{% navtabs codeblock %}
{% navtab Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: AccessRole
metadata:
  name: role-1
spec:
  rules:
  - types: ["MeshTrafficPermission", "MeshTrace", "MeshAccessLog"] # List of Kuma resource kinds that are granted access. If it's empty, access is granted to all kinds.
    names: ["res-1"] # List of allowed type names that are granted access. If it's empty, access is granted to resources regardless of the name.
    mesh: default # Grants access to the resources in the named mesh. It can only be used with the mesh-scoped resources.
    access: ["CREATE", "UPDATE", "DELETE"] # The action bound to a type.
    when: # A set of qualifiers to receive access. Only one of them needs to be fulfilled to receive access.
    - targetRef: # A condition on the targetRef section in policies 2.0 (like MeshAccessLog or MeshTrace).
        kind: MeshService
        name: backend
    - targetRef:
        kind: MeshSubset
        tags:
          k8s.kuma.io/namespace: kuma-demo
    - targetRef:
        kind: MeshService
        name: web
      to: # can only be used with policies that have a "to" list (like MeshAccessLog)
        targetRef:
          kind: MeshService
          name: backend
    - targetRef:
        kind: MeshService
        name: web
      from: # can only be used with policies that have a "from" list (like MeshTrafficPermission)
        targetRef:
          kind: Mesh
```
{% endnavtab %}
{% navtab Universal %}
```yaml
type: AccessRole
name: role-1
rules:
- types: ["MeshTrafficPermission", "MeshTrace", "MeshAccessLog"] # List of Kuma resource types that are granted access. If it's empty, access is granted to all types.
  names: ["res-1"] # List of allowed type names that are granted access. If it's empty, access is granted to resources regardless of the name.
  mesh: default # Grants access to the resources in the named mesh. It can only be used with the mesh-scoped resources.
  access: ["CREATE", "UPDATE", "DELETE"] # The action bound to a type.
  when: # A set of qualifiers to receive access. Only one of them needs to be fulfilled to receive access.
  - targetRef: # A condition on the targetRef section in policies 2.0 (like MeshAccessLog or MeshTrace).
      kind: MeshService
      name: backend
  - targetRef:
      kind: MeshSubset
      tags:
        k8s.kuma.io/namespace: kuma-demo
  - targetRef:
      kind: MeshService
      name: web
    to: # can only be used with policies that have a "to" list (like MeshAccessLog)
      targetRef:
        kind: MeshService
        name: backend
  - targetRef:
      kind: MeshService
      name: web
    from: # can only be used with policies that have a "from" list (like MeshTrafficPermission)
      targetRef:
        kind: Mesh
```
{% endnavtab %}
{% endnavtabs %}
The lack of `targetRef`, `from`, or `to` means that a user can specify anything in this section.
For example, the `when` element with a specific `from` section allows the user to pick anything for `targetRef` in the policy.

If the policy contains multiple `to` elements, you must specify an RBAC qualifier for every single `to` element.
{% endnavtab %}
{% navtab Source and Destination selectors %}
{% navtabs codeblock %}
{% navtab Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: AccessRole
metadata:
  name: role-1
spec:
  rules:
  - types: ["TrafficPermission", "TrafficRoute", "Mesh"] # list of Kuma resource kinds to which access is granted. If empty, then access is granted to all kinds
    names: ["res-1"] # list of allowed names of types to which access is granted. If empty, then access is granted to resources regardless of the name.
    mesh: default # Mesh within which the access to resources is granted. It can only be used with the Mesh-scoped resources.
    access: ["CREATE", "UPDATE", "DELETE", "GENERATE_DATAPLANE_TOKEN", "GENERATE_USER_TOKEN", "GENERATE_ZONE_CP_TOKEN", "GENERATE_ZONE_TOKEN"] # an action that is bound to a type.
    when: # a set of qualifiers to receive access. Only one of them needs to be fulfilled to receive an access
    - sources: # a condition on sources section in connection policies (like TrafficRoute or HealthCheck). If missing, then all sources are allowed
        match:
          kuma.io/service: web
      destinations: # a condition on destinations section in connection policies (like TrafficRoute or HealthCheck). If missing, then all destinations are allowed
        match:
          kuma.io/service: backend
    - selectors: # a condition on selectors section in dataplane policies (like TrafficTrace or ProxyTemplate).
        match:
          kuma.io/service: web
    - dpToken: # a condition on generate dataplane token.
        tags:
        - name: kuma.io/service
          value: web
```
{% endnavtab %}
{% navtab Universal %}
```yaml
type: AccessRole
name: role-1
rules:
- types: ["TrafficPermission", "TrafficRoute", "Mesh"] # list of Kuma resource types to which access is granted. If empty, then access is granted to all types
  names: ["res-1"] # list of allowed names of types to which access is granted. If empty, then access is granted to resources regardless of the name.
  mesh: default # Mesh within which the access to resources is granted. It can only be used with the Mesh-scoped resources.
  access: ["CREATE", "UPDATE", "DELETE", "GENERATE_DATAPLANE_TOKEN", "GENERATE_USER_TOKEN", "GENERATE_ZONE_CP_TOKEN", "GENERATE_ZONE_TOKEN"] # an action that is bound to a type.
  when: # a set of qualifiers to receive access. Only one of them needs to be fulfilled to receive an access
  - sources: # a condition on sources section in connection policies (like TrafficRoute or HealthCheck). If missing, then all sources are allowed
      match:
        kuma.io/service: web
    destinations: # a condition on destinations section in connection policies (like TrafficRoute or HealthCheck). If missing, then all destinations are allowed
      match:
        kuma.io/service: backend
  - selectors: # a condition on selectors section in dataplane policies (like TrafficTrace or ProxyTemplate).
      match:
        kuma.io/service: web
  - dpToken: # a condition on generate dataplane token.
      tags:
      - name: kuma.io/service
        value: web
```
{% endnavtab %}
{% endnavtabs %}
{% endnavtab %}
{% endnavtabs %}

{:.important}
> **Important:** Granting access actions without binding them to specific resource types provides full access, including to Secrets and GlobalSecrets, posing security risks. For example, an AccessRole with `access: ["CREATE", "UPDATE", "DELETE"]` and no defined `types` allows modifying any resource, including secrets. Even without `GENERATE_DATAPLANE_TOKEN`, `GENERATE_USER_TOKEN`, `GENERATE_ZONE_CP_TOKEN`, or `GENERATE_ZONE_TOKEN`, the user can retrieve secrets and use them to generate tokens manually. To prevent this, always bind access actions to specific resource types. Instead of unrestricted access, explicitly define allowed types, such as `types: ["MeshHTTPRoute", "MeshTCPRoute", "MeshTrace"]`, to ensure the role can only manage those resources and not secrets or other sensitive data.

### AccessRoleBinding

`AccessRoleBinding` assigns a set of `AccessRoles` to a list of subjects (users or groups). Because these bindings are global in scope, they apply across all meshes, allowing centralized management of permissions.

{% navtabs codeblock %}
{% navtab Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: AccessRoleBinding
metadata:
  name: binding-1
spec:
  subjects:
  - type: User
    name: john.doe@example.com
  - type: Group
    name: team-a
  roles:
  - role-1
```
{% endnavtab %}
{% navtab Universal %}
```yaml
type: AccessRoleBinding
name: binding-1
subjects:
- type: User
  name: john.doe@example.com
- type: Group
  name: team-a
roles:
- role-1
```
{% endnavtab %}
{% endnavtabs %}

#### Restricting the default AccessRoleBinding

{:.important}
> **Important:** [By default](/mesh/{{page.release}}/features/rbac/#default), {{site.mesh_product_name}} assigns the `admin` role to everyone in the `mesh-system:authenticated` and `mesh-system:unauthenticated` groups. This means every user automatically gets admin rights, even if you create a custom binding for them, they will also inherit the default admin role.

To limit admin privileges to a specific group, update the default binding. For example, to grant admin rights only to members of the `mesh-system:admin` group, replace the default binding with the following:

{% navtabs codeblock %}
{% navtab Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: AccessRoleBinding
metadata:
  name: default
spec:
  subjects:
  - type: Group
    name: mesh-system:admin
  # The `system:serviceaccounts:kube-system` group is required by Kubernetes controllers to manage {{site.mesh_product_name}} 
  # resources, for example, cleaning up data plane objects when a namespace is removed.
  - type: Group
    name: system:serviceaccounts:kube-system
  roles:
  - admin
```
{% endnavtab %}
{% navtab Universal %}
```yaml
type: AccessRoleBinding
name: default
subjects:
- type: Group
  name: mesh-system:admin
roles:
- admin
```
{% endnavtab %}
{% endnavtabs %}

## Example roles

Let's go through example roles in the organization that can be created using {{site.mesh_product_name}} RBAC.

### {{site.mesh_product_name}} operator (admin)

Mesh operator is a part of infrastructure team responsible for {{site.mesh_product_name}} deployment.

{% navtabs codeblock %}
{% navtab Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: AccessRole
metadata:
  name: admin
spec:
  rules:
  - access: ["CREATE", "UPDATE", "DELETE", "GENERATE_DATAPLANE_TOKEN", "GENERATE_USER_TOKEN", "GENERATE_ZONE_CP_TOKEN", "GENERATE_ZONE_TOKEN"]
```
{% endnavtab %}
{% navtab Universal %}
```yaml
type: AccessRole
name: admin
rules:
- access: ["CREATE", "UPDATE", "DELETE", "GENERATE_DATAPLANE_TOKEN", "GENERATE_USER_TOKEN", "GENERATE_ZONE_CP_TOKEN", "GENERATE_ZONE_TOKEN"]
```
{% endnavtab %}
{% endnavtabs %}

This way {{site.mesh_product_name}} operators can execute any action.

{:.note}
> **Note**: This role is automatically created on the start of the control plane.

### Service owner

Service owner is a part of team responsible for given service. Let's take a `backend` service as an example.

{% navtabs codeblock %}
{% navtab Kubernetes %}
[//]: # (MeshTCPRoute was added in `2.3.0`)
{% if_version eq:2.2.x %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: AccessRole
metadata:
  name: backend-owner
spec:
  rules:
  - mesh: default
    types: ["MeshTrafficPermission", "MeshRateLimit"]
    access: ["CREATE", "DELETE", "UPDATE"]
    when:
    - targetRef:
        kind: MeshService
        name: backend
  - mesh: default
    types: ["MeshHTTPRoute", "MeshHealthCheck", "MeshCircuitBreaker", "MeshFaultInjection", "MeshRetry", "MeshTimeout", "MeshAccessLog"]
    access: ["CREATE", "DELETE", "UPDATE"]
    when:
    - targetRef:
        kind: Mesh
      from:
        targetRef:
          kind: MeshSubset
          tags:
            kuma.io/service: backend
    - targetRef:
        kind: Mesh
      to:
        targetRef:
          kind: MeshService
          name: backend
  - mesh: default
    types: ["MeshTrace", "MeshProxyPatch"]
    access: ["CREATE", "DELETE", "UPDATE"]
    when:
    - targetRef:
        kind: MeshService
        name: backend
```
{% endif_version %}
{% if_version gte:2.3.x %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: AccessRole
metadata:
  name: backend-owner
spec:
  rules:
  - mesh: default
    types: ["MeshTrafficPermission", "MeshRateLimit"]
    access: ["CREATE", "DELETE", "UPDATE"]
    when:
    - targetRef:
        kind: MeshService
        name: backend
  - mesh: default
    types: ["MeshHTTPRoute", "MeshTCPRoute", "MeshHealthCheck", "MeshCircuitBreaker", "MeshFaultInjection", "MeshRetry", "MeshTimeout", "MeshAccessLog"]
    access: ["CREATE", "DELETE", "UPDATE"]
    when:
    - targetRef:
        kind: Mesh
      from:
        targetRef:
          kind: MeshSubset
          tags:
            kuma.io/service: backend
    - targetRef:
        kind: Mesh
      to:
        targetRef:
          kind: MeshService
          name: backend
  - mesh: default
    types: ["MeshTrace", "MeshProxyPatch"]
    access: ["CREATE", "DELETE", "UPDATE"]
    when:
    - targetRef:
        kind: MeshService
        name: backend
```
{% endif_version %}
{% endnavtab %}
{% navtab Universal %}
[//]: # (MeshTCPRoute was added in `2.3.0`)
{% if_version eq:2.2.x %}
```yaml
type: AccessRole
name: backend-owner
rules:
- mesh: default
  types: ["MeshTrafficPermission", "MeshRateLimit"]
  access: ["CREATE", "DELETE", "UPDATE"]
  when:
  - targetRef:
      kind: MeshService
      name: backend
- mesh: default
  types: ["MeshHTTPRoute", "MeshHealthCheck", "MeshCircuitBreaker", "MeshFaultInjection", "MeshRetry", "MeshTimeout", "MeshAccessLog"]
  access: ["CREATE", "DELETE", "UPDATE"]
  when:
  - targetRef:
      kind: Mesh
    from:
      targetRef:
        kind: MeshSubset
        tags:
          kuma.io/service: backend
  - targetRef:
      kind: Mesh
    to:
      targetRef:
        kind: MeshService
        name: backend
- mesh: default
  types: ["MeshTrace", "MeshProxyPatch"]
  access: ["CREATE", "DELETE", "UPDATE"]
  when:
  - targetRef:
      kind: MeshService
      name: backend
```
{% endif_version %}
{% if_version gte:2.3.x %}
```yaml
type: AccessRole
name: backend-owner
rules:
- mesh: default
  types: ["MeshTrafficPermission", "MeshRateLimit"]
  access: ["CREATE", "DELETE", "UPDATE"]
  when:
  - targetRef:
      kind: MeshService
      name: backend
- mesh: default
  types: ["MeshHTTPRoute", "MeshTCPRoute", "MeshHealthCheck", "MeshCircuitBreaker", "MeshFaultInjection", "MeshRetry", "MeshTimeout", "MeshAccessLog"]
  access: ["CREATE", "DELETE", "UPDATE"]
  when:
  - targetRef:
      kind: Mesh
    from:
      targetRef:
        kind: MeshSubset
        tags:
          kuma.io/service: backend
  - targetRef:
      kind: Mesh
    to:
      targetRef:
        kind: MeshService
        name: backend
- mesh: default
  types: ["MeshTrace", "MeshProxyPatch"]
  access: ["CREATE", "DELETE", "UPDATE"]
  when:
  - targetRef:
      kind: MeshService
      name: backend
```
{% endif_version %}
{% endnavtab %}
{% endnavtabs %}

* Modify `MeshRateLimit` and `MeshTrafficPermission` that allows/restricts access to the backend service.
  This changes the configuration of the data plane proxy that implements the `backend` service.
* Modify connection policies (`MeshHTTPRoute`, {% if_version gte:2.3.x inline:true %}`MeshTCPRoute`, {% endif_version %}`MeshHealthCheck`, `MeshCircuitBreaker`, `MeshFaultInjection`, `MeshRetry`, `MeshTimeout`, `MeshRateLimit`, `MeshAccessLog`)
  that matches the backend service that connects to other services. This changes the configuration of the data plane proxy that implements the `backend` service.
* Modify connection policies that matches any service that consumes backend service.
  This changes the configuration of data plane proxies that are connecting to the backend, but the configuration only affects connections to the backend service.
  It's useful because the service owner of the backend knows what (`MeshTimeout`, `MeshHealthCheck`) should be applied when communicating with their service.
* Modify the `MeshTrace` or `MeshProxyPatch` that matches the backend service. This changes the configuration of the data plane proxy that implements the `backend` service.

{:.note}
> **Note**: When giving users `UPDATE` permission, remember to add `UPDATE` permission to all selectors they can switch between. For example, if a user only has access to `sources` selector, they won't be able to update policy with `destinations` selector or new `targetRef` selectors. Likewise, when a user only has access to the `targetRef` kind `MeshService`, they won't be able to update the policy to use a different `targetRef` kind.

### Observability operator

We may also have an infrastructure team which is responsible for the logging/metrics/tracing systems in the organization.
Currently, those features are configured on `Mesh`, `MeshAccessLog`, and `MeshTrace` objects.

{% navtabs codeblock%}
{% navtab Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: AccessRole
metadata:
  name: observability-operator
spec:
  rules:
  - mesh: '*'
    types: ["MeshAccessLog", "MeshTrace"]
    access: ["CREATE", "DELETE", "UPDATE"]
  - types: ["Mesh"]
    access: ["CREATE", "DELETE", "UPDATE"]
```
{% endnavtab %}
{% navtab Universal %}
```yaml
type: AccessRole
name: observability-operator
rules:
- mesh: '*'
  types: ["MeshAccessLog", "MeshTrace"]
  access: ["CREATE", "DELETE", "UPDATE"]
- types: ["Mesh"]
  access: ["CREATE", "DELETE", "UPDATE"]
```
{% endnavtab %}
{% endnavtabs %}

This way an observability operator can:
* Modify `MeshAccessLog` and `MeshTrace` in any mesh
* Modify any `Mesh`

### Single Mesh operator

{{site.mesh_product_name}} lets us segment the deployment into many logical service meshes configured by Mesh object.
We may want to give access to one specific Mesh and all objects connected with this Mesh.

{% navtabs codeblock %}
{% navtab Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: AccessRole
metadata:
  name: demo-mesh-operator
spec:
  rules:
  - mesh: demo
    access: ["CREATE", "DELETE", "UPDATE"]
  - types: ["Mesh"]
    names: ["demo"]
    access: ["CREATE", "DELETE", "UPDATE"]
```
{% endnavtab %}
{% navtab Universal %}
```yaml
type: AccessRole
name: demo-mesh-operator
rules:
- mesh: demo
  access: ["CREATE", "DELETE", "UPDATE"]
- types: ["Mesh"]
  names: ["demo"]
  access: ["CREATE", "DELETE", "UPDATE"]
```
{% endnavtab %}
{% endnavtabs %}

This way all observability operator can:
* Modify all resources in the demo mesh
* Modify `demo` Mesh object.

## Kubernetes

Kubernetes provides their own RBAC system, but it's not sufficient to cover use cases for several reasons:
* You cannot restrict access to resources of specific Mesh
* You cannot restrict access based on the content of the policy

{{site.mesh_product_name}} RBAC works on top of Kubernetes RBAC.
For example, to restrict the access for a user to modify `MeshTrafficPermission` for backend service, they need to be able to create `MeshTrafficPermission` in the first place.

The `subjects` in `AccessRoleBinding` are compatible with Kubernetes users and groups.
{{site.mesh_product_name}} RBAC on Kubernetes is implemented using Kubernetes Webhook when applying resources. This means you can only use Kubernetes users and groups for `CREATE`, `DELETE` and `UPDATE` access.
`GENERATE_DATAPLANE_TOKEN`, `GENERATE_USER_TOKEN`, `GENERATE_ZONE_CP_TOKEN`, `GENERATE_ZONE_TOKEN` are used when interacting with {{site.mesh_product_name}} API Server, in this case you need to use the user token.

## Default

{{site.mesh_product_name}} creates an `admin` `AccessRole` that allows every action.

{% if_version lte:2.5.x %}
In a standalone deployment, the `default` `AccessRoleBinding` assigns this role to every authenticated and unauthenticated user.

In a multi-zone deployment, the `default` `AccessRoleBinding` on the global control plane assigns this role to every authenticated and unauthenticated user.
However, on the zone control plane, the `default` `AccessRoleBinding` is restricted to the `admin` `AccessRole` only.
{% endif_version %}
{% if_version gte:2.6.x %}
The `default` `AccessRoleBinding` assigns this role to every authenticated and unauthenticated user.
{% endif_version %}

{% navtabs codeblock %}
{% navtab Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: AccessRole
metadata:
  name: admin
spec:
  rules:
  - access: ["CREATE", "UPDATE", "DELETE", "GENERATE_DATAPLANE_TOKEN", "GENERATE_USER_TOKEN", "GENERATE_ZONE_CP_TOKEN", "GENERATE_ZONE_TOKEN"]
---
apiVersion: kuma.io/v1alpha1
kind: AccessRoleBinding
metadata:
  name: default
spec:
  subjects:
  - type: Group
    name: mesh-system:authenticated
  - type: Group
    name: mesh-system:unauthenticated
  - type: Group
    name: system:authenticated
  - type: Group
    name: system:unauthenticated
  roles:
  - admin
```
{% endnavtab %}
{% navtab Universal %}
```yaml
type: AccessRole
name: admin
rules:
- access: ["CREATE", "UPDATE", "DELETE", "GENERATE_DATAPLANE_TOKEN", "GENERATE_USER_TOKEN", "GENERATE_ZONE_CP_TOKEN", "GENERATE_ZONE_TOKEN"]
---
type: AccessRoleBinding
name: default
subjects:
- type: Group
  name: mesh-system:authenticated
- type: Group
  name: mesh-system:unauthenticated
roles:
- admin
```
{% endnavtab %}
{% endnavtabs %}

To restrict access to `admin` only, change the default `AccessRole` policy:

{% navtabs codeblock %}
{% navtab Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: AccessRoleBinding
metadata:
  name: default
spec:
  subjects:
  - type: Group
    name: mesh-system:admin
  - type: Group
    name: system:masters
  # The `system:serviceaccounts:kube-system` group is required by Kubernetes controllers to manage {{site.mesh_product_name}} 
  # resources, for example, cleaning up data plane objects when a namespace is removed.
  - type: Group
    name: system:serviceaccounts:kube-system
  roles:
  - admin
```
{% endnavtab %}
{% navtab Universal %}
```yaml
type: AccessRoleBinding
name: default
subjects:
- type: Group
  name: mesh-system:admin
roles:
- admin
```
{% endnavtab %}
{% endnavtabs %}

## Example

{% navtabs %}
{% navtab "targetRef" selectors %}
The following steps create a new user and restrict the access to only `MeshTrafficPermission` for the backend service.

{% navtabs %}
{% navtab Kubernetes %}

1. Create a backend-owner Kubernetes user and configure `kubectl`:

    ```sh
    mkdir -p /tmp/k8s-certs
    cd /tmp/k8s-certs
    openssl genrsa -out backend-owner.key 2048 # generate client key
    openssl req -new -key backend-owner.key -subj "/CN=backend-owner" -out backend-owner.csr # generate client certificate request
    CSR=$(cat backend-owner.csr | base64 | tr -d "\n") && echo "apiVersion: certificates.k8s.io/v1
    kind: CertificateSigningRequest
    metadata:
      name: backend-owner
    spec:
      request: $CSR
      signerName: kubernetes.io/kube-apiserver-client
      usages:
      - client auth" | kubectl apply -f -
    kubectl certificate approve backend-owner
    kubectl get csr backend-owner -o jsonpath='{.status.certificate}'| base64 -d > backend-owner.crt
    kubectl config set-credentials backend-owner \
    --client-key=/tmp/k8s-certs/backend-owner.key \
    --client-certificate=/tmp/k8s-certs/backend-owner.crt \
    --embed-certs=true
    kubectl config set-context backend-owner --cluster=YOUR_CLUSTER_NAME --user=backend-owner
    ```

2. Create Kubernetes RBAC to allow backend-owner to manage all `MeshTrafficPermission`:

    ```sh
    echo "
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: kuma-policy-management
    rules:
    - apiGroups:
      - kuma.io
      resources:
      - meshtrafficpermissions
      verbs:
      - get
      - list
      - watch
      - create
      - update
      - patch
      - delete
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: kuma-policy-management-backend-owner
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: kuma-policy-management
    subjects:
    - kind: User
      name: backend-owner
      apiGroup: rbac.authorization.k8s.io
    " | kubectl apply -f -
    ```

3. Change default {{site.mesh_product_name}} RBAC to restrict access to resources by default:

    ```sh
    echo "
    apiVersion: kuma.io/v1alpha1
    kind: AccessRoleBinding
    metadata:
      name: default
    spec:
      subjects:
      - type: Group
        name: mesh-system:admin
      - type: Group
        name: system:masters
      - type: Group
        name: system:serviceaccounts:kube-system
      roles:
      - admin
    " | kubectl apply -f -
    ```

4. Create an AccessRole to grant permissions to user `backend-owner` to modify `MeshTrafficPermission` only for the backend service:

    ```sh
    echo '
    ---
    apiVersion: kuma.io/v1alpha1
    kind: AccessRole
    metadata:
      name: backend-owner
    spec:
      rules:
      - types: ["MeshTrafficPermission"]
        mesh: default
        access: ["CREATE", "UPDATE", "DELETE"]
        when:
        - targetRef:
            kind: MeshService
            name: backend
    ---
    apiVersion: kuma.io/v1alpha1
    kind: AccessRoleBinding
    metadata:
      name: backend-owners
    spec:
      subjects:
      - type: User
        name: backend-owner
      roles:
      - backend-owner
    ' | kubectl apply -f -
    ```

5. Change the service to test user access:

    ```sh
    kubectl config use-context backend-owner
    echo "
    apiVersion: kuma.io/v1alpha1
    kind: MeshTrafficPermission
    metadata:
      name: web-to-backend
      namespace: kong-mesh-system
      labels:
        kuma.io/mesh: default
    spec:
      targetRef:
        kind: MeshService
        name: backend
      from:
      - targetRef:
          kind: MeshService
          name: web
        default:
          action: ALLOW
    " | kubectl apply -f -
    # operation should succeed, access to backend service access is granted

    echo "
    apiVersion: kuma.io/v1alpha1
    kind: MeshTrafficPermission
    metadata:
      name: web-to-backend
      namespace: kong-mesh-system
      labels:
        kuma.io/mesh: default
    spec:
      targetRef:
        kind: MeshService
        name: not-backend # access to this service is not granted
      from:
      - targetRef:
          kind: MeshService
          name: web
        default:
          action: ALLOW
    " | kubectl apply -f -
    # operation should not succeed
    ```
{% endnavtab %}
{% navtab Universal %}
The following steps create a new user and restrict the access to only `TrafficPermission` for the backend service.

{:.note}
> **Note**: By default, all requests that originate from localhost are authenticated as the `admin` user in the `mesh-system:admin` group.
For this example to work, you must either run the control plane with `KUMA_API_SERVER_AUTHN_LOCALHOST_IS_ADMIN` set to `false` or access the control plane using a method other than localhost.

1. Extract the admin token and configure `kumactl` with the admin:

    ```sh
    export ADMIN_TOKEN=$(curl http://localhost:5681/global-secrets/admin-user-token | jq -r .data | base64 -d)
    kumactl config control-planes add \
    --name=cp-admin \
    --address=https://localhost:5682 \
    --skip-verify=true \
    --auth-type=tokens \
    --auth-conf token=$ADMIN_TOKEN
    ```

2. Configure backend-owner:

    ```sh
    export BACKEND_OWNER_TOKEN=$(kumactl generate user-token --valid-for=24h --name backend-owner)
    kumactl config control-planes add \
    --name=cp-backend-owner \
    --address=https://localhost:5682 \
    --skip-verify=true \
    --auth-type=tokens \
    --auth-conf token=$BACKEND_OWNER_TOKEN
    kumactl config control-planes switch --name cp-admin # switch back to admin
    ```

3. Change default {{site.mesh_product_name}} RBAC to restrict access to resources by default:

    ```sh
    echo "type: AccessRoleBinding
    name: default
    subjects:
    - type: Group
      name: mesh-system:admin
    roles:
    - admin" | kumactl apply -f -
    ```

4. Create {{site.mesh_product_name}} RBAC to only allow the backend-owner to modify `MeshTrafficPermission` for backend:

    ```sh
    echo '
    type: AccessRole
    name: backend-owner
    rules:
    - types: ["MeshTrafficPermission"]
      mesh: default
      access: ["CREATE", "UPDATE", "DELETE"]
      when:
      - targetRef:
          kind: MeshService
          name: backend
    ' | kumactl apply -f -
    echo '
    type: AccessRoleBinding
    name: backend-owners
    subjects:
    - type: User
      name: backend-owner
    roles:
    - backend-owner' | kumactl apply -f -
    ```

5. Change the user and test RBAC:

    ```sh
    kumactl config control-planes switch --name cp-backend-owner
    echo "
    type: MeshTrafficPermission
    mesh: default
    name: web-to-backend
    spec:
      targetRef:
        kind: MeshService
        name: backend
      from:
      - targetRef:
          kind: MeshService
          name: web
        default:
          action: ALLOW
    " | kumactl apply -f -
    # this operation should succeed

    echo "
    type: MeshTrafficPermission
    mesh: default
    name: web-to-backend
    spec:
      targetRef:
        kind: MeshService
        name: not-backend
      from:
      - targetRef:
          kind: MeshService
          name: web
        default:
          action: ALLOW
    " | kumactl apply -f -
    Error: Access Denied (user "backend-owner/mesh-system:authenticated" cannot access the resource)
    ```

{% endnavtab %}
{% endnavtabs %}
{% endnavtab %}
{% navtab Source and Destination selectors %}
{% navtabs %}
{% navtab Kubernetes %}

1. Create a backend-owner Kubernetes user and configure `kubectl`:

    ```sh
    mkdir -p /tmp/k8s-certs
    cd /tmp/k8s-certs
    openssl genrsa -out backend-owner.key 2048 # generate client key
    openssl req -new -key backend-owner.key -subj "/CN=backend-owner" -out backend-owner.csr # generate client certificate request
    CSR=$(cat backend-owner.csr | base64 | tr -d "\n") && echo "apiVersion: certificates.k8s.io/v1
    kind: CertificateSigningRequest
    metadata:
      name: backend-owner
    spec:
      request: $CSR
      signerName: kubernetes.io/kube-apiserver-client
      usages:
      - client auth" | kubectl apply -f -
    kubectl certificate approve backend-owner
    kubectl get csr backend-owner -o jsonpath='{.status.certificate}'| base64 -d > backend-owner.crt
    kubectl config set-credentials backend-owner \
    --client-key=/tmp/k8s-certs/backend-owner.key \
    --client-certificate=/tmp/k8s-certs/backend-owner.crt \
    --embed-certs=true
    kubectl config set-context backend-owner --cluster=YOUR_CLUSTER_NAME --user=backend-owner
    ```

2. Create Kubernetes RBAC to allow backend-owner to manage all `TrafficPermission`:

    ```sh
    echo "
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: kuma-policy-management
    rules:
    - apiGroups:
      - kuma.io
      resources:
      - trafficpermissions
      verbs:
      - get
      - list
      - watch
      - create
      - update
      - patch
      - delete
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: kuma-policy-management-backend-owner
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: kuma-policy-management
    subjects:
    - kind: User
      name: backend-owner
      apiGroup: rbac.authorization.k8s.io
    " | kubectl apply -f -
    ```

3. Change default {{site.mesh_product_name}} RBAC to restrict access to resources by default:

    ```sh
    echo "
    apiVersion: kuma.io/v1alpha1
    kind: AccessRoleBinding
    metadata:
      name: default
    spec:
      subjects:
      - type: Group
        name: mesh-system:admin
      - type: Group
        name: system:masters
      - type: Group
        name: system:serviceaccounts:kube-system
      roles:
      - admin
    " | kubectl apply -f -
    ```

4. Create an AccessRole to grant permissions to the `backend-owner` user to modify `TrafficPermission` only for the backend service:

    ```sh
    echo '
    ---
    apiVersion: kuma.io/v1alpha1
    kind: AccessRole
    metadata:
      name: backend-owner
    spec:
      rules:
      - types: ["TrafficPermission"]
        mesh: default
        access: ["CREATE", "UPDATE", "DELETE"]
        when:
        - destinations:
            match:
              kuma.io/service: backend
    ---
    apiVersion: kuma.io/v1alpha1
    kind: AccessRoleBinding
    metadata:
      name: backend-owners
    spec:
      subjects:
      - type: User
        name: backend-owner
      roles:
      - backend-owner
    ' | kubectl apply -f -
    ```

5. Change the service to test user access:

    ```sh
    kubectl config use-context backend-owner
    echo "
    apiVersion: kuma.io/v1alpha1
    kind: TrafficPermission
    mesh: default
    metadata:
      name: web-to-backend
    spec:
      sources:
      - match:
          kuma.io/service: web
      destinations:
      - match:
          kuma.io/service: backend
    " | kubectl apply -f -
    # operation should succeed, access to backend service access is granted

    echo "
    apiVersion: kuma.io/v1alpha1
    kind: TrafficPermission
    mesh: default
    metadata:
      name: web-to-backend
    spec:
      sources:
      - match:
          kuma.io/service: web
      destinations:
      - match:
          kuma.io/service: not-backend # access to this service is not granted
    " | kubectl apply -f -
    # operation should not succeed
    ```
{% endnavtab %}
{% navtab Universal %}

{:.note}
> **Note**: By default, all requests that originates from localhost are authenticated as the `admin` user belonging to the `mesh-system:admin` group.
For this example to work, you must either run the control plane with `KUMA_API_SERVER_AUTHN_LOCALHOST_IS_ADMIN` set to `false` or access the control plane via a method other than localhost.

1. Extract admin token and configure kumactl with admin:

    ```sh
    export ADMIN_TOKEN=$(curl http://localhost:5681/global-secrets/admin-user-token | jq -r .data | base64 -d)
    kumactl config control-planes add \
    --name=cp-admin \
    --address=https://localhost:5682 \
    --skip-verify=true \
    --auth-type=tokens \
    --auth-conf token=$ADMIN_TOKEN
    ```

2. Configure backend-owner:

    ```sh
    export BACKEND_OWNER_TOKEN=$(kumactl generate user-token --valid-for=24h --name backend-owner)
    kumactl config control-planes add \
    --name=cp-backend-owner \
    --address=https://localhost:5682 \
    --skip-verify=true \
    --auth-type=tokens \
    --auth-conf token=$BACKEND_OWNER_TOKEN
    kumactl config control-planes switch --name cp-admin # switch back to admin
    ```

3. Change default {{site.mesh_product_name}} RBAC to restrict access to resources by default:

    ```sh
    echo "type: AccessRoleBinding
    name: default
    subjects:
    - type: Group
      name: mesh-system:admin
    roles:
    - admin" | kumactl apply -f -
    ```

4. Create {{site.mesh_product_name}} RBAC to restrict backend-owner to only modify `TrafficPermission` for backend:

    ```sh
    echo '
    type: AccessRole
    name: backend-owner
    rules:
    - types: ["TrafficPermission"]
      mesh: default
      access: ["CREATE", "UPDATE", "DELETE"]
      when:
      - destinations:
          match:
            kuma.io/service: backend
    ' | kumactl apply -f -
    echo '
    type: AccessRoleBinding
    name: backend-owners
    subjects:
    - type: User
      name: backend-owner
    roles:
    - backend-owner' | kumactl apply -f -
    ```

5. Change the user and test RBAC:

    ```sh
    kumactl config control-planes switch --name cp-backend-owner
    echo "
    type: TrafficPermission
    mesh: default
    name: web-to-backend
    sources:
    - match:
        kuma.io/service: web
    destinations:
    - match:
        kuma.io/service: backend
    " | kumactl apply -f -
    # this operation should succeed

    echo "
    type: TrafficPermission
    mesh: default
    name: web-to-backend
    sources:
    - match:
        kuma.io/service: web
    destinations:
    - match:
        kuma.io/service: other
    " | kumactl apply -f -
    Error: Access Denied (user "backend-owner/mesh-system:authenticated" cannot access the resource)
    ```

{% endnavtab %}
{% endnavtabs %}
{% endnavtab %}
{% endnavtabs %}

## Multi-zone

In a multi-zone setup, `AccessRole` and `AccessRoleBinding` are not synchronized between the global control plane and the zone control plane.

## Wildcard tag value matching

{:.note}
> **Note**: This feature is available starting in {{site.mesh_product_name}} 1.9.1

{:.note}
> **Note**: This feature currently only works with "Source and Destination" selectors. This limitation restricts using newer policy types like `MeshTrafficPermission`, `MeshAccessLog`, or `MeshHTTPRoute`.


You can perform partial tag value matching using `*` wildcards.

For example, the following role:

{% navtabs codeblock %}
{% navtab Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: AccessRole
metadata:
  name: role-wildcard
spec:
  rules:
  - types: ["TrafficRoute"]
    mesh: default
    access: ["CREATE", "UPDATE", "DELETE"]
    when:
    - sources:
        match:
          k8s.kuma.io/namespace: orders
      destinations:
        match:
          kuma.io/service: '*_orders_*'
```
{% endnavtab %}
{% navtab Universal %}
```yaml
type: AccessRole
name: role-wildcard
rules:
- types: ["TrafficRoute"]
  mesh: default
  access: ["CREATE", "UPDATE", "DELETE"]
  when:
  - sources:
      match:
        k8s.kuma.io/namespace: orders
    destinations:
      match:
        kuma.io/service: '*_orders_*'
```
{% endnavtab %}
{% endnavtabs %}

would allow a subject to create the following resource:

{% navtabs codeblock %}
{% navtab Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: TrafficRoute
metadata:
  name: tr-orders
spec:
  sources:
  - match:
      k8s.kuma.io/namespace: 'orders'
  destinations:
  - match:
      kuma.io/service: web_orders_svc_1000
  - match:
      kuma.io/service: backend_orders_svc_1000
  conf:
    destination:
      kuma.io/service: '*'
```
{% endnavtab %}
{% navtab Universal %}
```yaml
type: TrafficRoute
mesh: default
name: tr-orders
sources:
- match:
    k8s.kuma.io/namespace: 'orders'
destinations:
- match:
    kuma.io/service: web_orders_svc_1000
- match:
    kuma.io/service: backend_orders_svc_1000
conf:
  destination:
    kuma.io/service: '*'
```
{% endnavtab %}
{% endnavtabs %}

## What should I do if I've locked myself out?

If you remove the default `AccessRoleBinding` and `AccessRole`, you might find yourself locked out and unable to edit any resources. If you encounter this situation, you can regain access to the cluster by following these steps:

1. [Configure the control-plane](/mesh/{{page.release}}/documentation/configuration/#modifying-the-configuration) by setting the: `KUMA_ACCESS_TYPE` environment variable to `static`, and then restart the control-plane.
2. Create the default `AccessRoleBinding` and `AccessRole` (as described in the [default section](/mesh/{{page.release}}/features/rbac/#default)), or add new groups if necessary.
3. Remove the `KUMA_ACCESS_TYPE` environment variable for the control-plane and restart the control-plane.
