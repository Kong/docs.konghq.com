---
title: Get started with Konnect
---

{% mermaid %}
flowchart TD
    A{Start my {{site.konnect_short_name}} journey} -->B(Set up an API for me)
    A{Start my {{site.konnect_short_name}} journey} -->C(I want to do it myself)
    B --> D(Use the quickstart wizard)
    C --> E(Add an API to {{site.konnect_short_name}})
    C --> F(Import {{site.base_gateway}} entities to {{site.konnect_short_name}})

    %% this section defines node interactions
    click D "https://cloud.konghq.com/quick-start"
    click E "/konnect/getting-started/add-api/"
    click F "/konnect/getting-started/import/"
{% endmermaid %}