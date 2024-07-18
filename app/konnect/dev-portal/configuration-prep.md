---
title: Dev Portal configuration preparation
content_type: concept
---

It's helpful to know which Dev Portal settings you need to configure based on your use cases before you go through the steps to configure your Dev Portal or Dev Portals. 

There are a few questions to consider before you create your Dev Portal:

* What is your Dev Portal for? 
    * An internal company catalog for APIs?
    * A public API catalog so other companies and developers can use your APIs to create apps?
    * Both an internal catalog for engineers in your company with APIs still in beta as well as a public catalog with APIs that are GA?
* Who will be using your Dev Portal?
    * Internal developers?
    * External developers?
    * Both internal and external developers?
* How will you manage apps created by developers, if any?
    * Do you want to automatically approve all apps?
    * Do you want to manually approve apps?
    * What type of authentication do you want to require for apps?

Use the following diagram to help you determine which Dev Portal settings you'll need to configure:

{% mermaid %}
flowchart TD
    A{Do you want your users to consume your APIs?} --> B(Yes)
    B --> C{Are your users internal or external?}
    C --> |internal| D(Use SSO to allow developers to log in)
    C --> |external| J(Assign roles to developers after they register)
    C --> |both| K(Multi-portal with roles for external and SSO for internal)
    A --> E(No)
    A --> F(Some)
    E --> G(Assign a view only role)
    F --> |they can't consume| G
    F --> |they can consume| C
    D --> H{How will you manage developer apps?}
    J --> H
    K --> H
    H --> I(Manually approve or deny apps)
    H --> L(Automatically approve all apps)
    I --> M{How will developers authenticate their apps?}
    M --> N(Dynamic client registration)
    M --> O(Use default authentication strategy in Konnect)

    %% this section defines node interactions
    click D "/konnect/dev-portal/access-and-approval/azure/"
    click J "/konnect/dev-portal/access-and-approval/manage-teams/"
    click G "/konnect/dev-portal/access-and-approval/manage-teams/"
    click I "/konnect/dev-portal/access-and-approval/manage-app-reg-requests/"
    click L "/konnect/dev-portal/create-dev-portal/"
    click N "/konnect/dev-portal/applications/dynamic-client-registration/"
    click O "/konnect/dev-portal/applications/enable-app-reg/"
{% endmermaid %}

## Next steps

Now that you know what your use cases are and which settings you'll need to configure, you can [create your Dev Portal or Dev Portals](/konnect/dev-portal/create-dev-portal). 