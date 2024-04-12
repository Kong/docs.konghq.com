import { createApp } from 'vue';
import SearchApp from '~/javascripts/views/SearchApp/Index.vue';
import InstantSearch from 'vue-instantsearch/vue3/es';
import "~/stylesheets/variables.less";

const app = createApp(SearchApp);
app.use(InstantSearch);
app.mount('#search-app');
