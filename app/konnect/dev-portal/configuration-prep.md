---
title: Dev Portal configuration preparation
content_type: concept
---

It's best to know what settings you'll need to configure in your Dev Portal before you create your first Dev Portal.

1. Create API products and product versions
1. Configure pre-config settings depending on your use case:
    1. (Internal developers only) Configure SSO to allow internal developers to log in to Dev Portal with their IdP credentials
    1. Configure an [authentication strategy](/konnect/dev-portal/applications/enable-app-reg/) if you plan to use one. This auth strategy will be how developers authenticate when they use your APIs.
    1. Configure DCR if you plan to use it.
1. Create one or more Dev Portals, configuring the settings described in the flowcharts that meet your use case.
1. Manage developers and apps that are registered.

Dev Portal configuration involves answering the following questions ahead of time:

* Who will be using my Dev Portal or Dev Portals?
* What will my Dev Portal be used for?
* Will you allow developers to create applications against your APIs? And if so, how will you manage the applications they create?

It's helpful to know before you configure Dev Portal which settings you need to configure based on your use cases. 

Before you configure your Dev Portal or Dev Portals, go through the following flowcharts to determine which settings you'll need to configure:

## Who will be using your Dev Portal or Dev Portals?

There are three options to choose from when talking about who will be using your Dev Portal or Dev Portals:

### External developers
{% mermaid %}
flowchart TD
    A[External developers] --> B(How will you manage devs?)
    B --> C(Approve registrations automatically)
    B --> D(Manually approve or deny registrations)
{% endmermaid %}

### Internal developers
{% mermaid %}
flowchart TD
    A[Internal developers] --> B(How will you manage devs?)
    B --> C(Use SSO to allow developers to log in)
    B --> D(Manually approve or deny registrations)
{% endmermaid %}

### External and internal developers
{% mermaid %}
flowchart TD
    A[External and internal developers] --> B(How will you manage the external devs?)
    A --> C(How will you manage the internal devs?)
    B --> D(Approve registrations automatically)
    B --> E(Manually approve or deny registrations)
    C --> F(Use SSO to allow developers to log in)
    C --> E(Manually approve or deny registrations)
{% endmermaid %}

## What will my Dev Portal be used for?
{% mermaid %}
flowchart TD
    A{Do you want your users to consume your APIs?} --> B(Yes)
    B --> C{Are your users internal or external?}
    C --> |internal| D(SSO)
    C --> |external| J(roles)
    C --> |both| K(Multi-portal with roles for external and SSO for internal)
    A --> E(No)
    A --> F(Some)
    E --> G(Assign a view only role)
    F --> |they can't consume| G
    F --> |they can consume| C
{% endmermaid %}

## How will you manage applications?
{% mermaid %}
flowchart TD
    A{How will you manage developer apps?} --> B(We're not allowing apps)
    A --> C(Manually approve or deny apps)
    A --> D(Automatically approve all apps)
    C --> E{How will devs authenticate their apps?}
    D --> E
    E --> F(Dynamic client registration)
    E --> G(Use default authentication strategy in {{site.konnect_short_name}})
{% endmermaid %}