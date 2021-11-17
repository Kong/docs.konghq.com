---
title: Admins Examples
book: admins
---

## How to Invite and Register an Admin

### Introduction

Can be used for automation

### Prerequisites

```bash
export USERNAME=<username>
export EMAIL=<email>
export WORKSPACE=<workspace>
export HOST=<admin_api_host>
export TOKEN=Kong-Admin-Token:<super_admin_token>
```

for example:
```bash
export USERNAME=drogon
export EMAIL=test@test.com
export WORKSPACE=default
export HOST=127.0.0.1:8001
export ADMIN_TOKEN=Kong-Admin-Token:hunter2
```

May benefit from HTTPie and jq.

## Step 1
Extract and store the token from the registration URL, either by manually creating an environment variable or by echoing and piping with `jq`:

#### Manual method example:

1. Send a request to the registration URL
```bash
http $HOST/$WORKSPACE/admins/$USERNAME?generate_register_url=true $TOKEN
```

2. Copy the response and export as an environment variable, for example:
```bash
export REGISTER_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NDUwNjc0NjUsImlkIjoiM2IyNzY3MzEtNjIxZC00ZjA3LTk3YTQtZjU1NTg0NmJkZjJjIn0.gujRDi2pX_E7u2zuhYBWD4MoPFKe3axMAq-AUcORg2g
```

#### Programmatic method (requires `jq`):
```bash
REGISTER_TOKEN=$(http $HOST/$WORKSPACE/admins/$USERNAME?generate_register_url=true $TOKEN | jq .token -r)
```

## Step 2

```bash
http $HOST/$WORKSPACE/admins/register token=$REGISTER_TOKEN username=$USERNAME email=$EMAIL password="<new_password>"
```
