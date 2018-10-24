---
title: Overview
book: workspaces
chapter: 1
toc: false
---

## Introduction

Starting with its 0.33 version, Kong Enterprise ships with a **novel Workspaces
implementation**, allowing Kong Admins to **segment** Admin API configuration &
traffic domains. Workspaces are useful in a wide range of scenarios; for instance,
in multi-team setups, where multiple teams share the same Kong cluster. In
previous Kong Enterprise versions, these teams would be able to access each
other's Admin API entities, which might be undesirable for many reasons;
in Kong Enterprise 0.33 it's possible for teams to have their own private,
segmented spaces, while still sharing the same Kong cluster. Workspaces by
themselves, though useful, only allow one to segment traffic, but not to control
access to individual workspaces - for that, read the [RBAC Book][rbac-overview]
to learn how to leverage the power of Workspaces with RBAC.

Next: [Workspaces Admin API &rsaquo;]({{page.book.next}})

---

[rbac-overview]: /enterprise/{{page.kong_version}}/rbac/overview
