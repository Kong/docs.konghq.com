---
title: Role-Based Access Control
---

Role-Based Access Control (RBAC) lets you restrict access to resources and actions to specified users or groups, based on user roles.

## How it works

{{site.mesh_product_name}} provides two resources to implement RBAC:

- `AccessRole` specifies kinds of access and resources to which access is granted. Note that access is defined only for write operations. Read access is available to all users.
- `AccessRoleBinding` lists users and the access roles that are assigned to them.

### AccessRole

AccessRole defines a role that is assigned separately to users.
It is global-scoped, which means it is not bound to a mesh.

{% navtabs %}
{% navtab Universal %}
```yaml
type: AccessRole
name: role-1
rules:
- types: ["TrafficPermission", "TrafficRoute", "Mesh"] # list of types to which access is granted. If empty, then access is granted to all types
  names: ["res-1"] # list of allowed names of types to which access is granted. If empty, then access is granted to resources regardless of the name.
  mesh: default # Mesh within which the access to resources is granted. It can only be used with the Mesh-scoped resources.
  access: ["CREATE", "UPDATE", "DELETE", "GENERATE_DATAPLANE_TOKEN", "GENERATE_USER_TOKEN", "GENERATE_ZONE_CP_TOKEN", "GENERATE_ZONE_TOKEN"] # an action that is bound to a type.
  when: # a set of qualifiers to receive an access. Only one of them needs to be fulfilled to receive an access
  - sources: # a condition on sources section in connection policies (like TrafficRoute or Healtchecheck). If missing, then all sources are allowed
      match:
        kuma.io/service: web
    destinations: # a condition on destinations section in connection policies (like TrafficRoute or Healtchecheck). If missing, then all destinations are allowed
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
{% navtab Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: AccessRole
metadata:
  name: role-1
spec:
  rules:
  - types: ["TrafficPermission", "TrafficRoute", "Mesh"] # list of types to which access is granted. If empty, then access is granted to all types
    names: ["res-1"] # list of allowed names of types to which access is granted. If empty, then access is granted to resources regardless of the name.
    mesh: default # Mesh within which the access to resources is granted. It can only be used with the Mesh-scoped resources.
    access: ["CREATE", "UPDATE", "DELETE", "GENERATE_DATAPLANE_TOKEN", "GENERATE_USER_TOKEN", "GENERATE_ZONE_CP_TOKEN", "GENERATE_ZONE_TOKEN"] # an action that is bound to a type.
    when: # a set of qualifiers to receive an access. Only one of them needs to be fulfilled to receive an access
    - sources: # a condition on sources section in connection policies (like TrafficRoute or Healtchecheck). If missing, then all sources are allowed
        match:
          kuma.io/service: web
      destinations: # a condition on destinations section in connection policies (like TrafficRoute or Healtchecheck). If missing, then all destinations are allowed
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

### AccessRoleBinding

AccessRoleBinding assigns a set of AccessRoles to a set of subjects (users and groups).
It is global-scoped, which means it is not bound to a mesh.

{% navtabs %}
{% navtab Universal %}
```yaml
type: AccessRoleBinding
name: binding-1
subjects: # a list of subjects that will be assigned roles
- type: User # type of the subject. Available values: ("User", "Group")
  name: john.doe@example.com # name of the subject.
- type: Group
  name: team-a
roles: # a list of roles that will be assigned to the list of subjects.
- role-1
```
{% endnavtab %}
{% navtab Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: AccessRoleBinding
metadata:
  name: binding-1
spec:
  subjects: # a list of subjects that will be assigned roles
  - type: User # type of the subject. Available values: ("User", "Group")
    name: john.doe@example.com # name of the subject.
  - type: Group
    name: team-a
  roles: # a list of roles that will be assigned to the list of subjects.
  - role-1
```
{% endnavtab %}
{% endnavtabs %}

## Example roles

Let's go through example roles in the organization that can be created using {{site.mesh_product_name}} RBAC.

### Kong Mesh operator (admin)

Mesh operator is a part of infrastructure team responsible for {{site.mesh_product_name}} deployment.

{% navtabs %}
{% navtab Universal %}
```yaml
type: AccessRole
name: admin
rules:
- access: ["CREATE", "UPDATE", "DELETE", "GENERATE_DATAPLANE_TOKEN", "GENERATE_USER_TOKEN", "GENERATE_ZONE_CP_TOKEN", "GENERATE_ZONE_TOKEN"]
```
{% endnavtab %}
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
{% endnavtabs %}

This way {{site.mesh_product_name}} operators can execute any action.

_Note: this role is precreated on the start of the control plane._

### Service owner

Service owner is a part of team responsible for given service. Let's take a `backend` service as an example.

