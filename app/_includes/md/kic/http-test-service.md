## Deploy an upstream HTTP application

To proxy requests, you need an upstream application to proxy to. Deploying this
echo server provides a simple application that returns information about the
Pod it's running in:

```bash
echo "
apiVersion: v1
kind: Service
metadata:
  labels:
    app: echo
  name: echo
spec:
  ports:
  - port: 1025
    name: tcp
    protocol: TCP
    targetPort: 1025
  - port: 1026
    name: udp
    protocol: TCP
    targetPort: 1026
  - port: 1027
    name: http
    protocol: TCP
    targetPort: 1027
  selector:
    app: echo
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: echo
  name: echo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: echo
  strategy: {}
  template:
    metadata:
      creationTimestamp: null
      labels:
        app: echo
    spec:
      containers:
      - image: kong/go-echo:latest
        name: echo
        ports:
        - containerPort: 1027
        env:
          - name: NODE_NAME
            valueFrom:
              fieldRef:
                fieldPath: spec.nodeName
          - name: POD_NAME
            valueFrom:
              fieldRef:
                fieldPath: metadata.name
          - name: POD_NAMESPACE
            valueFrom:
              fieldRef:
                fieldPath: metadata.namespace
          - name: POD_IP
            valueFrom:
              fieldRef:
                fieldPath: status.podIP
        resources: {}
" | kubectl apply -f -
```
Response:
```text
service/echo created
deployment.apps/echo created
```
