---
title: Add your API to Konnect
---

Some explanation of how you created a demo service etc. in wizard onboarding, and this will help you add your own APIs to Konnect to test.

Should we do more explaining in this topic? Like what services, routes, etc are. 

Feels like there's two groups here who would want this topic: 1. I use an API gateway (that isn't Kong) and know about APIs and just want to test my existing one and 2. I have no API gateway and don't know much about them and I'm exploring Konnect as an option. 

Maybe optional expandable explanations if they want more info, but they choose if they want to consume that info?

## Add your API

{% navtabs %}
{% navtab Konnect UI %}
1. Create service with your API.
2. Add route.
3. Verify? 
{% endnavtab %}
{% navtab Konnect API %}
1. Create service with your API.
2. Add route.
3. Verify? 
{% endnavtab %}
{% endnavtabs %}

## Next steps

Now that you've added your API to {{site.konnect_short_name}}, you can continue to test {{site.konnect_short_name}}'s capabilities:

<div class="docs-grid-install max-2">

  <a href="/hub/kong-inc/key-auth/how-to/basic-example/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-flag.svg" alt="">
    <div class="install-text">Protect my APIs with authentication</div>
  </a>

  <a href="/hub/kong-inc/rate-limiting/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-flag.svg" alt="">
    <div class="install-text">Rate limit my APIs</div>
  </a>

  <a href="/konnect/dev-portal/applications/enable-app-reg/" class="docs-grid-install-block no-description">
    <img class="install-icon no-image-expand" src="/assets/images/icons/documentation/icn-flag.svg" alt="">
    <div class="install-text">Make my APIs available to customers</div>
  </a>

</div>