{% navtabs %}
{% navtab Universal %}
```yaml
type: AccessRole
name: backend-owner
rules:
- mesh: default
  types: ["TrafficPermission", "RateLimit"]
  access: ["CREATE", "DELETE", "UPDATE"]
  when:
  - destinations:
      match:
        kuma.io/service: backend
- mesh: default
  types: ["TrafficRoute", "HealthCheck", "CircuitBreaker", "FaultInjection", "Retry", "Timeout", "TrafficLog"]
  access: ["CREATE", "DELETE", "UPDATE"]
  when:
  - sources:
      match:
        kuma.io/service: backend
  - destinations:
      match:
        kuma.io/service: backend
- mesh: default
  types: ["TrafficTrace", "ProxyTemplate"]
  access: ["CREATE", "DELETE", "UPDATE"]
  when:
  - selectors:
      match:
        kuma.io/service: backend
```
{% endnavtab %}
{% navtab Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: AccessRole
metadata:
  name: backend-owner
spec:
  rules:
    - mesh: default
      types: ["TrafficPermission", "RateLimit"]
      access: ["CREATE", "DELETE", "UPDATE"]
      when:
        - destinations:
            match:
              kuma.io/service: backend
    - mesh: default
      types: ["TrafficRoute", "HealthCheck", "CircuitBreaker", "FaultInjection", "Retry", "Timeout", "TrafficLog"]
      access: ["CREATE", "DELETE", "UPDATE"]
      when:
        - sources:
            match:
              kuma.io/service: backend
        - destinations:
            match:
              kuma.io/service: backend
    - mesh: default
      types: ["TrafficTrace", "ProxyTemplate"]
      access: ["CREATE", "DELETE", "UPDATE"]
      when:
        - selectors:
            match:
              kuma.io/service: backend
```
{% endnavtab %}
{% endnavtabs %}

This way a service owners can:
* Modify `RateLimit` and `TrafficPermission` that allows/restrict access to the backend service.
  This changes the configuration of data plane proxy that implements `backend` service.
* Modify connection policies (`TrafficRoute`, `HealthCheck`, `CircuitBreaker`, `FaultInjection`, `Retry`, `Timeout`, `RateLimit`, `TrafficLog`)
  that matches backend service that connects to other services. This changes the configuration of data plane proxy that implements `backend` service.
* Modify connection policies that matches any service that consumes backend service.
  This changes the configuration of data plane proxies that are connecting to backend, but the configuration only affects connections to backend service.
  It's useful because the service owner of backend has the best knowledge what (Timeouts, HealthCheck) should be applied when communicating with their service.
* Modify `TrafficTrace` or `ProxyTemplate` that matches backend service. This changes the configuration of data plane proxy that implements `backend` service.

### Observability operator

We may also have an infrastructure team which is responsible for the logging/metrics/tracing systems in the organization.
Currently, those features are configured on `Mesh`, `TrafficLog` and `TrafficTrace` objects.

{% navtabs %}
{% navtab Universal %}
```yaml
type: AccessRole
name: observability-operator
rules:
- mesh: '*'
  types: ["TrafficLog", "TrafficTrace"]
  access: ["CREATE", "DELETE", "UPDATE"]
- types: ["Mesh"]
  access: ["CREATE", "DELETE", "UPDATE"]
```
{% endnavtab %}
{% navtab Kubernetes %}
```yaml
apiVersion: kuma.io/v1alpha1
kind: AccessRole
metadata:
  name: observability-operator
spec:
  rules:
    - mesh: '*'
      types: ["TrafficLog", "TrafficTrace"]
      access: ["CREATE", "DELETE", "UPDATE"]
    - types: ["Mesh"]
      access: ["CREATE", "DELETE", "UPDATE"]
```
{% endnavtab %}
{% endnavtabs %}

This way an observability operator can:
* Modify `TrafficLog` and `TrafficTrace` in any mesh
* Modify any `Mesh`

### Single Mesh operator

{{site.mesh_product_name}} lets us segment the deployment into many logical Service Meshes configured by Mesh object.
We may want to give an access to one specific Mesh and all objects connected with this Mesh.

{% navtabs %}
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
{% endnavtabs %}

This way all observability operator can:
* Modify all resources in the demo mesh
* Modify `demo` Mesh object.

## Kubernetes

Kubernetes provides their own RBAC system, but it's not sufficient to cover use cases for several reasons:
* You cannot restrict an access to resources of specific Mesh
* You cannot restrict an access based on the content of the policy

{{site.mesh_product_name}} RBAC works on top of Kubernetes RBAC.
For example, to restrict the access for a user to modify TrafficPermission for backend service, they need to be able to create TrafficPermission in the first place.

The `subjects` in `AccessRoleBinding` are compatible with Kubernetes users and groups.
{{site.mesh_product_name}} RBAC on Kubernetes is implemented using Kubernetes Webhook when applying resources. This means you can only use Kubernetes users and groups for `CREATE`, `DELETE` and `UPDATE` access.
`GENERATE_DATAPLANE_TOKEN`, `GENERATE_USER_TOKEN`, `GENERATE_ZONE_CP_TOKEN`, `GENERATE_ZONE_TOKEN` are used when interacting with {{site.mesh_product_name}} API Server, in this case you need to use the user token.

## Default

{{site.mesh_product_name}} creates an `admin` AccessRole that allows every action.

In a standalone deployment, the `default` AccessRoleBinding assigns this role to every authenticated and unauthenticated user.

In a multizone deployment, the `default` AccessRoleBinding on the global control plane assigns this role to every authenticated and unauthenticated user.
However, on the zone control plane, the `default` AccessRoleBinding is restricted to the `admin` AccessRole only.

{% navtabs %}
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
{% endnavtabs %}

To restrict access to `admin` only, change the default AccessRole policy:

{% navtabs %}
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
  - type: Group
    name: system:serviceaccounts:kube-system
  roles:
  - admin
```
`system:serviceaccounts:kube-system` is required for Kubernetes controllers to manage Kuma resources -- for example, to remove Dataplane objects when a namespace is removed.
{% endnavtab %}
{% endnavtabs %}

## Example

Here are the steps to create a new user and restrict the access only to TrafficPermission for backend service.

{% navtabs %}
{% navtab Universal %}

**NOTE** By default, all requests that originates from localhost are authenticated as user `admin` belonging to group `mesh-system:admin`.
In order for this example to work you must either run the control plane with `KUMA_API_SERVER_AUTHN_LOCALHOST_IS_ADMIN` set to `false` or be accessing the control plane not via localhost.

1.  Extract admin token and configure kumactl with admin

    ```sh
    $ export ADMIN_TOKEN=$(curl http://localhost:5681/global-secrets/admin-user-token | jq -r .data | base64 -d)
    $ kumactl config control-planes add \
    --name=cp-admin \
    --address=https://localhost:5682 \
    --skip-verify=true \
    --auth-type=tokens \
    --auth-conf token=$ADMIN_TOKEN
    ```

1.  Configure backend-owner

    ```sh
    $ export BACKEND_OWNER_TOKEN=$(kumactl generate user-token --valid-for=24h --name backend-owner)
    $ kumactl config control-planes add \
    --name=cp-backend-owner \
    --address=https://localhost:5682 \
    --skip-verify=true \
    --auth-type=tokens \
    --auth-conf token=$BACKEND_OWNER_TOKEN
    $ kumactl config control-planes switch --name cp-admin # switch back to admin
    ```

1.  Change default {{site.mesh_product_name}} RBAC to restrict access to resources by default

    ```sh
    $ echo "type: AccessRoleBinding
    name: default
    subjects:
    - type: Group
      name: mesh-system:admin
    roles:
    - admin" | kumactl apply -f -
    ```

1.  Create {{site.mesh_product_name}} RBAC to restrict backend-owner to only modify TrafficPermission for backend

    ```sh
    $ echo '
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
    $ echo '
    type: AccessRoleBinding
    name: backend-owners
    subjects:
    - type: User
      name: backend-owner
    roles:
    - backend-owner' | kumactl apply -f -
    ```

1.  Change the user and test RBAC

    ```sh
    $ kumactl config control-planes switch --name cp-backend-owner
    $ echo "
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

    $ echo "
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
{% navtab Kubernetes %}

1.  Create a backend-owner Kubernetes user and configure kubectl

    ```sh
    $ mkdir -p /tmp/k8s-certs
    $ cd /tmp/k8s-certs
    $ openssl genrsa -out backend-owner.key 2048 # generate client key
    $ openssl req -new -key backend-owner.key -subj "/CN=backend-owner" -out backend-owner.csr # generate client certificate request
    $ CSR=$(cat backend-owner.csr | base64 | tr -d "\n") && echo "apiVersion: certificates.k8s.io/v1
    kind: CertificateSigningRequest
    metadata:
      name: backend-owner
    spec:
      request: $CSR
      signerName: kubernetes.io/kube-apiserver-client
      usages:
      - client auth" | kubectl apply -f -
    $ kubectl certificate approve backend-owner
    $ kubectl get csr backend-owner -o jsonpath='{.status.certificate}'| base64 -d > backend-owner.crt
    $ kubectl config set-credentials backend-owner \
    --client-key=/tmp/k8s-certs/backend-owner.key \
    --client-certificate=/tmp/k8s-certs/backend-owner.crt \
    --embed-certs=true
    $ kubectl config set-context backend-owner --cluster=YOUR_CLUSTER_NAME --user=backend-owner
    ```

1.  Create Kubernetes RBAC to allow backend-owner to manage all TrafficPermission

    ```sh
    $ echo "
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

1.  Change default {{site.mesh_product_name}} RBAC to restrict access to resources by default

    ```sh
    $ echo "
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
      roles:
      - admin
    " | kubectl apply -f -
    ```

1.  Create an AccessRole to grant permissions to user `backend-owner` to modify TrafficPermission only for the backend service:

    ```sh
    $ echo "
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
    " | kubectl apply -f -
    ```

1.  Change the service to test user access:

    ```sh
    $ kubectl config use-context backend-owner
    $ echo "
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

    $ echo "
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
{% endnavtabs %}

## Multizone

In a multizone setup, `AccessRole` and `AccessRoleBinding` are not synchronized between the global control plane and the zone control plane.
