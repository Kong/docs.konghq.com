// To see this message, follow the instructions for your Ruby framework.
//
// When using a plain API, perhaps it's better to generate an HTML entrypoint
// and link to the scripts and stylesheets, and let Vite transform it.

import "~/javascripts/modal.js"
import "~/javascripts/app.js";
import "~/javascripts/compat-dropdown.js";
import "~/javascripts/plugin-hub.js";
import "~/javascripts/subscribe.js";
import "~/javascripts/navbar.js";
import "~/javascripts/feedback-widget.js";
import "~/javascripts/copy-code-snippet-support.js";
import "~/javascripts/content-header.js"
import "~/javascripts/sidebar.js"
import Tabs from "~/javascripts/tabs.js"

// uncomment the path to promo-banner.js when adding a new promo banner
// also uncomment the promo banner sections in app/_assets/stylesheets/header.less and /app/_includes/nav-v2.html -->
import "~/javascripts/promo-banner.js"


document.addEventListener('DOMContentLoaded', (event) => {
  new Tabs();
})
